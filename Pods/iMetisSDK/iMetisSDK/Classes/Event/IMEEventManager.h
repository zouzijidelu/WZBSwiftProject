//
//  IMEEventManager.h
//  imetis
//
//  Created by 黄娇双 on 2019/2/26.
//  Copyright © 2019年 iTalkBB Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMEEventInfo.h"
#import "IMEDBManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMEEventManager : NSObject

@property (nonatomic, strong, readonly) IMEDBManager *dbManager;


/**
 Create

 @return IMEEventManager object
 */
+ (instancetype)shareInstance;

/**
 Auto Handle event

 @param event eventInfo
 @param isInstant whether immediately
 */
- (void)handleEventWithEvent:(IMEEventInfo *)event isInstant:(BOOL)isInstant;

@end

NS_ASSUME_NONNULL_END
