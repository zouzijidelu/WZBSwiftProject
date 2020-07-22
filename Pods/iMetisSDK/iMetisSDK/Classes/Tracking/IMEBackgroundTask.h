//
//  IMEBackgroundTask.h
//  imetis
//
//  Created by valenti on 2019/3/14.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
// 后台任务

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMEBackgroundTask : NSObject

+ (instancetype)defaultTask;

- (void)uploadEventsData;

- (void)didEnterBackgroundCallBack:(NSNotification *)notification;
- (void)willEnterForegroundCallBack:(NSNotification *)notification;
- (void)willTerminateCallBack:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
