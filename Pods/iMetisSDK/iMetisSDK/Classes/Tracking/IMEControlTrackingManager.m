//
//  IMEControlTrackingManager.m
//  imetis
//
//  Created by valenti on 2019/2/25.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import "IMEControlTrackingManager.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "IMEConstant.h"

@interface UIControl (Tracking)

@end

@implementation UIControl (Tracking)

- (void)imetis_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    IMLog(@"🧨all targets are %@", event.allTouches);
    IMLog(@"⌚️imetis_sendAction, target is %@", target);
    [self imetis_sendAction:action to:target forEvent:event];
}

@end

@implementation IMEControlTrackingManager

#pragma mark - init

static IMEControlTrackingManager* _instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMEControlTrackingManager alloc]init];
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

- (void)startAutoControlTracking {
    
    [self swizzleViewMethod];
}

- (void)stopAutoControlTracking {
    
}

#pragma mark - private implementation

- (void)swizzleViewMethod {
    static BOOL alreadyExchanged;
    if (alreadyExchanged) return;
    alreadyExchanged = YES;
    Method originalMethod = class_getInstanceMethod(UIControl.class, @selector(sendAction:to:forEvent:));
    Method swizzleMethod = class_getInstanceMethod(UIControl.class, @selector(imetis_sendAction:to:forEvent:));
    method_exchangeImplementations(originalMethod, swizzleMethod);
}

@end
