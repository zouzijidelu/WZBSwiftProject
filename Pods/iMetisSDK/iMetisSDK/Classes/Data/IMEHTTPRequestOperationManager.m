//
//  IMEHTTPRequestOperationManager.m
//  imetis
//
//  Created by valenti on 2019/3/4.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import "IMEHTTPRequestOperationManager.h"
#import "IMEURLRequestSerialization.h"
#import "IMEDataPersistence.h"
#import "IMEJsonUtil.h"

#define kDefaultTimeout 30

@interface IMEHTTPRequestOperationManager()<NSURLSessionDelegate>

@property(nonatomic, strong) NSString* URL;
@property(nonatomic, strong) NSString* method;
@property(nonatomic, strong) id parameters;
@property(nonatomic, strong) NSMutableURLRequest* request;
@property(nonatomic, strong) NSURLSession* session;
@property(nonatomic, strong) NSURLSessionTask* task;

@end

@implementation IMEHTTPRequestOperationManager

- (instancetype)initWithMethod:(NSString *)method URL:(NSString *)URL parameters:(nullable id)parameters {
    self = [self init];
    if (self) {
        self.URL = URL;
        self.parameters = parameters;
        self.method = method;
        self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:kDefaultTimeout];
    }
    return self;
}

#pragma mark - private -
- (void)setAllowInvalidCertificates:(BOOL)allowInvalidCertificates {
    
    if (allowInvalidCertificates) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration                                                                    defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    }
}

- (NSURLSession *)session {
    
    if (!_session) {
        return [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration                                                    defaultSessionConfiguration]];
    }
    return _session;
}



#pragma mark - public -
- (NSString *)contentType {
    
    IMContentType mimeType = [IMEDataPersistence defaultPersistence].mimeType;
    
    switch (mimeType) {
        case IMContentTypeDefault:
            _contentType = @"application/x-www-form-urlencoded";
            break;
        case IMContentTypeJson:
            _contentType = @"application/json";
            break;
        case IMContentTypeZip:
            _contentType = @"application/zip";
            break;
        case IMContentTypeBmp:
            _contentType = @"image/bmp";
            break;
        case IMContentTypeText:
            _contentType = @"text/plain";
            break;
        case IMContentTypeJpeg:
            _contentType = @"image/jpeg";
            break;
        case IMContentTypePng:
            _contentType = @"image/png";
            break;
        case IMContentTypeGif:
            _contentType = @"text/gif";
            break;
            
        default:
            _contentType = @"application/x-www-form-urlencoded";
            break;
    }
    return _contentType;
}

- (void)setRequest {
    if ([self.method isEqualToString:@"GET"] && self.parameters) {
        self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[self.URL                              stringByAppendingString:@"?"] stringByAppendingString: [IMEURLRequestSerialization                                               queryStringFromParameters: (NSDictionary*)self.parameters]]]];
    }
    self.request.HTTPMethod = self.method;
    if (self.parameters) {
        NSString* token = [NSString stringWithFormat:@"Bearer %@", [[IMEDataPersistence defaultPersistence]                                                  accessToken]];
        
        [self.request addValue:token forHTTPHeaderField:@"Authorization"];
        [self.request addValue:self.contentType forHTTPHeaderField:@"Content-Type"];
    }
}

- (void)setBody {
    if (self.parameters && ![self.method isEqual:@"GET"]) {
        self.request.HTTPBody = [[IMEURLRequestSerialization queryStringFromParameters:                                                              (NSDictionary*)self.parameters] dataUsingEncoding:NSUTF8StringEncoding];
        if ([IMEDataPersistence defaultPersistence].mimeType == IMContentTypeDefault) {
            self.request.HTTPBody = [[IMEURLRequestSerialization queryStringFromParameters:self.parameters] dataUsingEncoding:NSUTF8StringEncoding];
        } else {
            if ([self.parameters isKindOfClass:[NSDictionary class]]) {
                // 单条事件
                self.request.HTTPBody = [[IMEJsonUtil convertToJsonString:self.parameters]         dataUsingEncoding:NSUTF8StringEncoding];
            } else if ([self.parameters isKindOfClass:[NSArray class]]) {
                // 多条事件处理
                NSArray* param = (NSArray*)self.parameters;
                NSMutableString* paraString = [NSMutableString string];
                
                for (NSInteger i = 0; i < param.count; i ++) {
                    NSString* item = [IMEJsonUtil convertToJsonString: (NSDictionary*)param[i]];
                    [paraString appendString: i == param.count - 1 ?  item : [NSString                     stringWithFormat:@"%@\n", item]];
                }
                self.request.HTTPBody = [paraString dataUsingEncoding:NSUTF8StringEncoding];
            }
        }
    }
}

- (void)setTaskWithSuccess:(void(^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                   failure:(void (^)(NSError *__nullable error))failure {
    
    self.task = [self.session dataTaskWithRequest:self.request completionHandler:^(NSData * data,                                                                       NSURLResponse *response,NSError *error){
        if (error) {
//            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//            IMLog(@"-----Status Code %ld", [httpResponse statusCode]);
            failure(error);
        } else {
            if (success) {
                success(data,response);
            }
        }
    }];
    [self.task resume];
}

- (void)request:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable))success                                                                                            failure:(void (^)(NSError * _Nullable))failure {
    [self setRequest];
    [self setBody];
    [self setTaskWithSuccess:success failure:failure];
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod                      isEqualToString:NSURLAuthenticationMethodServerTrust]) {//服务器信任证书
        NSURLCredential *credential = [NSURLCredential                 credentialForTrust:challenge.protectionSpace.serverTrust];//服务器信任证书
        if (completionHandler)
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
}
@end
