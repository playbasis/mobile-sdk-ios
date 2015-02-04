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
// only apply to some of api call ie. rule()
static NSString * const BASE_ASYNC_URL = @"https://api.pbapp.net/async/call";

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

/**
 Refactored method to return PBRequest according to the setting input to the method.
 */
-(PBRequest *)refactoredInternalBaseReturnWithBlockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withMethod:(NSString *)method andData:(NSString *)data andResponse:(id)response;

/**
 @abstract Send http request via synchronized blocking call with delegate.
 
 @param syncURLRequest Whether or not to use sync-url request.
 This url is independent from blocking or non-blocking call. A blocking call can still use async url-request. The difference is that async url-request will response back to client immediately, and faster than sync url-request with will piggyback actual payload data upon request.
 */
-(PBRequest *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andDelegate:(id<PBResponseHandler>)delegate;

/**
 @abstract Send http request via synchronized blocking call with block.
 
 @param syncURLRequest Whether or not to use sync-url request.
 This url is independent from blocking or non-blocking call. A blocking call can still use async url-request. The difference is that async url-request will response back to client immediately, and faster than sync url-request with will piggyback actual payload data upon request.
 */
-(PBRequest *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andBlock:(PBResponseBlock)block;

/**
 @abstract Send http request via non-blocking call with delegate.
 
 @param syncURLRequest Whether or not to use sync-url request.
 This url is independent from blocking or non-blocking call. A blocking call can still use async url-request. The difference is that async url-request will response back to client immediately, and faster than sync url-request with will piggyback actual payload data upon request.
 */
-(PBRequest *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andDelegate:(id<PBResponseHandler>)delegate;

/**
 @abstract Send http request via non-blocking call.
 
 @param syncURLRequest Whether or not to use sync-url request with delegate.
 This url is independent from blocking or non-blocking call. A blocking call can still use async url-request. The difference is that async url-request will response back to client immediately, and faster than sync url-request with will piggyback actual payload data upon request.
 */
-(PBRequest *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andBlock:(PBResponseBlock)block;

/**
 Internal working method to send request to process an action through all game's rules defined for client's website.
 This method return result via delegate.
 */
-(PBRequest *)ruleInternal:(NSString *)playerId forAction:(NSString *)action blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl withDelegate:(id<PBResponseHandler>)delegate withParams:(va_list)params;

/**
 Internal working method to send request to process an action through all game's rules defined for client's website.
 This method return result via block.
 */
-(PBRequest *)ruleInternal:(NSString *)playerId forAction:(NSString *)action blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl withBlock:(PBResponseBlock)block withParams:(va_list)params;

/*
 All internal base methods for API calls are listed here.
 */
// - auth
-(PBRequest *)authInternalBase:(NSString *)apiKey withApiSecret:(NSString *)apiSecret blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - renew
-(PBRequest *)renewInternalBase:(NSString *)apiKey withApiSecret:(NSString *)apiSecret blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - playerPublic
-(PBRequest *)playerPublicInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - player
-(PBRequest *)playerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - playerList
-(PBRequest *)playerListInternalBase:(NSString *)playerListId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - playerDetailPublic
-(PBRequest *)playerDetailPublicInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - playerDetail
-(PBRequest *)playerDetailInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - deleteUser
-(PBRequest *)deleteUserInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - login
-(PBRequest *)loginInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - logout
-(PBRequest *)logoutInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - points
-(PBRequest *)pointsInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

@end

//
// delegate object for handling authentication
//
@interface PBAuthDelegate : NSObject <PBResponseHandler>
{
    Playbasis* pb;
    BOOL finished;
    
    // either use one or another
    id<PBResponseHandler> finishDelegate;
    PBResponseBlock finishBlock;
}
-(id)initWithCoder:(NSCoder *)decoder;
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithPlaybasis:(Playbasis*)playbasis andDelegate:(id<PBResponseHandler>)delegate;
-(id)initWithPlaybasis:(Playbasis*)playbasis andBlock:(PBResponseBlock)block;
-(BOOL)isFinished;
-(void)processResponse:(NSDictionary *)jsonResponse withURL:(NSURL *)url error:(NSError*)error;
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
    
    // use delegate, thus nil out block
    finishDelegate = delegate;
    finishBlock = nil;
    
    return self;
}

-(id)initWithPlaybasis:(Playbasis *)playbasis andBlock:(PBResponseBlock)block
{
    if(!(self = [super init]))
        return nil;
    finished = NO;
    pb = playbasis;
    
    // use block, thus nil out delegate
    finishDelegate = nil;
    finishBlock = block;
    
    return self;
}

-(BOOL)isFinished
{
    return finished;
}
-(void)processResponse:(NSDictionary *)jsonResponse withURL:(NSURL *)url error:(NSError*)error
{
    if(error)
    {
        // auth failed
        NSLog(@"Auth failed, return immediately");
        return;
    }
    
    id success = [jsonResponse objectForKey:@"success"];
    if(!success)
    {
        //auth failed
        finished = YES;
        if(finishDelegate && ([finishDelegate respondsToSelector:@selector(processResponse:withURL:error:)]))
            [finishDelegate processResponse:jsonResponse withURL:url error:error];
        return;
    }
    id response = [jsonResponse objectForKey:@"response"];
    id token = [response objectForKey:@"token"];
    [pb setToken:token];
    finished = YES;
    
    // choose either to response back via delegate or block
    // response via delegate
    if(finishDelegate && ([finishDelegate respondsToSelector:@selector(processResponse:withURL:error:)]))
    {
        [finishDelegate processResponse:jsonResponse withURL:url error:error];
    }
    else if(finishBlock)
    {
        finishBlock(jsonResponse, url, error);
    }
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
    
    // after queue creation then start checking to load requests from file
    [[self getRequestOperationalQueue] load];
    
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

-(PBRequest *)refactoredInternalBaseReturnWithBlockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withMethod:(NSString *)method andData:(NSString *)data andResponse:(id)response
{
    if(blockingCall)
    {
        if(useDelegate)
        {
            return [self call:method withData:data syncURLRequest:syncUrl andDelegate:response];
        }
        else
        {
            return [self call:method withData:data syncURLRequest:syncUrl andBlock:response];
        }
    }
    else
    {
        if(useDelegate)
        {
            return [self callAsync:method withData:data syncURLRequest:syncUrl andDelegate:response];
        }
        else
        {
            return [self callAsync:method withData:data syncURLRequest:syncUrl andBlock:response];
        }
    }
}

-(const NSMutableArray *)getRequestOperationalQueue
{
    return requestOptQueue;
}

-(PBRequest *)auth:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andDelegate:(id<PBResponseHandler>)delegate
{
    return [self authInternalBase:apiKey withApiSecret:apiSecret blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)auth:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andBlock:(PBResponseBlock)block
{
    return [self authInternalBase:apiKey withApiSecret:apiSecret blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)authAsync:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andDelegate:(id<PBResponseHandler>)delegate
{
    return [self authInternalBase:apiKey withApiSecret:apiSecret blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)authAsync:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andBlock:(PBResponseBlock)block
{
    return [self authInternalBase:apiKey withApiSecret:apiSecret blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)authInternalBase:(NSString *)apiKey withApiSecret:(NSString *)apiSecret blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    // note: the final response is via PBAuthDelegate either by delegate or block
    // in this case, it's by delegate
    apiKeyParam = [[NSString alloc] initWithFormat:@"?api_key=%@", apiKey];
    
    // check whether it uses delegate to response back
    if(useDelegate)
        authDelegate = [[PBAuthDelegate alloc] initWithPlaybasis:self andDelegate:response];
    else
        authDelegate = [[PBAuthDelegate alloc] initWithPlaybasis:self andBlock:response];
    
    NSString *data = [NSString stringWithFormat:@"api_key=%@&api_secret=%@", apiKey, apiSecret];
    
    // auth call has only delegate response, thus we just check for blocking/non-blocking call
    if(blockingCall)
        return [self call:@"Auth" withData:data syncURLRequest:syncUrl andDelegate:authDelegate];
    else
        return [self callAsync:@"Auth" withData:data syncURLRequest:syncUrl andDelegate:authDelegate];
}

-(PBRequest *)renew:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andDelegate:(id<PBResponseHandler>)delegate
{
    return [self renewInternalBase:apiKey withApiSecret:apiSecret blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)renew:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andBlock:(PBResponseBlock)block
{
    return [self renewInternalBase:apiKey withApiSecret:apiSecret blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)renewAsync:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andDelegate:(id<PBResponseHandler>)delegate
{
    return [self renewInternalBase:apiKey withApiSecret:apiSecret blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)renewAsync:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andBlock:(PBResponseBlock)block
{
    return [self renewInternalBase:apiKey withApiSecret:apiSecret blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)renewInternalBase:(NSString *)apiKey withApiSecret:(NSString *)apiSecret blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    apiKeyParam = [[NSString alloc] initWithFormat:@"?api_key=%@", apiKey];
    
    // check whether it uses delegate to response back
    if(useDelegate)
        authDelegate = [[PBAuthDelegate alloc] initWithPlaybasis:self andDelegate:response];
    else
        authDelegate = [[PBAuthDelegate alloc] initWithPlaybasis:self andBlock:response];
    
    NSString *data = [NSString stringWithFormat:@"api_key=%@&api_secret=%@", apiKey, apiSecret];
    
    // auth call has only delegate response, thus we just check for blocking/non-blocking call
    if(blockingCall)
        return [self call:@"Auth" withData:data syncURLRequest:syncUrl andDelegate:authDelegate];
    else
        return [self callAsync:@"Auth" withData:data syncURLRequest:syncUrl andDelegate:authDelegate];
}

-(PBRequest *)playerPublic:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self playerPublicInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerPublic:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self playerPublicInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerPublicAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self playerPublicInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerPublicAsync:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self playerPublicInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerPublicInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@%@", playerId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil andResponse:response];
}

-(PBRequest *)player:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self playerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)player:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self playerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self playerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerAsync:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self playerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@", playerId];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

// playerListId player id as used in client's website separate with ',' example '1,2,3'
-(PBRequest *)playerList:(NSString *)playerListId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self playerListInternalBase:playerListId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerList:(NSString *)playerListId withBlock:(PBResponseBlock)block
{
    return [self playerListInternalBase:playerListId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerListAsync:(NSString *)playerListId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self playerListInternalBase:playerListId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerListAsync:(NSString *)playerListId withBlock:(PBResponseBlock)block
{
    return [self playerListInternalBase:playerListId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerListInternalBase:(NSString *)playerListId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/list"];
    NSString *data = [NSString stringWithFormat:@"token=%@&list_player_id%@", token, playerListId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)playerDetailPublic:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self playerDetailPublicInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerDetailPublic:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self playerDetailPublicInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerDetailPublicAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self playerDetailPublicInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerDetailPublicAsync:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self playerDetailPublicInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerDetailPublicInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/data/all%@", playerId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil andResponse:response];
}

-(PBRequest *)playerDetail:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self playerDetailInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerDetail:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self playerDetailInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerDetailAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self playerDetailInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerDetailAsync:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self playerDetailInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerDetailInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/data/all", playerId];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
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
-(PBRequest *)registerUser:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate :(NSString *)username :(NSString *)email :(NSString *)imageUrl, ...
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
    
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}
-(PBRequest *)registerUser:(NSString *)playerId withBlock:(PBResponseBlock)block :(NSString *)username :(NSString *)email :(NSString *)imageUrl, ...
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
    
    return [self call:method withData:data syncURLRequest:YES andBlock:block];
}
-(PBRequest *)registerUserAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate :(NSString *)username :(NSString *)email :(NSString *)imageUrl, ...
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
    
    return [self callAsync:method withData:data syncURLRequest:YES andDelegate:delegate];
}
-(PBRequest *)registerUserAsync:(NSString *)playerId withBlock:(PBResponseBlock)block :(NSString *)username :(NSString *)email :(NSString *)imageUrl, ...
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
    
    return [self callAsync:method withData:data syncURLRequest:YES andBlock:block];
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
-(PBRequest *)updateUser:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate :(NSString *)firstArg ,...
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
    
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}
-(PBRequest *)updateUser:(NSString *)playerId withBlock:(PBResponseBlock)block :(NSString *)firstArg ,...
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
    
    return [self call:method withData:data syncURLRequest:YES andBlock:block];
}
-(PBRequest *)updateUserAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate :(NSString *)firstArg ,...
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
    
    return [self callAsync:method withData:data syncURLRequest:YES andDelegate:delegate];
}
-(PBRequest *)updateUserAsync:(NSString *)playerId withBlock:(PBResponseBlock)block :(NSString *)firstArg ,...
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
    
    return [self callAsync:method withData:data syncURLRequest:YES andBlock:block];
}

-(PBRequest *)deleteUser:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self deleteUserInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)deleteUser:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self deleteUserInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)deleteUserAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self deleteUserInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)deleteUserAsync:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self deleteUserInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)deleteUserInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/delete", playerId];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];

    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)login:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self loginInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)login:(NSString *)playerId syncUrl:(BOOL)syncUrl withDelegate:(id<PBResponseHandler>)delegate;
{
    return [self loginInternalBase:playerId blockingCall:YES syncUrl:syncUrl useDelegate:YES withResponse:delegate];
}

-(PBRequest *)login:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self loginInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)login:(NSString *)playerId syncUrl:(BOOL)syncUrl withBlock:(PBResponseBlock)block
{
    return [self loginInternalBase:playerId blockingCall:YES syncUrl:syncUrl useDelegate:NO withResponse:block];
}
-(PBRequest *)loginAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self loginInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)loginAsync:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self loginInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)loginInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/login", playerId];
    
    NSString *data = nil;
    
    if(syncUrl)
        data = [NSString stringWithFormat:@"token=%@", token];
    else
    {
        NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
        [dictData setObject:token forKey:@"token"];
        
        NSMutableDictionary *dictWholeData = [NSMutableDictionary dictionary];
        [dictWholeData setObject:method forKey:@"endpoint"];
        [dictWholeData setObject:dictData forKey:@"data"];
        [dictWholeData setObject:@"nil" forKey:@"channel"];
        
        // get json string
        data = [dictWholeData JSONString];
        NSLog(@"jsonString = %@", data);
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)logout:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
{
    return [self logoutInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)logout:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self logoutInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)logoutAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self logoutInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)logoutAsync:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self logoutInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)logoutInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/logout", playerId];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)points:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pointsInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)points:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self pointsInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)pointsAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pointsInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)pointsAsync:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self pointsInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
- (PBRequest *)pointsInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/points%@", playerId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil andResponse:response];
}

-(PBRequest *)point:(NSString *)playerId :(NSString *)pointName :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/point/%@%@", playerId, pointName, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}



-(PBRequest *)pointHistory:(NSString *)playerId :(NSString *)pointName :(unsigned int)offset :(unsigned int)limit :(id<PBResponseHandler>)delegate
{
    NSString *data = [NSString stringWithFormat:@"&offset=%u&limit=%u", offset, limit];
    if (pointName != nil) {
        data = [NSString stringWithFormat:@"%@&point_name=%@", data, pointName];
    }
    NSString *method = [NSString stringWithFormat:@"Player/%@/point_history%@%@", playerId, apiKeyParam, data];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)actionTime:(NSString *)playerId :(NSString *)actionName :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/%@/time%@", playerId, actionName, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)actionLastPerformed:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/time%@", playerId, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)actionLastPerformedTime:(NSString *)playerId :(NSString *)actionName :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/%@/time%@", playerId, actionName, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)actionPerformedCount:(NSString *)playerId :(NSString *)actionName :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/%@/count%@", playerId, actionName, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)badgeOwned:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/badge%@", playerId, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)rank:(NSString *)rankedBy :(unsigned int)limit :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/rank/%@/%u%@", rankedBy, limit, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)ranks:(unsigned int)limit :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/ranks/%u%@", limit, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)level:(unsigned int)level :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/level/%u%@", level, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)levels:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/levels%@", apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)claimBadge:(NSString *)playerId :(NSString *)badgeId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/badge/%@/claim", playerId, badgeId];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)redeemBadge:(NSString *)playerId :(NSString *)badgeId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/badge/%@/redeem", playerId, badgeId];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)goodsOwned:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/goods%@", playerId, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)questOfPlayer:(NSString *)playerId :(NSString *)questId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/quest/%@%@&player_id=%@", questId, apiKeyParam, playerId];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)questListOfPlayer:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Player/quest%@&player_id=%@", apiKeyParam, playerId];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)badge:(NSString *)badgeId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Badge/%@%@", badgeId, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)badges :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Badge%@", apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)goods:(NSString *)goodId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Goods/%@%@", goodId, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)goodsList:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Goods%@", apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)actionConfig :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Engine/actionConfig%@", apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

//
// @param	...[vararg]     Varargs of String for additional parameters to be sent to the rule method.
// 							Each element is a string in the format of key=value, for example: url=playbasis.com
// 							The following keys are supported:
// 							- url		url or filter string (for triggering non-global actions)
// 							- reward	name of the custom-point reward to give (for triggering rules with custom-point reward)
// 							- quantity	amount of points to give (for triggering rules with custom-point reward)
//
-(PBRequest *)rule:(NSString *)playerId forAction:(NSString *)action withDelegate:(id<PBResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self ruleInternal:playerId forAction:action blockingCall:YES syncUrl:YES withDelegate:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequest *)rule:(NSString *)playerId forAction:(NSString *)action syncUrl:(BOOL)syncUrl withDelegate:(id<PBResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    
    return [self ruleInternal:playerId forAction:action blockingCall:YES syncUrl:syncUrl withDelegate:delegate withParams:argumentList];

    va_end(argumentList);
}

-(PBRequest *)rule:(NSString *)playerId forAction:(NSString *)action withBlock:(PBResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    
    return [self ruleInternal:playerId forAction:action blockingCall:YES syncUrl:YES withBlock:block withParams:argumentList];
    
    va_end(argumentList);
}
-(PBRequest *)rule:(NSString *)playerId forAction:(NSString *)action syncUrl:(BOOL)syncUrl withBlock:(PBResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    
    return [self ruleInternal:playerId forAction:action blockingCall:YES syncUrl:syncUrl withBlock:block withParams:argumentList];
    
    va_end(argumentList);
}

-(PBRequest *)ruleAsync:(NSString *)playerId forAction:(NSString *)action withDelegate:(id<PBResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    
    return [self ruleInternal:playerId forAction:action blockingCall:NO syncUrl:YES withDelegate:delegate withParams:argumentList];
    
    va_end(argumentList);
}
-(PBRequest *)ruleAsync:(NSString *)playerId forAction:(NSString *)action syncUrl:(BOOL)syncUrl withDelegate:(id<PBResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    
    return [self ruleInternal:playerId forAction:action blockingCall:NO syncUrl:syncUrl withDelegate:delegate withParams:argumentList];
    
    va_end(argumentList);
}

-(PBRequest *)ruleAsync:(NSString *)playerId forAction:(NSString *)action withBlock:(PBResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    
    return [self ruleInternal:playerId forAction:action blockingCall:NO syncUrl:YES withBlock:block withParams:argumentList];
    
    va_end(argumentList);
}
-(PBRequest *)ruleAsync:(NSString *)playerId forAction:(NSString *)action syncUrl:(BOOL)syncUrl withBlock:(PBResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    
    return [self ruleInternal:playerId forAction:action blockingCall:NO syncUrl:syncUrl withBlock:block withParams:argumentList];
    
    va_end(argumentList);
}

-(PBRequest *)ruleInternal:(NSString *)playerId forAction:(NSString *)action blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl withDelegate:(id<PBResponseHandler>)delegate withParams:(va_list)params
{
    NSAssert(token, @"access token is nil");
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@&player_id=%@&action=%@", token, playerId, action];
    
    id optionalData;
    while ((optionalData = va_arg(params, NSString *)))
    {
        [data appendFormat:@"&%@", optionalData];
    }
    
    // call to a proper type of call
    if(blockingCall)
        return [self call:@"Engine/rule" withData:data syncURLRequest:syncUrl andDelegate:delegate];
    else
        return [self callAsync:@"Engine/rule" withData:data syncURLRequest:syncUrl andDelegate:delegate];
}

-(PBRequest *)ruleInternal:(NSString *)playerId forAction:(NSString *)action blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl withBlock:(PBResponseBlock)block withParams:(va_list)params
{
    NSAssert(token, @"access token is nil");
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@&player_id=%@&action=%@", token, playerId, action];
    
    id optionalData;
    while ((optionalData = va_arg(params, NSString *)))
    {
        [data appendFormat:@"&%@", optionalData];
    }
    
    // call to a proper type of call
    if(blockingCall)
        return [self call:@"Engine/rule" withData:data syncURLRequest:syncUrl andBlock:block];
    else
        return [self callAsync:@"Engine/rule" withData:data syncURLRequest:syncUrl andBlock:block];
}

-(PBRequest *)questListWithDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quest%@", apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}
-(PBRequest *)questListWithBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quest%@", apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andBlock:block];
}
-(PBRequest *)questListWithDelegateAsync:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quest%@", apiKeyParam];
    return [self callAsync:method withData:nil syncURLRequest:YES andDelegate:delegate];
}
-(PBRequest *)questListWithBlockAsync:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quest%@", apiKeyParam];
    return [self callAsync:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quest:(NSString *)questId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@%@", questId, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}
-(PBRequest *)quest:(NSString *)questId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@%@", questId, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andBlock:block];
}
-(PBRequest *)questAsync:(NSString *)questId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@%@", questId, apiKeyParam];
    return [self callAsync:method withData:nil syncURLRequest:YES andDelegate:delegate];
}
-(PBRequest *)questAsync:(NSString *)questId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@%@", questId, apiKeyParam];
    return [self callAsync:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)mission:(NSString *)questId :(NSString *)missionId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@/misson/%@%@", questId, missionId, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)questAvailable:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@/available/%@&player_id=%@", questId, apiKeyParam, playerId];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}
-(PBRequest *)questAvailable:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@/available/%@&player_id=%@", questId, apiKeyParam, playerId];
    return [self call:method withData:nil syncURLRequest:YES andBlock:block];
}
-(PBRequest *)questAvailableAsync:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@/available/%@&player_id=%@", questId, apiKeyParam, playerId];
    return [self callAsync:method withData:nil syncURLRequest:YES andDelegate:delegate];
}
-(PBRequest *)questAvailableAsync:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@/available/%@&player_id=%@", questId, apiKeyParam, playerId];
    return [self callAsync:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)questsAvailable:(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quest/available/%@&player_id=%@", apiKeyParam, playerId];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)joinQuest:(NSString *)questId :(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quest/%@/join", questId];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id%@", token, playerId];
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)cancelQuest:(NSString *)questId :(NSString *)playerId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quest/%@/cancel", questId];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id%@", token, playerId];
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)redeemGoods:(NSString *)goodsId :(NSString *)playerId :(unsigned int)amount :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    if(amount < 1){
        amount = 1;
    }
    NSString *method = [NSString stringWithFormat:@"Redeem/goods"];
    NSString *data = [NSString stringWithFormat:@"token=%@&goods_id=%@&player_id%@&amount=%u", token, goodsId, playerId, amount];
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)recentPoint:(unsigned int)offset :(unsigned int)limit :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Service/recent_point%@&offset=%u&limit=%u", apiKeyParam, offset, limit];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)recentPointByName:(NSString *)pointName :(unsigned int)offset :(unsigned int)limit :(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Service/recent_point%@&offset=%u&limit=%u&point_name=%@", apiKeyParam, offset, limit, pointName];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)sendEmail:(NSString *)playerId :(NSString *)subject :(NSString *)message :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Email/send"];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&subject=%@&message=%@", token, playerId, subject, message];
    
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)sendEmail:(NSString *)playerId :(NSString *)subject :(NSString *)message :(NSString *)templateId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Email/send"];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&subject=%@&message=%@&template_id=%@", token, playerId, subject, message, templateId];
    
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

- (PBRequest *)sendEmailCoupon:(NSString *)playerId :(NSString *)refId :(NSString *)subject :(NSString *)message :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Email/send"];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&ref_id=%@&message=%@", token, playerId, refId, message];
    
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)sendEmailCoupon:(NSString *)playerId :(NSString *)refId :(NSString *)subject :(NSString *)message :(NSString *)templateId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Email/send"];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&ref_id=%@&message=%@&template_id=%@", token, playerId, refId, message, templateId];
    
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizList:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/list%@&player_id=%@", apiKeyParam, playerId];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizList:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/list%@&player_id=%@", apiKeyParam, playerId];
    return [self call:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizListAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/list%@&player_id=%@", apiKeyParam, playerId];
    return [self callAsync:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizListAsync:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/list%@&player_id=%@", apiKeyParam, playerId];
    return [self callAsync:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizDetail:(NSString *)quizId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/detail%@", quizId, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizDetail:(NSString *)quizId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/detail%@", quizId, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizDetailAsync:(NSString *)quizId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/detail%@", quizId, apiKeyParam];
    return [self callAsync:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizDetailAsync:(NSString *)quizId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/detail%@", quizId, apiKeyParam];
    return [self callAsync:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizDetail:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/detail%@&player_id=%@", quizId, apiKeyParam, playerId];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizDetail:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/detail%@&player_id=%@", quizId, apiKeyParam, playerId];
    return [self call:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizDetailAsync:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/detail%@&player_id=%@", quizId, apiKeyParam, playerId];
    return [self callAsync:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizDetailAsync:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/detail%@&player_id=%@", quizId, apiKeyParam, playerId];
    return [self callAsync:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizRandom:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/random%@&player_id=%@", apiKeyParam, playerId];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizRandom:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/random%@&player_id=%@", apiKeyParam, playerId];
    return [self call:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizRandomAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/random%@&player_id=%@", apiKeyParam, playerId];
    return [self callAsync:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizRandomAsync:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/random%@&player_id=%@", apiKeyParam, playerId];
    return [self callAsync:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizDone:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/player/%@/%ld%@", playerId, (long)limit, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizDone:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/player/%@/%ld%@", playerId, (long)limit, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizDoneAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/player/%@/%ld%@", playerId, (long)limit, apiKeyParam];
    return [self callAsync:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizDoneAsync:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/player/%@/%ld%@", playerId, (long)limit, apiKeyParam];
    return [self callAsync:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizPending:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/player/%@/pending/%ld%@", playerId, (long)limit, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizPending:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/player/%@/pending/%ld%@", playerId, (long)limit, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizPendingAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/player/%@/pending/%ld%@", playerId, (long)limit, apiKeyParam];
    return [self callAsync:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizPendingAsync:(NSString *)playerId limit:(NSInteger *)limit withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/player/%@/pending/%ld%@", playerId, (long)limit, apiKeyParam];
    return [self callAsync:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizQuestion:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/question%@&player_id=%@", quizId, apiKeyParam, playerId];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizQuestion:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/question%@&player_id=%@", quizId, apiKeyParam, playerId];
    return [self call:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizQuestionAsync:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/question%@&player_id=%@", quizId, apiKeyParam, playerId];
    return [self callAsync:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizQuestionAsync:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/question%@&player_id=%@", quizId, apiKeyParam, playerId];
    return [self callAsync:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizAnswer:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withDelegate:(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/answer", quizId];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&question_id=%@&option_id=%@", token, playerId, questionId, optionId];
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizAnswer:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBResponseBlock)block
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/answer", quizId];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&question_id=%@&option_id=%@", token, playerId, questionId, optionId];
    return [self call:method withData:data syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizAnswerAsync:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withDelegate:(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/answer", quizId];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&question_id=%@&option_id=%@", token, playerId, questionId, optionId];
    return [self callAsync:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizAnswerAsync:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBResponseBlock)block
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/answer", quizId];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&question_id=%@&option_id=%@", token, playerId, questionId, optionId];
    return [self callAsync:method withData:data syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizScoreRank:(NSString *)quizId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/rank/%ld%@", quizId, (long)limit, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizScoreRank:(NSString *)quizId limit:(NSInteger)limit withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/rank/%ld%@", quizId, (long)limit, apiKeyParam];
    return [self call:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)quizScoreRankAsync:(NSString *)quizId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/rank/%ld%@", quizId, (long)limit, apiKeyParam];
    return [self callAsync:method withData:nil syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)quizScoreRankAsync:(NSString *)quizId limit:(NSInteger)limit withBlock:(PBResponseBlock)block
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/rank/%ld%@", quizId, (long)limit, apiKeyParam];
    return [self callAsync:method withData:nil syncURLRequest:YES andBlock:block];
}

-(PBRequest *)sms:(NSString *)playerId :(NSString *)message :(id<PBResponseHandler>)delegate
{
    NSAssert(token , @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Sms/send"];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@", token, playerId, message];
    
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)sms:(NSString *)playerId :(NSString *)message :(NSString *)templateId :(id<PBResponseHandler>)delegate
{
    NSAssert(token , @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Sms/send"];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@&template_id=%@", token, playerId, message, templateId];
    
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)smsCoupon:(NSString *)playerId :(NSString *)refId :(NSString *)message :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Sms/goods"];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&ref_id=%@&message=%@", token, playerId, refId, message];
    
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)smsCoupon:(NSString *)playerId :(NSString *)refId :(NSString *)message :(NSString *)templateId :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Sms/goods"];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&ref_id=%@&message=%@&template_id=%@", token, playerId, refId, message, templateId];
    
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)push:(NSString *)playerId :(NSString *)message :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    
    // check if device token is there and set before making a request
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    if(deviceToken == nil)
    {
        NSLog(@"No device token acquired just yet.");
        return nil;
    }
    
    NSString *method = [NSString stringWithFormat:@"Push/notification"];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@", token, playerId, message];
    
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)push:(NSString *)playerId :(NSString *)message :(id<PBResponseHandler>)delegate :(NSString *)templateId
{
    NSAssert(token, @"access token is nil");
    
    // check if device token is there and set before making a request
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    if(deviceToken == nil)
    {
        NSLog(@"No device token acquired just yet.");
        return nil;
    }
    
    NSString *method = [NSString stringWithFormat:@"Push/notification"];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@&template_id=%@", token, playerId, message, templateId];
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)registerForPushNotification:(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    
    // get device token from what we save in NSUserDefaults
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    NSAssert(deviceToken, @"device token is nil");
    
    NSString *method = [NSString stringWithFormat:@"Push/registerdevice"];
    NSString *data = [NSString stringWithFormat:@"token=%@&device_token=%@", token, deviceToken];
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(PBRequest *)track:(NSString *)playerId forAction:(NSString *)action withDelegate:(id<PBResponseHandler>)delegate
{
    // TODO: Add checking if playerId exists in the system, then register it properly with information that still needed to gather
    
    // use the async-url request and non-blocking call
    return [self ruleAsync:playerId forAction:action syncUrl:NO withDelegate:delegate, nil];
}

-(PBRequest *)track:(NSString *)playerId forAction:(NSString *)action withBlock:(PBResponseBlock)block
{
    // TODO: Add checking if playerId exists in the system, then register it properly with information that still needed to gather
    
    // use the async-url request and non-blocking call
    return [self ruleAsync:playerId forAction:action syncUrl:NO withBlock:block, nil];
}

-(PBRequest *)do:(NSString *)playerId action:(NSString *)action withDelegate:(id<PBResponseHandler>)delegate
{
    // TODO: Add checking if playerId exists in the system, then register it properly with information that still needed to gather
    
    return [self rule:playerId forAction:action withDelegate:delegate, nil];
}

-(PBRequest *)do:(NSString *)playerId action:(NSString *)action withBlock:(PBResponseBlock)block
{
    // TODO: Add checking if playerId exists in the system, then register it properly with information that still needed to gather
    
    return [self rule:playerId forAction:action withBlock:block, nil];
}

-(PBRequest *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andDelegate:(id<PBResponseHandler>)delegate
{
    return [self callInternalBase:method withData:data blockingCall:YES syncURLRequest:syncURLRequest useDelegate:YES withResponse:delegate];
}

-(PBRequest *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andBlock:(PBResponseBlock)block
{
    return [self callInternalBase:method withData:data blockingCall:YES syncURLRequest:syncURLRequest useDelegate:NO withResponse:block];
}

-(PBRequest *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andDelegate:(id<PBResponseHandler>)delegate
{
    return [self callInternalBase:method withData:data blockingCall:NO syncURLRequest:syncURLRequest useDelegate:YES withResponse:delegate];
}

-(PBRequest *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andBlock:(PBResponseBlock)block
{
    return [self callInternalBase:method withData:data blockingCall:NO syncURLRequest:syncURLRequest useDelegate:NO withResponse:block];
}

-(PBRequest *)callInternalBase:(NSString *)method withData:(NSString *)data blockingCall:(BOOL)blockingCall syncURLRequest:(BOOL)syncURLRequest useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    id request = nil;
    
    // set the default mode to sync mode
    NSString *urlRequest = BASE_URL;
    // if it goes to async mode, then set it accordingly
    if(!syncURLRequest)
        urlRequest = BASE_ASYNC_URL;
    
    id url = nil;
    
    // if it's sync url request then append method into base url
    if(syncURLRequest)
        url = [NSURL URLWithString:[urlRequest stringByAppendingString:method]];
    // otherwise, no need to append anything to the base url
    else
        url = [NSURL URLWithString:urlRequest];
    
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
        
        if(syncURLRequest)
            [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        else
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
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
    // create PBRequest with delegate callback
    PBRequest* pbRequest = nil;
    if(useDelegate)
    {
        pbRequest = [[PBRequest alloc] initWithURLRequest:request blockingCall:blockingCall andDelegate:response];
    }
    // create PBRequest with block callback
    else
    {
        pbRequest = [[PBRequest alloc] initWithURLRequest:request blockingCall:blockingCall andBlock:response];
    }
    
    // if network is reachable then dispatch it immediately
    if(isNetworkReachable)
    {
        // start the request
        [pbRequest start];
    }
    // otherwise, then add into the queue
    else
    {
        // add PBRequest into operational queue
        [requestOptQueue enqueue:pbRequest];
        
        NSLog(@"Queue size = %d", [requestOptQueue count]);
    }
    
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
