//
//  authAndLoginViewController.m
//  demoApp
//
//  Created by Playbasis on 1/27/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "authAndLoginViewController.h"
#import "demoAppSettings.h"
#import "RNDecryptor.h"

static const NSTimeInterval kWaitingTime = 0.15f;

@interface authAndLoginViewController ()

/**
 Begin the authenticating the app.
 This method will be called automatically, and internally. You should not call this manually.
 */
-(void)authenticateApp;

/**
 Transition to Mainmenu Screen after authentication and logging in process finished.
 This method will be called automatically, and internally. You should not call this manually.
 */
-(void)transitionToMainMenuScreen;

@end

@implementation authAndLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // update the activity label that we will authenticate the app
    self.activityLabel.text = @"Authenticating the app";
    
    // give it a very short time to let user see process on screen that we're authenticating the app
    // before actual authenticating process is carried out
    [self performSelector:@selector(authenticateApp) withObject:self afterDelay:kWaitingTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processResponseWithAuth:(PBAuth_Response *)auth withURL:(NSURL *)url error:(NSError *)error
{
    if(error)
    {
        // get url path
        NSString* urlPath = [url path];
        
        // print out the response
        NSLog(@"delegate triggered from URL: %@", urlPath);
        NSLog(@"Error = %@", [error localizedDescription]);
        
        // indicating that it failed in authenticated the app
        // tell user to try again
        self.activityLabel.text = @"Authenticated failed";
        
        // TODO: Add trying again later ...
        
        return;
    }
    else
    {
        // get url path
        NSString* urlPath = [url path];
        
        // print out the response
        NSLog(@"delegate triggered from URL: %@", urlPath);
        NSLog(@"%@", auth);
        
        if(!authed && [urlPath isEqualToString:@"/Auth"])
        {
            authed = YES;
            NSLog(@"authed");

            //[[Playbasis sharedPB] player:user :self];
            
            // test callling login via block
            NSLog(@"Calling login via block");
            
            // register device with playbasis platform
            NSString *deviceToken = [Playbasis getDeviceToken];
            if (deviceToken != nil)
            {
                [[Playbasis sharedPB] registerForPushNotificationPlayerId:USER options:@{@"device_token": deviceToken, @"device_description" : @"user's device token", @"device_name": @"ios device"} withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
                    if (error != nil)
                    {
                        NSLog(@"error register device token with platform %@", [error localizedDescription]);
                    }
                    else
                    {
                        NSLog(@"successfully registered device token with platform");
                        
                        // send notification right away
                        [[Playbasis sharedPB] pushNotificationForPlayer:USER message:@"Test message" withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
                            if (error != nil)
                            {
                                NSLog(@"error sending push notif for %@", USER);
                            }
                            else
                            {
                                NSLog(@"successfully sent push notif for %@", USER);
                            }
                        }];
                    }
                }];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // update activity label that we will log in user
                self.activityLabel.text = [NSString stringWithFormat:@"Logging in user '%@'", USER];
            });
            
            // login
        
            [[Playbasis sharedPB] loginPlayer:USER options:nil withBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
                if(!error)
                {
                    NSLog(@"%@ logged in successfully. [result : %@]", USER, result);
                }
                else
                {
                    NSLog(@"Failed to log in for %@", USER);
                }
            }];
            
            // TODO: Add temporary testcase here ...
            // every tetcase added here should be removed immediately after finish testing
            
            PBLOG(@"Passed through this line");
            
            // delay a short time to let user see the update on screen, then transition into mainmenu screen
            [self performSelector:@selector(transitionToMainMenuScreen) withObject:self afterDelay:kWaitingTime];
        }
    }
}

-(void)processResponseWithPlayerPublic:(PBPlayerPublic_Response *)playerResponse withURL:(NSURL *)url error:(NSError *)error
{
    NSLog(@"playerPublic = %@", playerResponse);
}

-(void)authenticateApp
{
    NSLog(@"About to begin auth() the app");
    
    // authenticate the app
    // TODO: Insert your apikey, and secret here ...
    [[Playbasis sharedPB] authWithApiKey:@"269122575" apiSecret:@"c57495174674157dd19317dd79e3c36e" bundleId:@"io.wasin.playbasisapitest" andDelegate:self];
}

-(void)transitionToMainMenuScreen
{
    [self performSegueWithIdentifier:@"showMainmenuScreen" sender:self];
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
