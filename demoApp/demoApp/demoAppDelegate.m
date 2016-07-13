//
//  demoAppDelegate.m
//  demoApp
//
//  Created by Playbasis on 5/20/56 BE.
//  Copyright (c) 2556 Playbasis. All rights reserved.
//

#import "demoAppDelegate.h"
#import "demoAppSettings.h"
#import "Playbasis.h"

@implementation demoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // immediately set protected resource key to use in encrypt / decrypt process of files inside protectedResources folder inside the bundle
    [Playbasis setProtectedResourcesKey:@"abcdefghijklmnopqrstuvwxyz123456"];
    
    // call class method of Playbasis to handle native thing of trying to registering device for push notification for us
    [Playbasis registerDeviceForPushNotification];
    
    CGRect winSize = [[UIScreen mainScreen] bounds];
    CGFloat height = winSize.size.height;
    CGFloat width = winSize.size.width;
    NSLog(@"width: %f, height: %f", width, height);
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // call utility method of Playbasis to handle and save device token for later use
    [Playbasis saveDeviceToken:deviceToken withKey:@"DeviceToken"];
    NSLog(@"deviceToken: %@", [Playbasis getDeviceToken]);
    PBLOG(@"Successfully set device token for push notification.");
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    PBLOG(@"Failed to register device, error: %@", error);
}

-(void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply
{
    // get message
    NSString *message = [userInfo objectForKey:@"message"];
    // reply dictionary
    NSMutableDictionary *replyDict = [NSMutableDictionary dictionary];
    
    if([message isEqualToString:@"playerPublic-firstName"])
    {
        [[Playbasis sharedPB] playerPublic:USER withBlock:^(PBPlayerPublic_Response *playerResponse, NSURL *url, NSError *error) {
            if(!error)
            {
                // response back with nil (indicating error)
                [replyDict setValue:playerResponse.playerBasic.firstName forKey:@"response"];
            }
            else
            {
                // response back with nil (indicating error)
                [replyDict setValue:nil forKey:@"response"];
            }
        }];
    }
    else
    {
        // response back with nil (indicating error)
        [replyDict setValue:nil forKey:@"response"];
    }
    
    reply(replyDict);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userInfo: %@", userInfo);
}

@end
