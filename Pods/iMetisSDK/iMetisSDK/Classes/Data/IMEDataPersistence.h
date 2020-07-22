//
//  IMEDataPersistence.h
//  imetis
//
//  Created by valenti on 2019/3/6.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
// 数据持久化

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, IMContentType) {
    IMContentTypeDefault = 0,
    IMContentTypeJson = 1 << 0,
    IMContentTypeBmp = 1 << 1,
    IMContentTypeText = 1 << 2,
    IMContentTypeZip = 1 << 3,
    IMContentTypePng = 1 << 4,
    IMContentTypeGif = 1 << 5,
    IMContentTypeJpeg = 1 << 6
};


NS_ASSUME_NONNULL_BEGIN

@interface IMEDataPersistence : NSObject

@property (nonatomic, copy, nullable) NSString* accessToken;
@property (nonatomic, copy, nullable) NSString* refreshToken;

@property (nonatomic, copy, nullable) NSString* clientId;
@property (nonatomic, copy, nullable) NSString* clientSecret;

@property (nonatomic, assign) NSInteger expiresIn;

@property (nonatomic, copy, nullable) NSString* logHost;
@property (nonatomic, copy, nullable) NSString* authHost;

@property (nonatomic, copy, nullable) NSString* userId;

@property (nonatomic, assign) IMContentType mimeType;


/**
 是否无条件信任 Server 端，绕过 HTTPS 证书验证
 */
@property (nonatomic, assign) BOOL isTrustServer;
@property (nonatomic, assign, getter=isSdkInitialized) BOOL sdkInitialized;

+ (instancetype)defaultPersistence;

@end

NS_ASSUME_NONNULL_END
