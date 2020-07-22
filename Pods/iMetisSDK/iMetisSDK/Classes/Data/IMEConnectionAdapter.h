//
//  IMEConnectionAdapter.h
//  imetis
//
//  Created by valenti on 2019/3/4.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
// 网络适配器

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMEConnectionAdapter : NSObject


/**
 无参数请求

 @param method GET、POST
 @param URL URL
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestWithMethod:(nullable NSString *)method
                     URL:(nullable NSString *)URL
                 success:(nullable void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                 failure:(nullable void (^)(NSError *__nullable error))failure;

/**
 GET 方式无参数请求

 @param URL URL
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestGETWithURL:(nullable NSString *)URL
                  success:(nullable void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                  failure:(nullable void (^)(NSError *__nullable error))failure;


/**
 GET 方式有参数请求

 @param URL URL
 @param parameters parameters
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestGETWithURL:(nullable NSString *)URL
              parameters:(nullable id) parameters
                 success:(nullable void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                 failure:(nullable void (^)(NSError *__nullable error))failure;


/**
 POST 方式无参请求

 @param URL URL
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestPOSTWithURL:(nullable NSString *)URL
                  success:(nullable void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                  failure:(nullable void (^)(NSError *__nullable error))failure;


/**
 POST 方式有参请求

 @param URL URL
 @param parameters parameters
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestPOSTWithURL:(nullable NSString *)URL
               parameters:(nullable id) parameters
                  success:(nullable void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                  failure:(nullable void (^)(NSError *__nullable error))failure;

@end

NS_ASSUME_NONNULL_END
