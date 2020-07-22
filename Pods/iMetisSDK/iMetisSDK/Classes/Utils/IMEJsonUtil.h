//
//  IMEJsonUtil.h
//  imetis
//
//  Created by 黄娇双 on 2019/2/26.
//  Copyright © 2019年 iTalkBB Team. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMEJsonUtil : NSObject

/**
 dictionary --> json string

 @param dict dictionary
 @return json string
 */
+ (NSString *)convertToJsonString:(NSDictionary *)dict;

/**
 json string --> dictionary

 @param jsonString json string
 @return dictionary
 */
+ (NSDictionary *)convertToDictionary:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
