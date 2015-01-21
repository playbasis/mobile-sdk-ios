//
//  demoViewController.m
//  demoApp
//
//  Created by Maethee Chongchitnant on 5/20/56 BE.
//  Copyright (c) 2556 Maethee Chongchitnant. All rights reserved.
//

#import "demoViewController.h"
#import "playbasis.h"

@interface demoViewController ()

@end

@implementation demoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    pb = [[Playbasis alloc] init];
    
    // TODO: Change to user's appKey and appSecret
    [pb auth:@"2409609667" :@"ca58bad1f0c69e0d9229d2fba2646d62" :self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processResponse:(NSDictionary *)jsonResponse withURL:(NSURL *)url
{
    NSLog(@"delegate triggered from URL: %@", [url path]);
    NSLog(@"%@", jsonResponse);
    if(!authed && [[url path] isEqualToString:@"/Auth"])
    {
        authed = YES;
        NSLog(@"authed");
        
        // immediately after we're authenticated, then register device with playbasis
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppDeviceToken"];
        NSLog(@"device token in controller: %@ ", deviceToken);
        // register device token with playbasis for push notification
        //[pb registerForPushNotification:deviceToken :self];
        
        /*NSString *user = @"1";
        [pb player:user :self];
        //[pb registerUser:@"user123" :self :@"username123" :@"username@email.com" :@"http://imageurl.html", @"first_name=fname", @"last_name=lname", nil];
        [pb login:user :self];
        [pb logout:user :self];
        [pb points:user :self];
        [pb point:user :@"exp" :self];
        [pb actionLastPerformed:user :self];
        [pb actionLastPerformedTime:user :@"like" :self];
        [pb actionPerformedCount:user :@"like" :self];
        [pb badgeOwned:user :self];
        [pb rank:@"exp" :10 :self];
        [pb badges:self];
        [pb badge:@"1" :self];
        [pb actionConfig:self];
        [pb rule:user :@"like" :self, @"url=http://mysite.com/page", nil];*/
        
        // TODO: Change the information to register as another user ...
        //[pb registerUser:@"2" :self :@"haxpor" :@"haxpor@gmail.com" :@"http://imageurl.html", @"first_name=Wasin", @"last_name=Thonkaew", @"gender=1", nil];
        
        //[pb player:@"1" :self];
        [pb playerPublic:@"2" :self];
    }
    else if(authed)
    {
        NSLog(@"Entered 2nd block");
        
        // TODO: Add test for other things else ...
    }
}

@end
