//
//  IMEBaseInfoManager.h
//  imetis
//
//  Created by 黄娇双 on 2019/2/21.
//  Copyright © 2019年 iTalkBB Team. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMEBaseInfoManager : NSObject
/**
 Create
 @return IMEBaseInfoManager object
 */
+ (instancetype)shareInstance;


/**
 Customize your App's uuid .
 */
- (void)setAppUUID:(NSString *)uuid;

/**
 Get the device application unique identifier.                                                                    Uninstalling the application will change the identifier and the restart will not
 
 @return unique identification code
 */
- (NSString *)getAppUUID;

/**
 Get mobile phone name
 
 @return mobile phone name
 */
- (NSString *)getPhoneName;

/**
 Get mobile phone system name
 
 @return mobile phone system name
 */
- (NSString *)getPhoneSystemName;

/**
 Get mobile phone system version
 
 @return mobile phone system version（12.1）
 */
- (NSString *)getSystemVersion;

/**
 Get mobile phone model
 
 @return mobile phone model (iPhone)
 */
- (NSString *)getPhoneModel;

/**
 Get mobile phone localized model
 
 @return mobile phone localized model
 */
- (NSString *)getPhoneLocalizedModel;

/**
 Get mobile phone battery level
 
 @return mobile phone battery level
 */
- (NSInteger)getBatteryLevel;

/**
 Get the name of the application
 
 @return the name of the application
 */
- (NSString *)getAppName;

/**
 Get the version of the application
 
 @return the version of the application
 */
- (NSString *)getAppVersion;

/**
 Get app version code, i.e. Build number.
 @return The version of build number.
 */
- (NSInteger)getAppVersionCode;

/**
 Get the bundle identifier of the application
 
 @return the bundle identifier
 */
- (NSString *)getAppBundleId;

/**
 Get mobile phone Sub models（iPhone7,1）
 
 @return mobile phone Sub models
 */
- (NSString *)getDeviceSubModel;

/**
 Get network status
 
 @return network status (wifi/wwan/disconnected)
 */
- (NSString *)getNetWorkStatus;

/**
 Get current time
 
 @return current time (2019-02-22 17:00:07)
 */
- (NSString *)getCurrentTime;

@end

NS_ASSUME_NONNULL_END
