//
//  IMEConnectionAdapter.m
//  imetis
//
//  Created by valenti on 2019/3/4.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import "IMEConnectionAdapter.h"
#import "IMEURLRequestSerialization.h"
#import "IMEHTTPRequestOperationManager.h"
#import "IMEDataPersistence.h"

@implementation IMEConnectionAdapter

+ (void)requestWithMethod:(NSString *)method
                      URL:(NSString *)URL
                  success:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable))success
                  failure:(void (^)(NSError * _Nullable))failure {
    IMEHTTPRequestOperationManager* manager = [[IMEHTTPRequestOperationManager alloc] initWithMethod:method                                                                        URL:URL parameters:nil];
    manager.allowInvalidCertificates = IMEDataPersistence.defaultPersistence.isTrustServer;
    [manager request:success failure:failure];
    
}

+ (void)requestGETWithURL:(NSString *)URL
                  success:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable))success
                  failure:(void (^)(NSError * _Nullable))failure {
    IMEHTTPRequestOperationManager* manager = [[IMEHTTPRequestOperationManager alloc] initWithMethod:@"GET"                                                                        URL:URL parameters:nil];
    manager.allowInvalidCertificates = IMEDataPersistence.defaultPersistence.isTrustServer;
    [manager request:success failure:failure];
}

+ (void)requestGETWithURL:(NSString *)URL
               parameters:(id)parameters
                  success:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable))success
                  failure:(void (^)(NSError * _Nullable))failure {
    IMEHTTPRequestOperationManager* manager = [[IMEHTTPRequestOperationManager alloc] initWithMethod:@"GET"                                                                URL:URL parameters:parameters];
    manager.allowInvalidCertificates = IMEDataPersistence.defaultPersistence.isTrustServer;
    [manager request:success failure:failure];
}

+ (void)requestPOSTWithURL:(NSString *)URL
                   success:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable))success
                   failure:(void (^)(NSError * _Nullable))failure {
    IMEHTTPRequestOperationManager* manager = [[IMEHTTPRequestOperationManager alloc] initWithMethod:@"POST"                                                                               URL:URL parameters:nil];
    manager.allowInvalidCertificates = IMEDataPersistence.defaultPersistence.isTrustServer;
    [manager request:success failure:failure];
}

+ (void)requestPOSTWithURL:(NSString *)URL
                parameters:(id)parameters
                   success:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable))success
                   failure:(void (^)(NSError * _Nullable))failure {
    IMEHTTPRequestOperationManager* manager = [[IMEHTTPRequestOperationManager alloc] initWithMethod:@"POST"                                                                   URL:URL parameters:parameters];
    manager.allowInvalidCertificates = IMEDataPersistence.defaultPersistence.isTrustServer;
    [manager request:success failure:failure];
}

@end
