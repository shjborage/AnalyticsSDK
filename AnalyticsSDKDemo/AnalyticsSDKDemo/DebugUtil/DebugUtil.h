//
//  DebugUtils.h
//  BFServiceStation
//
//  Created by Eric on 10/16/13.
//  Copyright (c) 2013 Baofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#if LOG2FILE
#import "SQDebugUtils.h"
#endif

#define kHandleException              1
#define kUseGoogleStackTrace          0 //use GTM functions to improve stack trace
#define kUDBfExceptionLogs            @"kBfExceptionLog"
#define kMaxExceptionItems            1000

@interface DebugUtil : NSObject

+ (id)sharedDebug;

- (void)startLog;

@end
