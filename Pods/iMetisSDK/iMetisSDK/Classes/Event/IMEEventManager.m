//
//  IMEEventManager.m
//  imetis
//
//  Created by 黄娇双 on 2019/2/26.
//  Copyright © 2019年 iTalkBB Team. All rights reserved.
//

#import "IMEEventManager.h"
#import "IMEData.h"
#import "IMEConstant.h"
#import "IMEExceptionTool.h"

#define CheckSDKStarted() if (![IMEExceptionTool checkSdkInitialization]) return;

@interface IMEEventManager()

@property (nonatomic, strong) IMEDBManager *dbManager;


@end

@implementation IMEEventManager

+ (instancetype)shareInstance {
    static IMEEventManager *eventManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventManager = [[[IMEEventManager alloc] init] initialize];
    });
    return eventManager;
}

- (instancetype)initialize {
    
    _dbManager = [[[IMEDBManager alloc]init] initialize];
    
    return self;
}

- (void)handleEventWithEvent:(IMEEventInfo *)event isInstant:(BOOL)isInstant {
    if (isInstant) {
        
        CheckSDKStarted()
        
        [[IMEData shareInstance] uploadEventData:event success:^{
            
        } failure:^{
            [self->_dbManager insertEvent:event complete:^(BOOL res, IMEDBManager * _Nonnull manager) {
                
            }];
        }];
    } else {
        [_dbManager insertEvent:event complete:^(BOOL res, IMEDBManager * _Nonnull manager) {
            
        }];
    }
}


@end
