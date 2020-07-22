//
//  IMEetisSDK.h
//  imetis
//
//  Created by Michael Wu on 2019/2/21.
//  Copyright © 2019年 iTalkBB Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMEConstant.h"
#import "IMESDKConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMetisSDK : NSObject
/**
 Create
 
 @return IMEetisSDK object
 */
+ (instancetype)shareIMetisSDK;

/**
 sdk automatically initiate authentication
 */
- (void)registerSDKWithConfiguration:(void(^)(IMESDKConfiguration *config))configuration;

/**
 Set user id
 
 @param userId user id
 */
- (void)setUserId:(NSString *)userId;

/**
 Set App UUID if you need, default is [[UIDevice.currentDevice identifierForVendor] UUIDString]
 
 @param uuid customizable App-uuid
 */
- (void)setAppUUID:(NSString *)uuid;

/**
 Clear user id
 */
- (void)clearUserId;

/**
 Record a normal event.

 @param eventName Event name.
 @param indexName Index name.
 */
- (void)record:(NSString *)eventName indexName:(NSString *)indexName;


/**
 Record a normal event with detail infomation.

 @param eventName Event name.
 @param level Event Level, @see IMEventLevel
 @param extra Custom information.
 @param description Event description.
 @param indexName Index name.
 @param isInstant Whether to upload event to server immediately.
 */
- (void)record:(NSString *)eventName
         level:(IMEventLevel)level
         extra:(nullable NSDictionary *)extra
   description:(nullable NSString *)description
     indexName:(nullable NSString *)indexName
     isInstant:(BOOL)isInstant;

/**
 Timed event start.
 */
- (void)recordEventBegin:(NSString *)eventName indexName:(NSString *)indexName;

/**
 Timed event start (detailed)
 */
- (void)recordEventBegin:(NSString *)eventName
                   level:(IMEventLevel)level
                   extra:(nullable NSDictionary *)extra
             description:(nullable NSString *)description
               indexName:(nullable NSString *)indexName;

/**
 Timed event end
 */
- (void)recordEventEnd:(NSString *)eventName indexName:(NSString *)indexName;

/**
 Timed event end  (detailed)
 */
- (void)recordEventEnd:(NSString *)eventName
                 level:(IMEventLevel)level
                 extra:(nullable NSDictionary *)extra
           description:(nullable NSString *)description
             indexName:(nullable NSString *)indexName
             isInstant:(BOOL)isInstant;

/**
 Set max imetis cache size

 @param maxCacheSize max cache size unit is (MB)
 */
- (void)setMaxCacheSize:(long)maxCacheSize;

/**
 Whether to open auto tracking
 */
- (void)setAutoTrackingEnabled:(BOOL)enable autoTrackIndexName:(NSString *)indexName;

/**
 Whether sdk initialized

 @return sdk status
 */
- (BOOL)isSDKInitialized;

@end

NS_ASSUME_NONNULL_END
