//
//  playbasis.m
//  playbasis
//
//  Created by Playbasis.
//  Copyright (c) 2556 Playbasis. All rights reserved.
//

#import "playbasis.h"
#import <UIKit/UIKit.h>
#import "Reachability.h"

static NSString * const BASE_URL = @"https://api.pbapp.net/";

//
// additional interface for private methods
//
@interface Playbasis ()
{
    BOOL isNetworkReachable;
    Reachability *reachability;
}

/**
 Set token.
 */
-(void)setToken:(NSString *)newToken;

/**
 Dispatch a first founded request in the operational queue and only if network
 can be reached.
 */
-(void)dispatchFirstRequestInQueue:(NSTimer*)dt;

/**
 This method will be called whenever network status changed.
 */
-(void)checkNetworkStatus:(NSNotification*)notice;

-(void)onApplicationDidFinishLaunching:(NSNotification *)notif;
-(void)onApplicationWillResignActive:(NSNotification *)notif;
-(void)onApplicationDidEnterBackground:(NSNotification *)notif;
-(void)onApplicationWillEnterForeground:(NSNotification *)notif;
-(void)onApplicationDidBecomeActive:(NSNotification *)notif;
-(void)onApplicationWillTerminate:(NSNotification *)notif;

@end

//
// delegate object for handling authentication
//
@interface PBAuthDelegate : NSObject <PBResponseHandler>
{
    Playbasis* pb;
    BOOL finished;
    id<PBResponseHandler> finishDelegate;
}
-(id)initWithCoder:(NSCoder *)decoder;
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithPlaybasis:(Playbasis*)playbasis andDelegate:(id<PBResponseHandler>)delegate;
-(BOOL)isFinished;
-(void)processResponse:(NSDictionary *)jsonResponse withURL:(NSURL *) url;
@end

@implementation PBAuthDelegate

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    pb = [decoder decodeObjectForKey:@"pb"];
    finished = [decoder decodeBoolForKey:@"finished"];
    finishDelegate = [decoder decodeObjectForKey:@"finishDelegate"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:pb forKey:@"pb"];
    [encoder encodeBool:finished forKey:@"finished"];
    [encoder encodeObject:finishDelegate forKey:@"finishDelegate"];
}

-(id)initWithPlaybasis:(Playbasis *)playbasis andDelegate:(id<PBResponseHandler>)delegate
{
    if(!(self = [super init]))
        return nil;
    finished = NO;
    pb = playbasis;
    finishDelegate = delegate;
    return self;
}
-(BOOL)isFinished
{
    return finished;
}
-(void)processResponse:(NSDictionary *)jsonResponse withURL:(NSURL *)url
{
    id success = [jsonResponse objectForKey:@"success"];
    if(!success)
    {
        //auth failed
        finished = YES;
        if(finishDelegate && ([finishDelegate respondsToSelector:@selector(processResponse:withURL:)]))
            [finishDelegate processResponse:jsonResponse withURL:url];
        return;
    }
    id response = [jsonResponse objectForKey:@"response"];
    id token = [response objectForKey:@"token"];
    [pb setToken:token];
    finished = YES;
    if(finishDelegate && ([finishDelegate respondsToSelector:@selector(processResponse:withURL:)]))
        [finishDelegate processResponse:jsonResponse withURL:url];
}
@end

//
// The Playbasis Object
//
@implementation Playbasis

// NSUserDefaults key for Playbasis sdk to retrieve it later
static NSString *sDeviceTokenRetrievalKey = nil;

@synthesize token;

+(void)registerDeviceForPushNotification
{
    // register for push notification
    // note: ios 8 changes the way to setup push notification, it's deprecated the old method
    // thus we need to check on this one
    // note 2: we will register device with this device token later with playbasis
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        NSLog(@"Register device ios %f+", 8.0f);
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
        NSLog(@"Registered devie ios < %f", 8.0f);
    }
}

+(void)saveDeviceToken:(NSData *)deviceToken withKey:(NSString *)key
{
    // we got device token, then we need to trim the brackets, and cut out space
    NSString *device = [deviceToken description];
    device = [device stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    device = [device stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"Device token is: %@", device);
    
    // save the key for Playbasis to be able to retrieve it via NSUserDefaults later
    sDeviceTokenRetrievalKey = key;
    
    // save it via NSUserDefaults (non-critical data to be encrypted)
    // we will got this data later in UIViewController-based class
    [[NSUserDefaults standardUserDefaults] setObject:device forKey:sDeviceTokenRetrievalKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(id)sharedPB
{
    static Playbasis *sharedPlaybasis = nil;
    
    // use dispatch_once_t to initialize singleton just once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlaybasis = [[self alloc] init];
    });
    
    return sharedPlaybasis;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    token = [decoder decodeObjectForKey:@"token"];
    apiKeyParam = [decoder decodeObjectForKey:@"apiKeyParam"];
    authDelegate = [decoder decodeObjectForKey:@"authDelegate"];
    requestOptQueue = [decoder decodeObjectForKey:@"requestOptQueue"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:token forKey:@"token"];
    [encoder encodeObject:apiKeyParam forKey:@"apiKeyParam"];
    [encoder encodeObject:authDelegate forKey:@"authDelegate"];
    [encoder encodeObject:requestOptQueue forKey:@"requestOptQueue"];
}

-(id)init
{
    if(!(self = [super init]))
        return nil;
    
    isNetworkReachable = FALSE;
    token = nil;
    apiKeyParam = nil;
    authDelegate = nil;
    
    // create reachability instance
    reachability = [Reachability reachabilityForInternetConnection];
    // initially set the network status here
    // send 'nil' in has no effect for this method
    [self checkNetworkStatus:nil];
    
    // add notification of network status change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    // add notification of UIApplication
    // we add them here to reduce code user has to add in Delegate class
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    
    // start notifier right away
    [reachability startNotifier];
    
    // schedule interval call to dispatch request in queue
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(dispatchFirstRequestInQueue:) userInfo:nil repeats:YES];
    
#if __has_feature(objc_arc)
    requestOptQueue = [NSMutableArray array];
#else
    requestOptQueue = [[NSMutableArray array] retain];
#endif
    return self;
}

-(void)dealloc
{
    // stop notifier
    [reachability stopNotifier];
    // remove notification of network status change
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    // remove notification of UIApplication
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    
#if __has_feature(objc_arc)
    // do nothing
#else
    if(token)
        [token release];
    if(authDelegate)
        [authDelegate release];
    if(requestOptQueue)
        [requestOptQueue release];
    [super dealloc];
#endif
}

-(const NSMutableArray *)getRequestOperationalQueue
{
    return requestOptQueue;
}

-(PBRequest *)auth:(NSString *)apiKey :(NSString *)apiSecret :(id<PBResponseHandler>)delegate
{
    apiKeyParam = [[NSString alloc] initWithFormat:@"?api_key=%@", apiKey];
    authDelegate = [[PBAuthDelegate alloc] initWithPlaybasis:self andDelegate:delegate];
    NSString *data = [NSString stringWithFormat:@"api_key=%@&api_secret=%@", apiKey, apiSecret];
    return [self call:@"Auth" withData:data andDelegate:authDelegate];
}

-(PBRequest *)renew:(NSString *)apiKey :(NSString *)apiSecret :(id<PBResponseHandler>)delegate
{
    apiKeyParam = [[NSString alloc] initWithFormat:@"?api_key=%@", apiKey];
    authDelegate = [[PBAuthDelegate alloc] initWithPlaybasis:self andDelegate:delegate];
    NSString *data = [NSString stringWithFormat:@"api_key=%@&api_secret=%@", apiKey, apiSecret];
    return [self call:@"Auth/renew" withData:data andDelegate:authDelegate];
}

-(PBRequest *)playerPublic:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@%@", playerId, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)player:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@", playerId];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    return [self call:method withData:data andDelegate:delegate];
}

// playerListId player id as used in client's website separate with ',' example '1,2,3'
-(PBRequest *)playerList:(NSString *)playerListId :(id<PBResponseHandler>)delegate
{
   NSAssert(token, @"access token is nil");
   NSString *method = [NSString stringWithFormat:@"Player/list"];
   NSString *data = [NSString stringWithFormat:@"token=%@&list_player_id%@", token, playerListId];
   return [self call:method withData:data andDelegate:delegate];
}

-(PBRequest *)playerDetailPublic:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/data/all%@", playerId, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)playerDetail:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
   NSAssert(token, @"access token is nil");
   NSString *method = [NSString stringWithFormat:@"Player/%@/data/all", playerId];
   NSString *data = [NSString stringWithFormat:@"token=%@", token];
   return [self call:method withData:data andDelegate:delegate];
}

//
// @param	...[vararg]     Varargs of String for additional parameters to be sent to the register method.
// 							Each element is a string in the format of key=value, for example: first_name=john
// 							The following keys are supported:
// 							- facebook_id
// 							- twitter_id
// 							- password		assumed hashed
//							- first_name
// 							- last_name
// 							- nickname
// 							- gender		1=Male, 2=Female
// 							- birth_date	format YYYY-MM-DD
//
-(PBRequest *)registerUser:(NSString *)playerId :(id<PBResponseHandler>)delegate :(NSString *)username :(NSString *)email :(NSString *)imageUrl, ...
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/register", playerId];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@&username=%@&email=%@&image=%@", token, username, email, imageUrl];
    
    id optionalData;
    va_list argumentList;
    va_start(argumentList, imageUrl);
    while ((optionalData = va_arg(argumentList, NSString *)))
    {
        [data appendFormat:@"&%@", optionalData];
    }
    va_end(argumentList);
    
    return [self call:method withData:data andDelegate:delegate];
}

// @param	...[vararg]		Key-value for data to be updated.
//                          The following keys are supported:
//                          - username
//                          - email
//                          - image
//                          - exp
//                          - level
//                          - facebook_id
//                          - twitter_id
//                          - password		assumed hashed
//                          - first_name
//                          - last_name
//                          - nickname
//                          - gender		1=Male, 2=Female
//                          - birth_date	format YYYY-MM-DD
-(PBRequest *)updateUser:(NSString *)playerId :(id<PBResponseHandler>)delegate :(NSString *)firstArg ,...
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/update", playerId];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@", token];

    id updateData;
    va_list argumentList;
    va_start(argumentList, firstArg);
    while ((updateData = va_arg(argumentList, NSString *)))
    {
        [data appendFormat:@"&%@", updateData];
    }
    va_end(argumentList);
    
    return [self call:method withData:data andDelegate:delegate];
}

-(PBRequest *)deleteUser:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/delete", playerId];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    return [self call:method withData:data andDelegate:delegate];
}

-(PBRequest *)login:(NSString *)playerId :(id<PBResponseHandler>)delegate;
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/login", playerId];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    return [self call:method withData:data andDelegate:delegate];
}

-(PBRequest *)logout:(NSString *)playerId :(id<PBResponseHandler>)delegate;
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/logout", playerId];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    return [self call:method withData:data andDelegate:delegate];
}

-(PBRequest *)points:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/points%@", playerId, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)point:(NSString *)playerId :(NSString *)pointName :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/point/%@%@", playerId, pointName, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)pointHistory:(NSString *)playerId :(NSString *)pointName :(unsigned int)offset :(unsigned int)limit :(id<PBResponseHandler>)delegate
{
    NSString *data = [NSString stringWithFormat:@"&offset=%u&limit=%u", offset, limit];
    if (pointName != nil) {
        data = [NSString stringWithFormat:@"%@&point_name=%@", data, pointName];
    }
    NSString *method = [NSString stringWithFormat:@"Player/%@/point_history%@%@", playerId, apiKeyParam, data];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)actionTime:(NSString *)playerId :(NSString *)actionName :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/%@/time%@", playerId, actionName, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)actionLastPerformed:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/time%@", playerId, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)actionLastPerformedTime:(NSString *)playerId :(NSString *)actionName :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/%@/time%@", playerId, actionName, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)actionPerformedCount:(NSString *)playerId :(NSString *)actionName :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/%@/count%@", playerId, actionName, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)badgeOwned:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/badge%@", playerId, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)rank:(NSString *)rankedBy :(unsigned int)limit :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/rank/%@/%u%@", rankedBy, limit, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)ranks:(unsigned int)limit :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/ranks/%u%@", limit, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)level:(unsigned int)level :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/level/%u%@", level, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)levels:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/levels%@", apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)claimBadge:(NSString *)playerId :(NSString *)badgeId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/badge/%@/claim", playerId, badgeId];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    return [self call:method withData:data andDelegate:delegate];
}

-(PBRequest *)redeemBadge:(NSString *)playerId :(NSString *)badgeId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/badge/%@/redeem", playerId, badgeId];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    return [self call:method withData:data andDelegate:delegate];
}

-(PBRequest *)goodsOwned:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/goods%@", playerId, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)questOfPlayer:(NSString *)playerId :(NSString *)questId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/quest/%@%@&player_id=%@", questId, apiKeyParam, playerId];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)questListOfPlayer:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/quest%@&player_id=%@", apiKeyParam, playerId];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)badge:(NSString *)badgeId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Badge/%@%@", badgeId, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)badges :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Badge%@", apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)goods:(NSString *)goodId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Goods/%@%@", goodId, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)goodsList:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Goods%@", apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)actionConfig :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Engine/actionConfig%@", apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

//
// @param	...[vararg]     Varargs of String for additional parameters to be sent to the rule method.
// 							Each element is a string in the format of key=value, for example: url=playbasis.com
// 							The following keys are supported:
// 							- url		url or filter string (for triggering non-global actions)
// 							- reward	name of the custom-point reward to give (for triggering rules with custom-point reward)
// 							- quantity	amount of points to give (for triggering rules with custom-point reward)
//
-(PBRequest *)rule:(NSString *)playerId :(NSString *)action :(id<PBResponseHandler>)delegate, ...
{
    NSAssert(token, @"access token is nil");
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@&player_id=%@&action=%@", token, playerId, action];
    
    id optionalData;
    va_list argumentList;
    va_start(argumentList, delegate);
    while ((optionalData = va_arg(argumentList, NSString *)))
    {
        [data appendFormat:@"&%@", optionalData];
    }
    va_end(argumentList);
    
    return [self call:@"Engine/rule" withData:data andDelegate:delegate];
}

-(PBRequest *)quests:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quest%@", apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)quest:(NSString *)questId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@%@", questId, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)mission:(NSString *)questId :(NSString *)missionId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@/misson/%@%@", questId, missionId, apiKeyParam];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)questAvailable:(NSString *)questId :(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@/available/%@&player_id=%@", questId, apiKeyParam, playerId];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)questsAvailable:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quest/available/%@&player_id=%@", apiKeyParam, playerId];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)joinQuest:(NSString *)questId :(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quest/%@/join", questId];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id%@", token, playerId];
    return [self call:method withData:data andDelegate:delegate];
}

-(PBRequest *)cancelQuest:(NSString *)questId :(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quest/%@/cancel", questId];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id%@", token, playerId];
    return [self call:method withData:data andDelegate:delegate];
}

-(PBRequest *)redeemGoods:(NSString *)goodsId :(NSString *)playerId :(unsigned int)amount :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    if(amount < 1){
        amount = 1;
    }
    NSString *method = [NSString stringWithFormat:@"Redeem/goods"];
    NSString *data = [NSString stringWithFormat:@"token=%@&goods_id=%@&player_id%@&amount=%u", token, goodsId, playerId, amount];
    return [self call:method withData:data andDelegate:delegate];
}

-(PBRequest *)recentPoint:(unsigned int)offset :(unsigned int)limit :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Service/recent_point%@&offset=%u&limit=%u", apiKeyParam, offset, limit];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)recentPointByName:(NSString *)pointName :(unsigned int)offset :(unsigned int)limit :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Service/recent_point%@&offset=%u&limit=%u&point_name=%@", apiKeyParam, offset, limit, pointName];
    return [self call:method withData:nil andDelegate:delegate];
}

-(PBRequest *)push:(NSString *)playerId :(NSString *)message :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Push/notification"];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@", token, playerId, message];
    
    return [self call:method withData:data andDelegate:delegate];
}

-(PBRequest *)push:(NSString *)playerId :(NSString *)message :(id<PBResponseHandler>)delegate :(NSString *)templateId
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Push/notification"];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@&template_id=%@", token, playerId, message, templateId];
    return [self call:method withData:data andDelegate:delegate];
}

-(PBRequest *)registerForPushNotification:(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    
    // get device token from what we save in NSUserDefaults
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    NSAssert(deviceToken, @"device token is nil");
    
    NSString *method = [NSString stringWithFormat:@"Push/registerdevice"];
    NSString *data = [NSString stringWithFormat:@"token=%@&device_token=%@", token, deviceToken];
    return [self call:method withData:data andDelegate:delegate];
}

-(PBRequest *)call:(NSString *)method withData:(NSString *)data andDelegate:(id<PBResponseHandler>)delegate
{
    id request = nil;
    id url = [NSURL URLWithString:[BASE_URL stringByAppendingString:method]];
    if(!data)
    {
        request = [NSURLRequest requestWithURL:url];
    }
    else
    {
        NSData *postData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        {
            // set date header
            // note: this is saved for the originality of timestamp for this request being sent later even thoguh it will be save for later dispatching if network cannot be reached
            NSDate *date = [NSDate date];
            
            // crete a date formatter
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // setup format to be http date
            // see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.18
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [dateFormatter setDateFormat: @"EEE',' dd MMM yyyy HH:mm:ss zzz"];
            // get http date string
            NSString *httpDateStr = [dateFormatter stringFromDate:date];
            
            NSLog(@"date: %@", [date description]);
            NSLog(@"dateStr: %@", httpDateStr);
            
            // set to request's date header
            [request setValue:httpDateStr forHTTPHeaderField:@"Date"];
        }
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
    }
    id pbRequest = [[PBRequest alloc] initWithURLRequest:request andDelegate:delegate];
    
    // add PBRequest into operational queue
    [requestOptQueue enqueue:pbRequest];
    
    NSLog(@"Queue size = %d", [requestOptQueue count]);
    
#if __has_feature(objc_arc)
    return pbRequest;
#else
    return [pbRequest autorelease];
#endif
}

-(void)setToken:(NSString *)newToken
{
    
#if __has_feature(objc_arc)
    token = newToken;
#else
    if(token)
        [token release];
    token = newToken;
    [token retain];
#endif
    
    NSLog(@"token assigned: %@", token);
}

-(void)dispatchFirstRequestInQueue:(NSTimer *)dt
{
    //NSLog(@"Called dispatchFirstRequestInQueue");
    
    // only dispatch a first found request if network can be reached, and
    // operational queue is not empty
    if(isNetworkReachable && ![requestOptQueue empty])
    {
        [[self getRequestOperationalQueue] dequeueAndStart];
        NSLog(@"Dispatched first founed request in queue");
    }
}

-(void)checkNetworkStatus:(NSNotification *)notice
{
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    switch(networkStatus)
    {
        case NotReachable:
            isNetworkReachable = FALSE;
            NSLog(@"Network is not reachable");
            break;
        case ReachableViaWiFi:
            isNetworkReachable = TRUE;
            NSLog(@"Network is reachable via WiFi");
            break;
        case ReachableViaWWAN:
            isNetworkReachable = TRUE;
            NSLog(@"Network is reachable via WWAN");
            break;
    }
}

-(void)onApplicationDidFinishLaunching:(NSNotification *)notif
{
    NSLog(@"called onApplicationDidFinishLaunching()");
    
    // immediately load requests from file
    [[[Playbasis sharedPB] getRequestOperationalQueue] load];
}

-(void)onApplicationWillResignActive:(NSNotification *)notif
{
    NSLog(@"called onApplicatoinWillResignActive()");
}

-(void)onApplicationDidEnterBackground:(NSNotification *)notif
{
    NSLog(@"called onApplicationDidEnterBackground()");
    
    // serialize and save all requests in queue
    [[[Playbasis sharedPB] getRequestOperationalQueue] serializeAndSaveToFile];
}

-(void)onApplicationWillEnterForeground:(NSNotification *)notif
{
    NSLog(@"called onApplicationWillEnterForeground()");
    
    // load saved requests from file
    [[[Playbasis sharedPB] getRequestOperationalQueue] load];
}

-(void)onApplicationDidBecomeActive:(NSNotification *)notif
{
    NSLog(@"called onApplicationDidBecomeActive()");
}

-(void)onApplicationWillTerminate:(NSNotification *)notif
{
    NSLog(@"called onApplicationWillTerminate()");
    
    // serialize and save all requests in queue
    [[[Playbasis sharedPB] getRequestOperationalQueue] serializeAndSaveToFile];
}

@end
