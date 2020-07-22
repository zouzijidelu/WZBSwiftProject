//
//  IMEEventInfo.m
//  imetis
//
//  Created by 黄娇双 on 2019/2/21.
//  Copyright © 2019年 iTalkBB Team. All rights reserved.
//

#import "IMEEventInfo.h"
#import "IMEMD5.h"
#import "IMEBaseInfoManager.h"

NSString * const EVENT_EVENTID_KEY = @"eventId";
NSString * const EVENT_NAME_KEY = @"name";
NSString * const EVENT_DURATION_KEY = @"duration";
NSString * const EVENT_TYPE_KEY = @"eventLevel";
NSString * const EVENT_DESCRIPTION_KEY = @"description";
NSString * const EVENT_TIMESTAMP_KEY = @"timestamp";
NSString * const EVENT_LINE_KEY = @"line";
NSString * const EVENT_EXTRA_KEY = @"extra";
NSString * const JSON_INDEXNAME_KEY = @"indexName";

@implementation IMEEventInfo


- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    NSString *name = [dict objectForKey:EVENT_NAME_KEY];
    NSInteger level = [[dict objectForKey:EVENT_TYPE_KEY] integerValue];
    NSString *description = [dict objectForKey:EVENT_DESCRIPTION_KEY];
    NSString *timestamp = [dict objectForKey:EVENT_TIMESTAMP_KEY];
    NSInteger lineNumber = [[dict objectForKey:EVENT_LINE_KEY] integerValue];
    NSDictionary *extraInfo = [dict objectForKey:EVENT_EXTRA_KEY];
    NSInteger duration = [[dict objectForKey:EVENT_DURATION_KEY]integerValue];
    NSString *indexName = [dict objectForKey:JSON_INDEXNAME_KEY];
    
    NSParameterAssert(name);
    NSParameterAssert(indexName);
    
    self = [self initWithName:name level:level description:description timestamp:timestamp lineNumber:lineNumber extraInfo:extraInfo duration:duration indexName:indexName];
    
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
                       level:(NSInteger)level
                 description:(NSString *)description
                   timestamp:(NSString *)timestamp
                  lineNumber:(NSInteger)lineNumber
                   extraInfo:(NSDictionary *)extraInfo
                    duration:(NSInteger)duration
                   indexName:(NSString *)indexName {
    
    NSParameterAssert(name);
    NSParameterAssert(indexName);
    
    if (self = [super init]) {
        _name = name;
        _level = level;
        _descriptions = description;
        _timestamp = timestamp;
        _lineNumber = lineNumber;
        _info = extraInfo;
        _duration = duration;
        _indexName = indexName;
    }
    return self;
}


- (NSString *)eventId {
    NSString *eventInfo = [NSString stringWithFormat:@"%@%@%@%ld%@%ld%ld%@", self.name,                             self.descriptions, self.info.description, (long)self.level, self.timestamp,                           (long)self.lineNumber, (long)self.duration,self.indexName];
    return [IMEMD5 md5:eventInfo];
}

- (NSDictionary *)toDictionary {
    
    NSInteger eventDuration = _duration;
    NSString* eventDescription = !_descriptions ? @"" : _descriptions;
    NSInteger eventLine = _lineNumber == 0 ? -1 : _lineNumber;
    NSDictionary* eventExtra = !_info ? @{} : _info;
    
    NSDictionary *final = @{
                            EVENT_NAME_KEY:_name,
                            EVENT_TYPE_KEY:@(_level),
                            EVENT_DESCRIPTION_KEY:eventDescription,
                            EVENT_TIMESTAMP_KEY:_timestamp,
                            EVENT_LINE_KEY:@(eventLine),
                            EVENT_EXTRA_KEY:eventExtra,
                            EVENT_DURATION_KEY:@(eventDuration),
                            EVENT_EVENTID_KEY:self.eventId,
                            JSON_INDEXNAME_KEY:_indexName
                            };
    return final;
}


@end
