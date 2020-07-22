//
//  IMEJsonUtil.m
//  imetis
//
//  Created by 黄娇双 on 2019/2/26.
//  Copyright © 2019年 iTalkBB Team. All rights reserved.
//

#import "IMEJsonUtil.h"
#import "IMEConstant.h"
@implementation IMEJsonUtil

+ (NSString *)convertToJsonString:(NSDictionary *)dict {
    NSError *error;
    NSString *jsonString = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if (!jsonData) {
        IMLog(@"%@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSDictionary *)convertToDictionary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSError *err;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        IMLog(@"json parse failure：%@",err);
        return nil;
    }
    return dic;
}
@end
