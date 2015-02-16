//
//  Playbasis.m
//  Playbasis
//
//  Created by Playbasis.
//  Copyright (c) 2556 Playbasis. All rights reserved.
//

#import "Playbasis.h"

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
 Refactored method to return PBRequest according to the setting input to the method.
 */
-(PBRequest *)refactoredInternalBaseReturnWithBlockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withMethod:(NSString *)method andData:(NSString *)data responseType:(pbResponseType) responseType andResponse:(id)response;

/**
 Return json-data string used to send via async url request.
 */
-(NSString *)formAsyncUrlRequestJsonDataStringFromData:(NSString *)dataString method:(NSString *)method;

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
-(PBRequest *)ruleInternal:(NSString *)playerId forAction:(NSString *)action blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl withBlock:(id)block withParams:(va_list)params;

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

// - point
-(PBRequest *)pointInternalBase:(NSString *)playerId forPoint:(NSString *)pointName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - pointHistory
-(PBRequest *)pointHistoryInternalBase:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - actionTime
-(PBRequest *)actionTimeInternalBase:(NSString *)playerId forAction:(NSString *)actionName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - actionLastPerformed
-(PBRequest *)actionLastPerformedInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - actionLastPerformedTime
-(PBRequest *)actionLastPerformedTimeInternalBase:(NSString *)playerId forAction:(NSString *)actionName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - actionPerformedCount
-(PBRequest *)actionPerformedCountInternalBase:(NSString *)playerId forAction:(NSString *)actionName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - badgeOwned
-(PBRequest *)badgeOwnedInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - rank
-(PBRequest *)rankInternalBase:(NSString *)rankedBy withLimit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - ranks
-(PBRequest *)ranksInternalBase:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - level
-(PBRequest *)levelInternalBase:(unsigned int)level blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - levels
-(PBRequest *)levelsInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - claimBadge
-(PBRequest *)claimBadgeInternalBase:(NSString *)playerId withBadgeId:(NSString *)badgeId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - redeemBadge
-(PBRequest *)redeemBadgeInternalBase:(NSString *)playerId withBadgeId:(NSString *)badgeId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - goodsOwned
-(PBRequest *)goodsOwnedInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questOfPlayer
-(PBRequest *)questOfPlayerInternalBase:(NSString *)playerId questId:(NSString *)questId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questRewardHistoryOfPlayer
-(PBRequest *)questRewardHistoryOfPlayerInternalBase:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - deductRewardFromPlayer
-(PBRequest *)deductRewardFromPlayerInternalBase:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questListOfPlayer
-(PBRequest *)questListOfPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - mission
-(PBRequest *)missionInternalBase:(NSString *)questId mission:(NSString *)missionId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questListAvailableForPlayer
-(PBRequest *)questListAvailableForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questAvailable
-(PBRequest *)questAvailableInternalBase:(NSString *)questId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quest
-(PBRequest *)questWithQuestIdInternalBase:(NSString *)questId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - joinQuest
-(PBRequest *)joinQuestInternalBase:(NSString *)questId player:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - joinAllQuests
-(PBRequest *) joinAllQuestsForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - cancelQuest
-(PBRequest *)cancelQuestInternalBase:(NSString *)questId player:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - redeemGoods
-(PBRequest *)redeemGoodsInternalBase:(NSString *)goodsId player:(NSString *)playerId amount:(unsigned int)amount blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - recentPoint
-(PBRequest *)recentPointInternalBase:(unsigned int)offset limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - recentPointByName
-(PBRequest *)recentPointByNameInternalBase:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - resetPoints
-(PBRequest *)resetPointForAllPlayersForPointInternalBase:(NSString *)pointName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - sendEmail
-(PBRequest *)sendEmailInternalBase:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - sendEmail (with template-id)
-(PBRequest *)sendEmailInternalBase:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - sendEmailCoupon
-(PBRequest *)sendEmailCouponInternalBase:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - sendEmailCoupon (with template-id)
-(PBRequest *)sendEmailCouponInternalBase:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizList
-(PBRequest *)quizListInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizDetail
-(PBRequest *)quizDetailInternalBase:(NSString *)quizId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizDetail (with player-id)
-(PBRequest *)quizDetailInternalBase:(NSString *)quizId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizRandom
-(PBRequest *)quizRandomInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizDone
-(PBRequest *)quizDoneInternalBase:(NSString *)playerId limit:(NSInteger)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizPending
-(PBRequest *)quizPendingInternalBase:(NSString *)playerId limit:(NSInteger)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizQuestion
-(PBRequest *)quizQuestionInternalBase:(NSString *)quizId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizAnswer
-(PBRequest *)quizAnswerInternalBase:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizScoreRank
-(PBRequest *)quizScoreRankInternalBase:(NSString *)quizId limit:(NSInteger)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - sms
-(PBRequest *)smsInternalBase:(NSString *)playerId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - sms (with template-id)
-(PBRequest *)smsInternalBase:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - smsCoupon
-(PBRequest *)smsCouponInternalBase:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - smsCoupon (with template-id)
-(PBRequest *)smsCouponInternalBase:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - push
-(PBRequest *)pushInternalBase:(NSString *)playerId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - push (with template-id)
-(PBRequest *)pushInternalBase:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - badge
-(PBRequest *)badgeInternalBase:(NSString *)badgeId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - badges
-(PBRequest *)badgesInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - goods
-(PBRequest *)goodsInternalBase:(NSString *)goodId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - goodsList
-(PBRequest *)goodsListInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - goodsGroupAvailable
-(PBRequest *)goodsGroupAvailableInternalBase:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - actionConfig
-(PBRequest *)actionConfigInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questList
-(PBRequest *)questListInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - track
-(void)trackInternalBase:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - do
-(void)doInternalBase:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

@end

//
// delegate object for handling authentication
//
@interface PBAuthDelegate : NSObject <PBAuth_ResponseHandler>
{
    Playbasis* pb;
    BOOL finished;
    
    // either use one or another
    id<PBAuth_ResponseHandler> finishDelegate;
    PBAuth_ResponseBlock finishBlock;
}
-(id)initWithCoder:(NSCoder *)decoder;
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithPlaybasis:(Playbasis*)playbasis andDelegate:(id<PBAuth_ResponseHandler>)delegate;
-(id)initWithPlaybasis:(Playbasis*)playbasis andBlock:(PBAuth_ResponseBlock)block;
-(BOOL)isFinished;
-(void)processResponseWithAuth:(PBAuth_Response *)auth withURL:(NSURL *)url error:(NSError *)error;
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

-(id)initWithPlaybasis:(Playbasis *)playbasis andDelegate:(id<PBAuth_ResponseHandler>)delegate
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

-(id)initWithPlaybasis:(Playbasis *)playbasis andBlock:(PBAuth_ResponseBlock)block
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
-(void)processResponseWithAuth:(PBAuth_Response *)auth withURL:(NSURL *)url error:(NSError *)error
{
    // there's an error
    if(error)
    {
        // auth failed
        NSLog(@"Auth failed, error = %@", [error localizedDescription]);
        return;
    }
    
    // otherwise, it's okay
    [pb setToken:auth.token];
    finished = YES;
    
    // just relay the response to user's delegate or block
    if(finishDelegate && ([finishDelegate respondsToSelector:@selector(processResponseWithAuth:withURL:error:)]))
    {
        [finishDelegate processResponseWithAuth:auth withURL:url error:error];
    }
    else if(finishBlock)
    {
        finishBlock(auth, url, error);
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
@synthesize apiKey = _apiKey;

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

+(Playbasis*)sharedPB
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
    _apiKey = [decoder decodeObjectForKey:@"apiKey"];
    apiKeyParam = [decoder decodeObjectForKey:@"apiKeyParam"];
    authDelegate = [decoder decodeObjectForKey:@"authDelegate"];
    requestOptQueue = [decoder decodeObjectForKey:@"requestOptQueue"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:token forKey:@"token"];
    [encoder encodeObject:_apiKey forKey:@"apiKey"];
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

-(PBRequest *)refactoredInternalBaseReturnWithBlockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withMethod:(NSString *)method andData:(NSString *)data responseType:(pbResponseType)responseType andResponse:(id)response
{
    if(blockingCall)
    {
        if(useDelegate)
        {
            return [self call:method withData:data syncURLRequest:syncUrl responseType:responseType andDelegate:response];
        }
        else
        {
            return [self call:method withData:data syncURLRequest:syncUrl responseType:responseType andBlock:response];
        }
    }
    else
    {
        if(useDelegate)
        {
            return [self callAsync:method withData:data syncURLRequest:syncUrl responseType:responseType andDelegate:response];
        }
        else
        {
            return [self callAsync:method withData:data syncURLRequest:syncUrl responseType:responseType andBlock:response];
        }
    }
}

-(NSString *)formAsyncUrlRequestJsonDataStringFromData:(NSString *)dataString method:(NSString*)method
{
    // create json data object
    // we will set object for each field in the loop
    NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
    
    // split all params from data
    NSArray *linesWithEqualSign = [dataString componentsSeparatedByString:@"&"];
    for(NSString *lineWithEqualSign in linesWithEqualSign)
    {
        NSArray *fieldAndValue = [lineWithEqualSign componentsSeparatedByString:@"="];
        
        // set into dict
        [dictData setValue:(NSString*)[fieldAndValue objectAtIndex:1] forKey:[fieldAndValue objectAtIndex:0]];
    }
    
    // package into format
    NSMutableDictionary *dictWholeData = [NSMutableDictionary dictionary];
    [dictWholeData setObject:method forKey:@"endpoint"];
    [dictWholeData setObject:dictData forKey:@"data"];
    [dictWholeData setObject:@"nil" forKey:@"channel"];
    
    // get json string
    NSString *dataFinal = [dictWholeData JSONString];
    NSLog(@"jsonString = %@", dataFinal);
    
    return dataFinal;
}

-(const NSMutableArray *)getRequestOperationalQueue
{
    return requestOptQueue;
}

-(PBRequest *)auth:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andDelegate:(id<PBAuth_ResponseHandler>)delegate
{
    return [self authInternalBase:apiKey withApiSecret:apiSecret blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)auth:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andBlock:(PBAuth_ResponseBlock)block
{
    return [self authInternalBase:apiKey withApiSecret:apiSecret blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)authAsync:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andDelegate:(id<PBAuth_ResponseHandler>)delegate
{
    return [self authInternalBase:apiKey withApiSecret:apiSecret blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)authAsync:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andBlock:(PBAuth_ResponseBlock)block
{
    return [self authInternalBase:apiKey withApiSecret:apiSecret blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)authInternalBase:(NSString *)apiKey withApiSecret:(NSString *)apiSecret blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    // save apikey
    _apiKey = apiKey;
    
    // note: the final response is via PBAuthDelegate either by delegate or block
    // in this case, it's by delegate
    apiKeyParam = [[NSString alloc] initWithFormat:@"?api_key=%@", apiKey];
    
    // check whether it uses delegate to response back
    if(useDelegate)
        authDelegate = [[PBAuthDelegate alloc] initWithPlaybasis:self andDelegate:response];
    else
        authDelegate = [[PBAuthDelegate alloc] initWithPlaybasis:self andBlock:response];
    
    NSString *method = [NSString stringWithFormat:@"Auth%@", apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"api_key=%@&api_secret=%@", apiKey, apiSecret];
    
    // auth call has only delegate response, thus we send delegate as a parameter into the refactored method below
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:YES withMethod:method andData:data responseType:responseType_auth andResponse:authDelegate];
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
    // save apikey
    _apiKey = apiKey;
    
    apiKeyParam = [[NSString alloc] initWithFormat:@"?api_key=%@", apiKey];
    
    // check whether it uses delegate to response back
    if(useDelegate)
        authDelegate = [[PBAuthDelegate alloc] initWithPlaybasis:self andDelegate:response];
    else
        authDelegate = [[PBAuthDelegate alloc] initWithPlaybasis:self andBlock:response];
    
    NSString *method = [NSString stringWithFormat:@"Auth%@", apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"api_key=%@&api_secret=%@", apiKey, apiSecret];
    
    // auth call has only delegate response, thus we send delegate as a parameter into the refactored method below
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:YES withMethod:method andData:data responseType:responseType_auth andResponse:authDelegate];
}

-(PBRequest *)playerPublic:(NSString *)playerId withDelegate:(id<PBPlayerPublic_ResponseHandler>)delegate
{
    return [self playerPublicInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerPublic:(NSString *)playerId withBlock:(PBPlayerPublic_ResponseBlock)block
{
    return [self playerPublicInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerPublicAsync:(NSString *)playerId withDelegate:(id<PBPlayerPublic_ResponseHandler>)delegate
{
    return [self playerPublicInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerPublicAsync:(NSString *)playerId withBlock:(PBPlayerPublic_ResponseBlock)block
{
    return [self playerPublicInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerPublicInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@%@", playerId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_playerPublic andResponse:response];
}

-(PBRequest *)player:(NSString *)playerId withDelegate:(id<PBPlayer_ResponseHandler>)delegate
{
    return [self playerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)player:(NSString *)playerId withBlock:(PBPlayer_ResponseBlock)block
{
    return [self playerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerAsync:(NSString *)playerId withDelegate:(id<PBPlayer_ResponseHandler>)delegate
{
    return [self playerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerAsync:(NSString *)playerId withBlock:(PBPlayer_ResponseBlock)block
{
    return [self playerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@%@", playerId, apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_player andResponse:response];
}

// playerListId player id as used in client's website separate with ',' example '1,2,3'
-(PBRequest *)playerList:(NSString *)playerListId withDelegate:(id<PBPlayerList_ResponseHandler>)delegate
{
    return [self playerListInternalBase:playerListId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerList:(NSString *)playerListId withBlock:(PBPlayerList_ResponseBlock)block
{
    return [self playerListInternalBase:playerListId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerListAsync:(NSString *)playerListId withDelegate:(id<PBPlayerList_ResponseHandler>)delegate
{
    return [self playerListInternalBase:playerListId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerListAsync:(NSString *)playerListId withBlock:(PBPlayerList_ResponseBlock)block
{
    return [self playerListInternalBase:playerListId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerListInternalBase:(NSString *)playerListId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/list%@", apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&list_player_id=%@", token, playerListId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_playerList andResponse:response];
}

-(PBRequest *)playerDetailPublic:(NSString *)playerId withDelegate:(id<PBPlayerDetailedPublic_ResponseHandler>)delegate
{
    return [self playerDetailPublicInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerDetailPublic:(NSString *)playerId withBlock:(PBPlayerDetailedPublic_ResponseBlock)block
{
    return [self playerDetailPublicInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerDetailPublicAsync:(NSString *)playerId withDelegate:(id<PBPlayerDetailedPublic_ResponseHandler>)delegate
{
    return [self playerDetailPublicInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerDetailPublicAsync:(NSString *)playerId withBlock:(PBPlayerDetailedPublic_ResponseBlock)block
{
    return [self playerDetailPublicInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerDetailPublicInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/data/all%@", playerId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_playerDetailedPublic andResponse:response];
}

-(PBRequest *)playerDetail:(NSString *)playerId withDelegate:(id<PBPlayerDetailed_ResponseHandler>)delegate
{
    return [self playerDetailInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerDetail:(NSString *)playerId withBlock:(PBPlayerDetailed_ResponseBlock)block
{
    return [self playerDetailInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerDetailAsync:(NSString *)playerId withDelegate:(id<PBPlayerDetailed_ResponseHandler>)delegate
{
    return [self playerDetailInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)playerDetailAsync:(NSString *)playerId withBlock:(PBPlayerDetailed_ResponseBlock)block
{
    return [self playerDetailInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)playerDetailInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/data/all%@", playerId, apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_playerDetailed andResponse:response];
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
    NSString *method = [NSString stringWithFormat:@"Player/%@/register%@", playerId, apiKeyParam];
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
    NSString *method = [NSString stringWithFormat:@"Player/%@/register%@", playerId, apiKeyParam];
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
    NSString *method = [NSString stringWithFormat:@"Player/%@/register%@", playerId, apiKeyParam];
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
    NSString *method = [NSString stringWithFormat:@"Player/%@/register%@", playerId, apiKeyParam];
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
-(PBRequest *)registerUserAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block :(NSString *)username :(NSString *)email :(NSString *)imageUrl, ...
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/register%@", playerId, apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@&username=%@&email=%@&image=%@", token, username, email, imageUrl];
    
    id optionalData;
    va_list argumentList;
    va_start(argumentList, imageUrl);
    while ((optionalData = va_arg(argumentList, NSString *)))
    {
        [data appendFormat:@"&%@", optionalData];
    }
    va_end(argumentList);
    
    // form async url request data
    NSString *dataFinal = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    
    return [self callAsync:method withData:dataFinal syncURLRequest:NO andBlock:block];
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
    NSString *method = [NSString stringWithFormat:@"Player/%@/update%@", playerId, apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@", token];
    
    // append firstArg first, but check against nil
    if(firstArg != nil)
        [data appendFormat:@"&%@", firstArg];

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
    NSString *method = [NSString stringWithFormat:@"Player/%@/update%@", playerId, apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@", token];
    
    // append firstArg first, but check against nil
    if(firstArg != nil)
        [data appendFormat:@"&%@", firstArg];
    
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
    NSString *method = [NSString stringWithFormat:@"Player/%@/update%@", playerId, apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@", token];
    
    // append firstArg first, but check against nil
    if(firstArg != nil)
        [data appendFormat:@"&%@", firstArg];
    
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
    NSString *method = [NSString stringWithFormat:@"Player/%@/update%@", playerId, apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@", token];
    
    // append firstArg first, but check against nil
    if(firstArg != nil)
        [data appendFormat:@"&%@", firstArg];
    
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
-(PBRequest *)updateUserAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block :(NSString *)firstArg, ...
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/update%@", playerId, apiKeyParam];
    
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@", token];
    
    // append firstArg first, but check against nil
    if(firstArg != nil)
        [data appendFormat:@"&%@", firstArg];
    
    id updateData;
    va_list argumentList;
    va_start(argumentList, firstArg);
    // this loop start next to firstArg
    while ((updateData = va_arg(argumentList, NSString *)))
    {
        [data appendFormat:@"&%@", updateData];
    }
    va_end(argumentList);
    
    // form async url request data
    NSString *dataFinal = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    
    return [self callAsync:method withData:dataFinal syncURLRequest:NO andBlock:block];
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
-(PBRequest *)deleteUserAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self deleteUserInternalBase:playerId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)deleteUserInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/delete%@", playerId, apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }

    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)loginAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self loginInternalBase:playerId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)login:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self loginInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}

-(PBRequest *)login:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self loginInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
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
    NSString *method = [NSString stringWithFormat:@"Player/%@/login%@", playerId, apiKeyParam];
    
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
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
-(PBRequest *)logoutAsync_:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self logoutInternalBase:playerId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)logoutInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/logout%@", playerId, apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)points:(NSString *)playerId withDelegate:(id<PBPoints_ResponseHandler>)delegate
{
    return [self pointsInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)points:(NSString *)playerId withBlock:(PBPoints_ResponseBlock)block
{
    return [self pointsInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)pointsAsync:(NSString *)playerId withDelegate:(id<PBPoints_ResponseHandler>)delegate
{
    return [self pointsInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)pointsAsync:(NSString *)playerId withBlock:(PBPoints_ResponseBlock)block
{
    return [self pointsInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
- (PBRequest *)pointsInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/points%@", playerId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_points andResponse:response];
}

-(PBRequest *)point:(NSString *)playerId forPoint:(NSString *)pointName withDelegate:(id<PBPoint_ResponseHandler>)delegate
{
    return [self pointInternalBase:playerId forPoint:pointName blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)point:(NSString *)playerId forPoint:(NSString *)pointName withBlock:(PBPoint_ResponseBlock)block
{
    return [self pointInternalBase:playerId forPoint:pointName blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)pointAsync:(NSString *)playerId forPoint:(NSString *)pointName withDelegate:(id<PBPoint_ResponseHandler>)delegate
{
    return [self pointInternalBase:playerId forPoint:pointName blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)pointAsync:(NSString *)playerId forPoint:(NSString *)pointName withBlock:(PBPoint_ResponseBlock)block
{
    return [self pointInternalBase:playerId forPoint:pointName blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)pointInternalBase:(NSString *)playerId forPoint:(NSString *)pointName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/point/%@%@", playerId, pointName, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_point andResponse:response];
}


-(PBRequest *)pointHistory:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName offset:offset withLimit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)pointHistory:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName offset:offset withLimit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)pointHistoryAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName offset:offset withLimit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)pointHistoryAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName offset:offset withLimit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)pointHistoryInternalBase:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *params = [NSString stringWithFormat:@"&offset=%u&limit=%u", offset, limit];
    if (pointName != nil) {
        params = [NSString stringWithFormat:@"%@&point_name=%@", params, pointName];
    }
    NSString *method = [NSString stringWithFormat:@"Player/%@/point_history%@%@", playerId, apiKeyParam, params];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_pointHistory andResponse:response];
}

-(PBRequest *)actionTime:(NSString *)playerId forAction:(NSString *)actionName withDelegate:(id<PBActionTime_ResponseHandler>)delegate;
{
    return [self actionTimeInternalBase:playerId forAction:actionName blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)actionTime:(NSString *)playerId forAction:(NSString *)actionName withBlock:(PBActionTime_ResponseBlock)block
{
    return [self actionTimeInternalBase:playerId forAction:actionName blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)actionTimeAsync:(NSString *)playerId forAction:(NSString *)actionName withDelegate:(id<PBActionTime_ResponseHandler>)delegate
{
    return [self actionTimeInternalBase:playerId forAction:actionName blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)actionTimeAsync:(NSString *)playerId forAction:(NSString *)actionName withBlock:(PBActionTime_ResponseBlock)block
{
    return [self actionTimeInternalBase:playerId forAction:actionName blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)actionTimeInternalBase:(NSString *)playerId forAction:(NSString *)actionName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/%@/time%@", playerId, actionName, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_actionTime andResponse:response];
}

-(PBRequest *)actionLastPerformed:(NSString *)playerId withDelegate:(id<PBLastAction_ResponseHandler>)delegate
{
    return [self actionLastPerformedInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)actionLastPerformed:(NSString *)playerId withBlock:(PBLastAction_ResponseBlock)block
{
    return [self actionLastPerformedInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)actionLastPerformedAsync:(NSString *)playerId withDelegate:(id<PBLastAction_ResponseHandler>)delegate
{
    return [self actionLastPerformedInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)actionLastPerformedAsync:(NSString *)playerId withBlock:(PBLastAction_ResponseBlock)block
{
    return [self actionLastPerformedInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)actionLastPerformedInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/time%@", playerId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_lastAction andResponse:response];
}


-(PBRequest *)actionLastPerformedTime:(NSString *)playerId forAction:(NSString *)actionName withDelegate:(id<PBResponseHandler>)delegate
{
    return [self actionLastPerformedTimeInternalBase:playerId forAction:actionName blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)actionLastPerformedTime:(NSString *)playerId forAction:(NSString *)actionName withBlock:(PBResponseBlock)block
{
    return [self actionLastPerformedTimeInternalBase:playerId forAction:actionName blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)actionLastPerformedTimeAsync:(NSString *)playerId forAction:(NSString *)actionName withDelegate:(id<PBResponseHandler>)delegate
{
    return [self actionLastPerformedTimeInternalBase:playerId forAction:actionName blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)actionLastPerformedTimeAsync:(NSString *)playerId forAction:(NSString *)actionName withBlock:(PBResponseBlock)block
{
    return [self actionLastPerformedTimeInternalBase:playerId forAction:actionName blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)actionLastPerformedTimeInternalBase:(NSString *)playerId forAction:(NSString *)actionName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/%@/time%@", playerId, actionName, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil andResponse:response];
}

-(PBRequest *)actionPerformedCount:(NSString *)playerId forAction:(NSString *)actionName withDelegate:(id<PBActionCount_ResponseHandler>)delegate
{
    return [self actionPerformedCountInternalBase:playerId forAction:actionName blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)actionPerformedCount:(NSString *)playerId forAction:(NSString *)actionName withBlock:(PBActionCount_ResponseBlock)block
{
    return [self actionPerformedCountInternalBase:playerId forAction:actionName blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)actionPerformedCountAsync:(NSString *)playerId forAction:(NSString *)actionName withDelegate:(id<PBActionCount_ResponseHandler>)delegate
{
    return [self actionPerformedCountInternalBase:playerId forAction:actionName blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)actionPerformedCountAsync:(NSString *)playerId forAction:(NSString *)actionName withBlock:(PBActionCount_ResponseBlock)block
{
    return [self actionPerformedCountInternalBase:playerId forAction:actionName blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)actionPerformedCountInternalBase:(NSString *)playerId forAction:(NSString *)actionName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/%@/count%@", playerId, actionName, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_actionCount andResponse:response];
}

-(PBRequest *)badgeOwned:(NSString *)playerId withDelegate:(id<PBPlayerBadges_ResponseHandler>)delegate
{
    return [self badgeOwnedInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)badgeOwned:(NSString *)playerId withBlock:(PBPlayerBadges_ResponseBlock)block
{
    return [self badgeOwnedInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)badgeOwnedAsync:(NSString *)playerId withDelegate:(id<PBPlayerBadges_ResponseHandler>)delegate
{
    return [self badgeOwnedInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)badgeOwnedAsync:(NSString *)playerId withBlock:(PBPlayerBadges_ResponseBlock)block
{
    return [self badgeOwnedInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)badgeOwnedInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/badge%@", playerId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_playerBadges andResponse:response];
}

-(PBRequest *)rank:(NSString *)rankedBy withLimit:(unsigned int)limit andDelegate:(id<PBRank_ResponseHandler>)delegate
{
    return [self rankInternalBase:rankedBy withLimit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)rank:(NSString *)rankedBy withLimit:(unsigned int)limit andBlock:(PBRank_ResponseBlock)block
{
    return [self rankInternalBase:rankedBy withLimit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)rankAsync:(NSString *)rankedBy withLimit:(unsigned int)limit andDelegate:(id<PBRank_ResponseHandler>)delegate
{
    return [self rankInternalBase:rankedBy withLimit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)rankAsync:(NSString *)rankedBy withLimit:(unsigned int)limit andBlock:(PBRank_ResponseBlock)block
{
    return [self rankInternalBase:rankedBy withLimit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)rankInternalBase:(NSString *)rankedBy withLimit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/rank/%@/%u%@", rankedBy, limit, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_rank andResponse:response];
}

-(PBRequest *)ranks:(unsigned int)limit withDelegate:(id<PBRank_ResponseHandler>)delegate
{
    return [self ranksInternalBase:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)ranks:(unsigned int)limit withBlock:(PBRanks_ResponseBlock)block
{
    return [self ranksInternalBase:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)ranksAsync:(unsigned int)limit withDelegate:(id<PBRank_ResponseHandler>)delegate
{
    return [self ranksInternalBase:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)ranksAsync:(unsigned int)limit withBlock:(PBRanks_ResponseBlock)block
{
    return [self ranksInternalBase:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)ranksInternalBase:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/ranks/%u%@", limit, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_ranks andResponse:response];
}

-(PBRequest *)level:(unsigned int)level withDelegate:(id<PBLevel_ResponseHandler>)delegate
{
    return [self levelInternalBase:level blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)level:(unsigned int)level withBlock:(PBLevel_ResponseBlock)block
{
    return [self levelInternalBase:level blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)levelAsync:(unsigned int)level withDelegate:(id<PBLevel_ResponseHandler>)delegate
{
    return [self levelInternalBase:level blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)levelAsync:(unsigned int)level withBlock:(PBLevel_ResponseBlock)block
{
    return [self levelInternalBase:level blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)levelInternalBase:(unsigned int)level blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/level/%u%@", level, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_level andResponse:response];
}

-(PBRequest *)levelsWithDelegate:(id<PBLevels_ResponseHandler>)delegate
{
    return [self levelsInternalBase:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)levelsWithBlock:(PBLevels_ResponseBlock)block
{
    return [self levelsInternalBase:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)levelsAsyncWithDelegate:(id<PBLevels_ResponseHandler>)delegate
{
    return [self levelsInternalBase:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)levelsAsyncWithBlock:(PBLevels_ResponseBlock)block
{
    return [self levelsInternalBase:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)levelsInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/levels%@", apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_levels andResponse:response];
}

-(PBRequest *)claimBadge:(NSString *)playerId withBadgeId:(NSString *)badgeId andDelegate:(id<PBResponseHandler>)delegate
{
    return [self claimBadgeInternalBase:playerId withBadgeId:badgeId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)claimBadge:(NSString *)playerId withBadgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block
{
    return [self claimBadgeInternalBase:playerId withBadgeId:badgeId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)claimBadgeAsync:(NSString *)playerId withBadgeId:(NSString *)badgeId andDelegate:(id<PBResponseHandler>)delegate
{
    return [self claimBadgeInternalBase:playerId withBadgeId:badgeId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)claimBadgeAsync:(NSString *)playerId withBadgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block
{
    return [self claimBadgeInternalBase:playerId withBadgeId:badgeId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)claimBadgeAsync_:(NSString *)playerId withBadgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block
{
    return [self claimBadgeInternalBase:playerId withBadgeId:badgeId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)claimBadgeInternalBase:(NSString *)playerId withBadgeId:(NSString *)badgeId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/badge/%@/claim%@", playerId, badgeId, apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    
    if(!syncUrl)
    {
        // form async url request data
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)redeemBadge:(NSString *)playerId withBadgeId:(NSString *)badgeId andDelegate:(id<PBResponseHandler>)delegate
{
    return [self redeemBadgeInternalBase:playerId withBadgeId:badgeId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)redeemBadge:(NSString *)playerId withBadgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block
{
    return [self redeemBadgeInternalBase:playerId withBadgeId:badgeId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)redeemBadgeAsync:(NSString *)playerId withBadgeId:(NSString *)badgeId andDelegate:(id<PBResponseHandler>)delegate
{
    return [self redeemBadgeInternalBase:playerId withBadgeId:badgeId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)redeemBadgeAsync:(NSString *)playerId withBadgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block
{
    return [self redeemBadgeInternalBase:playerId withBadgeId:badgeId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)redeemBadgeAsync_:(NSString *)playerId withBadgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block
{
    return [self redeemBadgeInternalBase:playerId withBadgeId:badgeId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)redeemBadgeInternalBase:(NSString *)playerId withBadgeId:(NSString *)badgeId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/badge/%@/redeem%@", playerId, badgeId, apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", token];
    
    if(!syncUrl)
    {
        // form async url request data
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)goodsOwned:(NSString *)playerId withDelegate:(id<PBPlayerGoodsOwned_ResponseHandler>)delegate
{
    return [self goodsOwnedInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)goodsOwned:(NSString *)playerId withBlock:(PBPlayerGoodsOwned_ResponseBlock)block
{
    return [self goodsOwnedInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)goodsOwnedAsync:(NSString *)playerId withDelegate:(id<PBPlayerGoodsOwned_ResponseHandler>)delegate
{
    return [self goodsOwnedInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)goodsOwnedAsync:(NSString *)playerId withBlock:(PBPlayerGoodsOwned_ResponseBlock)block
{
    return [self goodsOwnedInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)goodsOwnedInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/goods%@", playerId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_playerGoodsOwned andResponse:response];
}

-(PBRequest *)questOfPlayer:(NSString *)playerId questId:(NSString *)questId andDelegate:(id<PBQuestOfPlayer_ResponseHandler>)delegate
{
    return [self questOfPlayerInternalBase:playerId questId:questId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questOfPlayer:(NSString *)playerId questId:(NSString *)questId andBlock:(PBQuestOfPlayer_ResponseBlock)block
{
    return [self questOfPlayerInternalBase:playerId questId:questId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questOfPlayerAsync:(NSString *)playerId questId:(NSString *)questId andDelegate:(id<PBQuestOfPlayer_ResponseHandler>)delegate
{
    return [self questOfPlayerInternalBase:playerId questId:questId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questOfPlayerAsync:(NSString *)playerId questId:(NSString *)questId andBlock:(PBQuestOfPlayer_ResponseBlock)block
{
    return [self questOfPlayerInternalBase:playerId questId:questId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questOfPlayerInternalBase:(NSString *)playerId questId:(NSString *)questId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/quest/%@%@&player_id=%@", questId, apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questOfPlayer andResponse:response];
}

-(PBRequest *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId offset:offset limit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId offset:offset limit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId offset:offset limit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId offset:offset limit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questRewardHistoryOfPlayerInternalBase:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/quest_reward_history%@&offset=%u&limit=%u", playerId, apiKeyParam, offset, limit];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questRewardHistoryOfPlayer andResponse:response];
}

-(PBRequest *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withDelegate:(id<PBResponseHandler>)delegate
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount force:force blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withBlock:(PBResponseBlock)block
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount force:force blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withDelegate:(id<PBResponseHandler>)delegate
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount force:force blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withBlock:(PBResponseBlock)block
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount force:force blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)deductRewardFromPlayerAsync_:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount force:force blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)deductRewardFromPlayerInternalBase:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/deduct_reward%@", playerId, apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&reward=%@&amount=%lu&force=%lu", token, reward, (unsigned long)amount, (unsigned long)force];
    
    if(!syncUrl)
    {
        // form async url request data
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)questListOfPlayer:(NSString *)playerId withDelegate:(id<PBQuestListOfPlayer_ResponseHandler>)delegate
{
    return [self questListOfPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questListOfPlayer:(NSString *)playerId withBlock:(PBQuestListOfPlayer_ResponseBlock)block
{
    return [self questListOfPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questListOfPlayerAsync:(NSString *)playerId withDelegate:(id<PBQuestListOfPlayer_ResponseHandler>)delegate
{
    return [self questListOfPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questListOfPlayerAsync:(NSString *)playerId withBlock:(PBQuestListOfPlayer_ResponseBlock)block
{
    return [self questListOfPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questListOfPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/quest%@&player_id=%@", apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questListOfPlayer andResponse:response];
}

-(PBRequest *)badge:(NSString *)badgeId withDelegate:(id<PBBadge_ResponseHandler>)delegate
{
    return [self badgeInternalBase:badgeId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)badge:(NSString *)badgeId withBlock:(PBBadge_ResponseBlock)block
{
    return [self badgeInternalBase:badgeId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)badgeAsync:(NSString *)badgeId withDelegate:(id<PBBadge_ResponseHandler>)delegate
{
    return [self badgeInternalBase:badgeId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)badgeAsync:(NSString *)badgeId withBlock:(PBBadge_ResponseBlock)block
{
    return [self badgeInternalBase:badgeId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)badgeInternalBase:(NSString *)badgeId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Badge/%@%@", badgeId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_badge andResponse:response];
}

-(PBRequest *)badgesWithDelegate:(id<PBBadges_ResponseHandler>)delegate
{
    return [self badgesInternalBase:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)badgesWithBlock:(PBBadges_ResponseBlock)block
{
    return [self badgesInternalBase:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)badgesAsyncWithDelegate:(id<PBBadges_ResponseHandler>)delegate
{
    return [self badgesInternalBase:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)badgesAsyncWithBlock:(PBBadges_ResponseBlock)block
{
    return [self badgesInternalBase:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)badgesInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Badges%@", apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_badges andResponse:response];
}

-(PBRequest *)goods:(NSString *)goodId withDelegate:(id<PBGoodsInfo_ResponseHandler>)delegate
{
    return [self goodsInternalBase:goodId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)goods:(NSString *)goodId withBlock:(PBGoodsInfo_ResponseBlock)block
{
    return [self goodsInternalBase:goodId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)goodsAsync:(NSString *)goodId withDelegate:(id<PBGoodsInfo_ResponseHandler>)delegate
{
    return [self goodsInternalBase:goodId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)goodsAsync:(NSString *)goodId withBlock:(PBGoodsInfo_ResponseBlock)block
{
    return [self goodsInternalBase:goodId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)goodsInternalBase:(NSString *)goodId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Goods/%@%@", goodId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_goodsInfo andResponse:response];
}

-(PBRequest *)goodsListWithDelegate:(id<PBGoodsListInfo_ResponseHandler>)delegate
{
    return [self goodsListInternalBase:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)goodsListWithBlock:(PBGoodsListInfo_ResponseBlock)block
{
    return [self goodsListInternalBase:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)goodsListAsyncWithDelegate:(id<PBGoodsListInfo_ResponseHandler>)delegate
{
    return [self goodsListInternalBase:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)goodsListAsyncWithBlock:(PBGoodsListInfo_ResponseBlock)block
{
    return [self goodsListInternalBase:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)goodsListInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Goods%@", apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_goodsListInfo andResponse:response];
}

-(PBRequest *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate
{
    return [self goodsGroupAvailableInternalBase:playerId group:group amount:amount blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block
{
    return [self goodsGroupAvailableInternalBase:playerId group:group amount:amount blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)goodsGroupAvailableAsyncForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate
{
    return [self goodsGroupAvailableInternalBase:playerId group:group amount:amount blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)goodsGroupAvailableAsyncForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block
{
    return [self goodsGroupAvailableInternalBase:playerId group:group amount:amount blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)goodsGroupAvailableAsyncForPlayer_:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block
{
    return [self goodsGroupAvailableInternalBase:playerId group:group amount:amount blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)goodsGroupAvailableInternalBase:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Redeem/goodsGroup%@&player_id=%@&group=%@&amount=%u", apiKeyParam, playerId, group, amount];
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_goodsGroupAvailable andResponse:response];
}

-(PBRequest *)actionConfigWithDelegate:(id<PBActionConfig_ResponseHandler>)delegate
{
    return [self actionConfigInternalBase:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)actionConfigWithBlock:(PBActionConfig_ResponseBlock)block
{
    return [self actionConfigInternalBase:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)actionConfigAsyncWithDelegate:(id<PBActionConfig_ResponseHandler>)delegate
{
    return [self actionConfigInternalBase:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)actionConfigAsyncWithBlock:(PBActionConfig_ResponseBlock)block
{
    return [self actionConfigInternalBase:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)actionConfigAsyncWithBlock_:(PBAsyncURLRequestResponseBlock)block
{
    return [self actionConfigInternalBase:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)actionConfigInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Engine/actionConfig%@", apiKeyParam];
    
    NSString *data = nil;
    
    if(syncUrl)
    {
        // create data param string
        // no data for sync url request
    }
    else
    {
        // create json data object
        NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
        
        // package into format
        NSMutableDictionary *dictWholeData = [NSMutableDictionary dictionary];
        [dictWholeData setObject:method forKey:@"endpoint"];
        [dictWholeData setObject:dictData forKey:@"data"];
        [dictWholeData setObject:@"nil" forKey:@"channel"];
        
        // get json string
        data = [dictWholeData JSONString];
        NSLog(@"jsonString = %@", data);
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_actionConfig andResponse:response];
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
-(PBRequest *)ruleAsync_:(NSString *)playerId forAction:(NSString *)action withBlock:(PBAsyncURLRequestResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    
    return [self ruleInternal:playerId forAction:action blockingCall:NO syncUrl:NO withBlock:block withParams:argumentList];
    
    va_end(argumentList);
}

-(PBRequest *)ruleInternal:(NSString *)playerId forAction:(NSString *)action blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl withDelegate:(id<PBResponseHandler>)delegate withParams:(va_list)params
{
    NSAssert(token, @"access token is nil");
    
    NSString *method = [NSString stringWithFormat:@"Engine/rule%@", apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@&player_id=%@&action=%@", token, playerId, action];
    
    if(params != nil)
    {
        id optionalData;
        while ((optionalData = va_arg(params, NSString *)))
        {
            [data appendFormat:@"&%@", optionalData];
        }
    }
    
    if(syncUrl)
    {
        // call to a proper type of call
        if(blockingCall)
            return [self call:method withData:data syncURLRequest:syncUrl andDelegate:delegate];
        else
            return [self callAsync:method withData:data syncURLRequest:syncUrl andDelegate:delegate];
    }
    else
    {
        // create json data object
        // we will set object for each field in the loop
        NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
        
        // split all params from data
        NSArray *linesWithEqualSign = [data componentsSeparatedByString:@"&"];
        for(NSString *lineWithEqualSign in linesWithEqualSign)
        {
            NSArray *fieldAndValue = [lineWithEqualSign componentsSeparatedByString:@"="];
            
            // set into dict
            [dictData setValue:(NSString*)[fieldAndValue objectAtIndex:1] forKey:[fieldAndValue objectAtIndex:0]];
        }
        
        // package into format
        NSMutableDictionary *dictWholeData = [NSMutableDictionary dictionary];
        [dictWholeData setObject:method forKey:@"endpoint"];
        [dictWholeData setObject:dictData forKey:@"data"];
        [dictWholeData setObject:@"nil" forKey:@"channel"];
        
        // get json string
        NSString *dataFinal = [dictWholeData JSONString];
        NSLog(@"jsonString = %@", dataFinal);
        
        return [self callAsync:method withData:dataFinal syncURLRequest:NO andDelegate:delegate];
    }
}

-(PBRequest *)ruleInternal:(NSString *)playerId forAction:(NSString *)action blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl withBlock:(id)block withParams:(va_list)params
{
    NSAssert(token, @"access token is nil");
    
    NSString *method = [NSString stringWithFormat:@"Engine/rule%@", apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@&player_id=%@&action=%@", token, playerId, action];
    
    if(params != nil)
    {
        id optionalData;
        while ((optionalData = va_arg(params, NSString *)))
        {
            [data appendFormat:@"&%@", optionalData];
        }
    }
    
    if(syncUrl)
    {
        // call to a proper type of call
        if(blockingCall)
            return [self call:method withData:data syncURLRequest:syncUrl andBlock:block];
        else
            return [self callAsync:method withData:data syncURLRequest:syncUrl andBlock:block];
    }
    else
    {
        // form async url request data
        NSString *dataFinal = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
        
        return [self callAsync:method withData:dataFinal syncURLRequest:NO andBlock:block];
    }
}

-(PBRequest *)questListWithDelegate:(id<PBQuestList_ResponseHandler>)delegate
{
    return [self questListInternalBase:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questListWithBlock:(PBQuestList_ResponseBlock)block
{
    return [self questListInternalBase:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questListWithDelegateAsync:(id<PBQuestList_ResponseHandler>)delegate
{
    return [self questListInternalBase:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questListWithBlockAsync:(PBQuestList_ResponseBlock)block
{
    return [self questListInternalBase:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questListInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quest%@", apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questList andResponse:response];
}

-(PBRequest *)questWithQuestId:(NSString *)questId withDelegate:(id<PBQuestInfo_ResponseHandler>)delegate
{
    return [self questWithQuestIdInternalBase:questId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questWithQuestId:(NSString *)questId withBlock:(PBQuestInfo_ResponseBlock)block
{
    return [self questWithQuestIdInternalBase:questId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questWithQuestIdAsync:(NSString *)questId withDelegate:(id<PBQuestInfo_ResponseHandler>)delegate
{
    return [self questWithQuestIdInternalBase:questId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questWithQuestIdAsync:(NSString *)questId withBlock:(PBQuestInfo_ResponseBlock)block
{
    return [self questWithQuestIdInternalBase:questId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questWithQuestIdInternalBase:(NSString *)questId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@%@", questId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questInfo andResponse:response];
}

-(PBRequest *)mission:(NSString *)questId mission:(NSString *)missionId withDelegate:(id<PBMissionInfo_ResponseHandler>)delegate
{
    return [self missionInternalBase:questId mission:missionId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)mission:(NSString *)questId mission:(NSString *)missionId withBlock:(PBMissionInfo_ResponseBlock)block
{
    return [self missionInternalBase:questId mission:missionId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)missionAsync:(NSString *)questId mission:(NSString *)missionId withDelegate:(id<PBMissionInfo_ResponseHandler>)delegate
{
    return [self missionInternalBase:questId mission:missionId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)missionAsync:(NSString *)questId mission:(NSString *)missionId withBlock:(PBMissionInfo_ResponseBlock)block
{
    return [self missionInternalBase:questId mission:missionId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)missionInternalBase:(NSString *)questId mission:(NSString *)missionId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@/mission/%@%@", questId, missionId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_missionInfo andResponse:response];
}

-(PBRequest *)questListAvailableForPlayer:(NSString *)playerId withDelegate:(id<PBQuestListAvailableForPlayer_ResponseHandler>)delegate
{
    return [self questListAvailableForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questListAvailableForPlayer:(NSString *)playerId withBlock:(PBQuestListAvailableForPlayer_ResponseBlock)block
{
    return [self questListAvailableForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questListAvailableForPlayerAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self questListAvailableForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questListAvailableForPlayerAsync:(NSString *)playerId withBlock:(PBQuestListAvailableForPlayer_ResponseBlock)block
{
    return [self questListAvailableForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questListAvailableForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quest/available%@&player_id=%@", apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questListAvailableForPlayer andResponse:response];
}

-(PBRequest *)questAvailable:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestAvailableForPlayer_ResponseHandler>)delegate
{
    return [self questAvailableInternalBase:questId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questAvailable:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBQuestAvailableForPlayer_ResponseBlock)block
{
    return [self questAvailableInternalBase:questId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questAvailableAsync:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestAvailableForPlayer_ResponseHandler>)delegate
{
    return [self questAvailableInternalBase:questId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)questAvailableAsync:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBQuestAvailableForPlayer_ResponseBlock)block
{
    return [self questAvailableInternalBase:questId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)questAvailableInternalBase:(NSString *)questId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@/available%@&player_id=%@", questId, apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questAvailableForPlayer andResponse:response];
}

-(PBRequest *)joinQuest:(NSString *)questId player:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self joinQuestInternalBase:questId player:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)joinQuest:(NSString *)questId player:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self joinQuestInternalBase:questId player:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)joinQuestAsync:(NSString *)questId player:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self joinQuestInternalBase:questId player:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)joinQuestAsync:(NSString *)questId player:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self joinQuestInternalBase:questId player:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)joinQuestAsync_:(NSString *)questId player:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self joinQuestInternalBase:questId player:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)joinQuestInternalBase:(NSString *)questId player:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quest/%@/join%@", questId, apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@", token, playerId];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)joinAllQuestsForPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self joinAllQuestsForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)joinAllQuestsForPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self joinAllQuestsForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)joinAllQuestsForPlayerAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self joinAllQuestsForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)joinAllQuestsForPlayerAsync:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self joinAllQuestsForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)joinAllQuestsForPlayerAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self joinAllQuestsForPlayerInternalBase:playerId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)joinAllQuestsForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quest/joinAll%@", apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@", token, playerId];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)cancelQuest:(NSString *)questId player:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self cancelQuestInternalBase:questId player:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)cancelQuest:(NSString *)questId player:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self cancelQuestInternalBase:questId player:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)cancelQuestAsync:(NSString *)questId player:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self cancelQuestInternalBase:questId player:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)cancelQuestAsync:(NSString *)questId player:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self cancelQuestInternalBase:questId player:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)cancelQuestAsync_:(NSString *)questId player:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self cancelQuestInternalBase:questId player:playerId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)cancelQuestInternalBase:(NSString *)questId player:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quest/%@/cancel%@", questId, apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id%@", token, playerId];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)redeemGoods:(NSString *)goodsId player:(NSString *)playerId amount:(unsigned int)amount withDelegate:(id<PBResponseHandler>)delegate
{
    return [self redeemGoodsInternalBase:goodsId player:playerId amount:amount blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)redeemGoods:(NSString *)goodsId player:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBResponseBlock)block
{
    return [self redeemGoodsInternalBase:goodsId player:playerId amount:amount blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)redeemGoodsAsync:(NSString *)goodsId player:(NSString *)playerId amount:(unsigned int)amount withDelegate:(id<PBResponseHandler>)delegate
{
    return [self redeemGoodsInternalBase:goodsId player:playerId amount:amount blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)redeemGoodsAsync:(NSString *)goodsId player:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBResponseBlock)block
{
    return [self redeemGoodsInternalBase:goodsId player:playerId amount:amount blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)redeemGoodsAsync_:(NSString *)goodsId player:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBResponseBlock)block
{
    return [self redeemGoodsInternalBase:goodsId player:playerId amount:amount blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)redeemGoodsInternalBase:(NSString *)goodsId player:(NSString *)playerId amount:(unsigned int)amount blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    if(amount < 1){
        amount = 1;
    }
    NSString *method = [NSString stringWithFormat:@"Redeem/goods%@", apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&goods_id=%@&player_id=%@&amount=%u", token, goodsId, playerId, amount];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)recentPoint:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate
{
    return [self recentPointInternalBase:offset limit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)recentPoint:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block
{
    return [self recentPointInternalBase:offset limit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)recentPointAsync:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate
{
    return [self recentPointInternalBase:offset limit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)recentPointAsync:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block
{
    return [self recentPointInternalBase:offset limit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)recentPointInternalBase:(unsigned int)offset limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Service/recent_point%@&offset=%u&limit=%u", apiKeyParam, offset, limit];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_recentPoint andResponse:response];
}

- (PBRequest *)recentPointByName:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBResponseHandler>)delegate
{
    return [self recentPointByNameInternalBase:pointName offset:offset limit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)recentPointByName:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBResponseBlock)block
{
    return [self recentPointByNameInternalBase:pointName offset:offset limit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)recentPointByNameAsync:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBResponseHandler>)delegate
{
    return [self recentPointByNameInternalBase:pointName offset:offset limit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)recentPointByNameAsync:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBResponseBlock)block
{
    return [self recentPointByNameInternalBase:pointName offset:offset limit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)recentPointByNameInternalBase:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Service/recent_point%@&offset=%u&limit=%u&point_name=%@", apiKeyParam, offset, limit, pointName];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil andResponse:response];
}

-(PBRequest *)resetPointForAllPlayersForPoint:(NSString *)pointName withDelegate:(id<PBResponseHandler>)delegate
{
    return [self resetPointForAllPlayersForPointInternalBase:pointName blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)resetPointForAllPlayersForPoint:(NSString *)pointName withBlock:(PBResponseBlock)block
{
    return [self resetPointForAllPlayersForPointInternalBase:pointName blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)resetPointForAllPlayersForPointAsync:(NSString *)pointName withDelegate:(id<PBResponseHandler>)delegate
{
    return [self resetPointForAllPlayersForPointInternalBase:pointName blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)resetPointForAllPlayersForPointAsync:(NSString *)pointName withBlock:(PBResponseBlock)block
{
    return [self resetPointForAllPlayersForPointInternalBase:pointName blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)resetPointForAllPlayersForPointAsync_:(NSString *)pointName withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self resetPointForAllPlayersForPointInternalBase:pointName blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)resetPointForAllPlayersForPointInternalBase:(NSString *)pointName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Service/reset_point%@",apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&point_name=%@", token, pointName];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)sendEmail:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self sendEmailInternalBase:playerId subject:subject message:message blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)sendEmail:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self sendEmailInternalBase:playerId subject:subject message:message blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)sendEmailAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self sendEmailInternalBase:playerId subject:subject message:message blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)sendEmailAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self sendEmailInternalBase:playerId subject:subject message:message blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)sendEmailAsync_:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self sendEmailInternalBase:playerId subject:subject message:message blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)sendEmailInternalBase:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Email/send%@",apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&subject=%@&message=%@", token, playerId, subject, message];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)sendEmail:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self sendEmailInternalBase:playerId subject:subject message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)sendEmail:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self sendEmailInternalBase:playerId subject:subject message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)sendEmailAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self sendEmailInternalBase:playerId subject:subject message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)sendEmailAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self sendEmailInternalBase:playerId subject:subject message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)sendEmailAsync_:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self sendEmailInternalBase:playerId subject:subject message:message template:templateId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)sendEmailInternalBase:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Email/send%@", apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&subject=%@&message=%@&template_id=%@", token, playerId, subject, message, templateId];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)sendEmailCoupon:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self sendEmailCouponInternalBase:playerId ref:refId subject:subject message:message blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)sendEmailCoupon:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self sendEmailCouponInternalBase:playerId ref:refId subject:subject message:message blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)sendEmailCouponAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self sendEmailCouponInternalBase:playerId ref:refId subject:subject message:message blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)sendEmailCouponAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self sendEmailCouponInternalBase:playerId ref:refId subject:subject message:message blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)sendEmailCouponAsync_:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self sendEmailCouponInternalBase:playerId ref:refId subject:subject message:message blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)sendEmailCouponInternalBase:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Email/goods%@", apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&ref_id=%@&message=%@", token, playerId, refId, message];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)sendEmailCoupon:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self sendEmailCouponInternalBase:playerId ref:refId subject:subject message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)sendEmailCoupon:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self sendEmailCouponInternalBase:playerId ref:refId subject:subject message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)sendEmailCouponAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self sendEmailCouponInternalBase:playerId ref:refId subject:subject message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)sendEmailCouponAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self sendEmailCouponInternalBase:playerId ref:refId subject:subject message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)sendEmailCouponAsync_:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self sendEmailCouponInternalBase:playerId ref:refId subject:subject message:message template:templateId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)sendEmailCouponInternalBase:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Email/goods%@",apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&ref_id=%@&message=%@&template_id=%@", token, playerId, refId, message, templateId];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)quizList:(NSString *)playerId withDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate
{
    return [self quizListInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizList:(NSString *)playerId withBlock:(PBActiveQuizList_ResponseBlock)block
{
    return [self quizListInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizListAsync:(NSString *)playerId withDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate
{
    return [self quizListInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizListAsync:(NSString *)playerId withBlock:(PBActiveQuizList_ResponseBlock)block
{
    return [self quizListInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizListInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/list%@&player_id=%@", apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_activeQuizList andResponse:response];
}

-(PBRequest *)quizDetail:(NSString *)quizId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate
{
    return [self quizDetailInternalBase:quizId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizDetail:(NSString *)quizId withBlock:(PBQuizDetail_ResponseBlock)block
{
    return [self quizDetailInternalBase:quizId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizDetailAsync:(NSString *)quizId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate
{
    return [self quizDetailInternalBase:quizId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizDetailAsync:(NSString *)quizId withBlock:(PBQuizDetail_ResponseBlock)block
{
    return [self quizDetailInternalBase:quizId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizDetailInternalBase:(NSString *)quizId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/detail%@", quizId, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_quizDetail andResponse:response];
}

-(PBRequest *)quizDetail:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate
{
    return [self quizDetailInternalBase:quizId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizDetail:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuizDetail_ResponseBlock)block
{
    return [self quizDetailInternalBase:quizId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizDetailAsync:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate
{
    return [self quizDetailInternalBase:quizId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizDetailAsync:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuizDetail_ResponseBlock)block
{
    return [self quizDetailInternalBase:quizId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizDetailInternalBase:(NSString *)quizId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/detail%@&player_id=%@", quizId, apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_quizDetail andResponse:response];
}

-(PBRequest *)quizRandom:(NSString *)playerId withDelegate:(id<PBQuizRandom_ResponseHandler>)delegate
{
    return [self quizRandomInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizRandom:(NSString *)playerId withBlock:(PBQuizRandom_ResponseBlock)block
{
    return [self quizRandomInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizRandomAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self quizRandomInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizRandomAsync:(NSString *)playerId withBlock:(PBQuizRandom_ResponseBlock)block
{
    return [self quizRandomInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizRandomInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/random%@&player_id=%@", apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_quizRandom andResponse:response];
}

-(PBRequest *)quizDone:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizDoneList_ResponseHandler>)delegate
{
    return [self quizDoneInternalBase:playerId limit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizDone:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizDoneList_ResponseBlock)block
{
    return [self quizDoneInternalBase:playerId limit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizDoneAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizDoneList_ResponseHandler>)delegate
{
    return [self quizDoneInternalBase:playerId limit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizDoneAsync:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizDoneList_ResponseBlock)block
{
    return [self quizDoneInternalBase:playerId limit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizDoneInternalBase:(NSString *)playerId limit:(NSInteger)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/player/%@/%ld%@", playerId, (long)limit, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_quizDoneListByPlayer andResponse:response];
}

-(PBRequest *)quizPending:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate
{
    return [self quizPendingInternalBase:playerId limit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizPending:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBResponseBlock)block
{
    return [self quizPendingInternalBase:playerId limit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizPendingAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate
{
    return [self quizPendingInternalBase:playerId limit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizPendingAsync:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBResponseBlock)block
{
    return [self quizPendingInternalBase:playerId limit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizPendingInternalBase:(NSString *)playerId limit:(NSInteger)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/player/%@/pending/%ld%@", playerId, (long)limit, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil andResponse:response];
}

-(PBRequest *)quizQuestion:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestion_ResponseHandler>)delegate
{
    return [self quizQuestionInternalBase:quizId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizQuestion:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuestion_ResponseBlock)block
{
    return [self quizQuestionInternalBase:quizId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizQuestionAsync:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestion_ResponseHandler>)delegate
{
    return [self quizQuestionInternalBase:quizId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizQuestionAsync:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuestion_ResponseBlock)block
{
    return [self quizQuestionInternalBase:quizId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizQuestionInternalBase:(NSString *)quizId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/question%@&player_id=%@", quizId, apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questionFromQuiz andResponse:response];
}

-(PBRequest *)quizAnswer:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withDelegate:(id<PBQuestionAnswered_ResponseHandler>)delegate
{
    return [self quizAnswerInternalBase:quizId optionId:optionId forPlayer:playerId ofQuestionId:questionId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizAnswer:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBQuestionAnswered_ResponseBlock)block
{
    return [self quizAnswerInternalBase:quizId optionId:optionId forPlayer:playerId ofQuestionId:questionId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizAnswerAsync:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withDelegate:(id<PBQuestionAnswered_ResponseHandler>)delegate
{
    return [self quizAnswerInternalBase:quizId optionId:optionId forPlayer:playerId ofQuestionId:questionId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizAnswerAsync:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBQuestionAnswered_ResponseBlock)block
{
    return [self quizAnswerInternalBase:quizId optionId:optionId forPlayer:playerId ofQuestionId:questionId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizAnswerAsync_:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBQuestionAnswered_ResponseBlock)block
{
    return [self quizAnswerInternalBase:quizId optionId:optionId forPlayer:playerId ofQuestionId:questionId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)quizAnswerInternalBase:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/answer%@", quizId, apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&question_id=%@&option_id=%@", token, playerId, questionId, optionId];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_questionAnswered andResponse:response];
}

-(PBRequest *)quizScoreRank:(NSString *)quizId limit:(NSInteger)limit withDelegate:(id<PBPlayersQuizRank_ResponseHandler>)delegate
{
    return [self quizScoreRankInternalBase:quizId limit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizScoreRank:(NSString *)quizId limit:(NSInteger)limit withBlock:(PBPlayersQuizRank_ResponseBlock)block
{
    return [self quizScoreRankInternalBase:quizId limit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizScoreRankAsync:(NSString *)quizId limit:(NSInteger)limit withDelegate:(id<PBPlayersQuizRank_ResponseHandler>)delegate
{
    return [self quizScoreRankInternalBase:quizId limit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)quizScoreRankAsync:(NSString *)quizId limit:(NSInteger)limit withBlock:(PBPlayersQuizRank_ResponseBlock)block
{
    return [self quizScoreRankInternalBase:quizId limit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)quizScoreRankInternalBase:(NSString *)quizId limit:(NSInteger)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/rank/%ld%@", quizId, (long)limit, apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_playersQuizRank andResponse:response];
}

-(PBRequest *)sms:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self smsInternalBase:playerId message:message blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)sms:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self smsInternalBase:playerId message:message blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)smsAsync:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self smsInternalBase:playerId message:message blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)smsAsync:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self smsInternalBase:playerId message:message blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)smsAsync_:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self smsInternalBase:playerId message:message blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)smsInternalBase:(NSString *)playerId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token , @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Sms/send%@", apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@", token, playerId, message];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)sms:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self smsInternalBase:playerId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)sms:(NSString *)playerId message:(NSString *)message tempalte:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self smsInternalBase:playerId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)smsAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self smsInternalBase:playerId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)smsAsync:(NSString *)playerId message:(NSString *)message tempalte:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self smsInternalBase:playerId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)smsInternalBase:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token , @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Sms/send%@", apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@&template_id=%@", token, playerId, message, templateId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)smsCoupon:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self smsCouponInternalBase:playerId ref:refId message:message blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)smsCoupon:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self smsCouponInternalBase:playerId ref:refId message:message blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)smsCouponAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self smsCouponInternalBase:playerId ref:refId message:message blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)smsCouponAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self smsCouponInternalBase:playerId ref:refId message:message blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)smsCouponAsync_:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self smsCouponInternalBase:playerId ref:refId message:message blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequest *)smsCouponInternalBase:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Sms/goods%@", apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&ref_id=%@&message=%@", token, playerId, refId, message];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)smsCoupon:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self smsCouponInternalBase:playerId ref:refId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)smsCoupon:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self smsCouponInternalBase:playerId ref:refId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)smsCouponAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self smsCouponInternalBase:playerId ref:refId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)smsCouponAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self smsCouponInternalBase:playerId ref:refId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)smsCouponInternalBase:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Sms/goods%@", apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&ref_id=%@&message=%@&template_id=%@", token, playerId, refId, message, templateId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)push:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pushInternalBase:playerId message:message blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)push:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self pushInternalBase:playerId message:message blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)pushAsync:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pushInternalBase:playerId message:message blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)pushAsync:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self pushInternalBase:playerId message:message blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)pushInternalBase:(NSString *)playerId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    
    // check if device token is there and set before making a request
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    if(deviceToken == nil)
    {
        NSLog(@"No device token acquired just yet.");
        return nil;
    }
    
    NSString *method = [NSString stringWithFormat:@"Push/notification%@",apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@", token, playerId, message];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)push:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pushInternalBase:playerId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)push:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self pushInternalBase:playerId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)pushAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pushInternalBase:playerId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequest *)pushAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self pushInternalBase:playerId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequest *)pushInternalBase:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(token, @"access token is nil");
    
    // check if device token is there and set before making a request
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    if(deviceToken == nil)
    {
        NSLog(@"No device token acquired just yet.");
        return nil;
    }
    
    NSString *method = [NSString stringWithFormat:@"Push/notification%@", apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@&template_id=%@", token, playerId, message, templateId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequest *)registerForPushNotification:(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
    
    // get device token from what we save in NSUserDefaults
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    NSAssert(deviceToken, @"device token is nil");
    
    NSString *method = [NSString stringWithFormat:@"Push/registerdevice%@", apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&device_token=%@", token, deviceToken];
    return [self call:method withData:data syncURLRequest:YES andDelegate:delegate];
}

-(void)track:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController *)view withBlock:(PBAsyncURLRequestResponseBlock)block
{
    // it's always async url request, thus non-blocking call
    [self trackInternalBase:playerId forAction:action fromView:view useDelegate:NO withResponse:block];
}
-(void)trackInternalBase:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController *)view useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    // begin entire sequence in async way
    // as track is in async way
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // the sequence should be in sequencial thus we use blocking call
        
        // check if user exists in the system or not
        [self player:playerId withBlock:^(PBPlayer_Response *player, NSURL *url, NSError *error) {
            // user doesn't exist
            if(player == nil && error != nil && error.code == 200)
            {
                NSLog(@"Player doesn't exist");
                
                // show registration form
                if(view != nil)
                {
                    [self showRegistrationFormFromView:view intendedPlayerId:playerId withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
                        if(!error)
                        {
                            NSLog(@"Register successfully, then do rule().");
                            // register successfully, then do the work
                            // now it's time to track
                            // response back to the root response
                            [self ruleAsync_:playerId forAction:action withBlock:response, nil];
                        }
                        else
                        {
                            NSLog(@"Register failed, then send error back to response.");

                            PBAsyncURLRequestResponseBlock sb = (PBAsyncURLRequestResponseBlock)response;
                            sb([PBResultStatus_Response resultStatusWithFailure], nil, error);
                        }
                    }];
                }
                // otherwise, response back with error
                else
                {
                    NSLog(@"No view set, then send back with error to reponse.");
                    // if there's no view input, then directly send back response with error
                    PBAsyncURLRequestResponseBlock sb = (PBAsyncURLRequestResponseBlock)response;
                    sb([PBResultStatus_Response resultStatusWithFailure], url, error);
                }
            }
            // player exists
            else if(player != nil && error == nil)
            {
                NSLog(@"Player exists as following info: %@", player);
                
                // now it's time to track
                // response back to the root response
                [self ruleAsync_:playerId forAction:action withBlock:response, nil];
            }
            // error
            else
            {
                NSLog(@"Error occurs: %@", error);
                
                // direct response back
                if(response != nil)
                {
                    PBAsyncURLRequestResponseBlock sb = (PBAsyncURLRequestResponseBlock)response;
                    sb([PBResultStatus_Response resultStatusWithFailure], url, error);
                }
            }
        }];
    });
}

-(void)do:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withDelegate:(id<PBResponseHandler>)delegate
{
    [self doInternalBase:playerId forAction:action fromView:view blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(void)do:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withBlock:(PBResponseBlock)block
{
    [self doInternalBase:playerId forAction:action fromView:view blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(void)doAsync:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withDelegate:(id<PBResponseHandler>)delegate
{
    [self doInternalBase:playerId forAction:action fromView:view blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(void)doAsync:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withBlock:(PBResponseBlock)block
{
    [self doInternalBase:playerId forAction:action fromView:view blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(void)doInternalBase:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    // check if user exists in the system or not
    [self playerInternalBase:playerId blockingCall:blockingCall syncUrl:YES useDelegate:NO withResponse:^(PBPlayer_Response *player, NSURL *url, NSError *error) {
        // user doesn't exist
        if(player == nil && error != nil && error.code == 200)
        {
            NSLog(@"Player doesn't exist");
            
            // show registration form
            if(view != nil)
            {
                [self showRegistrationFormFromView:view intendedPlayerId:playerId withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
                    if(!error)
                    {
                        NSLog(@"Register successfully, then do rule().");
                        // register successfully, then do the work
                        // now it's time to track
                        // response back to the root response
                        if(useDelegate)
                        {
                            if(response)
                            {
                                [self ruleInternal:playerId forAction:action blockingCall:blockingCall syncUrl:YES withDelegate:response withParams:nil];
                            }
                        }
                        else
                        {
                            if(response)
                            {
                                [self ruleInternal:playerId forAction:action blockingCall:blockingCall syncUrl:YES withBlock:response withParams:nil];
                            }
                        }
                    }
                    else
                    {
                        NSLog(@"Register failed, then send error back to response.");

                        if(useDelegate)
                        {
                            if([response respondsToSelector:@selector(processResponse:withURL:error:)])
                            {
                                [response processResponse:nil withURL:url error:error];
                            }
                        }
                        else
                        {
                            if(response)
                            {
                                PBResponseBlock sb = (PBResponseBlock)response;
                                sb(nil, url, error);
                            }
                        }
                    }
                }];
            }
            // otherwise, response back with error
            else
            {
                NSLog(@"No view set, then send back with error to reponse.");
                // if there's no view input, then directly send back response with error
                if(useDelegate)
                {
                    if([response respondsToSelector:@selector(processResponse:withURL:error:)])
                    {
                        [response processResponse:nil withURL:url error:error];
                    }
                }
                else
                {
                    if(response)
                    {
                        PBResponseBlock sb = (PBResponseBlock)response;
                        sb(nil, url, error);
                    }
                }
            }
        }
        // player exists
        else if(player != nil && error == nil)
        {
            NSLog(@"Player exists as following info: %@", player);
            
            // now it's time to track
            // response back to the root response
            if(useDelegate)
            {
                if(response)
                {
                    [self ruleInternal:playerId forAction:action blockingCall:blockingCall syncUrl:YES withDelegate:response withParams:nil];
                }
            }
            else
            {
                if(response)
                {
                    [self ruleInternal:playerId forAction:action blockingCall:blockingCall syncUrl:YES withBlock:response withParams:nil];
                }
            }
        }
        // error
        else
        {
            NSLog(@"Error occurs: %@", error);
            
            // direct response back
            if(useDelegate)
            {
                if([response respondsToSelector:@selector(processResponse:withURL:error:)])
                {
                    [response processResponse:nil withURL:url error:error];
                }
            }
            else
            {
                if(response)
                {
                    PBResponseBlock sb = (PBResponseBlock)response;
                    sb(nil, url, error);
                }
            }
        }
    }];

}

-(PBRequest *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andDelegate:(id<PBResponseHandler>)delegate
{
    return [self callInternalBase:method withData:data blockingCall:YES syncURLRequest:syncURLRequest useDelegate:YES withResponse:delegate];
}

-(PBRequest *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest responseType:(pbResponseType)responseType andDelegate:(id<PBResponseHandler>)delegate
{
    return [self callInternalBase:method withData:data blockingCall:YES syncURLRequest:syncURLRequest useDelegate:YES responseType:responseType withResponse:delegate];
}

-(PBRequest *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andBlock:(PBResponseBlock)block
{
    return [self callInternalBase:method withData:data blockingCall:YES syncURLRequest:syncURLRequest useDelegate:NO withResponse:block];
}

-(PBRequest *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest responseType:(pbResponseType)responseType andBlock:(PBResponseBlock)block
{
    return [self callInternalBase:method withData:data blockingCall:YES syncURLRequest:syncURLRequest useDelegate:NO responseType:responseType withResponse:block];
}

-(PBRequest *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andDelegate:(id<PBResponseHandler>)delegate
{
    return [self callInternalBase:method withData:data blockingCall:NO syncURLRequest:syncURLRequest useDelegate:YES withResponse:delegate];
}

-(PBRequest *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest responseType:(pbResponseType)responseType andDelegate:(id<PBResponseHandler>)delegate
{
    return [self callInternalBase:method withData:data blockingCall:NO syncURLRequest:syncURLRequest useDelegate:YES responseType:responseType withResponse:delegate];
}

-(PBRequest *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andBlock:(PBResponseBlock)block
{
    return [self callInternalBase:method withData:data blockingCall:NO syncURLRequest:syncURLRequest useDelegate:NO withResponse:block];
}

-(PBRequest *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest responseType:(pbResponseType)responseType andBlock:(PBResponseBlock)block
{
    return [self callInternalBase:method withData:data blockingCall:NO syncURLRequest:syncURLRequest useDelegate:NO responseType:responseType withResponse:block];
}


-(PBRequest *)callInternalBase:(NSString *)method withData:(NSString *)data blockingCall:(BOOL)blockingCall syncURLRequest:(BOOL)syncURLRequest useDelegate:(BOOL)useDelegate responseType:(pbResponseType)responseType withResponse:(id)response
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
        pbRequest = [[PBRequest alloc] initWithURLRequest:request blockingCall:blockingCall syncUrl:syncURLRequest responseType:responseType andDelegate:response];
    }
    // create PBRequest with block callback
    else
    {
        pbRequest = [[PBRequest alloc] initWithURLRequest:request blockingCall:blockingCall syncUrl:syncURLRequest responseType:responseType andBlock:response];
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
        
        NSLog(@"Queue size = %lu", (unsigned long)[requestOptQueue count]);
    }
    
#if __has_feature(objc_arc)
    return pbRequest;
#else
    return [pbRequest autorelease];
#endif
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
        pbRequest = [[PBRequest alloc] initWithURLRequest:request blockingCall:blockingCall syncUrl:syncURLRequest responseType:responseType_normal andDelegate:response];
    }
    // create PBRequest with block callback
    else
    {
        pbRequest = [[PBRequest alloc] initWithURLRequest:request blockingCall:blockingCall syncUrl:syncURLRequest responseType:responseType_normal andBlock:response];
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
        
        NSLog(@"Queue size = %lu", (unsigned long)[requestOptQueue count]);
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
    
    // create a passing data with dictionary
    NSNumber *data = [NSNumber numberWithInt:networkStatus];
    NSDictionary *passingData = [NSDictionary dictionaryWithObject:data forKey:@"data"];
    
    // notify listeners about this events
    [[NSNotificationCenter defaultCenter] postNotificationName:pbNetworkStatusChangedNotification object:nil userInfo:passingData];
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

//--------------------------------------------------
// UI
//--------------------------------------------------
-(void)showRegistrationFormFromView:(UIViewController *)view withBlock:(PBResponseBlock)block
{
    [self showRegistrationFormFromView:view intendedPlayerId:nil withBlock:block];
}

-(void)showRegistrationFormFromView:(UIViewController *)view intendedPlayerId:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    NSBundle *pbBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle]  URLForResource:@"pblibResource" withExtension:@"bundle"]];
    
    // get playbasis's storyboard
    UIStoryboard *pbStoryboard = [UIStoryboard storyboardWithName:@"PBStoryboard" bundle:pbBundle];
    
    // get regis ui-view-controller
    pbUserRegistrationFormViewController *regisForm = [pbStoryboard instantiateViewControllerWithIdentifier:@"registrationFormViewController"];
    // set response back from registration process
    regisForm.responseBlock = block;
    // set intended player id to register
    regisForm.intendedPlayerId = playerId;
    
    // set some style
    regisForm.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // show form
    dispatch_async(dispatch_get_main_queue(), ^{
        [view presentViewController:regisForm animated:YES completion:nil];
    });
}

@end