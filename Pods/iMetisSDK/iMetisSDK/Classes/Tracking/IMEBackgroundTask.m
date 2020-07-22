//
//  IMEBackgroundTask.m
//  imetis
//
//  Created by valenti on 2019/3/14.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import "IMEBackgroundTask.h"
#import "IMEEventManager.h"
#import "IMETrackingManager.h"
#import "IMEEventManager.h"
#import "IMEData.h"
#import "IMEDataPersistence.h"
#import <UIKit/UIKit.h>

@interface IMEBackgroundTask()

@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation IMEBackgroundTask {
    // Count of upload failure times
    NSInteger _retryTimes;
    NSInteger _maxRetryTimes;
}

#pragma mark - init -

static IMEBackgroundTask* _instance = nil;

+ (instancetype)defaultTask {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMEBackgroundTask alloc]init];
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

- (instancetype)init {
    if (self = [super init]) {
        _maxRetryTimes = 3;
        _backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
    return self;
}

#pragma mark - Private

- (void)endBackgroundTask {
   
    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        [UIApplication.sharedApplication endBackgroundTask: self.backgroundTaskIdentifier];
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
    _retryTimes = 0;
}

#pragma mark - Application Notification

// Application did enter background
- (void)didEnterBackgroundCallBack:(NSNotification *)notification {
    IMLog(@"[•_•] imetis: App did enter background.");
    if (!_backgroundTaskIdentifier) {
        _backgroundTaskIdentifier = [[UIApplication sharedApplication]                                                      beginBackgroundTaskWithExpirationHandler:^{
            
            [self endBackgroundTask]; // 申请的后台时间(3 分钟)即将到达的时候执行该 block, 停止上报
        }];
        _retryTimes = 0;
        [self uploadEventsData];
    }
    
}

// Application will enter foreground
- (void)willEnterForegroundCallBack:(NSNotification *)notification {
    
    IMLog(@"[•_•] imetis: App will enter foreground.");
    [[IMEData shareInstance] refreshToken];
    
    [self endBackgroundTask];
}

// Application will terminate
- (void)willTerminateCallBack:(NSNotification *)notification {
    IMLog(@"[•_•] imetis: App will terminate.");
}


/*
- (void)timedUpload:(NSTimer *)timer {
    NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining == DBL_MAX) {
        IMLog(@"Background Time Remaining = Undetermined");
    } else {
        IMLog(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
        [self uploadEventsData];
    }
}
*/

- (void)uploadEventsData {
    
    [IMEEventManager.shareInstance.dbManager selectEventsWithCount:IM_MAX_COUNT_EVENTS complete:^(BOOL res, NSArray<IMEEventInfo *> * _Nonnull events, IMEDBManager * _Nonnull manager) {
       
        if (!res) {
            IMLog(@"[iMetis][WARN]IM select failed, attention please !");
            return ;
        }
        if (!events.count) {
            return;
        }
        
        [IMEData.shareInstance uploadEventsData:events success:^{
            [self uploadEventsData];
        } failure:^{
            if (self->_retryTimes < self->_maxRetryTimes) {
                [self uploadEventsData];
                self->_retryTimes++;
            }
        }];
        
    }];
}


@end
