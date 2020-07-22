//
//  IMEDataManager.m
//  imetis
//
//  Created by valenti on 2019/2/25.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import "IMEData.h"
#import "IMEConnectionAdapter.h"
#import "IMEDataPersistence.h"
#import "IMEBaseInfoManager.h"
#import "IMEJsonUtil.h"
#import "IMEEventManager.h"
#import "IMEExceptionTool.h"
#import "IMEConstant.h"

NSString* const BS_USER_ID_KEY = @"userId";
NSString* const BS_DEVICE_ID_KEY = @"deviceId";
NSString* const BS_DEVICE_MODEL_KEY = @"deviceModel";
NSString* const BS_DEVICE_SUBMODEL_KEY = @"deviceSubModel";
NSString* const BS_DEVICE_PLATFORM_KEY = @"devicePlatform";
NSString* const BS_APP_NAME_KEY = @"appName";
NSString* const BS_APP_ID_KEY = @"appId";
NSString* const BS_APP_VERSION_NAME_KEY = @"appVersionName";
NSString* const BS_APP_VERSION_CODE_KEY = @"appVersionCode";
NSString* const BS_NETWORK_STATUS_KEY = @"networkStatus";
NSString* const BS_SYSTEM_VERSION_KEY = @"systemVersion";
NSString* const BS_VENDOR_KEY = @"vendor";
NSString* const BS_BATTERY_KEY = @"battery";

NSString* const PARAM_INDEX_KEY = @"indexName";
NSString* const PARAM_BASEINFO_KEY = @"baseInfo";
NSString* const PARAM_EVENT_KEY = @"event";
NSString* const PARAM_CLIENT_ID_KEY = @"client_id";
NSString* const PARAM_CLIENT_SECRET_KEY = @"client_secret";


NSString* const RESPONSE_ACCESS_TOKEN_KEY = @"access_token";
NSString* const RESPONSE_EXPIRES_IN_KEY = @"expires_in";
NSString* const RESPONSE_TOKEN_TYPE_KEY = @"bearer";
NSString* const RESPONSE_REFRESH_TOKEN_KEY = @"refresh_token";

static char * const imetis_network_queue = "imetis.network.async.queue";

static const void * const kDispatchQueueSpecificKey = &kDispatchQueueSpecificKey;

@interface IMEData (){
    dispatch_queue_t _queue;
}

@end

@implementation IMEData

#pragma mark - init
static IMEData* _instance = nil;
+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMEData alloc]init];
        [_instance initialize];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)initialize {
    
    _queue = dispatch_queue_create(imetis_network_queue, DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_set_specific(_queue, kDispatchQueueSpecificKey, imetis_network_queue, NULL);
    
    return self;
}

#pragma mark - internal logic -
- (void)requestAccessToken:(NSString *)clientID
                    secret:(NSString *)secret {
    
    if (![IMEExceptionTool checkAuthURL]) return;
    
    [IMEDataPersistence defaultPersistence].clientId = clientID;
    [IMEDataPersistence defaultPersistence].clientSecret = secret;

    [self refreshToken];
}

#pragma mark - Queue

- (void)inIMNetworkDistachQueue:(void(^)(void))block {
    
    char *key = dispatch_get_specific(kDispatchQueueSpecificKey);
   
    if (key != NULL) {
        block();
    }else {
        dispatch_async(_queue, ^{
            block();
        });
    }
}

#pragma mark - Http

// 单条数据上报
- (void)uploadEventData:(IMEEventInfo *)eventInfo
                success:(void (^)(void))success
                failure:(void (^)(void))failure {
    
    if (![IMEExceptionTool checkUploadURL]) return;
    
    [IMEDataPersistence defaultPersistence].mimeType = IMContentTypeJson;
    
    NSDictionary* param = IMAppendingEventParam(eventInfo.toDictionary);
    
    [IMEConnectionAdapter requestPOSTWithURL:[IMEDataPersistence defaultPersistence].logHost parameters:param                                               success:^(NSData * _Nullable data, NSURLResponse * _Nullable response) {
        // HTTP 状态码
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        
        NSInteger statusCode = httpResponse.statusCode;
        
        IMLog(@"[-_-] imetis: http response code is %ld", (long)statusCode);
        
        // token 过期
        if (statusCode >= 200 && statusCode < 300) {
            [self inIMNetworkDistachQueue:success];
            
        }else {
            if (statusCode == 401) {
                [self refreshToken];
            }
            [self inIMNetworkDistachQueue:failure];
        }
        
    } failure:^(NSError * _Nullable error) {
        [self inIMNetworkDistachQueue:^{
            failure();
        }];
    }];
}
// 多条数据上报
- (void)uploadEventsData:(NSArray<IMEEventInfo *> *)events
                 success:(nullable void (^)(void))success
                 failure:(nullable void (^)(void))failure {
    
    if (![IMEDataPersistence defaultPersistence].logHost || [[IMEDataPersistence defaultPersistence].logHost         isEqualToString:@""]) return;

    IMEDataPersistence.defaultPersistence.isTrustServer = YES;
    [IMEDataPersistence defaultPersistence].mimeType = IMContentTypeJson;
    
    NSMutableArray* param = [NSMutableArray array];
    [events enumerateObjectsUsingBlock:^(IMEEventInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [param addObject:IMAppendingEventParam(obj.toDictionary)];
    }];
    
    [IMEConnectionAdapter requestPOSTWithURL: [IMEDataPersistence defaultPersistence].logHost parameters:param                                                               success:^(NSData * _Nullable data, NSURLResponse * _Nullable response) {

        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        
        NSInteger statusCode = httpResponse.statusCode;
        
        IMLog(@"[-_-] imetis: http response code is %ld", (long)statusCode);
        
        if (statusCode == 401) {
            [self inIMNetworkDistachQueue:^{
                if (failure) failure();
            }];

            [self refreshToken];
        } else {
            
            [IMEEventManager.shareInstance.dbManager deleteEventsWithCount:IM_MAX_COUNT_EVENTS complete:^(BOOL res, IMEDBManager * _Nonnull manager) {

            }];
            
            [self inIMNetworkDistachQueue:^{
                if (success) success();
            }];
        }
    } failure:^(NSError * _Nullable error) {
        [self inIMNetworkDistachQueue:^{
            if (failure) failure();
        }];
    }];
}

- (void)refreshToken {
    if (![IMEExceptionTool checkAuthURL]) return;
    
    NSString* clientID = [IMEDataPersistence defaultPersistence].clientId;
    NSString* clientSecret = [IMEDataPersistence defaultPersistence].clientSecret;

    if ([IMEDataPersistence defaultPersistence].accessToken.length > 0) {
        [IMEDataPersistence.defaultPersistence setSdkInitialized:YES];
    }
    
    [IMEDataPersistence defaultPersistence].mimeType = IMContentTypeDefault;
#warning 要改
    IMEDataPersistence.defaultPersistence.isTrustServer = YES;
    
    [IMEConnectionAdapter requestPOSTWithURL:IMEDataPersistence.defaultPersistence.authHost parameters:                                     @{PARAM_CLIENT_ID_KEY : clientID, PARAM_CLIENT_SECRET_KEY : clientSecret}                                                                     success:^(NSData * _Nullable data, NSURLResponse * _Nullable response) {
        // 处理返回的 Data 数据
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:                                NSJSONReadingMutableContainers error: nil];
        IMLog(@"%@", dictionary);
        
        // 认证成功说明 SDK 初始化完成
        [IMEDataPersistence defaultPersistence].accessToken = dictionary[RESPONSE_ACCESS_TOKEN_KEY];
        [IMEDataPersistence.defaultPersistence setSdkInitialized:YES];
        
    } failure:^(NSError * _Nullable error) {
        IMLog(@"[>_<] imetis: request failure!!!");
        if (![IMEDataPersistence defaultPersistence].accessToken.length) {
            [IMEDataPersistence.defaultPersistence setSdkInitialized:NO];
        }
    }];
}


// - (void)retryRequestToken
NSDictionary* IMAppendingEventParam(NSDictionary* eventDict) {
    
    NSMutableDictionary *mutEventDictCopy = [eventDict mutableCopy];
    [mutEventDictCopy removeObjectForKey:JSON_INDEXNAME_KEY];
    
    NSDictionary* param = @{
                            PARAM_INDEX_KEY: eventDict[JSON_INDEXNAME_KEY],
                            PARAM_BASEINFO_KEY: @{
                                    BS_USER_ID_KEY : [IMEDataPersistence defaultPersistence].userId,
                                    BS_DEVICE_ID_KEY : [[IMEBaseInfoManager shareInstance] getAppUUID],
                                    BS_DEVICE_MODEL_KEY : [[IMEBaseInfoManager shareInstance] getPhoneModel],
                                    BS_DEVICE_SUBMODEL_KEY : [[IMEBaseInfoManager shareInstance] getDeviceSubModel],
                                    BS_APP_NAME_KEY : [[IMEBaseInfoManager shareInstance] getAppName],
                                    BS_APP_ID_KEY : [[IMEBaseInfoManager shareInstance] getAppBundleId],
                                    BS_APP_VERSION_NAME_KEY : [[IMEBaseInfoManager shareInstance] getAppVersion],
                                    BS_APP_VERSION_CODE_KEY :  @([[IMEBaseInfoManager shareInstance] getAppVersionCode]),
                                    BS_NETWORK_STATUS_KEY : [[IMEBaseInfoManager shareInstance] getNetWorkStatus],
                                    BS_SYSTEM_VERSION_KEY : [[IMEBaseInfoManager shareInstance] getSystemVersion],
                                    BS_VENDOR_KEY : @"Apple",
                                    BS_BATTERY_KEY : @([[IMEBaseInfoManager shareInstance] getBatteryLevel]),
                                    BS_DEVICE_PLATFORM_KEY: @"iOS"
                                    },
                            PARAM_EVENT_KEY: mutEventDictCopy,
                            };
    return param;
}

@end
