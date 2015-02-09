//
//  authAndLoginViewController.m
//  demoApp
//
//  Created by haxpor on 1/27/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "authAndLoginViewController.h"
#import "demoAppSettings.h"

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
            
            // update activity label that we will log in user
            self.activityLabel.text = [NSString stringWithFormat:@"Logging in user '%@'", USER];
            
            [[Playbasis sharedPB] login:USER syncUrl:YES withBlock:^(id jsonResponse, NSURL* url, NSError *error) {
                if(error)
                {
                    NSLog(@"failed login, error = %@", [error localizedDescription]);
                    
                    // update activity label that we failed in loggin in user
                    // tell user to try again
                    self.activityLabel.text = @"Loggin in user failed.";
                }
                else
                {
                    NSLog(@"[Blocking call via block] block triggered from URL: %@", [url path]);
                    NSLog(@"%@", [jsonResponse description]);
                    
                    // done logging in user, then we transition to mainmenu screen
                    //
                    // give it a very short time to let user see process on screen that we're logging in user before actual logging in process is carried out
                    [self performSelector:@selector(transitionToMainMenuScreen) withObject:self afterDelay:kWaitingTime];
                }
            }];
            
            // via delegate
            //[[Playbasis sharedPB] playerPublic:USER withDelegate:self];
            
            // TODO: Test something it here
            [[Playbasis sharedPB] actionTime:USER forAction:@"like" withBlock:^(PBActionTime_Response *actionTime, NSURL *url, NSError *error) {
                if(!error)
                {
                    NSLog(@"Action Time of like = %@", actionTime);
                }
            }];
        }
    }
}

-(void)processResponseWithPlayerPublic:(PBPlayerPublic_Response *)playerResponse withURL:(NSURL *)url error:(NSError *)error
{
    NSLog(@"playerPublic = %@", playerResponse);
}

-(void)authenticateApp
{
    NSLog(@"Begin auth() the app");
    
    // authenticate the app
    [[Playbasis sharedPB] auth:API_KEY withApiSecret:API_SECRET andDelegate:self];
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
