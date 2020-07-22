//
//  IMEDatabaseQueue.h
//  iMetisSDK
//
//  Created by Michael Wu on 2019/6/26.
//

#import <Foundation/Foundation.h>
#import "IMEDatabase.h"

NS_ASSUME_NONNULL_BEGIN

/**
 iMetis database queue , use it to make sure database operations in safe thread
 */
@interface IMEDatabaseQueue : NSObject

@property (nonatomic, copy, readonly) NSString *databasePath;//!< databse file path

+ (instancetype)databaseQueueWithPath:(NSString *)aPath;
- (instancetype)initWithPath:(NSString *)aPath NS_DESIGNATED_INITIALIZER;

+ (Class)databaseClass;

/**
 [IMEDatabase interrupt] in safe thread
 */
- (void)interrupt;

/**
 Close database used by queue.
 */
- (void)close;

/**
 Synchronously perform database operations on queue.

 @param block The code to be run on the queue of `FMDatabaseQueue`
 */
- (void)inDatabase:(void (^)(IMEDatabase *db))block;

@end

NS_ASSUME_NONNULL_END
