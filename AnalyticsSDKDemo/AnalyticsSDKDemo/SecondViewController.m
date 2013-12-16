//
//  SecondViewController.m
//  AnalyticsSDKDemo
//
//  Created by Eric on 12/12/13.
//  Copyright (c) 2013 Saick. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

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

#pragma mark - actions

- (IBAction)sliderValueDidChanged:(UISlider *)sender
{
  [AnalyticsSDK eventWithCategory:@"Second"
                            action:@"Slider"
                             label:@"ValueChange"
                             value:[NSNumber numberWithFloat:sender.value]];
}

@end
