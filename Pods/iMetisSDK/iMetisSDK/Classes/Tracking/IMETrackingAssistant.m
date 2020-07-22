//
//  IMViewTrackingAssistant.m
//  imetis
//
//  Created by valenti on 2019/2/27.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import "IMETrackingAssistant.h"
#import "IMETrackingManager.h"
#import "IMEEventManager.h"
#import "IMEEventInfo.h"
#import "IMEBaseInfoManager.h"

#define kDurationBeginKey @"beginTime"

static inline NSString * AS_getDurationRecordName(NSString *eventName, NSString *indexName) {
    return [NSString stringWithFormat:@"%@_%@",eventName,indexName];
}

@interface IMETrackingAssistant()

/**
 Container of cached event. <eventKey:eventInfo>
 */
@property(nonatomic, strong) NSMutableDictionary<NSString*, NSDictionary *>* eventContainer;

@end

@implementation IMETrackingAssistant

#pragma mark - init
static IMETrackingAssistant* _instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[IMETrackingAssistant alloc]init] initialize];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

#pragma mark - Initialize

- (instancetype)initialize {
    _eventContainer = [NSMutableDictionary new];
    
    return self;
}

#pragma mark - internal logic -

- (void)begin:(NSString *)eventName
        level:(IMEventLevel)level
        extra:(NSDictionary *)extra
  description:(NSString *)description
    indexName:(NSString *)indexName {
    
    NSParameterAssert(eventName);
    NSParameterAssert(indexName);
    
    extra = extra ? : @{};
    description = description ?: @"";
    NSDictionary *eventDict = @{
                                EVENT_NAME_KEY:eventName,
                                EVENT_TYPE_KEY:@(level),
                                EVENT_EXTRA_KEY:extra,
                                EVENT_DESCRIPTION_KEY:description,
                                JSON_INDEXNAME_KEY:indexName,
                                kDurationBeginKey:@(NSDate.date.timeIntervalSince1970)
                                };
    NSString *key = AS_getDurationRecordName(eventName, indexName);
    [_eventContainer setObject:eventDict forKey:key];
}

- (void)end:(NSString *)eventName indexName:(NSString *)indexName {
    
    NSString *key = AS_getDurationRecordName(eventName, indexName);
    NSDictionary *eventDict = [_eventContainer objectForKey:key];
    
    if (!eventDict) {
        return;
    }
    
    [self end:eventName level:[eventDict[EVENT_TYPE_KEY] integerValue] extra:eventDict[EVENT_EXTRA_KEY] description:eventDict[EVENT_DESCRIPTION_KEY] indexName:indexName Instant:NO];
    
}

- (void)end:(NSString *)eventName
      level:(IMEventLevel)level
      extra:(NSDictionary *)extra
description:(NSString *)description
  indexName:(NSString *)indexName
    Instant:(BOOL)instant {
    
    NSParameterAssert(eventName);
    NSParameterAssert(indexName);
    
    NSString *key = AS_getDurationRecordName(eventName, indexName);
    NSDictionary *eventDict = [_eventContainer objectForKey:key];
    
    if (!eventDict) {
        return; // Cant find the event by 'eventName'.
    }
    double beginTime = [[eventDict objectForKey:kDurationBeginKey] doubleValue];
    NSTimeInterval duration = [@(NSDate.date.timeIntervalSince1970) doubleValue] -  beginTime;
    
    IMEEventInfo *eventInfo = [[IMEEventInfo alloc]initWithName:eventName level:level description:description timestamp:[[IMEBaseInfoManager shareInstance] getCurrentTime] lineNumber:-1 extraInfo:extra duration:duration indexName:indexName];
    [[IMEEventManager shareInstance] handleEventWithEvent:eventInfo isInstant:instant];
    
    [_eventContainer removeObjectForKey:key];
}

- (void)cancelAllRecords {
    if (!_eventContainer.count || !_eventContainer) {
        return;
    }
    
    [_eventContainer enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSTimeInterval begin = [[obj objectForKey:kDurationBeginKey] doubleValue];
        NSTimeInterval duration = [@(NSDate.date.timeIntervalSince1970) doubleValue] -  begin;
        IMEEventInfo *eventInfo = [[IMEEventInfo alloc]initWithName:obj[EVENT_NAME_KEY] level:[obj[EVENT_TYPE_KEY] integerValue] description:obj[EVENT_DESCRIPTION_KEY] timestamp:[[IMEBaseInfoManager shareInstance] getCurrentTime] lineNumber:-1 extraInfo:obj[EVENT_EXTRA_KEY] duration:duration indexName:obj[JSON_INDEXNAME_KEY]];
        [[IMEEventManager shareInstance] handleEventWithEvent:eventInfo isInstant:NO];
    }];
    
    [_eventContainer removeAllObjects];
}

#pragma mark - Private

- (void)clean:(NSString *)eventName indexName:(nonnull NSString *)indexName {
    
    NSString *key = AS_getDurationRecordName(eventName, indexName);
    
    [_eventContainer removeObjectForKey:key];
}


@end
