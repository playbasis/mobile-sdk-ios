//
//  mainmenuViewController.m
//  demoApp
//
//  Created by haxpor on 1/27/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "mainmenuViewController.h"
#import "rewardStorePageViewController.h"
#import "questPageViewController.h"
#import "Playbasis.h"
#import "demoAppSettings.h"
#import "globalCaching.h"

@interface mainmenuViewController ()

@end

@implementation mainmenuViewController

-(void)networkStatusChanged:(NetworkStatus)status
{
    NSLog(@"Network status changed to %d", (int)status);
}

-(void)locationUpdated:(CLLocation *)location
{
    NSLog(@"Received location updated : %f %f", location.coordinate.latitude, location.coordinate.longitude);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.activityIndicator.hidden = YES;
    
    // start caching in the background
    [[globalCaching sharedInstance] startCachingDataInBackgroundForUser:USER complete:^(BOOL success) {
        NSLog(@"%@", success ? @"Successfully cached all relevant data" : @"Failed to cache all relevant data");
    }];
    
    // listen to network status changed from playbasis
    [Playbasis sharedPB].networkStatusChangedDelegate = self;
    // enable location update
    [Playbasis sharedPB].enableGettingLocation = NO;
    [Playbasis sharedPB].locationUpdatedDelegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}*/

-(void)viewWillAppear:(BOOL)animated
{
    // make sure navigation bar is always showing
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

@end
