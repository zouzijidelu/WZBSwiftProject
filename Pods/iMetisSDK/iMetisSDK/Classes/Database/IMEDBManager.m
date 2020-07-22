//
//  IMEDBManager.m
//  iMetisSDK
//
//  Created by Michael Wu on 2019/6/26.
//

#import "IMEDBManager.h"
#import "IMEDatabaseQueue.h"
#import "IMEConstant.h"

#define kEveryCleanMaxDataCount 5

#define kDefaultDatabaseFileDirectory     @"imetisDatabase"
#define kDefaultDatabaseFilePathComponent @"imetis.sqlite"

#define kimetisTable @"elk_imetis_ios"

#define kTableKey_primaryId @"id"
#define kTableKey_eventId @"eventId"
#define kTableKey_eventName @"eventName"
#define kTableKey_eventLevel @"eventLevel"
#define kTableKey_description @"description"
#define kTableKey_timestamp @"timestamp"
#define kTableKey_line  @"line"
#define kTableKey_extra @"eventExtra"
#define kTableKey_duration @"eventDuration"
#define kTableKey_indexName @"indexName"

@implementation NSString (IMSqlLog)

- (instancetype)sqlLog {
    IMLog(@"[iMetis][IMSql] %@",self);
    return self;
}

@end

/**
 Filter all input ' args to ", avoid to execute sqlite failed
 */
static NSString * FiltersInputArgString(NSString *inputArg) {
    NSString *final = [inputArg stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    return final;
}


/** All sqlite strings */

static NSString * sql_create() {
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ TEXT,%@ TEXT,%@ INTEGER,%@ TEXT,%@ INTEGER, %@ TEXT)",kimetisTable,kTableKey_primaryId,kTableKey_eventId,kTableKey_eventName,kTableKey_eventLevel,kTableKey_description,kTableKey_timestamp,kTableKey_line,kTableKey_extra,kTableKey_duration,kTableKey_indexName].sqlLog;
    return sql;
};

static NSString *sql_insert(IMEEventInfo *event) {
    
    NSString *extraJSONString = @"";
    if (event.info.allKeys > 0) {
        if (![NSJSONSerialization isValidJSONObject:event.info]) {
            return nil;
        }
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:event.info options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            assert("jsonString parse to data error !");
            return nil;
        }
        extraJSONString = [[NSString alloc]initWithData:jsonData encoding:(NSUTF8StringEncoding)];
    }
    
    extraJSONString = FiltersInputArgString(extraJSONString);
    NSString *eventName = FiltersInputArgString(event.name);
    NSString *eventDescription = FiltersInputArgString(event.descriptions);
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES ('%@','%@','%zd','%@','%@','%zd','%@','%zd','%@')",kimetisTable,kTableKey_eventId,kTableKey_eventName,kTableKey_eventLevel,kTableKey_description,kTableKey_timestamp,kTableKey_line,kTableKey_extra,kTableKey_duration,kTableKey_indexName,event.eventId,eventName,                                                                 event.level,eventDescription,event.timestamp,                                              event.lineNumber,extraJSONString,event.duration,event.indexName].sqlLog;
    return sql;
}


static NSString *sql_select(NSInteger count) {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ order by %@ limit %zd",kimetisTable,kTableKey_primaryId,count].sqlLog;
    return sql;
}

static NSString *sql_selectAll() {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",kimetisTable].sqlLog;
    return sql;
}

static NSString *sql_delete(NSInteger count) {
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ where %@ in (SELECT %@ FROM %@ order by %@ limit %zd)",kimetisTable,kTableKey_primaryId,kTableKey_primaryId,kimetisTable,kTableKey_primaryId,count].sqlLog;
    return sql;
    
}

static IMEEventInfo * db_createEventInfoFromDatabaseJSONDict(NSDictionary *databaseDict) {
    
    NSDictionary *extra = nil;
    NSString *jsonString = databaseDict[kTableKey_extra];
    if (jsonString.length > 0) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        extra = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            assert("jsonData parse to dictionary error !");
        }
    }
    IMEEventInfo *eventInfo = [[IMEEventInfo alloc]initWithName:databaseDict[kTableKey_eventName] level:[databaseDict[kTableKey_eventLevel] integerValue] description:databaseDict[kTableKey_description] timestamp:databaseDict[kTableKey_timestamp] lineNumber:[databaseDict[kTableKey_line] integerValue] extraInfo:extra duration:[databaseDict[kTableKey_duration] integerValue] indexName:databaseDict[kTableKey_indexName]];
    
    return eventInfo;
}

@interface IMEDBManager ()

@property (nonatomic, strong) IMEDatabaseQueue *dbQueue;

@property (nonatomic, copy) NSString *path;

@end

@implementation IMEDBManager


- (instancetype)initialize {
    
    // initialize
    _path = [self defaultDBFilePath];
    
    // create file
    [self createFileIfNotExist];
    
    _maxFileSize = 10.f; // 10MB
    _dbQueue = [IMEDatabaseQueue databaseQueueWithPath:_path];
    
    // create table
    NSString *sql = sql_create();
    [_dbQueue inDatabase:^(IMEDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:sql];
        if (res) {
            IMLog(@"[iMetis][IMEDBManager] Create table success ");
        }else {
            IMLog(@"[iMetis][IMEDBManager] Create table failed ");
        }
    }];
    
    return self;
}

- (void)reconfigDatabaseWithPath:(NSString *)path {
    
    [_dbQueue interrupt];
    [_dbQueue close];
    
    _path = path;
    _dbQueue = [IMEDatabaseQueue databaseQueueWithPath:_path];
    
}

#pragma mark - Api

- (void)insertEvent:(IMEEventInfo *)eventInfo complete:(IMOperationCompletion)completion {
    
    NSString *sql = sql_insert(eventInfo);
    
    [_dbQueue inDatabase:^(IMEDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:sql];
        completion(res,self);
    }];
    
}

- (void)deleteEventsWithCount:(NSInteger)count complete:(IMOperationCompletion)completion {
    
    NSString *sql = sql_delete(count);
    
    [_dbQueue inDatabase:^(IMEDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:sql];
        completion(res,self);
    }];
}

- (void)selectEventsWithCount:(NSInteger)count complete:(IMOperationQueryCompletion)completion {
    
    NSString *sql = sql_select(count);
    
    [_dbQueue inDatabase:^(IMEDatabase * _Nonnull db) {
        NSArray<NSDictionary*>* res = [db executeQuery:sql];
        
        NSMutableArray *final = [NSMutableArray new];
        [res enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            IMEEventInfo *eventInfo = db_createEventInfoFromDatabaseJSONDict(obj);
            [final addObject:eventInfo];
        }];
        
        completion(YES, final, self);
    }];
}

- (void)selectAllEventsComplete:(IMOperationQueryCompletion)completion {
    
    NSString *sql = sql_selectAll();
    
    [_dbQueue inDatabase:^(IMEDatabase * _Nonnull db) {
       
        NSArray<NSDictionary*>* res = [db executeQuery:sql];
        
        NSMutableArray *final = [NSMutableArray new];
        [res enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            IMEEventInfo *eventInfo = db_createEventInfoFromDatabaseJSONDict(obj);
            [final addObject:eventInfo];
        }];
        
        completion(YES, final, self);
    }];
}


#pragma mark - File

- (void)createFileIfNotExist {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:_path]) {
        IMLog(@"[iMetis] imetis file manager will create file into:%@",_path);
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                           NSUserDomainMask, YES) objectAtIndex:0];
        NSString *directryPath = [documentPath stringByAppendingPathComponent:kDefaultDatabaseFileDirectory];
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil                                                  error:nil];
        NSString *filePath = [directryPath stringByAppendingPathComponent:kDefaultDatabaseFilePathComponent];
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
}

- (void)autoCleanFileSizeIfNeeded {
    
    if (self.databaseFileSize > self->_maxFileSize) {
    
        [self deleteEventsWithCount:kEveryCleanMaxDataCount complete:^(BOOL res, IMEDBManager * _Nonnull manager) {
                if (res) {
                    [self autoCleanFileSizeIfNeeded]; // recursive
#ifdef DEBUG
                    [self selectAllEventsComplete:^(BOOL res, NSArray<IMEEventInfo *> * _Nonnull events, IMEDBManager * _Nonnull manager) {
                        IMLog(@"current events count is %zd",events.count);
                    }];
#endif
                }
        }];
    }
}

- (unsigned long long)databaseFileSize {
    NSString *filePath = _path;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        IMLog(@"sqlite file size is %f",[[manager attributesOfItemAtPath:filePath error:nil]                             fileSize] / (1024.0 * 1024.0));
        //unit conversion:  b -> M
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize] / (1024.0 * 1024.0);
    }
    return 0;
}


- (void)setNewFilePath:(NSString *)newFilePath {
    if (!newFilePath.length) {
        return;
    }
    if (![_path isEqualToString:newFilePath]) {
        [self reconfigDatabaseWithPath:newFilePath];
    }
}

- (NSString *)defaultDBFilePath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                           NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@",documentPath,kDefaultDatabaseFileDirectory,kDefaultDatabaseFilePathComponent];
    
    IMLog(@"[iMetis][IMEDatabase] file path --> %@",filePath);
    
    return filePath;
}

#pragma mark - Setter / Getter

- (IMEDatabaseQueue *)dbQueue {
    return _dbQueue;
}

- (void)setMaxFileSize:(long)maxFileSize {
    if (maxFileSize <= 0) {
        return;
    }
    _maxFileSize = maxFileSize;
    [self autoCleanFileSizeIfNeeded];
}

- (NSString *)path {
    return _path;
}


@end
