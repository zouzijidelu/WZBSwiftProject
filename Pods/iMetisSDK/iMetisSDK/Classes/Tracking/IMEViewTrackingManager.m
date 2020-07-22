//
//  IMEViewTrackingManager.m
//  imetis
//
//  Created by valenti on 2019/2/21.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import "IMEViewTrackingManager.h"
#import <UIKit/UIKit.h>
#import "IMETrackingAssistant.h"
#import "IMEDataPersistence.h"
#import "IMEEventInfo.h"
#import <objc/runtime.h>
#import "IMEBaseInfoManager.h"
#import "IMEConstant.h"

#define CheckTrackEnabled() if (![IMEViewTrackingManager shareInstance].isAutoTracking) return;
#define ViewTracker IMEViewTrackingManager.shareInstance

#pragma mark - UIViewController + Tracking 分类

@interface UIViewController (Tracking)

@end

@implementation UIViewController (Tracking)

- (void)imetis_viewDidAppear:(BOOL)animated {
    [self imetis_viewDidAppear:animated];
    
    CheckTrackEnabled()
    
    IMLog(@"⌚️imetis: viewDidAppear, currrent class is %@", NSStringFromClass(self.class));
    // 开始记录事件
    // 拼接事件名 文件名.m_当前控制器_auto后缀
    NSString* eventName = [NSString stringWithFormat:@"%@.m_%@",NSStringFromClass(self.class),                                           NSStringFromClass(self.class)];
    [[IMETrackingAssistant shareInstance] begin:eventName level:(IMEventLevelDebug) extra:@{} description:nil indexName:ViewTracker.defaultIndexName];
}

- (void)imetis_viewDidDisappear:(BOOL)animated {
    [self imetis_viewDidDisappear:animated];
    
    CheckTrackEnabled()
    
    IMLog(@"⌚️imetis: %@ did disppear!", NSStringFromClass(self.class));
    
    NSString* eventName = [NSString stringWithFormat:@"%@.m_%@",NSStringFromClass(self.class),                                                               NSStringFromClass(self.class)];
    
    [[IMETrackingAssistant shareInstance] end:eventName indexName:ViewTracker.defaultIndexName];
    
}

+ (UIViewController *)findTopViewController:(UIViewController *)viewController {
    if (viewController.presentedViewController) {
        return [UIViewController findTopViewController:viewController.presentedViewController];
    } else if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController* svc = (UISplitViewController*)viewController;
        if (svc.viewControllers.count > 0) {
            return [UIViewController findTopViewController:svc.viewControllers.lastObject];
        } else {
            return viewController;
        }
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nvc = (UINavigationController *)viewController;
        if (nvc.viewControllers.count > 0) {
            return [UIViewController findTopViewController:nvc.topViewController];
        } else {
            return viewController;
        }
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tvc = (UITabBarController*)viewController;
        if (tvc.viewControllers.count) {
            return [UIViewController findTopViewController:tvc.selectedViewController];
        } else {
            return viewController;
        }
    } else {
        return viewController;
    }
}

+ (UIViewController *)currentViewController {
    UIViewController* root = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findTopViewController:root];
}

@end

@implementation IMEViewTrackingManager

#pragma mark - init

static IMEViewTrackingManager* _instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMEViewTrackingManager alloc]init];
        
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

#pragma mark - 自动 -

- (void)setIsAutoTracking:(BOOL)isAutoTracking {
    _isAutoTracking = isAutoTracking;
    if (isAutoTracking) {
        [self startAutoViewTracking];
    }
}

- (void)startAutoViewTracking {
    if (!self.isAutoTracking) {
        return;
    }
    [self swizzleViewMethod];
}

#pragma mark - private implementation

- (void)swizzleViewMethod {
    static BOOL alreadyExchanged;
    if (alreadyExchanged) return;
    
    alreadyExchanged = YES;
    // view did appear
    [self exchangeImp:@selector(viewDidAppear:) targetMethod:@selector(imetis_viewDidAppear:)];
    // view did disappear
    [self exchangeImp:@selector(viewDidDisappear:) targetMethod:@selector(imetis_viewDidDisappear:)];
}

- (void)exchangeImp:(SEL)original targetMethod:(SEL)target {
    Method o_method = class_getInstanceMethod(UIViewController.class, original);
    Method t_method = class_getInstanceMethod(UIViewController.class, target);
    method_exchangeImplementations(o_method, t_method);
}

@end


