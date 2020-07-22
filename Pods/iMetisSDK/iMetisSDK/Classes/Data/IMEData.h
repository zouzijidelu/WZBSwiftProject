//
//  IMEDataManager.h
//  imetis
//
//  Created by valenti on 2019/2/25.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IMEEventInfo;

NS_ASSUME_NONNULL_BEGIN

@interface IMEData : NSObject

+ (instancetype)shareInstance;


/**
 认证 SDK

 @param clientID 唯一应用标识
 @param secret 唯一应用密钥
 */
- (void)requestAccessToken:(NSString *)clientID secret:(NSString *)secret;

/**
 单条上传事件

 @param eventDict 描述事件信息的字典
 */
- (void)uploadEventData:(IMEEventInfo *)eventInfo
                success:(nullable void (^)(void))success
                failure:(nullable void (^)(void))failure;


/**
 批量事件上传
 */
- (void)uploadEventsData:(NSArray<IMEEventInfo*>*)events
                 success:(nullable void (^)(void))success
                 failure:(nullable void (^)(void))failure;;

- (void)refreshToken;

@end

NS_ASSUME_NONNULL_END
