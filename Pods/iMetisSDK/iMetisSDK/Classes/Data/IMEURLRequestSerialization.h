//
//  IMEURLRequestSerialization.h
//  imetis
//
//  Created by valenti on 2019/3/4.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
// 参数的处理

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMEURLRequestSerialization : NSObject

+ (NSString *)queryStringFromParameters:(NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END
