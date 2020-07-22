//
//  IMEDBManager.h
//  iMetisSDK
//
//  Created by Michael Wu on 2019/6/26.
//

#import <Foundation/Foundation.h>
#import "IMEEventInfo.h"
#import "IMEDatabaseQueue.h"

NS_ASSUME_NONNULL_BEGIN

@class IMEDBManager;

typedef void(^IMOperationCompletion)(BOOL res, IMEDBManager *manager);

typedef void(^IMOperationQueryCompletion)(BOOL res, NSArray<IMEEventInfo *> *events, IMEDBManager *manager);

/**
 All database operation manager.
 */
@interface IMEDBManager : NSObject

@property (nonatomic, strong, readonly) IMEDatabaseQueue *dbQueue;//!< data base in safe thread queue

@property (nonatomic, assign) long maxFileSize;//!< file size unit is MB

@property (nonatomic, copy, readonly) NSString *path;//!< database file path

- (instancetype)initialize;

/**
 Auto check file size over max, clean datas if overed, see detail in {.m}
 */
- (void)autoCleanFileSizeIfNeeded;

/**
 Set new database file path

 @param newFilePath new file path
 */
- (void)setNewFilePath:(NSString *)newFilePath;

#pragma mark - Database

/**
 Insert eventInfo into databse

 @param eventInfo model
 @param completion complete-block
 */
- (void)insertEvent:(IMEEventInfo *)eventInfo complete:(IMOperationCompletion)completion;

/**
 Delete eventInfo with events count

 @param count event-counts
 @param completion complete-block
 */
- (void)deleteEventsWithCount:(NSInteger)count complete:(IMOperationCompletion)completion;

/**
 Select events with event count

 @param count event-counts
 @param completion complete-block
 */
- (void)selectEventsWithCount:(NSInteger)count complete:(IMOperationQueryCompletion)completion;

// TODO: in the future
//- (void)updateEvent:(IMEEventInfo *)event complete:(IMOperationCompletion)completion;

@end


NS_ASSUME_NONNULL_END
