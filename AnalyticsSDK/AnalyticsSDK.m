//
//  StatisticsSDK.m
//  StatisticsSDKDemo
//
//  Created by Eric on 12/12/13.
//  Copyright (c) 2013 Saick. All rights reserved.
//

#import "AnalyticsSDK.h"

#define kAnalyticsUD         @"Analytics_UDKey"
#define kAnalyticsUmeng      @"Analytics_Umeng"
#define kAnalyticsGoogle     @"Analytics_Google"

#define kIsEnable             @"isEnable"

@interface AnalyticsSDK ()

@end

@implementation AnalyticsSDK (private)

#pragma mark - Check isEnable statistics item

+ (void)initDefaultSettings
{
  NSDictionary *allItems = [[NSUserDefaults standardUserDefaults] objectForKey:kAnalyticsUD];
  if (![allItems isKindOfClass:[NSDictionary class]]) {
    allItems = @{kAnalyticsUmeng:  @{kIsEnable: @"NO"},
                 kAnalyticsGoogle: @{kIsEnable: @"NO"}};
    [[NSUserDefaults standardUserDefaults] setObject:allItems forKey:kAnalyticsUD];
    [[NSUserDefaults standardUserDefaults] synchronize];
  } // If there is, use it.
}

+ (void)enableUmeng
{
  [self initDefaultSettings];
  NSMutableDictionary *allItems = [NSMutableDictionary dictionaryWithDictionary:
                                   [[NSUserDefaults standardUserDefaults] objectForKey:kAnalyticsUD]];
  NSMutableDictionary *umeng = [NSMutableDictionary dictionaryWithDictionary:[allItems objectForKey:kAnalyticsUmeng]];
  [umeng setValue:@"YES" forKey:kIsEnable];
  [allItems setObject:umeng forKey:kAnalyticsUmeng];
  [[NSUserDefaults standardUserDefaults] setObject:allItems forKey:kAnalyticsUD];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)enableGoogle
{
  [self initDefaultSettings];
  NSMutableDictionary *allItems = [NSMutableDictionary dictionaryWithDictionary:
                                   [[NSUserDefaults standardUserDefaults] objectForKey:kAnalyticsUD]];
  NSMutableDictionary *google = [NSMutableDictionary dictionaryWithDictionary:[allItems objectForKey:kAnalyticsGoogle]];
  [google setValue:@"YES" forKey:kIsEnable];
  [allItems setObject:google forKey:kAnalyticsGoogle];
  [[NSUserDefaults standardUserDefaults] setObject:allItems forKey:kAnalyticsUD];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isEnableUmeng
{
  [self initDefaultSettings];
  NSDictionary *allItems = [[NSUserDefaults standardUserDefaults] objectForKey:kAnalyticsUD];
  return [[[allItems objectForKey:kAnalyticsUmeng] objectForKey:kIsEnable] boolValue];
}

+ (BOOL)isEnableGoogle
{
  [self initDefaultSettings];
  NSDictionary *allItems = [[NSUserDefaults standardUserDefaults] objectForKey:kAnalyticsUD];
  return [[[allItems objectForKey:kAnalyticsGoogle] objectForKey:kIsEnable] boolValue];
}

@end

@implementation AnalyticsSDK

/*
 connections
 */

#pragma mark - Connections-Umeng
#if kEnableUMeng
// Umeng
+ (void)connectUmengWithAppKey:(NSString *)appKey
{
  [self connectUmengWithAppKey:appKey reportPolicy:BATCH channelID:kDefaultChannel];
}

+ (void)connectUmengWithAppKey:(NSString *)appKey
                  reportPolicy:(ReportPolicy)rp
                     channelID:(NSString *)cid
{
  [self enableUmeng];
  
  [MobClick startWithAppkey:appKey reportPolicy:rp channelId:cid];
}
#endif

#pragma mark - Connections-Google
#if kEnableGoogle
// Google
+ (void)connectGoogleWithTrackingID:(NSString *)trackingID
{
  [self connectGoogleWithTrackingID:trackingID
                   dispatchInterval:kDefaultDispatchTimeInterval
                          channelId:@"App Store"];
}

+ (void)connectGoogleWithTrackingID:(NSString *)trackingID
                   dispatchInterval:(NSTimeInterval)interval
                          channelId:(NSString *)cid
{
  [self enableGoogle];
  
  [GAI sharedInstance].trackUncaughtExceptions = YES;
  [GAI sharedInstance].dispatchInterval = interval;
  id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:trackingID];
  [tracker set:[GAIFields customDimensionForIndex:1] value:cid];
}
#endif
/*
 settings
 */

#pragma mark - Settings
// Enable debug log.
+ (void)setLogEnabled:(BOOL)isEnable
{
#if kEnableUMeng
  [MobClick setLogEnabled:isEnable];
#endif
  
#if kEnableGoogle
  if (isEnable)
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
  else
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
#endif
}

/*
 basic page view
 */

#pragma mark - Basic page view

+ (void)beginLogView:(NSString *)viewName
{
#if kEnableUMeng
  [MobClick beginLogPageView:viewName];
#endif
  
#if kEnableGoogle
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker set:kGAIScreenName value:viewName];
  [tracker send:[[GAIDictionaryBuilder createAppView] build]];
#endif
}

+ (void)endLogView:(NSString *)viewName
{
#if kEnableUMeng
  [MobClick endLogPageView:viewName];
#endif
  
#if kEnableGoogle
#endif
}

/*
 events
 */

#pragma mark - Events

+ (void)eventWithAction:(NSString *)action
{
  [self eventWithCategory:@"" action:action];
}

+ (void)eventWithAction:(NSString *)action
                  label:(NSString *)label
{
  [self eventWithCategory:@"" action:action label:label];
}

+ (void)eventWithAction:(NSString *)action
                  value:(id)value
{
  [self eventWithCategory:@"" action:action label:@"" value:value];
}

+ (void)eventWithCategory:(NSString *)category
                   action:(NSString *)action
{
  [self eventWithCategory:category action:action label:@""];
}

+ (void)eventWithCategory:(NSString *)category
                   action:(NSString *)action
                    label:(NSString *)label
{
  [self eventWithCategory:category action:action label:label value:nil];
}

+ (void)eventWithCategory:(NSString *)category
                   action:(NSString *)action
                    label:(NSString *)label
                    value:(id)value
{
#if kEnableUMeng
  NSString *eventId = [NSString stringWithFormat:@"%@_%@", category, action];
  [MobClick event:eventId label:label];
  if (value)
    [MobClick event:eventId attributes:@{@"value": value}];
#endif
  
#if kEnableGoogle
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  
  [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                        action:action
                                                         label:label
                                                         value:value] build]];
#endif
}

+ (void)eventWithCategory:(NSString *)category
                   action:(NSString *)action
                    label:(NSString *)label
                     time:(NSTimeInterval)intervalMillis
{
#if kEnableUMeng
  NSString *eventId = [NSString stringWithFormat:@"%@_%@", category, action];
  [MobClick event:eventId label:label durations:(int)intervalMillis];
#endif
  
#if kEnableGoogle
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  
  [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:category
                                                       interval:[NSNumber numberWithFloat:intervalMillis]
                                                           name:action
                                                          label:label] build]];
#endif
}

@end
