//
//  IMEViewTrackingManager.h
//  imetis
//
//  Created by valenti on 2019/2/21.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMEViewTrackingManager : NSObject

@property (nonatomic, copy) NSString *defaultIndexName;

@property (assign, nonatomic) BOOL isAutoTracking;

+ (instancetype)shareInstance;

- (void)startAutoViewTracking;

@end

NS_ASSUME_NONNULL_END
