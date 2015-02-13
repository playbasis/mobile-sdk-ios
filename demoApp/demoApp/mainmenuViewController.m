//
//  mainmenuViewController.m
//  demoApp
//
//  Created by haxpor on 1/27/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "mainmenuViewController.h"
#import "playbasis.h"

@interface mainmenuViewController ()

@end

@implementation mainmenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // listen to network status changed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged:) name:pbNetworkStatusChangedNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // remove listener from notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:pbNetworkStatusChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onNetworkStatusChanged:(NSNotification *)notif
{
    // get NetworkStatus from notif
    NSDictionary *data = notif.userInfo;
    NSNumber *networkStatusNumber = [data objectForKey:@"data"];
    
    NetworkStatus networkStatus = [networkStatusNumber intValue];
    
    switch(networkStatus)
    {
        case NotReachable:
            NSLog(@"User: Network is not reachable");
            break;
        case ReachableViaWiFi:
            NSLog(@"User: Network is reachable via WiFi");
            break;
        case ReachableViaWWAN:
            NSLog(@"User: Network is reachable via WWAN");
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
