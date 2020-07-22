//
//  IMEExceptionTool.h
//  imetis
//
//  Created by valenti on 2019/3/21.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMEExceptionTool : NSObject

+ (BOOL)checkUploadURL;

+ (BOOL)checkSdkInitialization;

+ (BOOL)checkAuthURL;

@end

NS_ASSUME_NONNULL_END
