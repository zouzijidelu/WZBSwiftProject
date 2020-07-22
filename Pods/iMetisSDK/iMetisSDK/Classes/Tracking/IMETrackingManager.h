//
//  IMETrackingManager.h
//  imetis
//
//  Created by valenti on 2019/3/5.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
// 手动埋点

#import <Foundation/Foundation.h>
#import "IMEConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMETrackingManager : NSObject


/**
 记录事件

 @param eventName 事件名称
 @param level 事件级别
 @param extra 事件附加参数
 @param description 事件描述
 @param indexName index
 @param isInstant 是否立即上报标识
 */
+ (void)recordEvent:(NSString *)eventName
              level:(IMEventLevel)level
              extra:(nullable NSDictionary *)extra
        description:(nullable NSString *)description
          indexName:(nullable NSString *)indexName
          isInstant:(BOOL)isInstant;


/**
 计时事件 - 开始记录

 @param eventName 事件名称
 */
+ (void)recordStart:(NSString *)eventName
              level:(IMEventLevel)level
              extra:(NSDictionary *)extra
        description:(NSString *)description
          indexName:(NSString *)indexName;

/**
 计时事件 - 停止记录
 
 @param eventName 事件名称
 @param level 事件级别
 @param extra 事件附加参数
 @param description 事件描述
 @param indexName index
 @param isInstant 是否立即上报标识
 */
+ (void)recordStop:(NSString *)eventName
              level:(IMEventLevel)level
              extra:(nullable NSDictionary *)extra
        description:(nullable NSString *)description
          indexName:(nullable NSString *)indexName
          isInstant:(BOOL)isInstant;

+ (void)applicationDidEnterBackground:(NSNotification *)notiication;


@end

NS_ASSUME_NONNULL_END
