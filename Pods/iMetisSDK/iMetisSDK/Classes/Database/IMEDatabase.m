//
//  IMEDatabase.m
//  iMetisSDK
//
//  Created by Michael Wu on 2019/6/26.
//

#import "IMEDatabase.h"
#import <sqlite3.h>
#import "IMEConstant.h"

@interface IMEDatabase () {
    sqlite3 *_db;
    NSTimeInterval _startBusyRetryTime;
    NSString * _databasePath;
    BOOL _isOpen;
}

@end

@implementation IMEDatabase

#pragma mark - DB Api

+ (instancetype)databaseWithPath:(NSString *)path {
    
    IMEDatabase *database = [[IMEDatabase alloc]initWithPath:path];
    
    
    return database;
}

- (instancetype)initWithPath:(NSString *)path {
    
    assert(sqlite3_threadsafe()); // whoa there big boy- gotta make sure sqlite it happy with what we're going to do.
    
    self = [super init];
    
    if (self) {
        _databasePath               = [path copy];
        _db                         = nil;
        _maxBusyRetryTimeInterval   = 2;
        _isOpen                     = NO;
    }
    
    return self;
}

#pragma mark - Execute

- (BOOL)executeUpdate:(NSString *)sql {
    
    int err = sqlite3_exec(_db, sql.UTF8String, nil, nil, nil);
    
    if (err != SQLITE_OK) {
        IMAssert(NO, @"[iMetis][DataBase] sqlite occur error, please check sqlite string format !");
        //Close the database if it fails to execute
        [self close];
        return NO;
    }
    return YES;
}

- (NSArray<NSDictionary*> *)executeQuery:(NSString *)sql {
    
    sqlite3_stmt *sqlite3Stmt;
    NSMutableArray *res = [NSMutableArray array];
    //compile
    int err = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &sqlite3Stmt, nil);
    if (err != SQLITE_OK) {
        
        //failed
        IMAssert(NO, @"Failed to query database");
    } else {
        //Fetch the data for a row
        int count = sqlite3_column_count(sqlite3Stmt);
        while (sqlite3_step(sqlite3Stmt) == SQLITE_ROW) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (int i = 0; i < count; i ++) {
                //Gets the key of the current field
                NSString *keyStr = [NSString stringWithUTF8String:sqlite3_column_name(sqlite3Stmt, i)];
                //Gets the value of the current field
                const char *cValueStr = (const char *)sqlite3_column_text(sqlite3Stmt, i);
                NSString *valueStr;
                if (cValueStr == NULL) {
                    valueStr = @"";
                } else {
                    valueStr = [NSString stringWithUTF8String:cValueStr];
                }
                [dict setObject:valueStr forKey:keyStr];
            }
            [res addObject:dict];
        }
        sqlite3_finalize(sqlite3Stmt);
    }
    return res;
}


#pragma mark - Sql operations

- (BOOL)open {
    
    if (_isOpen) {
        IMLog(@"[iMetis][DataBase] db has been already opened");
        return YES;
    }
    
    // if we previously tried to open and it failed, make sure to close it before we try again
    if (_db) {
        [self close];
    }
    
    // now open database
    
    int err = sqlite3_open([self sqlitePath], &_db);
    if(err != SQLITE_OK) {
        IMLog(@"error opening!: %d", err);
        return NO;
    }
    
    if (_maxBusyRetryTimeInterval > 0.0) {
        // set the handler
        [self setMaxBusyRetryTimeInterval:_maxBusyRetryTimeInterval];
    }
    
    _isOpen = YES;
    IMLog(@"[iMetis][DataBase] db open success");
    return YES;
}

- (BOOL)close {
    if (!_db) {
        return YES;
    }
    
    int  rc;
    BOOL retry;
    BOOL triedFinalizingOpenStatements = NO;
    
    do {
        retry   = NO;
        rc      = sqlite3_close(_db);
        if (SQLITE_BUSY == rc || SQLITE_LOCKED == rc) {
            if (!triedFinalizingOpenStatements) {
                triedFinalizingOpenStatements = YES;
                sqlite3_stmt *pStmt;
                while ((pStmt = sqlite3_next_stmt(_db, nil)) !=0) {
                    IMLog(@"Closing leaked statement");
                    sqlite3_finalize(pStmt);
                    retry = YES;
                }
            }
        }
        else if (SQLITE_OK != rc) {
            IMLog(@"error closing!: %d", rc);
        }
    }
    while (retry);
    
    _db = nil;
    _isOpen = false;
    
    return YES;
}

- (BOOL)interrupt {
    if (_db) {
        sqlite3_interrupt(_db);
        return YES;
    }
    return NO;
}

- (BOOL)clean {
    if (_db) {
        int err = (sqlite3_exec(_db, @"VACUUM".UTF8String, nil, nil, nil));
        if (err != SQLITE_OK) {
            return NO;
        }
        return YES;
    }
    return NO;
}

#pragma mark - Busy retry

static int FMDBDatabaseBusyHandler(void *f, int count) {
    IMEDatabase *self = (__bridge IMEDatabase*)f;
    
    if (count == 0) {
        self->_startBusyRetryTime = [NSDate timeIntervalSinceReferenceDate];
        return 1;
    }
    
    NSTimeInterval delta = [NSDate timeIntervalSinceReferenceDate] - (self->_startBusyRetryTime);
    
    if (delta < [self maxBusyRetryTimeInterval]) {
        int requestedSleepInMillseconds = (int) arc4random_uniform(50) + 50;
        int actualSleepInMilliseconds = sqlite3_sleep(requestedSleepInMillseconds);
        if (actualSleepInMilliseconds != requestedSleepInMillseconds) {
            IMLog(@"WARNING: Requested sleep of %i milliseconds, but SQLite returned %i. Maybe SQLite wasn't built with HAVE_USLEEP=1?", requestedSleepInMillseconds, actualSleepInMilliseconds);
        }
        return 1;
    }
    
    return 0;
}

- (void)setMaxBusyRetryTimeInterval:(NSTimeInterval)timeout {
    
    _maxBusyRetryTimeInterval = timeout;
    
    if (!_db) {
        return;
    }
    
    if (timeout > 0) {
        sqlite3_busy_handler(_db, &FMDBDatabaseBusyHandler, (__bridge void *)(self));
    }
    else {
        // turn it off otherwise
        sqlite3_busy_handler(_db, nil, nil);
    }
}

#pragma mark - Sqlite information

+ (BOOL)isSqliteThreadSafe {
    // make sure to read the sqlite headers on this guy!
    return sqlite3_threadsafe() != 0;
}

+ (NSString *)sqliteLibVersion {
    return [NSString stringWithFormat:@"%s", sqlite3_libversion()];
}

- (void *)sqliteHandler {
    return _db;
}

- (const char*)sqlitePath {
    
    if (!_databasePath) {
        return ":memory:";
    }
    
    if ([_databasePath length] == 0) {
        return ""; // this creates a temporary database (it's an sqlite thing).
    }
    
    return [_databasePath fileSystemRepresentation];
    
}

#pragma mark - getter

- (NSString *)databasePath {
    return _databasePath;
}

- (BOOL)isOpen {
    return _isOpen;
}

@end
