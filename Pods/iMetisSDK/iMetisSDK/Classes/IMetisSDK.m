//
//  IMEetisSDK.m
//  imetis
//
//  Created by Michael Wu on 2019/2/21.
//  Copyright © 2019年 iTalkBB Team. All rights reserved.
//

#import "IMetisSDK.h"
#import "IMEViewTrackingManager.h"
#import "IMEData.h"
#import "IMETrackingManager.h"
#import "IMEDataPersistence.h"
#import "IMEEventManager.h"
#import "IMEBackgroundTask.h"
#import "IMEDataPersistence.h"
#import "IMEBaseInfoManager.h"
#import <UIKit/UIKit.h>

@implementation IMetisSDK
+ (instancetype)shareIMetisSDK {
    static IMetisSDK *imetis;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imetis = [[IMetisSDK alloc] init];
    });
    return imetis;
}

- (instancetype)init {
    if (self = [super init]) {
        //program initial start
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(didEnterBackgroundCallBack:)
                                                   name:UIApplicationDidEnterBackgroundNotification
                                                 object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(willEnterForegroundCallBack:)
                                                   name:UIApplicationWillEnterForegroundNotification
                                                 object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(willTerminateCallBack:)
                                                   name:UIApplicationWillTerminateNotification
                                                 object:nil];
    
        [IMEEventManager.shareInstance.dbManager autoCleanFileSizeIfNeeded];        
    }
    return self;
}

- (void)registerSDKWithConfiguration:(void (^)(IMESDKConfiguration * _Nonnull))configuration {
    
    if (!configuration) {
        NSAssert(NO, @"you must point a SDK configuration");
        return;
    }
    
    IMESDKConfiguration *config = [[IMESDKConfiguration alloc]init];
    configuration(config);
    
    [IMEDataPersistence defaultPersistence].authHost = config.OAuthURL;
    [IMEDataPersistence defaultPersistence].logHost = config.UploadLogURL;
    IMLog(@"[^_^][iMetis] Current auth url is: '%@'\n log url is '%@'",config.OAuthURL,config.UploadLogURL);
        
    [IMEData.shareInstance requestAccessToken:config.AppId secret:config.AppSecret];
    
    [IMEBackgroundTask.defaultTask performSelector:@selector(uploadEventsData) withObject:nil afterDelay:2.f]; // upload events if in DB .
    
}


- (void)setUserId:(NSString *)userId {
    [IMEDataPersistence defaultPersistence].userId = userId;
}

- (void)setAppUUID:(NSString *)uuid {
    [[IMEBaseInfoManager shareInstance] setAppUUID:uuid];
}

- (void)clearUserId {
    [IMEDataPersistence defaultPersistence].userId = @"";
}

- (void)record:(NSString *)eventName indexName:(nonnull NSString *)indexName {
    [IMETrackingManager recordEvent:eventName
                              level:IMEventLevelVerbose
                              extra:@{}
                        description:nil
                          indexName:indexName
                          isInstant:NO];
}

- (void)record:(NSString *)eventName
         level:(IMEventLevel)level
         extra:(NSDictionary *)extra
   description:(NSString *)description
     indexName:(NSString *)indexName
     isInstant:(BOOL)isInstant {
    
    [IMETrackingManager recordEvent:eventName
                             level:level
                             extra:extra
                       description:description
                         indexName:indexName
                         isInstant:isInstant];
    
}

- (void)recordEventBegin:(NSString *)eventName indexName:(NSString *)indexName {
    [self recordEventBegin:eventName level:(IMEventLevelVerbose) extra:nil description:nil indexName:indexName];
}

- (void)recordEventBegin:(NSString *)eventName
                   level:(IMEventLevel)level
                   extra:(NSDictionary *)extra
             description:(NSString *)description
               indexName:(NSString *)indexName {
    
    [IMETrackingManager recordStart:eventName level:level extra:extra description:description indexName:indexName];
}

- (void)recordEventEnd:(NSString *)eventName indexName:(nonnull NSString *)indexName {
    
    [IMETrackingManager recordStop: eventName
                             level: IMEventLevelVerbose
                             extra: @{}
                       description: nil
                         indexName: indexName
                         isInstant: NO];
}

- (void)recordEventEnd:(NSString *)eventName
                 level:(IMEventLevel)level
                 extra:(NSDictionary *)extra
           description:(NSString *)description
             indexName:(NSString *)indexName
             isInstant:(BOOL)isInstant {
    
    [IMETrackingManager recordStop:eventName
                            level:level
                            extra:extra
                      description:description
                        indexName:indexName
                        isInstant:isInstant];
}

- (void)setAutoTrackingEnabled:(BOOL)enable autoTrackIndexName:(NSString *)indexName {
    [IMEViewTrackingManager shareInstance].isAutoTracking = enable;
    [IMEViewTrackingManager shareInstance].defaultIndexName = indexName;
}

- (BOOL)isSDKInitialized {
    return [IMEDataPersistence defaultPersistence].isSdkInitialized;
}

#pragma mark - Private

- (void)setMaxCacheSize:(long)maxCacheSize {
    
    [IMEEventManager.shareInstance.dbManager setMaxFileSize:maxCacheSize];
}

#pragma mark - Notification

// Application did enter background
- (void)didEnterBackgroundCallBack:(NSNotification *)notification {
    [[IMEBackgroundTask defaultTask] didEnterBackgroundCallBack:notification];
}

// Application will enter foreground
- (void)willEnterForegroundCallBack:(NSNotification *)notification {
    [[IMEBackgroundTask defaultTask] willEnterForegroundCallBack:notification];
    [IMETrackingManager applicationDidEnterBackground:notification];
}

// Application will terminate
- (void)willTerminateCallBack:(NSNotification *)notification {
    [[IMEBackgroundTask defaultTask] willTerminateCallBack:notification];
}

@end
