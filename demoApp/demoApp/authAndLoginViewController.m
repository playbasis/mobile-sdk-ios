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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // update activity label that we will log in user
                self.activityLabel.text = [NSString stringWithFormat:@"Logging in user '%@'", USER];
            });
            
            // login via non-blocking call, and with async url request
            /*[[Playbasis sharedPB] loginAsync_:USER withBlock:^(PBResultStatus_Response *status, NSURL *url, NSError *error) {
                if(!error)
                {
                    NSLog(@"Login : %@", status);
                }
                else
                {
                    NSLog(@"%@", [error description]);
                }
            }];*/
            
            // via delegate
            //[[Playbasis sharedPB] playerPublic:USER withDelegate:self];
            
            // TODO: Test something it here
            [[Playbasis sharedPB] updateUserAsync_:USER withBlock:^(PBResultStatus_Response *status, NSURL *url, NSError *error) {
                if(!error)
                {
                    NSLog(@"Update user : %@", status);
                }
            } :@"email=wasin3@haxpor.org", @"last_name=google2", nil];
            
            /*[[Playbasis sharedPB] registerUserAsync_:USER withBlock:^(PBResultStatus_Response *status, NSURL *url, NSError *error) {
                if(!error)
                {
                    NSLog(@"Register user : %@", status);
                }
            } :@"wasint" :@"wasin@haxpor.org" :@"http://png-1.findicons.com/files/icons/1072/face_avatars/300/i04.png", nil];*/
            
            /*[[Playbasis sharedPB] ruleAsync_:USER forAction:@"login" withBlock:^(PBResultStatus_Response *status, NSURL *url, NSError *error) {
                if(!error)
                    NSLog(@"%@", status);
            }, nil];*/
            
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
