StatisticsSDK
=============

To be a full statistics SDK for all iOS statistics tools. For example, UMeng, 百度统计,  Google Analytics

Release Note:

**v0.1**

Basic support Umeng, GoogleAnalytics.


###Installation(CocoaPods)
Add the dependency to your `Podfile`:

```ruby
platform :ios

pod 'StatisticsSDK'
```

Run `pod install` to install the dependencies.

Next, import the header file wherever you want to use the tab bar controller:

```objc
#import "StatisticsSDK.h"
```

###Installation(Manual)

*	1, Add StatisticsSDK folder to you project.
*	2, Add linked libraries:
	*	CoreData.framework
	*	SystemConfiguration.framework
	*	libz.dylib
*	3, import the header file wherever you want to use the tab bar controller:

```objc
#import "StatisticsSDK.h"
```

###Sample Code


1. init StatisticsSDK

```objc
- (void)initStatisticsSDK
{
  [StatisticsSDK connectGoogleWithTrackingID:kAnalyticAppKeyGoogle];
  [StatisticsSDK connectUmengWithAppKey:kAnalyticAppKeyUmeng];
  
  [StatisticsSDK setLogEnabled:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.
  [self initStatisticsSDK];
  
  return YES;
}
```

2. Log some view

```objc
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [StatisticsSDK beginLogView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [StatisticsSDK endLogView:NSStringFromClass([self class])];
}
```

For extend: automatic log view

```objc
#import "StatisticsViewController.h"

@interface SecondViewController : StatisticsViewController

@end
```

3. Events Support

```objc
- (IBAction)btnDidPressed:(id)sender
{
  [StatisticsSDK eventWithCategory:@"First" action:@"Button" label:@"Pressed" value:nil];
  [StatisticsSDK eventWithCategory:@"First" action:@"Button" label:@"Pressed" time:1000];
}
```

###Support:
####1. [Umeng](http://dev.umeng.com/analytics/ios/ )

*	1, Default Channel : App Store
 
####2. [GoogleAnalytics](http://developers.google.com/analytics/devguides/collection/ios/v3/ )

*	1, Not support multi trackers
*	2, Default Channel : App Store
*	3, Default dispatch time interval 20 seconds
*	4, Default Automatically send uncaught exceptions to Google Analytics
 
###Notice:

*	1, If you connect one item, and then you remove your connnection, there is an warnning.
*	2, If you connect google analytics, **If your app uses the CoreData framework** *: responding to a notification, e.g. NSManagedObjectContextDidSaveNotification, from the Google Analytics CoreData object may result in an exception. Instead, Apple recommends filtering CoreData notifications by specifying the managed object context as a parameter to your listener. [Learn more from Apple](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/CoreDataFramework/Classes/NSManagedObjectContext_Class/NSManagedObjectContext.html).*
