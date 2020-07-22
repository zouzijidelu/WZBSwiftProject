//
//  IMEControlTrackingManager.h
//  imetis
//
//  Created by valenti on 2019/2/25.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//  UIControl 埋点

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMEControlTrackingManager : NSObject

+ (instancetype)shareInstance;

- (void)startAutoControlTracking;
- (void)stopAutoControlTracking;

@end

NS_ASSUME_NONNULL_END
