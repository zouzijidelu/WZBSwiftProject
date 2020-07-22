//
//  IMETrackingManager.m
//  imetis
//
//  Created by valenti on 2019/3/5.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import "IMETrackingManager.h"
#import "IMEViewTrackingManager.h"
#import "IMEEventManager.h"
#import "IMEConstant.h"
#import "IMETrackingAssistant.h"
#import "IMEBaseInfoManager.h"
#import "IMEEventInfo.h"
#import "IMEDataPersistence.h"

@implementation IMETrackingManager

+ (void)recordEvent:(NSString *)eventName
              level:(IMEventLevel)level
              extra:(NSDictionary *)extra
        description:(NSString *)description
          indexName:(NSString *)indexName
          isInstant:(BOOL)isInstant {
    
    if (![IMEDataPersistence defaultPersistence].isSdkInitialized) {
        isInstant = NO;
    }
    
    IMEEventInfo *eventInfo = [[IMEEventInfo alloc]initWithName:eventName level:level description:description timestamp:[IMEBaseInfoManager.shareInstance getCurrentTime] lineNumber:-1 extraInfo:extra duration:0 indexName:indexName];
    [[IMEEventManager shareInstance] handleEventWithEvent:eventInfo isInstant:isInstant];
}

+ (void)recordStart:(NSString *)eventName
              level:(IMEventLevel)level
              extra:(NSDictionary *)extra
        description:(NSString *)description
          indexName:(NSString *)indexName {
    
    [[IMETrackingAssistant shareInstance] begin:eventName level:level extra:extra description:description indexName:indexName];
}

+ (void)recordStop:(NSString *)eventName
             level:(IMEventLevel)level
             extra:(NSDictionary *)extra
       description:(NSString *)description
         indexName:(NSString *)indexName
         isInstant:(BOOL)isInstant {
    
    if (![IMEDataPersistence defaultPersistence].isSdkInitialized) {
        isInstant = NO;
    }
    
    [[IMETrackingAssistant shareInstance] end:eventName level:level extra:extra description:description indexName:indexName Instant:isInstant];  
}

+ (void)applicationDidEnterBackground:(NSNotification *)notiication {
    [[IMETrackingAssistant shareInstance] cancelAllRecords];
}

@end
