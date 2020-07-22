//
//  IMEConstant.h
//  imetis
//
//  Created by 黄娇双 on 2019/2/21.
//  Copyright © 2019年 iTalkBB Team. All rights reserved.
//

#ifndef IMEConstant_h
#define IMEConstant_h

#ifdef DEBUG
# define IMLog(fmt, ...) NSLog((@"\n[File:%s]\n" "[Function:%s]\n" "[Line:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define IMLog(...);
#endif

#define IMAssert(condition, desc) \
if (!condition) { \
IMLog(@"[IMetis][Assert] %@",desc); \
NSAssert(NO, desc); \
}

#define IM_BASEINFO_NETWORK_DISCONNECTED    @"disconnected"
#define IM_BASEINFO_NETWORK_WWAN            @"wwan"
#define IM_BASEINFO_NETWORK_WIFI            @"wifi"

#define IM_MAX_COUNT_EVENTS                 30

typedef NS_ENUM (NSInteger, IMEventLevel) {
    IMEventLevelVerbose = 1,
    IMEventLevelDebug = 2,
    IMEventLevelInfo = 3,
    IMEventLevelWarn = 4,
    IMEventLevelError = 5,
    IMEventLevelCrash = 12,
};

//NSInteger const MAX_FOR_EVENTS = 30;

#endif /* IMEConstant_h */
