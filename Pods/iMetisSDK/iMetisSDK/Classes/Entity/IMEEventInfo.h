//
//  IMEEventInfo.h
//  imetis
//
//  Created by 黄娇双 on 2019/2/21.
//  Copyright © 2019年 iTalkBB Team. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const EVENT_EVENTID_KEY;
extern NSString * const EVENT_NAME_KEY;
extern NSString * const EVENT_DURATION_KEY;
extern NSString * const EVENT_TYPE_KEY;
extern NSString * const EVENT_DESCRIPTION_KEY;
extern NSString * const EVENT_TIMESTAMP_KEY;
extern NSString * const EVENT_LINE_KEY;
extern NSString * const EVENT_EXTRA_KEY;
extern NSString * const JSON_INDEXNAME_KEY;


@interface IMEEventInfo : NSObject
/**
 event name
 */
@property (nonatomic, copy) NSString *name;

/**
 event level (1/2/3/4/5/12)
 */
@property (nonatomic, assign) NSInteger level;

/**
 event description
 */
@property (nonatomic, copy) NSString *descriptions;

/**
 event timestamp
 */
@property (nonatomic, copy) NSString *timestamp;

/**
 the line number of the event in the file
 */
@property (nonatomic, assign) NSInteger lineNumber;

/**
 extra message
 */
@property (nonatomic, copy) NSDictionary *info;

/**
 time difference
 */
@property (nonatomic, assign) NSInteger duration;

/**
 index name
 */
@property (nonatomic, copy) NSString *indexName;


- (instancetype)initWithName:(NSString *)name
                       level:(NSInteger)level
                 description:(NSString *)description
                   timestamp:(NSString *)timestamp
                  lineNumber:(NSInteger)lineNumber
                   extraInfo:(NSDictionary *)extraInfo
                    duration:(NSInteger)duration
                   indexName:(NSString *)indexName;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)toDictionary;

- (NSString *)eventId;

@end

