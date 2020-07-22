//
//  IMEHTTPRequestOperationManager.h
//  imetis
//
//  Created by valenti on 2019/3/4.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
// 请求管理器

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMEHTTPRequestOperationManager : NSObject

/**
 是否信任非法证书
 */
@property (nonatomic, assign) BOOL allowInvalidCertificates;

/**
 设置请求题 HEADER Content-Type 字段
 */
@property (nonatomic, copy) NSString* contentType;

- (void)request:(nullable void(^)(NSData *__nullable data,NSURLResponse * __nullable response))success
        failure:(nullable void (^)(NSError *__nullable error))failure;

- (instancetype)initWithMethod:(NSString*)method URL:(NSString*)URL parameters:(nullable id)parameters;

@end

NS_ASSUME_NONNULL_END
