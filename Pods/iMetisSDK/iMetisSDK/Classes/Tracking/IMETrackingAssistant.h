//
//  IMViewTrackingAssistant.h
//  imetis
//
//  Created by valenti on 2019/2/27.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IMEConstant.h"


NS_ASSUME_NONNULL_BEGIN

@interface IMETrackingAssistant : NSObject

+ (instancetype)shareInstance;

/**
 Start to record
 */
- (void)begin:(NSString *)eventName
        level:(IMEventLevel)level
        extra:(NSDictionary *)extra
  description:(NSString *)description
    indexName:(NSString *)indexName;

/**
End record.
 */
- (void)end:(NSString *)eventName indexName:(NSString *)indexName;

/**
 End record detail.
 */
- (void)end:(NSString *)eventName
      level:(IMEventLevel)level
      extra:(NSDictionary *)extra
description:(NSString *)description
  indexName:(NSString *)indexName
    Instant:(BOOL)instant;



/**
 Cancel all event records when app did enter background.
 And all of timed-events cached will be save to database, waitting to upload to server.
 */
- (void)cancelAllRecords;


@end

NS_ASSUME_NONNULL_END
