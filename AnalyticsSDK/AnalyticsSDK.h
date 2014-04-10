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
 *  2, Event:eventId->category_action
 
 ####2. [GoogleAnalytics](http://developers.google.com/analytics/devguides/collection/ios/v3/ )
 
 *	1, Not support multi trackers
 *	2, Default Channel : App Store
 *	3, Default dispatch time interval 20 seconds
 *	4, Default Automatically send uncaught exceptions to Google Analytics
 
 ###Notice:
 
 *	1, If you connnect one item, and then you remove your connnection, there is an warnning.
 *  2, For Umeng:
    *   1, event_id 和 tag 不能使用特殊字符，且长度不能超过128个字节；map中的key和value 都不能使用特殊字符，key 不能超 过128个字节，value 不能超过256个字节
    *   2, id， ts， du是保留字段，不能作为eventId及key的名称。
    *   3, 每个应用至多添加500个自定义事件，每个event 的 key不能超过10个，每个key的取值不能超过1000个（不允许通过key-value结构来统计类似搜索关键词，网页链接等随机生成的字符串信息）。 如有任何问题，请联系客服qq: 800083942。
 */

#define kDefaultChannel                 @"App Store"
#define kDefaultDispatchTimeInterval    20.0f


#import <Foundation/Foundation.h>
#import "MobClick.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface AnalyticsSDK : NSObject

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

/*!
 @brief settings
 */

// Enable debug log.
+ (void)setLogEnabled:(BOOL)isEnable;

/*!
 @brief basic page view
 */
+ (void)beginLogView:(NSString *)viewName;
+ (void)endLogView:(NSString *)viewName;

/*!
 @brief events
 */
+ (void)eventWithAction:(NSString *)action;
+ (void)eventWithCategory:(NSString *)category
                   action:(NSString *)action;
+ (void)eventWithCategory:(NSString *)category
                   action:(NSString *)action
                    label:(NSString *)label;
+ (void)eventWithCategory:(NSString *)category
                   action:(NSString *)action
                    label:(NSString *)label
                    value:(id)value;
+ (void)eventWithCategory:(NSString *)category
                   action:(NSString *)action
                    label:(NSString *)label
                     time:(NSTimeInterval)intervalMillis;

/*
 extend
 Make your view controller is a subclass of StatisticsViewController, then it'll automatic log your
 View path.
 */

@end
