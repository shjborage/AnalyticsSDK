//
//  StatisticsViewController.h
//  StatisticsSDKDemo
//
//  Created by Eric on 12/14/13.
//  Copyright (c) 2013 Saick. All rights reserved.
//

#import "AnalyticsSDK.h"

#if kEnableGoogle
#import "GAITrackedViewController.h"
@interface AnalyticsViewController : GAITrackedViewController
#else
@interface AnalyticsViewController : UIViewController
#endif

@end
