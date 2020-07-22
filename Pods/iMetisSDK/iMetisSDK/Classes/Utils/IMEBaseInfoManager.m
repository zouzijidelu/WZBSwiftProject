//
//  IMEBaseInfoManager.m
//  imetis
//
//  Created by 黄娇双 on 2019/2/21.
//  Copyright © 2019年 iTalkBB Team. All rights reserved.
//

#import "IMEBaseInfoManager.h"
#import <UIKit/UIKit.h>
#import "IMEConstant.h"
#import <sys/utsname.h>
#import "IMEReachability.h"

@interface IMEBaseInfoManager ()

@property (nonatomic, copy) NSString *uuid;

@end

@implementation IMEBaseInfoManager


+ (instancetype)shareInstance {
    static IMEBaseInfoManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[IMEBaseInfoManager alloc] init];
    });
    return shareInstance;
}

#pragma mark - Initialize

- (void)initialize {
    
    _uuid = [[UIDevice.currentDevice identifierForVendor] UUIDString];
}

#pragma mark - Setter / Getter

- (void)setAppUUID:(NSString *)uuid {
    _uuid = uuid;
}

- (NSString *)getAppUUID {
    return _uuid;
}

- (NSString *)getPhoneName {
    return [[UIDevice currentDevice] name];
}

- (NSString *)getPhoneSystemName {
    return [[UIDevice currentDevice] systemName];
}

- (NSString *)getSystemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)getPhoneModel {
    return [[UIDevice currentDevice] model];
}

- (NSString *)getPhoneLocalizedModel {
    return [[UIDevice currentDevice] localizedModel];
}

- (NSInteger)getBatteryLevel {
    
    UIDevice.currentDevice.batteryMonitoringEnabled = YES;
    double deviceLevelPercent = [UIDevice currentDevice].batteryLevel;
    NSInteger batteryLevel = (NSInteger) (100 * deviceLevelPercent);
    /*
    //Allow monitoring battery
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    NSInteger batteryLevel = 0;
    NSArray *children;
    if ([[[UIApplication sharedApplication] valueForKeyPath:@"_statusBar"] isKindOfClass:                               NSClassFromString(@"UIStatusBar_Modern")]) {
        children = [[[[[[UIApplication sharedApplication] valueForKeyPath:@"_statusBar"]                                            valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews]                                             valueForKey:@"_subviewCache"];
        if (children.count > 2) {
            for(id child in children[2]){
                if ([child isKindOfClass:NSClassFromString(@"_UIBatteryView")]) {
                    batteryLevel = [[child valueForKeyPath:@"_chargePercent"] doubleValue] * 100;
                    break;
                }
            }
        }
    } else {
        UIApplication *application = [UIApplication sharedApplication];
        children = [[[application valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
        for(id child in children){
            if ([child isKindOfClass:NSClassFromString(@"UIStatusBarBatteryPercentItemView")]) {
                batteryLevel = [[child valueForKeyPath:@"_percentString"] integerValue];
                break;
            }
        }
    }
     */
    return batteryLevel;
}

- (NSString *)getNetWorkStatus {
    
    NSString *statusString = IM_BASEINFO_NETWORK_DISCONNECTED;;
    IMEReachability *reachability = [IMEReachability reachabilityWithHostName:@"www.imetis.com"];
    IMNetworkStatus status = reachability.currentReachabilityStatus;
    
    switch (status) {
        case NotReachable:
        {
            statusString = IM_BASEINFO_NETWORK_DISCONNECTED;
        }
            break;
        case ReachableViaWWAN:
        {
            statusString = IM_BASEINFO_NETWORK_WWAN;
        }
            break;
        case ReachableViaWiFi:
        {
            statusString = IM_BASEINFO_NETWORK_WIFI;
        }
            break;
        default:
            break;
    }
    return statusString;
}

- (NSString *)getAppName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}

- (NSString *)getAppVersion {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

- (NSInteger)getAppVersionCode {
    return [(NSString *)[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"] integerValue];
}

- (NSString *)getAppBundleId {
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (NSString *)getDeviceSubModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    IMLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

@end
