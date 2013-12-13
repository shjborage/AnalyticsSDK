//
//  StatisticsSDK.h
//  StatisticsSDKDemo
//
//  Created by Eric on 12/12/13.
//  Copyright (c) 2013 Saick. All rights reserved.
//

/*
 ###Support:
 ####1. [Umeng](http://dev.umeng.com/analytics/ios/ )
 
 *	1, Default Channel : App Store
 
 ####2. [GoogleAnalytics](http://developers.google.com/analytics/devguides/collection/ios/v3/ )
 
 *	1, Not support multi trackers
 *	2, Default Channel : App Store
 *	3, Default dispatch time interval 20 seconds
 *	4, Default Automatically send uncaught exceptions to Google Analytics
 
 ###Notice:
 
 *	1. If you connnect one item, and then you remove your connnection, there is an warnning.
 */

#define kDefaultChannel                 @"App Store"
#define kDefaultDispatchTimeInterval    20.0f


#import <Foundation/Foundation.h>
#import "MobClick.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface StatisticsSDK : NSObject

/*
 connections
 */

// Umeng
+ (void)connectUmengWithAppKey:(NSString *)appKey;
+ (void)connectUmengWithAppKey:(NSString *)appKey
                  reportPolicy:(ReportPolicy)rp
                     channelID:(NSString *)cid;

// Google
+ (void)connectGoogleWithTrackingID:(NSString *)trackingID;
+ (void)connectGoogleWithTrackingID:(NSString *)trackingID
                   dispatchInterval:(NSTimeInterval)interval
                          channelId:(NSString *)cid;

/*
 settings
 */

// Enable debug log.
+ (void)setLogEnabled:(BOOL)isEnable;

/*
 basic page view
 */
+ (void)beginLogView:(NSString *)viewName;
+ (void)endLogView:(NSString *)viewName;

/*
 events
 */

/*
 extend
 */

@end
