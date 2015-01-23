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
    //[[Playbasis sharedPB] auth:@"API_KEY" :@"API_SECRET" :self];
    [[Playbasis sharedPB] auth:@"2409609667" :@"ca58bad1f0c69e0d9229d2fba2646d62" :self];
    //[[Playbasis sharedPB] auth:@"3026965093" :@"ce9c9335d542674a2a3e286307dba8c0" :self];
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
    
    // print out the response
    NSLog(@"delegate triggered from URL: %@", urlPath);
    NSLog(@"%@", jsonResponse);
    
    if(!authed && [urlPath isEqualToString:@"/Auth"])
    {
        NSLog(@"delegate triggered from URL: %@", [url path]);
        NSLog(@"%@", jsonResponse);
        
        authed = YES;
        NSLog(@"authed");
        
        // test user
        NSString *user = @"1";
        //NSString *user = @"jontestuser";
        [[Playbasis sharedPB] player:user :self];
        //[[Playbasis sharedPB] login:user :self];
        
        // register device token with playbasis for push notification
        //[[Playbasis sharedPB] registerForPushNotification:self];
        
        //[[Playbasis sharedPB] registerUser:@"user123" :self :@"username123" :@"username@email.com" :@"http://imageurl.html", @"first_name=fname", @"last_name=lname", nil];
        /*[[Playbasis sharedPB] login:user :self];
        [[Playbasis sharedPB] logout:user :self];
        [[Playbasis sharedPB] points:user :self];
        [[Playbasis sharedPB] point:user :@"exp" :self];
        [[Playbasis sharedPB] actionLastPerformed:user :self];
        [[Playbasis sharedPB] actionLastPerformedTime:user :@"like" :self];
        [[Playbasis sharedPB] actionPerformedCount:user :@"like" :self];
        [[Playbasis sharedPB] badgeOwned:user :self];
        [[Playbasis sharedPB] rank:@"exp" :10 :self];
        [[Playbasis sharedPB] badges:self];
        [[Playbasis sharedPB] badge:@"1" :self];
        [[Playbasis sharedPB] actionConfig:self];
        [[Playbasis sharedPB] rule:user :@"like" :self, @"url=http://mysite.com/page", nil];*/
        
        // TODO: Change the information to register as another user ...
        //[[Playbasis sharedPB] registerUser:@"2" :self :@"haxpor" :@"haxpor@gmail.com" :@"http://imageurl.html", @"first_name=Wasin", @"last_name=Thonkaew", @"gender=1", nil];
        
        //[[Playbasis sharedPB] player:@"1" :self];
        //[[Playbasis sharedPB] playerPublic:@"2" :self];
        //[[Playbasis sharedPB] playerDetailPublic:@"2" :self];
        //[[Playbasis sharedPB] actionTime:@"1" :@"login" :self];
        
        //[[Playbasis sharedPB] actionLastPerformedTime:@"1" :@"login" :self];
        
        // Test showing access token got from auth process
        //NSLog(@"Token = %@", pb.token);
    }
    else if(authed)
    {
        // TODO: Add test for other things else ...
        if([urlPath isEqualToString:@"/Player/1/login"])
        {
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
            // do something here
        }
        else if([urlPath isEqualToString:@"/Player/1/action/login/time"])
        {
            // do something here
        }
        else if([urlPath isEqualToString:@"/Push/registerdevice"])
        {
            NSLog(@"Successfully registered device with Playbasis system");
        }
    }
}

- (IBAction)callAPI_player1:(id)sender {
    // execute this only if authenticate app successfully
    if(pb.token != nil)
    {
        NSLog(@"Touched to callAPI_player1");

        // execute like action
        [[Playbasis sharedPB] rule:@"1" :@"like" :self, nil];
    }
}

- (IBAction)callAPI_player:(id)sender {
    // execute this only if authenticate app successfully
    if(pb.token != nil)
    {
        NSLog(@"Touched to get player's info");
        
        // get player information
        [[Playbasis sharedPB] player:@"1" :self];
    }
}

- (IBAction)queueSerializeAndSaveToFile:(id)sender {
    NSLog(@"Touched to serialize all requests in an opt-queue");
    
    [[[Playbasis sharedPB] getRequestOperationalQueue] serializeAndSaveToFile];
    
    NSLog(@"Successfully serialized and saved to file from a queue.");
}

- (IBAction)QueueLoadFromFile:(id)sender {
    NSLog(@"Touched to load requests into an opt-queue from file.");
    
    [[[Playbasis sharedPB] getRequestOperationalQueue] load];
    
    NSLog(@"Successfully loaded from file");
}

@end
