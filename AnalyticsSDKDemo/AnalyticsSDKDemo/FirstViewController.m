//
//  FirstViewController.m
//  AnalyticsSDKDemo
//
//  Created by Eric on 12/12/13.
//  Copyright (c) 2013 Saick. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [AnalyticsSDK beginLogView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [AnalyticsSDK endLogView:NSStringFromClass([self class])];
}

#pragma mark - actions

- (IBAction)btnDidPressed:(id)sender
{
  [AnalyticsSDK eventWithCategory:@"First" action:@"Button" label:@"Pressed" value:nil];
  [AnalyticsSDK eventWithCategory:@"First" action:@"Button" label:@"Pressed" time:1000];
}

@end
