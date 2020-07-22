//
//  IMEMD5.m
//  imetis
//
//  Created by valenti on 2019/3/21.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import "IMEMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation IMEMD5

+ (NSString *)md5:(NSString *)str {
    const char *cStr = str.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *md5 = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5 appendFormat:@"%02x", result[i]];
    }
    return md5;
}

@end
