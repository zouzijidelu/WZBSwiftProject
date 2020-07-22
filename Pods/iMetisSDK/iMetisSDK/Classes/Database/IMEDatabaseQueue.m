//
//  IMEDatabaseQueue.m
//  iMetisSDK
//
//  Created by Michael Wu on 2019/6/26.
//

#import "IMEDatabaseQueue.h"
#import "IMEConstant.h"

static NSString * const kDispatchQueueSyncName = @"imetis.database.sync.queue";

static const void * const kDispatchQueueSpecificKey = &kDispatchQueueSpecificKey;

@interface IMEDatabaseQueue () {
    IMEDatabase *_db;
    dispatch_queue_t _queue;
    NSString *_path;
}

@end

@implementation IMEDatabaseQueue

+ (instancetype)databaseQueueWithPath:(NSString *)aPath {
    IMEDatabaseQueue *q = [[IMEDatabaseQueue alloc] initWithPath:aPath];
    
    return q;
}

- (instancetype)initWithPath:(NSString *)aPath {
    
    self = [super init];
    
    if (self != nil) {
        
        _db = [[[self class] databaseClass] databaseWithPath:aPath];
        

        BOOL success = [_db open];

        if (!success) {
            IMAssert(NO, @"Could not create database queue for path ");
            return 0x00;
        }
        _path = aPath;
        
        _queue = dispatch_queue_create([kDispatchQueueSyncName UTF8String], NULL);
        dispatch_queue_set_specific(_queue, kDispatchQueueSpecificKey, (__bridge void *)self, NULL);
    }
    
    return self;
}

#pragma mark - Api

- (void)interrupt {
    [self imetis_performInSafeThreadQueue:^{
        
        [[self database] interrupt];
    }];
}

- (void)close {
    [self imetis_performInSafeThreadQueue:^{
        [self->_db close];
    }];
}

- (void)inDatabase:(void (^)(IMEDatabase * _Nonnull))block {
    
    IMEDatabaseQueue *currentSyncQueue = (__bridge id)dispatch_get_specific(kDispatchQueueSpecificKey);
    assert(currentSyncQueue != self && "inDatabase: was called reentrantly on the same queue, which would lead to a deadlock");
    
    [self imetis_performInSafeThreadQueue:^{
        
        IMEDatabase *db = [self database];
        
        block(db);
        
    }];
}

#pragma mark - Private

- (void)imetis_performInSafeThreadQueue:(void(^)(void))syncBlock {
    
    dispatch_sync(_queue, ^() {
        syncBlock();
    });
}

#pragma mark - getter

- (IMEDatabase *)database {
    if (![_db isOpen]) {
        if (!_db) {
            _db = [IMEDatabase databaseWithPath:_path];
        }
        
        BOOL success = [_db open];

        if (!success) {
            IMLog(@"FMDatabaseQueue could not reopen database for path %@", _path);
            _db  = 0x00;
            return 0x00;
        }
    }
    return _db;
}

+ (Class)databaseClass {
    return [IMEDatabase class];
}

- (NSString *)databasePath {
    return _path;
}

@end
