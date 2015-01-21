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
    //[pb auth:@"API_KEY" :@"API_SECRET" :self];
    [pb auth:@"2409609667" :@"ca58bad1f0c69e0d9229d2fba2646d62" :self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processResponse:(NSDictionary *)jsonResponse withURL:(NSURL *)url
{
    // get url path
    NSString* urlPath = [url path];
    
    if(!authed && [urlPath isEqualToString:@"/Auth"])
    {
        NSLog(@"delegate triggered from URL: %@", [url path]);
        NSLog(@"%@", jsonResponse);
        
        authed = YES;
        NSLog(@"authed");
        
        NSString *user = @"1";
        [pb player:user :self];
        //[pb registerUser:@"user123" :self :@"username123" :@"username@email.com" :@"http://imageurl.html", @"first_name=fname", @"last_name=lname", nil];
        /*[pb login:user :self];
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
        //[pb playerPublic:@"2" :self];
        //[pb playerDetailPublic:@"2" :self];
        //[pb actionTime:@"1" :@"login" :self];
        
        //[pb actionLastPerformedTime:@"1" :@"login" :self];
        
        // register device token with playbasis for push notification
        //[pb registerForPushNotification:self];
    }
    else if(authed)
    {
        // TODO: Add test for other things else ...
        if([urlPath isEqualToString:@"/Player/1/login"])
        {
            NSLog(@"delegate triggered from URL: %@", urlPath);
            NSLog(@"%@", jsonResponse);
            
            NSLog(@"%@", [jsonResponse valueForKey:@"success"]);
            
            // get whether logging in successful or not
            BOOL isSuccess = [[jsonResponse valueForKey:@"success"] boolValue];
            
            // check if log in successfully
            if(isSuccess)
                NSLog(@"Player 1 log in successfully.");
            else
                NSLog(@"Player 1 log in failed.");
        }
        else if([urlPath isEqualToString:@"/Player/1/action/login/time"])
        {
            NSLog(@"delegate triggered from URL: %@", urlPath);
            NSLog(@"%@", jsonResponse);
        }
        else if([urlPath isEqualToString:@"/Player/1/action/login/time"])
        {
            NSLog(@"delegate triggered from URL: %@", urlPath);
            NSLog(@"%@", jsonResponse);
        }
        else if([urlPath isEqualToString:@"/Push/registerdevice"])
        {
            NSLog(@"delegate triggered from URL: %@", urlPath);
            NSLog(@"%@", jsonResponse);
            
            NSLog(@"Successfully registered device with Playbasis system");
        }
    }
}

@end
