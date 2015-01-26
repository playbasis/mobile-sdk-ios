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
    
    // TODO: Change to user's app_key and app_secret here
    //[[Playbasis sharedPB] auth:@"API_KEY" :@"API_SECRET" :self];
    [[Playbasis sharedPB] auth:@"2409609667" :@"ca58bad1f0c69e0d9229d2fba2646d62" :self];
    //[[Playbasis sharedPB] auth:@"3026965093" :@"ce9c9335d542674a2a3e286307dba8c0" :self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processResponse:(NSDictionary*)jsonResponse withURL:(NSURL *)url error:(NSError*)error
{
    if(error)
    {
        // get url path
        NSString* urlPath = [url path];
        
        // print out the response
        NSLog(@"delegate triggered from URL: %@", urlPath);
        NSLog(@"%@", jsonResponse);
        NSLog(@"Error = %@", [error localizedDescription]);
        
        return;
    }
    else
    {
        // get url path
        NSString* urlPath = [url path];
        
        // print out the response
        NSLog(@"delegate triggered from URL: %@", urlPath);
        NSLog(@"%@", jsonResponse);
        
        if(!authed && [urlPath isEqualToString:@"/Auth"])
        {
            authed = YES;
            NSLog(@"authed");
            
            // test user
            NSString *user = @"1";
            //NSString *user = @"jontestuser";
            //[[Playbasis sharedPB] player:user :self];
            
            // test callling login via block
            NSLog(@"Calling login via block");
            [[Playbasis sharedPB] login:user syncUrl:YES withBlock:^(NSDictionary *jsonResponse, NSURL* url, NSError *error) {
                if(error)
                {
                    NSLog(@"failed login, error = %@", [error localizedDescription]);
                }
                else
                {
                    NSLog(@"[Blocking call via block] block triggered from URL: %@", [url path]);
                    NSLog(@"%@", [jsonResponse description]);
                }
            }];
            
            // test track()
            /*NSLog(@"Calling track()");
            [[Playbasis sharedPB] track:user forAction:@"like" withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
                if(!error)
                {
                    NSLog(@"response from url = %@", [url path]);
                    NSLog(@"response = %@", [jsonResponse description]);
                }
            }];
            
            // test do()
            NSLog(@"Calling do()");
            [[Playbasis sharedPB] do:user action:@"like" withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
                if(!error)
                {
                    NSLog(@"response from url = %@", [url path]);
                    NSLog(@"response = %@", [jsonResponse description]);
                }
            }];*/
            
            // test calling via non-blocking call
            /*NSLog(@"Non-blocking player() call 1");
            [[Playbasis sharedPB] playerAsync:user withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
                if(error)
                {
                    NSLog(@"failed player(), error = %@", [error localizedDescription]);
                }
                else
                {
                    NSLog(@"[Blocking call via block 1] block triggered from URL: %@", [url path]);
                    NSLog(@"%@", [jsonResponse description]);
                }
            }];
            NSLog(@"Non-blocking player() call 2");
            [[Playbasis sharedPB] playerAsync:user withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
                if(error)
                {
                    NSLog(@"failed player(), error = %@", [error localizedDescription]);
                }
                else
                {
                    NSLog(@"[Blocking call via block 2] block triggered from URL: %@", [url path]);
                    NSLog(@"%@", [jsonResponse description]);
                }
            }];
            NSLog(@"Non-blocking player() call 3");
            [[Playbasis sharedPB] playerAsync:user withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
                if(error)
                {
                    NSLog(@"failed player(), error = %@", [error localizedDescription]);
                }
                else
                {
                    NSLog(@"[Blocking call via block 3] block triggered from URL: %@", [url path]);
                    NSLog(@"%@", [jsonResponse description]);
                }
            }];
            NSLog(@"Non-blocking player() call 4");
            [[Playbasis sharedPB] playerAsync:user withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
                if(error)
                {
                    NSLog(@"failed player(), error = %@", [error localizedDescription]);
                }
                else
                {
                    NSLog(@"[Blocking call via block 4] block triggered from URL: %@", [url path]);
                    NSLog(@"%@", [jsonResponse description]);
                }
            }];*/
            
            // register device token with playbasis for push notification
            //[[Playbasis sharedPB] registerForPushNotification:self];
            
            //[[Playbasis sharedPB] registerUser:@"user123" :self :@"username123" :@"username@email.com" :@"http://imageurl.html", @"first_name=fname", @"last_name=lname", nil];
            //[[Playbasis sharedPB] updateUser:user :self :@"username=1", @"email=haxpor@gmail.com", @"image=http://wasin.io/wp-content/uploads/2015/01/L-lYrqmV.png", nil];
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
            
            //[[Playbasis sharedPB] player:@"1" withDelegate:self];
            //[[Playbasis sharedPB] playerPublic:@"2" :self];
            //[[Playbasis sharedPB] playerDetailPublic:@"2" :self];
            //[[Playbasis sharedPB] actionTime:@"1" :@"login" :self];
            
            //[[Playbasis sharedPB] actionLastPerformedTime:@"1" :@"login" :self];
            
            // Test showing access token got from auth process
            //NSLog(@"Token = %@", pb.token);
            
            //[[Playbasis sharedPB] sms:user :@"SMS content" :self];
            //[[Playbasis sharedPB] sendEmail:user :@"Subject" :@"Content of Email" :self];
            
            //[[Playbasis sharedPB] ruleAsync:user :@"like" :self, nil];
            //[[Playbasis sharedPB] ruleAsync:user :@"like" :self, nil];
            
            /*NSLog(@"1 request");
            [[Playbasis sharedPB] rule:user :@"like" :self, nil];
            NSLog(@"2 request");
            [[Playbasis sharedPB] rule:user :@"like" :self, nil];
            NSLog(@"2 request");
            [[Playbasis sharedPB] rule:user :@"like" :self, nil];
            NSLog(@"2 request");
            [[Playbasis sharedPB] rule:user :@"like" :self, nil];*/
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
}

- (IBAction)callAPI_player1:(id)sender {
    // execute this only if authenticate app successfully
    if([[Playbasis sharedPB] token] != nil)
    {
        NSLog(@"Touched to callAPI_player1");

        // execute like action
        [[Playbasis sharedPB] rule:@"1" forAction:@"like" withDelegate:self, nil];
    }
}

- (IBAction)callAPI_player:(id)sender {
    // execute this only if authenticate app successfully
    if([[Playbasis sharedPB] token] != nil)
    {
        NSLog(@"Touched to get player's info");
        
        NSString *user = @"1";
        
        // test calling via non-blocking call
        NSLog(@"Non-blocking player() call 1");
        [[Playbasis sharedPB] playerAsync:user withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"failed player(), error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"[Blocking call via block 1] block triggered from URL: %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }];
        NSLog(@"Non-blocking player() call 2");
        [[Playbasis sharedPB] playerAsync:user withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"failed player(), error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"[Blocking call via block 2] block triggered from URL: %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }];
        NSLog(@"Non-blocking player() call 3");
        [[Playbasis sharedPB] playerAsync:user withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"failed player(), error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"[Blocking call via block 3] block triggered from URL: %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }];
        NSLog(@"Non-blocking player() call 4");
        [[Playbasis sharedPB] playerAsync:user withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"failed player(), error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"[Blocking call via block 4] block triggered from URL: %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }];
    }
}

- (IBAction)callAPI_asyncPlayerBulk:(id)sender {
    // execute this only if authenticate app successfully
    if([[Playbasis sharedPB] token] != nil)
    {
        NSLog(@"Touched to send rule: for 'like' 4 requests");
        
        NSString *user = @"1";
        NSString *action = @"like";
        
        // test calling via non-blocking call
        NSLog(@"Non-blocking rule():like call 1");
        [[Playbasis sharedPB] rule:user forAction:action withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"Failed rule():like - 1, error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"response req 1 from url = %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }, nil];
        
        NSLog(@"Non-blocking rule():like call 2");
        [[Playbasis sharedPB] rule:user forAction:action withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"Failed rule():like - 2, error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"response req 2 from url = %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }, nil];
        
        NSLog(@"Non-blocking rule():like call 3");
        [[Playbasis sharedPB] rule:user forAction:action withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"Failed rule():like - 3, error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"response req 3 from url = %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }, nil];
        
        NSLog(@"Non-blocking rule():like call 4");
        [[Playbasis sharedPB] rule:user forAction:action withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"Failed rule():like - 4, error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"response req 4 from url = %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }, nil];
    }
}

@end
