//
//  IMEExceptionTool.m
//  imetis
//
//  Created by valenti on 2019/3/21.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import "IMEExceptionTool.h"
#import "IMEDataPersistence.h"
#import "IMEConstant.h"

@implementation IMEExceptionTool

+ (BOOL)checkUploadURL {
    
    if (![IMEDataPersistence defaultPersistence].logHost || [[IMEDataPersistence defaultPersistence].logHost         isEqualToString:@""]) {
        NSString* exceptionName = @"[>_<] Null Upload URL Exception";
        NSString* reason = @"Please set upload URL.";
#ifdef DEBUG
        @throw [NSException exceptionWithName: exceptionName reason: reason userInfo: nil];
#else
        IMLog(@"%@!%@", exceptionName, reason);
        return NO;
#endif
    }
    return YES;
}

+ (BOOL)checkSdkInitialization {
    if (![IMEDataPersistence defaultPersistence].isSdkInitialized) {
        NSString* exceptionName = @"[>_<] iMetis SDK Initialization Exception";
        NSString* reason = @"Please initialize iMetis SDK first.";
#ifdef DEBUG
        @throw [NSException exceptionWithName:exceptionName reason: reason userInfo: nil];
#else
        IMLog(@"%@!%@", exceptionName, reason);
        return NO;
#endif
    }
    return YES;
}

+ (BOOL)checkAuthURL {
    if (![IMEDataPersistence defaultPersistence].authHost || [[IMEDataPersistence defaultPersistence].authHost                     isEqualToString:@""]) {
        NSString* exceptionName = @"[>_<] Null Authentication URL Exception";
        NSString* reason = @"Please set auth URL.";
#ifdef DEBUG
        @throw [NSException exceptionWithName:exceptionName reason: reason userInfo: nil];
#else
        IMLog(@"%@!%@", exceptionName, reason);
        return NO;
#endif
    }
    return YES;
}

@end
