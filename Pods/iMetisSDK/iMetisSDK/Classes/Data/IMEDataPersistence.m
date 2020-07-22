//
//  IMEDataPersistence.m
//  imetis
//
//  Created by valenti on 2019/3/6.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import "IMEDataPersistence.h"

NSString  * const kAccessToken = @"imetis_access_token";
NSString  * const kRefreshToken = @"imetis_refresh_token";
NSString  * const kExpiresIn = @"imetis_expires_in";
NSString  * const kLogHost = @"imetis_log_host";
NSString  * const kAuthHost = @"imetis_auth_host";
NSString  * const kUserId = @"imetis_user_id";
NSString  * const kIndexName = @"imetis_index_name";

@implementation IMEDataPersistence

#pragma mark - init
static IMEDataPersistence* _instance = nil;
+ (instancetype)defaultPersistence {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMEDataPersistence alloc]init];
        
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

#pragma mark - setter / getter

// hosts
- (void)setLogHost:(NSString *)logHost {
    [self saveValue:logHost withKey:kLogHost];
}
- (NSString *)logHost {
    return [self getValue:kLogHost];
}

- (void)setAuthHost:(NSString *)authHost {
    [self saveValue:authHost withKey:kAuthHost];
}
- (NSString *)authHost {
    return [self getValue:kAuthHost];
}

#pragma mark -

// userId
- (void)setUserId:(NSString *)userId {
    [self saveValue:userId withKey:kUserId];
}
- (NSString *)userId {
    return [self getValue:kUserId];
}

#pragma mark -

// access token
- (void)setAccessToken:(NSString *)accessToken {
    [self saveValue:accessToken withKey:kAccessToken];
}

- (NSString *)accessToken {
    NSString* token = (NSString *)[self getValue:kAccessToken];
    if (!token) {
        return  @"";
    }
    return token;
}

#pragma mark -

// refresh token
- (void)setRefreshToken:(NSString *)refreshToken {
    [self saveValue:refreshToken withKey:kRefreshToken];
}

- (NSString *)refreshToken {
    return (NSString *)[self getValue:kRefreshToken];
}

#pragma mark -

// expires in
- (void)setExpiresIn:(NSInteger)expiresIn {
    [self saveValue:[NSNumber numberWithInteger:expiresIn] withKey:kExpiresIn];
}

- (NSInteger)expiresIn {
    return [[self getValue:kExpiresIn] integerValue];
}

#pragma mark - private -

- (void)saveValue:(id)value withKey:(NSString *)key {
   [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (id)getValue:(NSString *)key {
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!value) {
        value = @"";
    }
    return value;
}

@end
