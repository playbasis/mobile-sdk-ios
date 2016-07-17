//
//  Playbasis.m
//  Playbasis
//
//  Created by Playbasis.
//  Copyright (c) 2556 Playbasis. All rights reserved.
//

#import "Playbasis.h"

#import "RNDecryptor.h"

#if TARGET_OS_IOS
#import "KLCPopup.h"
#import "MBProgressHUD.h"
#endif

#import "helper/PBValidator.h"
#import "model/OCMapperModelConfigurator.h"

// TODO: Remove this when we completely refactored all the code
@interface _customDeviceInfoHttpHeaderFields : NSObject

@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;
@property (nonatomic, strong) NSString *os;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *deviceBrand;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *sdkVersion;
@property (nonatomic, strong) NSString *appBundle;

@end

@implementation _customDeviceInfoHttpHeaderFields
@end

// shared instance of Playbasis
static Playbasis *sharedInstance = nil;

//
// additional interface for private methods
//
@interface Playbasis ()
{
    NSString *_apiKeyParam;
    NSString *_apiKey;
    BOOL _isNetworkReachable;
    Reachability *_reachability;
    
    /**
     Used internally to keep track of player-id logging in the system.
     
     Playbasis class will set intended player-id, then PBRequestUnit's response section will confirm whether player-id is successfully logged in or not.
     
     User should not use these two variables. They are used internally.
     */
    NSString *_intendedLoginPlayerId;
    BOOL _isIntendedLoginPlayerIdConfirmed;
    
    /**
     Used internally to keep track of player-id logging out the system.
     
     Playbasis class will set intended player-id, then PBRequestUnit's response section will confirm whether player-id is successfully logged out or not.
     
     User should not use these two variables. They are used internally.
     */
    NSString *_intendedLogoutPlayerId;
    BOOL _isIntendedLogoutPlayerIdConfirmed;
    
    /**
     Cached custom HTTP header fields for device information that will be used for all requests made in run-time.
     Use should not use this variable. It's used internally only.
     */
    _customDeviceInfoHttpHeaderFields *_customDeviceInfoHttpHeaderFieldsVar;
}

// overwrite write access within class only
@property (nonatomic, strong, readwrite) NSString* apiKey;
@property (nonatomic, strong, readwrite) NSString* apiSecret;
@property (nonatomic, strong, readwrite) NSString* baseUrl;
@property (nonatomic, strong, readwrite) NSString* baseAsyncUrl;

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

// TODO: Refactor UIApplication's event
-(void)onApplicationDidFinishLaunching:(NSNotification *)notif;
-(void)onApplicationWillResignActive:(NSNotification *)notif;
-(void)onApplicationDidEnterBackground:(NSNotification *)notif;
-(void)onApplicationWillEnterForeground:(NSNotification *)notif;
-(void)onApplicationDidBecomeActive:(NSNotification *)notif;
-(void)onApplicationWillTerminate:(NSNotification *)notif;

/**
 Refactored method to return PBRequestUnit according to the setting input to the method.
 */
-(PBRequestUnit *)refactoredInternalBaseReturnWithBlockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withMethod:(NSString *)method andData:(NSString *)data andResponse:(id)response;

/**
 Refactored method to return PBRequestUnit according to the setting input to the method.
 */
-(PBRequestUnit *)refactoredInternalBaseReturnWithBlockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withMethod:(NSString *)method andData:(NSString *)data responseType:(pbResponseType) responseType andResponse:(id)response;

/**
 Return json-data string used to send via async url request.
 */
-(NSString *)formAsyncUrlRequestJsonDataStringFromData:(NSString *)dataString method:(NSString *)method;

/**
 @abstract Send http request via synchronized blocking call with delegate.
 
 @param syncURLRequest Whether or not to use sync-url request.
 This url is independent from blocking or non-blocking call. A blocking call can still use async url-request. The difference is that async url-request will response back to client immediately, and faster than sync url-request with will piggyback actual payload data upon request.
 */
-(PBRequestUnit *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andDelegate:(id<PBResponseHandler>)delegate;

/**
 @abstract Send http request via synchronized blocking call with block.
 
 @param syncURLRequest Whether or not to use sync-url request.
 This url is independent from blocking or non-blocking call. A blocking call can still use async url-request. The difference is that async url-request will response back to client immediately, and faster than sync url-request with will piggyback actual payload data upon request.
 */
-(PBRequestUnit *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andBlock:(PBResponseBlock)block;

/**
 @abstract Send http request via non-blocking call with delegate.
 
 @param syncURLRequest Whether or not to use sync-url request.
 This url is independent from blocking or non-blocking call. A blocking call can still use async url-request. The difference is that async url-request will response back to client immediately, and faster than sync url-request with will piggyback actual payload data upon request.
 */
-(PBRequestUnit *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andDelegate:(id<PBResponseHandler>)delegate;

/**
 @abstract Send http request via non-blocking call.
 
 @param syncURLRequest Whether or not to use sync-url request with delegate.
 This url is independent from blocking or non-blocking call. A blocking call can still use async url-request. The difference is that async url-request will response back to client immediately, and faster than sync url-request with will piggyback actual payload data upon request.
 */
-(PBRequestUnit *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andBlock:(PBResponseBlock)block;

/**
 Internal working method to send request to process an action through all game's rules defined for client's website.
 */
-(PBRequestUnit *)ruleForPlayerInternalBase:(NSString *)playerId action:(NSString *)action blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response withParams:(va_list)params;

/**
 Generic dismiss method after touching button.
 Use with KLCPopup.
 */
- (void)klcPopup_dismissButtonPressed:(id)sender;

/*
 All internal base methods for API calls are listed here.
 */

// - auth
-(PBRequestUnit *)authWithApiKeyInternalBase:(NSString *)apiKey apiSecret:(NSString *)apiSecret blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - renew
-(PBRequestUnit *)renewWithApiKeyInternalBase:(NSString *)apiKey apiSecret:(NSString *)apiSecret blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - playerPublic
-(PBRequestUnit *)playerPublicInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - player
-(PBRequestUnit *)playerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - playerList
-(PBRequestUnit *)playerListInternalBase:(NSString *)playerListId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - playerDetailPublic
-(PBRequestUnit *)playerDetailPublicInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - playerDetail
-(PBRequestUnit *)playerDetailInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - playerSetCustomFields
-(PBRequestUnit *)playerSetCustomFieldsInternalBase:(NSString *)playerId keys:(NSArray<NSString*>*)keys values:(NSArray<NSString*>*)values blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - playerCustomFields
-(PBRequestUnit *)playerCustomFieldsInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - registerUserWithPlayerId
-(PBRequestUnit *)registerUserWithPlayerIdInternalBase:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response withParams:(va_list)params;

// - updaterUserForPlayerId
-(PBRequestUnit *)updateUserForPlayerIdInternalBase:(NSString *)playerId firstArg:(NSString *)firstArg blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response withParams:(va_list)params;

// - playerAuthForPlayerId
-(PBRequestUnit *)playerAuthForPlayerIdInternalBase:(NSString *)password options:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response withParams:(va_list)params;

// - deleteUser
-(PBRequestUnit *)deleteUserWithPlayerIdInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - login
-(PBRequestUnit *)loginPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - logout
-(PBRequestUnit *)logoutPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - points
-(PBRequestUnit *)pointsOfPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - point
-(PBRequestUnit *)pointOfPlayerInternalBase:(NSString *)playerId forPoint:(NSString *)pointName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - pointHistory (with optional parameter 'point_name')
-(PBRequestUnit *)pointHistoryInternalBase:(NSString *)playerId forPoint:(NSString *)pointName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - pointHistory (with optional parameter 'offset')
-(PBRequestUnit *)pointHistoryInternalBase:(NSString *)playerId offset:(unsigned int)offset blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - pointHistory (with optional parameter 'limit')
-(PBRequestUnit *)pointHistoryInternalBase:(NSString *)playerId withLimit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - pointHistory (with optional parameters 'point_name' and 'offset')
-(PBRequestUnit *)pointHistoryInternalBase:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - pointHistory (with optional parameters 'point_name' and 'limit')
-(PBRequestUnit *)pointHistoryInternalBase:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - pointHistory (with all optional parameters)
-(PBRequestUnit *)pointHistoryInternalBase:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - actionTime
-(PBRequestUnit *)actionTimeForPlayerInternalBase:(NSString *)playerId action:(NSString *)actionName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - actionLastPerformed
-(PBRequestUnit *)actionLastPerformedForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - actionLastPerformedTime
-(PBRequestUnit *)actionLastPerformedTimeForPlayerInternalBase:(NSString *)playerId action:(NSString *)actionName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - actionPerformedCount
-(PBRequestUnit *)actionPerformedCountForPlayerInternalBase:(NSString *)playerId action:(NSString *)actionName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - badgeOwned
-(PBRequestUnit *)badgeOwnedForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - rank
-(PBRequestUnit *)rankByInternalBase:(NSString *)rankedBy blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - rank (with optional parameter 'limit')
-(PBRequestUnit *)rankByInternalBase:(NSString *)rankedBy withLimit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - ranks
-(PBRequestUnit *)ranksWithLimitInternalBase:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - level
-(PBRequestUnit *)levelInternalBase:(unsigned int)level blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - levels
-(PBRequestUnit *)levelsInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - claimBadge
-(PBRequestUnit *)claimBadgeForPlayerInternalBase:(NSString *)playerId badgeId:(NSString *)badgeId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - redeemBadge
-(PBRequestUnit *)redeemBadgeForPlayerInternalBase:(NSString *)playerId badgeId:(NSString *)badgeId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - goodsOwned
-(PBRequestUnit *)goodsOwnedOfPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questOfPlayer
-(PBRequestUnit *)questOfPlayerInternalBase:(NSString *)playerId questId:(NSString *)questId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questRewardHistoryOfPlayer (with optional 'offset' parameter)
-(PBRequestUnit *)questRewardHistoryOfPlayerInternalBase:(NSString *)playerId offset:(unsigned int)offset blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questRewardHistoryOfPlayer (with optonal 'limit' parameters)
-(PBRequestUnit *)questRewardHistoryOfPlayerInternalBase:(NSString *)playerId limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questRewardHistoryOfPlayer (with both optional parameters)
-(PBRequestUnit *)questRewardHistoryOfPlayerInternalBase:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - deductRewardFromPlayer
-(PBRequestUnit *)deductRewardFromPlayerInternalBase:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - deductRewardFromPlayer (with optional parameter force)
-(PBRequestUnit *)deductRewardFromPlayerInternalBase:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questListOfPlayer
-(PBRequestUnit *)questListOfPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - mission
-(PBRequestUnit *)missionInternalBase:(NSString *)missionId ofQuest:(NSString *)questId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questListAvailableForPlayer
-(PBRequestUnit *)questListAvailableForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questAvailable
-(PBRequestUnit *)questAvailableInternalBase:(NSString *)questId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quest
-(PBRequestUnit *)questInternalBase:(NSString *)questId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - joinQuest
-(PBRequestUnit *)joinQuestInternalBase:(NSString *)questId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - joinAllQuests
-(PBRequestUnit *) joinAllQuestsForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - cancelQuest
-(PBRequestUnit *)cancelQuestInternalBase:(NSString *)questId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - redeemGoods
-(PBRequestUnit *)redeemGoodsInternalBase:(NSString *)goodsId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - redeemGoods (with optional parameter 'amount')
-(PBRequestUnit *)redeemGoodsInternalBase:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - redeemGoodsGroup
-(PBRequestUnit *)redeemGoodsGroupInternalBase:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - redeemGoodsGroup (with optional parameter 'amount')
-(PBRequestUnit *)redeemGoodsGroupInternalBase:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - recentPoint
-(PBRequestUnit *)recentPointWithOffsetInternalBase:(unsigned int)offset limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - recentPointByName
-(PBRequestUnit *)recentPointByNameInternalBase:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - resetPoints
-(PBRequestUnit *)resetPointForAllPlayersWithBlockingCallInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - resetPoints (with optional parameter 'point_name'
-(PBRequestUnit *)resetPointForAllPlayersForPointInternalBase:(NSString *)pointName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - sendEmail
-(PBRequestUnit *)sendEmailForPlayerInternalBase:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - sendEmail (with template-id)
-(PBRequestUnit *)sendEmailForPlayerInternalBase:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - sendEmailCoupon
-(PBRequestUnit *)sendEmailCouponForPlayerInternalBase:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - sendEmailCoupon (with template-id)
-(PBRequestUnit *)sendEmailCouponForPlayerInternalBase:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizList
-(PBRequestUnit *)quizListWithBlockingCallInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizList (with optional parameter 'player_id'.
-(PBRequestUnit *)quizListOfPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizDetail
-(PBRequestUnit *)quizDetailInternalBase:(NSString *)quizId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizDetail (with player-id)
-(PBRequestUnit *)quizDetailInternalBase:(NSString *)quizId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizRandom
-(PBRequestUnit *)quizRandomForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizDone
-(PBRequestUnit *)quizDoneForPlayerInternalBase:(NSString *)playerId limit:(NSInteger)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizPending
-(PBRequestUnit *)quizPendingOfPlayerInternalBase:(NSString *)playerId limit:(NSInteger)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizQuestion
-(PBRequestUnit *)quizQuestionInternalBase:(NSString *)quizId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - storeOrganizeList
-(PBRequestUnit *)storeOrganizeListInternalBase:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - storeNodeList
-(PBRequestUnit *)storeNodeListInternalBase:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - saleHistory
-(PBRequestUnit *)saleHistoryInternalBase:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - getAssociatedNode
- (PBRequestUnit *)getAssociatedNodeInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - playerRole
- (PBRequestUnit *)playerRoleInternalBase:(NSString *)playerId nodeId:(NSString *)node blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// -getContent
-(PBRequestUnit *)getContentInternalBase:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;


#if PBSandBoxEnabled==1
// - quizQuestion
-(PBRequestUnit *)quizQuestionInternalBase:(NSString *)quizId lastQuestion:(NSString *)lastQuestionId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;
#endif

// - quizAnswer
-(PBRequestUnit *)quizAnswerInternalBase:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - quizScoreRank
-(PBRequestUnit *)quizScoreRankInternalBase:(NSString *)quizId limit:(NSInteger)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - sms
-(PBRequestUnit *)sendSMSForPlayerInternalBase:(NSString *)playerId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - sms (with template-id)
-(PBRequestUnit *)sendSMSForPlayerInternalBase:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - smsCoupon
-(PBRequestUnit *)sendSMSCouponForPlayerInternalBase:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - smsCoupon (with template-id)
-(PBRequestUnit *)sendSMSCouponForPlayerInternalBase:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - pushNotification
-(PBRequestUnit *)pushNotificationForPlayerInternalBase:(NSString *)playerId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - pushNotification (with template-id)
-(PBRequestUnit *)pushNotificationForPlayerInternalBase:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - pushNotificationCoupon
-(PBRequestUnit *)pushNotificationCouponForPlayerInternalBase:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - pushNotificationCoupon (with template-id)
-(PBRequestUnit *)pushNotificationCouponForPlayerInternalBase:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - badge
-(PBRequestUnit *)badgeInternalBase:(NSString *)badgeId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - badges
-(PBRequestUnit *)badgesInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - goods
-(PBRequestUnit *)goodsInternalBase:(NSString *)goodId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - goodsList
-(PBRequestUnit *)goodsListInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - goodsGroupAvailable
-(PBRequestUnit *)goodsGroupAvailableInternalBase:(NSString *)playerId group:(NSString *)group blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - goodsGroupAvailable (with optional parameter 'amount')
-(PBRequestUnit *)goodsGroupAvailableInternalBase:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - actionConfig
-(PBRequestUnit *)actionConfigInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - questList
-(PBRequestUnit *)questListInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;

#if TARGET_OS_IOS
// - track
-(void)trackPlayerInternalBase:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view useDelegate:(BOOL)useDelegate withResponse:(id)response;

// - do
-(void)doPlayerInternalBase:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response;
#endif

@end

//
// The Playbasis Object
//
@implementation Playbasis

// NSUserDefaults key for Playbasis sdk to retrieve it later
static NSString *sDeviceTokenRetrievalKey = nil;

@synthesize token = _token;
@synthesize isNetworkReachable = _isNetworkReachable;
@synthesize enableGettingLocation = _enableGettingLocation;

#if TARGET_OS_IOS
@synthesize coreMotionManager = _coreMotionManager;
#endif

+(void)registerDeviceForPushNotification
{
    #if TARGET_OS_IOS
    // register for push notification
    // note: ios 8 changes the way to setup push notification, it's deprecated the old method
    // thus we need to check on this one
    // note 2: we will register device with this device token later with playbasis
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        PBLOG(@"Register device ios %f+", 8.0f);
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
        PBLOG(@"Registered devie ios < %f", 8.0f);
    }
    #endif
}

+(void)saveDeviceToken:(NSData *)deviceToken withKey:(NSString *)key
{
    // we got device token, then we need to trim the brackets, and cut out space
    NSString *device = [deviceToken description];
    device = [device stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    device = [device stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    PBLOG(@"Device token is: %@", device);
    
    // save the key for Playbasis to be able to retrieve it via NSUserDefaults later
    sDeviceTokenRetrievalKey = key;
    
    // save it via NSUserDefaults (non-critical data to be encrypted)
    // we will got this data later in UIViewController-based class
    [[NSUserDefaults standardUserDefaults] setObject:device forKey:sDeviceTokenRetrievalKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getDeviceToken
{
    if (sDeviceTokenRetrievalKey != nil && [sDeviceTokenRetrievalKey isEqualToString:@""])
        return [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    else
        return nil;
}

+(void)setServerUrl:(NSString *)url
{
    // TODO: Implement this later
}

+(NSString*)getServerUrl
{
    return nil;
}

+(void)setServerAsyncUrl:(NSString *)url
{
    // TODO: Implement this later
}

+(NSString *)getServerAsyncUrl
{
    return nil;
}

+(PBBuilder*)builder
{
    return [[PBBuilder alloc] init];
}

+(Playbasis*)sharedPB
{
    return sharedInstance;
}

+(NSString *)version
{
    return @"1.0";
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    _token = [decoder decodeObjectForKey:@"token"];
    _apiKey = [decoder decodeObjectForKey:@"apiKey"];
    _apiKeyParam = [decoder decodeObjectForKey:@"apiKeyParam"];
    _authDelegate = [decoder decodeObjectForKey:@"authDelegate"];
    _requestOptQueue = [decoder decodeObjectForKey:@"requestOptQueue"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_token forKey:@"token"];
    [encoder encodeObject:_apiKey forKey:@"apiKey"];
    [encoder encodeObject:_apiKeyParam forKey:@"apiKeyParam"];
    [encoder encodeObject:_authDelegate forKey:@"authDelegate"];
    [encoder encodeObject:_requestOptQueue forKey:@"requestOptQueue"];
}

-(instancetype)initWithConfiguration:(PBBuilderConfiguration*)configs
{
    if(!(self = [super init]))
        return nil;
    
    _isNetworkReachable = FALSE;
    _token = nil;
    _apiKeyParam = nil;
    _authDelegate = nil;
    
    // set custom device info http headers
    [self setCustomDeviceInfoHTTPHeaderFields];
    
    // location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    #if TARGET_OS_IOS
    // core motion
    _coreMotionManager = [[CMMotionManager alloc] init];
    
    // explicitly ask for permission for iOS 8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [_locationManager requestWhenInUseAuthorization];
    #endif
    
    // create reachability instance
    _reachability = [Reachability reachabilityForInternetConnection];
    // initially set the network status here
    // send 'nil' in has no effect for this method
    [self checkNetworkStatus:nil];
    
    // add notification of network status change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    #if TARGET_OS_IOS
    // add notification of UIApplication
    // we add them here to reduce code user has to add in Delegate class
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    #endif
    
    // start notifier right away
    [_reachability startNotifier];
    
    // create an empty of request opt-queue
    _requestOptQueue = [NSMutableArray array];
    
    // after queue creation then start checking to load requests from file
    [[self getRequestOperationalQueue] load];
    
    // schedule interval call to dispatch request in queue
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(dispatchFirstRequestInQueue:) userInfo:nil repeats:YES];
    
    // check if either apiKey or apiSecret is not valid, then throw exception
    if (![PBValidator isValidString:configs.apiKey] ||
        ![PBValidator isValidString:configs.apiSecret])
        [NSException raise:@"apiKey and apiSecret must be set first" format:@"either apiKey or apiSecret is nil"];
    
    // save configurations
    self.apiKey = configs.apiKey;
    self.apiSecret = configs.apiSecret;
    self.baseUrl = configs.baseUrl;
    self.baseAsyncUrl = configs.baseAsyncUrl;
    // set instance of this to shared instance
    sharedInstance = self;
    
    // configure model classes for OCMapper
    [OCMapperModelConfigurator configure:@"ConfigurableModelClasses"];
    
    return self;
}

-(void)dealloc
{
    // stop notifier
    [_reachability stopNotifier];
    // remove notification of network status change
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    #if TARGET_OS_IOS
    // remove notification of UIApplication
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    #endif
}

-(void)fireRequestIfNecessary:(PBRequestUnit<id> *)request
{
    // if network is reachable then dispatch it immediately
    if(_isNetworkReachable)
    {
        // start the request
        [request start];
    }
    // otherwise, then add into the queue
    else
    {
        // add PBRequestUnit into operational queue
        [_requestOptQueue enqueue:request];
        
        PBLOG(@"Queue size = %lu", (unsigned long)[_requestOptQueue count]);
    }
}

- (void)setEnableGettingLocation:(BOOL)get
{
    _enableGettingLocation = get;
    
    if(_enableGettingLocation)
    {
        [_locationManager startUpdatingLocation];
        PBLOG(@"Start updating location");
    }
    else
    {
        [_locationManager stopUpdatingLocation];
        PBLOG(@"Stop updating location.");
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    PBLOG(@"Location : %f %f", location.coordinate.latitude, location.coordinate.longitude);
    
    // also send update to delegate
    [self.locationUpdatedDelegate locationUpdated:location];
}

-(void)setCustomDeviceInfoHTTPHeaderFields
{
    // create a custom http header fields
    _customDeviceInfoHttpHeaderFieldsVar = [[_customDeviceInfoHttpHeaderFields alloc] init];
    
    #if TARGET_OS_IOS
    // get screen resolution
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    // scale (for retina)
    CGFloat scale = [UIScreen mainScreen].scale;
    PBLOG(@"scale : %.2f", scale);
    // screen width
    _customDeviceInfoHttpHeaderFieldsVar.screenWidth = screenRect.size.width * scale;
    PBLOG(@"screenWidth : %.2f", _customDeviceInfoHttpHeaderFieldsVar.screenWidth);
    
    // screen height
    _customDeviceInfoHttpHeaderFieldsVar.screenHeight = screenRect.size.height * scale;
    PBLOG(@"screenHeight : %.2f", _customDeviceInfoHttpHeaderFieldsVar.screenHeight);
    
    // os
    _customDeviceInfoHttpHeaderFieldsVar.os = @"ios";
    PBLOG(@"os : %@", _customDeviceInfoHttpHeaderFieldsVar.os);
    
    // osVersion
    _customDeviceInfoHttpHeaderFieldsVar.osVersion = [[UIDevice currentDevice] systemVersion];
    PBLOG(@"osVersion : %@", _customDeviceInfoHttpHeaderFieldsVar.osVersion);
    
    // deviceBrand
    _customDeviceInfoHttpHeaderFieldsVar.deviceBrand = @"Apple";
    PBLOG(@"deviceBrand : %@", _customDeviceInfoHttpHeaderFieldsVar.deviceBrand);
    
    // deviceName
    _customDeviceInfoHttpHeaderFieldsVar.deviceName = [[PBUtils sharedInstance] platformString];
    PBLOG(@"deviceName : %@", _customDeviceInfoHttpHeaderFieldsVar.deviceName);

    // sdkVersion
    _customDeviceInfoHttpHeaderFieldsVar.sdkVersion = [Playbasis version];
    PBLOG(@"sdkVersion : %@", _customDeviceInfoHttpHeaderFieldsVar.sdkVersion);
    
    // AppBundle
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *appbundleHeaderValue = [NSString stringWithFormat:@"%@-ios", bundleIdentifier];
    _customDeviceInfoHttpHeaderFieldsVar.appBundle = appbundleHeaderValue;
    PBLOG(@"App Bundle : %@", _customDeviceInfoHttpHeaderFieldsVar.appBundle);
    #endif
}

-(PBRequestUnit *)refactoredInternalBaseReturnWithBlockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withMethod:(NSString *)method andData:(NSString *)data andResponse:(id)response
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

-(PBRequestUnit *)refactoredInternalBaseReturnWithBlockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withMethod:(NSString *)method andData:(NSString *)data responseType:(pbResponseType)responseType andResponse:(id)response
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
    PBLOG(@"jsonString = %@", dataFinal);
    
    return dataFinal;
}

-(const NSMutableArray *)getRequestOperationalQueue
{
    return _requestOptQueue;
}

-(void)setIntendedLoginPlayerIdAndResetConfirmStatus:(NSString *)playerId
{
    _intendedLoginPlayerId = playerId;
    
    // reset confirm flag immediately
    [self confirmIntendedLoginPlayerId:NO];
}

-(void)confirmIntendedLoginPlayerId:(BOOL)confirm
{
    _isIntendedLoginPlayerIdConfirmed = confirm;
}

-(void)resetIntendedLoginPlayerId
{
    [self setIntendedLoginPlayerIdAndResetConfirmStatus:nil];
}

-(void)setIntendedLogoutPlayerIdAndResetConfirmStatus:(NSString *)playerId
{
    _intendedLogoutPlayerId = playerId;
    
    // reset confirm flag immediately
    [self confirmIntendedLogoutPlayerId:NO];
}

-(void)confirmIntendedLogoutPlayerId:(BOOL)confirm
{
    _isIntendedLogoutPlayerIdConfirmed = confirm;
    
    // if confirm, and both intended login & logout are matched, thus invalidate intended login player-id
    if(_isIntendedLogoutPlayerIdConfirmed &&
       [_intendedLogoutPlayerId isEqualToString:_intendedLoginPlayerId])
    {
        [self resetIntendedLoginPlayerId];
    }
}

-(void)resetIntendedLogoutPlayerId
{
    [self setIntendedLogoutPlayerIdAndResetConfirmStatus:nil];
}

// playerListId player id as used in client's website separate with ',' example '1,2,3'
-(PBRequestUnit *)playerList:(NSString *)playerListId withDelegate:(id<PBPlayerList_ResponseHandler>)delegate
{
    return [self playerListInternalBase:playerListId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerList:(NSString *)playerListId withBlock:(PBPlayerList_ResponseBlock)block
{
    return [self playerListInternalBase:playerListId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerListAsync:(NSString *)playerListId withDelegate:(id<PBPlayerList_ResponseHandler>)delegate
{
    return [self playerListInternalBase:playerListId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerListAsync:(NSString *)playerListId withBlock:(PBPlayerList_ResponseBlock)block
{
    return [self playerListInternalBase:playerListId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerListInternalBase:(NSString *)playerListId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/list%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&list_player_id=%@", _token, playerListId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_playerList andResponse:response];
}

-(PBRequestUnit *)playerDetailPublic:(NSString *)playerId withDelegate:(id<PBPlayerDetailedPublic_ResponseHandler>)delegate
{
    return [self playerDetailPublicInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerDetailPublic:(NSString *)playerId withBlock:(PBPlayerDetailedPublic_ResponseBlock)block
{
    return [self playerDetailPublicInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerDetailPublicAsync:(NSString *)playerId withDelegate:(id<PBPlayerDetailedPublic_ResponseHandler>)delegate
{
    return [self playerDetailPublicInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerDetailPublicAsync:(NSString *)playerId withBlock:(PBPlayerDetailedPublic_ResponseBlock)block
{
    return [self playerDetailPublicInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerDetailPublicInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/data/all%@", playerId, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_playerDetailedPublic andResponse:response];
}

-(PBRequestUnit *)playerDetail:(NSString *)playerId withDelegate:(id<PBPlayerDetailed_ResponseHandler>)delegate
{
    return [self playerDetailInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerDetail:(NSString *)playerId withBlock:(PBPlayerDetailed_ResponseBlock)block
{
    return [self playerDetailInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerDetailAsync:(NSString *)playerId withDelegate:(id<PBPlayerDetailed_ResponseHandler>)delegate
{
    return [self playerDetailInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerDetailAsync:(NSString *)playerId withBlock:(PBPlayerDetailed_ResponseBlock)block
{
    return [self playerDetailInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerDetailInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/data/all%@", playerId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", _token];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_playerDetailed andResponse:response];
}

-(PBRequestUnit *)playerSetCustomFields:(NSString *)playerId keys:(NSArray<NSString *> *)keys values:(NSArray<NSString *> *)values withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self playerSetCustomFieldsInternalBase:playerId keys:keys values:values blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerSetCustomFields:(NSString *)playerId keys:(NSArray<NSString *> *)keys values:(NSArray<NSString *> *)values withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self playerSetCustomFieldsInternalBase:playerId keys:keys values:values blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerSetCustomFieldsAsync:(NSString *)playerId keys:(NSArray<NSString *> *)keys values:(NSArray<NSString *> *)values withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self playerSetCustomFieldsInternalBase:playerId keys:keys values:values blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerSetCustomFieldsAsync:(NSString *)playerId keys:(NSArray<NSString *> *)keys values:(NSArray<NSString *> *)values withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self playerSetCustomFieldsInternalBase:playerId keys:keys values:values blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerSetCustomFieldsInternalBase:(NSString *)playerId keys:(NSArray<NSString *> *)keys values:(NSArray<NSString *> *)values blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/custom%@", playerId, _apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@&", _token];
    
    // form keys
    BOOL isFirstRound = YES;
    [data appendString:@"key="];
    for(NSString *k in keys)
    {
        if(!isFirstRound)
            [data appendFormat:@",%@", k];
        else
            [data appendFormat:@"%@", k];
        
        isFirstRound = NO;
    }
    
    // form values
    [data appendString:@"&value="];
    isFirstRound = YES;
    for(NSString *k in values)
    {
        if(!isFirstRound)
            [data appendFormat:@",%@", k];
        else
            [data appendFormat:@"%@", k];
        
        isFirstRound = NO;
    }
    
    // create final data
    NSString *dataFinal = [NSString stringWithString:data];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:dataFinal responseType:responseType_playerSetCustomFields andResponse:response];
}

-(PBRequestUnit *)playerCustomFields:(NSString *)playerId withDelegate:(id<PBPlayerCustomFields_ResponseHandler>)delegate
{
    return [self playerCustomFieldsInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerCustomFields:(NSString *)playerId withBlock:(PBPlayerCustomFields_ResponseBlock)block
{
    return [self playerCustomFieldsInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerCustomFieldsAsync:(NSString *)playerId withDelegate:(id<PBPlayerCustomFields_ResponseHandler>)delegate
{
    return [self playerCustomFieldsInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerCustomFieldsAsync:(NSString *)playerId withBlock:(PBPlayerCustomFields_ResponseBlock)block
{
    return [self playerCustomFieldsInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerCustomFieldsInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/custom%@", playerId, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_playerGetCustomFields andResponse:response];
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
-(PBRequestUnit *)registerUserWithPlayerId:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self registerUserWithPlayerIdInternalBase:playerId username:username email:email imageUrl:imageUrl blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)registerUserWithPlayerId:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self registerUserWithPlayerIdInternalBase:playerId username:username email:email imageUrl:imageUrl blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)registerUserWithPlayerIdAsync:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self registerUserWithPlayerIdInternalBase:playerId username:username email:email imageUrl:imageUrl blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)registerUserWithPlayerIdAsync:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self registerUserWithPlayerIdInternalBase:playerId username:username email:email imageUrl:imageUrl blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)registerUserWithPlayerIdAsync_:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andBlock:(PBAsyncURLRequestResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self registerUserWithPlayerIdInternalBase:playerId username:username email:email imageUrl:imageUrl blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)registerUserWithPlayerIdInternalBase:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response withParams:(va_list)params
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/register%@", playerId, _apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@&username=%@&email=%@&image=%@", _token, username, email, imageUrl];
    
    // create data final that will be used at the end of the process
    NSString *dataFinal = nil;
    
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
        // create a data final
        dataFinal = [NSString stringWithString:data];
    }
    else
    {
        // form async url request data
        dataFinal = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:dataFinal responseType:responseType_registerUser andResponse:response];
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
-(PBRequestUnit *)updateUserForPlayerId:(NSString *)playerId firstArg:(NSString *)firstArg andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self updateUserForPlayerIdInternalBase:playerId firstArg:firstArg blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)updateUserForPlayerId:(NSString *)playerId firstArg:(NSString *)firstArg andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self updateUserForPlayerIdInternalBase:playerId firstArg:firstArg blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)updateUserForPlayerIdAsync:(NSString *)playerId firstArg:(NSString *)firstArg andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self updateUserForPlayerIdInternalBase:playerId firstArg:firstArg blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)updateUserForPlayerIdAsync:(NSString *)playerId firstArg:(NSString *)firstArg andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self updateUserForPlayerIdInternalBase:playerId firstArg:firstArg blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)updateUserForPlayerIdAsync_:(NSString *)playerId firstArg:(NSString *)firstArg andBlock:(PBAsyncURLRequestResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self updateUserForPlayerIdInternalBase:playerId firstArg:firstArg blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)updateUserForPlayerIdInternalBase:(NSString *)playerId firstArg:(NSString *)firstArg blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response withParams:(va_list)params
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/update%@", playerId, _apiKeyParam];
    
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@", _token];
    
    // create a data final
    NSString *dataFinal = nil;
    
    // append firstArg first, but check against nil
    if(firstArg != nil)
        [data appendFormat:@"&%@", firstArg];
    
    // the less of the params
    if(params != nil)
    {
        id updateData;
        // this loop start next to firstArg
        while ((updateData = va_arg(params, NSString *)))
        {
            [data appendFormat:@"&%@", updateData];
        }
    }
    
    if(syncUrl)
    {
        dataFinal = [NSString stringWithString:data];
    }
    else
    {
        // form async url request data
        dataFinal = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }

    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:dataFinal responseType:responseType_updateUser andResponse:response];
}
-(PBRequestUnit *)deleteUserWithPlayerId:(NSString *)playerId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self deleteUserWithPlayerIdInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)deleteUserWithPlayerId:(NSString *)playerId withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self deleteUserWithPlayerIdInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deleteUserWithPlayerIdAsync:(NSString *)playerId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self deleteUserWithPlayerIdInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)deleteUserWithPlayerIdAsync:(NSString *)playerId withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self deleteUserWithPlayerIdInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deleteUserWithPlayerIdAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self deleteUserWithPlayerIdInternalBase:playerId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deleteUserWithPlayerIdInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/delete%@", playerId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", _token];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }

    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_deleteUser andResponse:response];
}

-(PBRequestUnit *)loginPlayer:(NSString *)playerId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self loginPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}

-(PBRequestUnit *)loginPlayer:(NSString *)playerId options:(NSMutableDictionary *)options withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self loginPlayerInternalBase:playerId options:options blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)loginPlayerAsync:(NSString *)playerId options:(NSMutableDictionary *)options withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self loginPlayerInternalBase:playerId options:options blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)loginPlayerAsync:(NSString *)playerId options:(NSMutableDictionary *)options withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self loginPlayerInternalBase:playerId options:options blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)loginPlayerAsync_:(NSString *)playerId options:(NSMutableDictionary *)options withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self loginPlayerInternalBase:playerId options:options blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)loginPlayerInternalBase:(NSString *)playerId options:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/login%@", playerId, _apiKeyParam];
    
    NSString *data = [NSString stringWithFormat:@"token=%@", _token];
    NSString *session_id = [options objectForKey:@"session_id"];
    NSString *session_expires_in = [options objectForKey:@"session_expires_in"];
    
    data = session_id == nil ? data : [data stringByAppendingString:[NSString stringWithFormat:@"&session_id=%@",session_id]];
    data = session_expires_in == nil ? data : [data stringByAppendingString:[NSString stringWithFormat:@"&session_expires_in=%@",session_expires_in]];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    // set intended player-id
    [self setIntendedLoginPlayerIdAndResetConfirmStatus:playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_loginUser andResponse:response];
}

//Player Auth
-(PBRequestUnit *)playerAuthForPlayerId:(NSString *)password options:(NSMutableDictionary *)options withDelegate:(id<PBPlayer_ResponseHandler>)delegate
{
    return [self playerAuthForPlayerIdInternalBase:password options:options blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}

-(PBRequestUnit *)playerAuthForPlayerId:(NSString *)password options:(NSMutableDictionary *)options withBlock:(PBPlayer_ResponseBlock)block
{
    return [self playerAuthForPlayerIdInternalBase:password options:options blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerAuthForPlayerIdAsync:(NSString *)password options:(NSMutableDictionary *)options withDelegate:(id<PBPlayer_ResponseHandler>)delegate
{
    return [self playerAuthForPlayerIdInternalBase:password options:options blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerAuthForPlayerIdAsync:(NSString *)password options:(NSMutableDictionary *)options withBlock:(PBPlayer_ResponseBlock)block
{
    return [self playerAuthForPlayerIdInternalBase:password options:options blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)lplayerAuthForPlayerIdAsync_:(NSString *)password options:(NSMutableDictionary *)options withBlock:(PBPlayer_ResponseBlock)block
{
    return [self playerAuthForPlayerIdInternalBase:password options:options blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerAuthForPlayerIdInternalBase:(NSString *)password options:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/auth%@", _apiKeyParam];
    
    NSString *data = [NSString stringWithFormat:@"token=%@&password=%@", _token,password];
    
    NSString *email = [options objectForKey:@"email"];
    NSString *username = [options objectForKey:@"username"];
    NSString *device_id = [options objectForKey:@"device_token"];
    
    data = email == nil ? data : [data stringByAppendingString:[NSString stringWithFormat:@"&email=%@",email]];
    data = username == nil ? data : [data stringByAppendingString:[NSString stringWithFormat:@"&username=%@",username]];
    data = device_id == nil ? data : [data stringByAppendingString:[NSString stringWithFormat:@"&device_token=%@",device_id]];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    // set intended player-id
    //[self setIntendedLoginPlayerIdAndResetConfirmStatus:playerId];
    PBRequestUnit *result = [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_loginUser andResponse:response];
    NSDictionary *json = [result getResponse];
    NSMutableDictionary *response_data = [json objectForKey:@"response"];
    [self setIntendedLoginPlayerIdAndResetConfirmStatus:[response_data objectForKey:@"cl_player_id"]];
    return result;
}
-(PBRequestUnit *)logoutPlayer:(NSString *)playerId sessionId:(NSString *)sessionId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
{
    return [self logoutPlayerInternalBase:playerId sessionId:sessionId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)logoutPlayer:(NSString *)playerId sessionId:(NSString *)sessionId withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self logoutPlayerInternalBase:playerId sessionId:sessionId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)logoutPlayerAsync:(NSString *)playerId sessionId:(NSString *)sessionId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self logoutPlayerInternalBase:playerId sessionId:sessionId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)logoutPlayerAsync:(NSString *)playerId sessionId:(NSString *)sessionId withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self logoutPlayerInternalBase:playerId sessionId:sessionId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)logoutPlayerAsync_:(NSString *)playerId sessionId:(NSString *)sessionId withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self logoutPlayerInternalBase:playerId sessionId:sessionId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)logoutPlayerInternalBase:(NSString *)playerId sessionId:(NSString *)sessionId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/logout%@", playerId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", _token];
    
    if(sessionId!=nil)
    {
        data = [data stringByAppendingString:[NSString stringWithFormat:@"&session_id=%@",sessionId]];
    }
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    // set intended player-id
    [self setIntendedLogoutPlayerIdAndResetConfirmStatus:playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_logoutUser andResponse:response];
}

-(PBRequestUnit *)pointsOfPlayer:(NSString *)playerId withDelegate:(id<PBPoints_ResponseHandler>)delegate
{
    return [self pointsOfPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointsOfPlayer:(NSString *)playerId withBlock:(PBPoints_ResponseBlock)block
{
    return [self pointsOfPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointsOfPlayerAsync:(NSString *)playerId withDelegate:(id<PBPoints_ResponseHandler>)delegate
{
    return [self pointsOfPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointsOfPlayerAsync:(NSString *)playerId withBlock:(PBPoints_ResponseBlock)block
{
    return [self pointsOfPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
- (PBRequestUnit *)pointsOfPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/points%@", playerId, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_points andResponse:response];
}

-(PBRequestUnit *)pointOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName withDelegate:(id<PBPoint_ResponseHandler>)delegate
{
    return [self pointOfPlayerInternalBase:playerId forPoint:pointName blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName withBlock:(PBPoint_ResponseBlock)block
{
    return [self pointOfPlayerInternalBase:playerId forPoint:pointName blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName withDelegate:(id<PBPoint_ResponseHandler>)delegate
{
    return [self pointOfPlayerInternalBase:playerId forPoint:pointName blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName withBlock:(PBPoint_ResponseBlock)block
{
    return [self pointOfPlayerInternalBase:playerId forPoint:pointName blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointOfPlayerInternalBase:(NSString *)playerId forPoint:(NSString *)pointName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/point/%@%@", playerId, pointName, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_point andResponse:response];
}

-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName andDelegate:(id<PBPointHistory_ResponseHandler>)delegate
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName andDelegate:(id<PBPointHistory_ResponseHandler>)delegate
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointHistoryInternalBase:(NSString *)playerId forPoint:(NSString *)pointName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *params = [NSString stringWithFormat:@"&point_name=%@", pointName];
    NSString *method = [NSString stringWithFormat:@"Player/%@/point_history%@%@", playerId, _apiKeyParam, params];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_pointHistory andResponse:response];
}

-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset andDelegate:(id<PBPointHistory_ResponseHandler>)delegate
{
    return [self pointHistoryInternalBase:playerId offset:offset blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId offset:offset blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset andDelegate:(id<PBPointHistory_ResponseHandler>)delegate
{
    return [self pointHistoryInternalBase:playerId offset:offset blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId offset:offset blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointHistoryInternalBase:(NSString *)playerId offset:(unsigned int)offset blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *params = [NSString stringWithFormat:@"&offset=%u", offset];
    NSString *method = [NSString stringWithFormat:@"Player/%@/point_history%@%@", playerId, _apiKeyParam, params];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_pointHistory andResponse:response];
}

-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate

{
    return [self pointHistoryInternalBase:playerId withLimit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId withLimit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate
{
    return [self pointHistoryInternalBase:playerId withLimit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId withLimit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointHistoryInternalBase:(NSString *)playerId withLimit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *params = [NSString stringWithFormat:@"&limit=%u", limit];
    NSString *method = [NSString stringWithFormat:@"Player/%@/point_history%@%@", playerId, _apiKeyParam, params];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_pointHistory andResponse:response];
}

-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset andDelegate:(id<PBPointHistory_ResponseHandler>)delegate
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName offset:offset blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName offset:offset blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset andDelegate:(id<PBPointHistory_ResponseHandler>)delegate
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName offset:offset blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName offset:offset blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointHistoryInternalBase:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *params = [NSString stringWithFormat:@"&point_name=%@&offset=%u", pointName, offset];
    NSString *method = [NSString stringWithFormat:@"Player/%@/point_history%@%@", playerId, _apiKeyParam, params];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_pointHistory andResponse:response];
}

-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName withLimit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName withLimit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName withLimit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName withLimit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointHistoryInternalBase:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *params = [NSString stringWithFormat:@"&point_name=%@&limit=%u", pointName, limit];
    NSString *method = [NSString stringWithFormat:@"Player/%@/point_history%@%@", playerId, _apiKeyParam, params];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_pointHistory andResponse:response];
}


-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName offset:offset withLimit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName offset:offset withLimit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName offset:offset withLimit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block
{
    return [self pointHistoryInternalBase:playerId forPoint:pointName offset:offset withLimit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pointHistoryInternalBase:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *params = [NSString stringWithFormat:@"&offset=%u&limit=%u", offset, limit];
    if (pointName != nil) {
        params = [NSString stringWithFormat:@"%@&point_name=%@", params, pointName];
    }
    NSString *method = [NSString stringWithFormat:@"Player/%@/point_history%@%@", playerId, _apiKeyParam, params];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_pointHistory andResponse:response];
}

-(PBRequestUnit *)actionTimeForPlayer:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionTime_ResponseHandler>)delegate;
{
    return [self actionTimeForPlayerInternalBase:playerId action:actionName blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)actionTimeForPlayer:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionTime_ResponseBlock)block
{
    return [self actionTimeForPlayerInternalBase:playerId action:actionName blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)actionTimeForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionTime_ResponseHandler>)delegate
{
    return [self actionTimeForPlayerInternalBase:playerId action:actionName blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)actionTimeForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionTime_ResponseBlock)block
{
    return [self actionTimeForPlayerInternalBase:playerId action:actionName blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)actionTimeForPlayerInternalBase:(NSString *)playerId action:(NSString *)actionName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/%@/time%@", playerId, actionName, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_actionTime andResponse:response];
}

-(PBRequestUnit *)actionLastPerformedForPlayer:(NSString *)playerId withDelegate:(id<PBLastAction_ResponseHandler>)delegate
{
    return [self actionLastPerformedForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)actionLastPerformedForPlayer:(NSString *)playerId withBlock:(PBLastAction_ResponseBlock)block
{
    return [self actionLastPerformedForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)actionLastPerformedForPlayerAsync:(NSString *)playerId withDelegate:(id<PBLastAction_ResponseHandler>)delegate
{
    return [self actionLastPerformedForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)actionLastPerformedForPlayerAsync:(NSString *)playerId withBlock:(PBLastAction_ResponseBlock)block
{
    return [self actionLastPerformedForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)actionLastPerformedForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/time%@", playerId, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_lastAction andResponse:response];
}


-(PBRequestUnit *)actionLastPerformedTimeForPlayer:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionLastPerformedTime_ResponseHandler>)delegate
{
    return [self actionLastPerformedTimeForPlayerInternalBase:playerId action:actionName blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)actionLastPerformedTimeForPlayer:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionLastPerformedTime_ResponseBlock)block
{
    return [self actionLastPerformedTimeForPlayerInternalBase:playerId action:actionName blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)actionLastPerformedTimeForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionLastPerformedTime_ResponseHandler>)delegate
{
    return [self actionLastPerformedTimeForPlayerInternalBase:playerId action:actionName blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)actionLastPerformedTimeForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionLastPerformedTime_ResponseBlock)block
{
    return [self actionLastPerformedTimeForPlayerInternalBase:playerId action:actionName blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)actionLastPerformedTimeForPlayerInternalBase:(NSString *)playerId action:(NSString *)actionName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/%@/time%@", playerId, actionName, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_actionLastPerformedTime andResponse:response];
}

-(PBRequestUnit *)actionPerformedCountForPlayer:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionCount_ResponseHandler>)delegate
{
    return [self actionPerformedCountForPlayerInternalBase:playerId action:actionName blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)actionPerformedCountForPlayer:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionCount_ResponseBlock)block
{
    return [self actionPerformedCountForPlayerInternalBase:playerId action:actionName blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)actionPerformedCountForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionCount_ResponseHandler>)delegate
{
    return [self actionPerformedCountForPlayerInternalBase:playerId action:actionName blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)actionPerformedCountForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionCount_ResponseBlock)block
{
    return [self actionPerformedCountForPlayerInternalBase:playerId action:actionName blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)actionPerformedCountForPlayerInternalBase:(NSString *)playerId action:(NSString *)actionName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/action/%@/count%@", playerId, actionName, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_actionCount andResponse:response];
}

-(PBRequestUnit *)badgeOwnedForPlayer:(NSString *)playerId withDelegate:(id<PBPlayerBadges_ResponseHandler>)delegate
{
    return [self badgeOwnedForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)badgeOwnedForPlayer:(NSString *)playerId withBlock:(PBPlayerBadges_ResponseBlock)block
{
    return [self badgeOwnedForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)badgeOwnedForPlayerAsync:(NSString *)playerId withDelegate:(id<PBPlayerBadges_ResponseHandler>)delegate
{
    return [self badgeOwnedForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)badgeOwnedForPlayerAsync:(NSString *)playerId withBlock:(PBPlayerBadges_ResponseBlock)block
{
    return [self badgeOwnedForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)badgeOwnedForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/badge%@", playerId, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_playerBadges andResponse:response];
}

-(PBRequestUnit *)rankBy:(NSString *)rankedBy andDelegate:(id<PBRank_ResponseHandler>)delegate
{
    return [self rankByInternalBase:rankedBy blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)rankBy:(NSString *)rankedBy andBlock:(PBRank_ResponseBlock)block
{
    return [self rankByInternalBase:rankedBy blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)rankByAsync:(NSString *)rankedBy andDelegate:(id<PBRank_ResponseHandler>)delegate
{
    return [self rankByInternalBase:rankedBy blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)rankByAsync:(NSString *)rankedBy andBlock:(PBRank_ResponseBlock)block
{
    return [self rankByInternalBase:rankedBy blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)rankByInternalBase:(NSString *)rankedBy blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/rank/%@%@", rankedBy, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_rank andResponse:response];
}

-(PBRequestUnit *)rankBy:(NSString *)rankedBy withLimit:(unsigned int)limit andDelegate:(id<PBRank_ResponseHandler>)delegate
{
    return [self rankByInternalBase:rankedBy withLimit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)rankBy:(NSString *)rankedBy withLimit:(unsigned int)limit andBlock:(PBRank_ResponseBlock)block
{
    return [self rankByInternalBase:rankedBy withLimit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)rankByAsync:(NSString *)rankedBy withLimit:(unsigned int)limit andDelegate:(id<PBRank_ResponseHandler>)delegate
{
    return [self rankByInternalBase:rankedBy withLimit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)rankByAsync:(NSString *)rankedBy withLimit:(unsigned int)limit andBlock:(PBRank_ResponseBlock)block
{
    return [self rankByInternalBase:rankedBy withLimit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)rankByInternalBase:(NSString *)rankedBy withLimit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/rank/%@/%u%@", rankedBy, limit, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_rank andResponse:response];
}

-(PBRequestUnit *)ranksWithLimit:(unsigned int)limit withDelegate:(id<PBRank_ResponseHandler>)delegate
{
    return [self ranksWithLimitInternalBase:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)ranksWithLimit:(unsigned int)limit withBlock:(PBRanks_ResponseBlock)block
{
    return [self ranksWithLimitInternalBase:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)ranksWithLimitAsync:(unsigned int)limit withDelegate:(id<PBRank_ResponseHandler>)delegate
{
    return [self ranksWithLimitInternalBase:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)ranksWithLimitAsync:(unsigned int)limit withBlock:(PBRanks_ResponseBlock)block
{
    return [self ranksWithLimitInternalBase:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)ranksWithLimitInternalBase:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/ranks/%u%@", limit, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_ranks andResponse:response];
}

-(PBRequestUnit *)level:(unsigned int)level withDelegate:(id<PBLevel_ResponseHandler>)delegate
{
    return [self levelInternalBase:level blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)level:(unsigned int)level withBlock:(PBLevel_ResponseBlock)block
{
    return [self levelInternalBase:level blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)levelAsync:(unsigned int)level withDelegate:(id<PBLevel_ResponseHandler>)delegate
{
    return [self levelInternalBase:level blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)levelAsync:(unsigned int)level withBlock:(PBLevel_ResponseBlock)block
{
    return [self levelInternalBase:level blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)levelInternalBase:(unsigned int)level blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/level/%u%@", level, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_level andResponse:response];
}

-(PBRequestUnit *)levelsWithDelegate:(id<PBLevels_ResponseHandler>)delegate
{
    return [self levelsInternalBase:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)levelsWithBlock:(PBLevels_ResponseBlock)block
{
    return [self levelsInternalBase:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)levelsAsyncWithDelegate:(id<PBLevels_ResponseHandler>)delegate
{
    return [self levelsInternalBase:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)levelsAsyncWithBlock:(PBLevels_ResponseBlock)block
{
    return [self levelsInternalBase:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)levelsInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/levels%@", _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_levels andResponse:response];
}

-(PBRequestUnit *)claimBadgeForPlayer:(NSString *)playerId badgeId:(NSString *)badgeId andDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self claimBadgeForPlayerInternalBase:playerId badgeId:badgeId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)claimBadgeForPlayer:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResultStatus_ResponseBlock)block
{
    return [self claimBadgeForPlayerInternalBase:playerId badgeId:badgeId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)claimBadgeForPlayerAsync:(NSString *)playerId badgeId:(NSString *)badgeId andDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self claimBadgeForPlayerInternalBase:playerId badgeId:badgeId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)claimBadgeForPlayerAsync:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResultStatus_ResponseBlock)block
{
    return [self claimBadgeForPlayerInternalBase:playerId badgeId:badgeId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)claimBadgeForPlayerAsync_:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self claimBadgeForPlayerInternalBase:playerId badgeId:badgeId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)claimBadgeForPlayerInternalBase:(NSString *)playerId badgeId:(NSString *)badgeId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/badge/%@/claim%@", playerId, badgeId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", _token];
    
    if(!syncUrl)
    {
        // form async url request data
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_claimBadge andResponse:response];
}

-(PBRequestUnit *)redeemBadgeForPlayer:(NSString *)playerId badgeId:(NSString *)badgeId andDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self redeemBadgeForPlayerInternalBase:playerId badgeId:badgeId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)redeemBadgeForPlayer:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResultStatus_ResponseBlock)block
{
    return [self redeemBadgeForPlayerInternalBase:playerId badgeId:badgeId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemBadgeForPlayerAsync:(NSString *)playerId badgeId:(NSString *)badgeId andDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self redeemBadgeForPlayerInternalBase:playerId badgeId:badgeId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)redeemBadgeForPlayerAsync:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResultStatus_ResponseBlock)block
{
    return [self redeemBadgeForPlayerInternalBase:playerId badgeId:badgeId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemBadgeForPlayerAsync_:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self redeemBadgeForPlayerInternalBase:playerId badgeId:badgeId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemBadgeForPlayerInternalBase:(NSString *)playerId badgeId:(NSString *)badgeId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/badge/%@/redeem%@", playerId, badgeId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", _token];
    
    if(!syncUrl)
    {
        // form async url request data
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_redeemBadge andResponse:response];
}

-(PBRequestUnit *)goodsOwnedOfPlayer:(NSString *)playerId withDelegate:(id<PBPlayerGoodsOwned_ResponseHandler>)delegate
{
    return [self goodsOwnedOfPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)goodsOwnedOfPlayer:(NSString *)playerId withBlock:(PBPlayerGoodsOwned_ResponseBlock)block
{
    return [self goodsOwnedOfPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)goodsOwnedOfPlayerAsync:(NSString *)playerId withDelegate:(id<PBPlayerGoodsOwned_ResponseHandler>)delegate
{
    return [self goodsOwnedOfPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)goodsOwnedOfPlayerAsync:(NSString *)playerId withBlock:(PBPlayerGoodsOwned_ResponseBlock)block
{
    return [self goodsOwnedOfPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)goodsOwnedOfPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/goods%@", playerId, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_playerGoodsOwned andResponse:response];
}

-(PBRequestUnit *)questOfPlayer:(NSString *)playerId questId:(NSString *)questId andDelegate:(id<PBQuestOfPlayer_ResponseHandler>)delegate
{
    return [self questOfPlayerInternalBase:playerId questId:questId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questOfPlayer:(NSString *)playerId questId:(NSString *)questId andBlock:(PBQuestOfPlayer_ResponseBlock)block
{
    return [self questOfPlayerInternalBase:playerId questId:questId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questOfPlayerAsync:(NSString *)playerId questId:(NSString *)questId andDelegate:(id<PBQuestOfPlayer_ResponseHandler>)delegate
{
    return [self questOfPlayerInternalBase:playerId questId:questId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questOfPlayerAsync:(NSString *)playerId questId:(NSString *)questId andBlock:(PBQuestOfPlayer_ResponseBlock)block
{
    return [self questOfPlayerInternalBase:playerId questId:questId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questOfPlayerInternalBase:(NSString *)playerId questId:(NSString *)questId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/quest/%@%@&player_id=%@", questId, _apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questOfPlayer andResponse:response];
}

-(PBRequestUnit *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId offset:offset blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId offset:offset blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId offset:offset blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId offset:offset blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questRewardHistoryOfPlayerInternalBase:(NSString *)playerId offset:(unsigned int)offset blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/quest_reward_history%@&offset=%u", playerId, _apiKeyParam, offset];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questRewardHistoryOfPlayer andResponse:response];
}

-(PBRequestUnit *)questRewardHistoryOfPlayer:(NSString *)playerId limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId limit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questRewardHistoryOfPlayer:(NSString *)playerId limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId limit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questRewardHistoryOfPlayerAsync:(NSString *)playerId limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId limit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questRewardHistoryOfPlayerAsync:(NSString *)playerId limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId limit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questRewardHistoryOfPlayerInternalBase:(NSString *)playerId limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/quest_reward_history%@&limit=%u", playerId, _apiKeyParam, limit];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questRewardHistoryOfPlayer andResponse:response];
}

-(PBRequestUnit *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId offset:offset limit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId offset:offset limit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId offset:offset limit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block
{
    return [self questRewardHistoryOfPlayerInternalBase:playerId offset:offset limit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questRewardHistoryOfPlayerInternalBase:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/quest_reward_history%@&offset=%u&limit=%u", playerId, _apiKeyParam, offset, limit];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questRewardHistoryOfPlayer andResponse:response];
}

-(PBRequestUnit *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withDelegate:(id<PBDeductReward_ResponseHandler>)delegate
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withBlock:(PBDeductReward_ResponseBlock)block
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withDelegate:(id<PBDeductReward_ResponseHandler>)delegate
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withBlock:(PBDeductReward_ResponseBlock)block
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deductRewardFromPlayerAsync_:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deductRewardFromPlayerInternalBase:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/deduct%@", playerId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&reward=%@&amount=%lu", _token, reward, (unsigned long)amount];
    
    if(!syncUrl)
    {
        // form async url request data
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_deductReward andResponse:response];
}

-(PBRequestUnit *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withDelegate:(id<PBDeductReward_ResponseHandler>)delegate
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount force:force blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withBlock:(PBDeductReward_ResponseBlock)block
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount force:force blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withDelegate:(id<PBDeductReward_ResponseHandler>)delegate
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount force:force blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withBlock:(PBDeductReward_ResponseBlock)block
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount force:force blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deductRewardFromPlayerAsync_:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self deductRewardFromPlayerInternalBase:playerId reward:reward amount:amount force:force blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deductRewardFromPlayerInternalBase:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/%@/deduct%@", playerId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&reward=%@&amount=%lu&force=%lu", _token, reward, (unsigned long)amount, (unsigned long)force];
    
    if(!syncUrl)
    {
        // form async url request data
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_deductReward andResponse:response];
}

-(PBRequestUnit *)questListOfPlayer:(NSString *)playerId filter:(NSString *)filter withDelegate:(id<PBQuestListOfPlayer_ResponseHandler>)delegate
{
    return [self questListOfPlayerInternalBase:playerId filter:filter blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questListOfPlayer:(NSString *)playerId filter:(NSString *)filter withBlock:(PBQuestListOfPlayer_ResponseBlock)block
{
    return [self questListOfPlayerInternalBase:playerId filter:filter blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questListOfPlayerAsync:(NSString *)playerId filter:(NSString *)filter withDelegate:(id<PBQuestListOfPlayer_ResponseHandler>)delegate
{
    return [self questListOfPlayerInternalBase:playerId filter:filter blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questListOfPlayerAsync:(NSString *)playerId filter:(NSString *)filter withBlock:(PBQuestListOfPlayer_ResponseBlock)block
{
    return [self questListOfPlayerInternalBase:playerId filter:filter blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questListOfPlayerInternalBase:(NSString *)playerId filter:(NSString *)filter blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/quest%@&player_id=%@", _apiKeyParam, playerId];
    if([filter isEqual:nil])
    {
        method = [method stringByAppendingString:[NSString stringWithFormat:@"&filter=%@",filter]];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questListOfPlayer andResponse:response];
}

-(PBRequestUnit *)playerUniqueCode:(NSString *)playerId withDelegate:(id<PBUniqueCode_ResponseHandler>)delegate
{
    return [self playerUniqueCodeInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerUniqueCode:(NSString *)playerId withBlock:(PBUniqueCode_ResponseBlock)block
{
    return [self playerUniqueCodeInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerUniqueCodeAsync:(NSString *)playerId withDelegate:(id<PBUniqueCode_ResponseHandler>)delegate
{
    return [self playerUniqueCodeInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerUniqueCodeAsync:(NSString *)playerId withBlock:(PBUniqueCode_ResponseBlock)block
{
    return [self playerUniqueCodeInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}

-(PBRequestUnit *)playerUniqueCodeInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/code%@", playerId, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_uniqueCode andResponse:response];
}

-(PBRequestUnit *)badge:(NSString *)badgeId withDelegate:(id<PBBadge_ResponseHandler>)delegate
{
    return [self badgeInternalBase:badgeId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)badge:(NSString *)badgeId withBlock:(PBBadge_ResponseBlock)block
{
    return [self badgeInternalBase:badgeId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)badgeAsync:(NSString *)badgeId withDelegate:(id<PBBadge_ResponseHandler>)delegate
{
    return [self badgeInternalBase:badgeId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)badgeAsync:(NSString *)badgeId withBlock:(PBBadge_ResponseBlock)block
{
    return [self badgeInternalBase:badgeId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)badgeInternalBase:(NSString *)badgeId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Badge/%@%@", badgeId, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_badge andResponse:response];
}

-(PBRequestUnit *)badgesWithDelegate:(id<PBBadges_ResponseHandler>)delegate
{
    return [self badgesInternalBase:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)badgesWithBlock:(PBBadges_ResponseBlock)block
{
    return [self badgesInternalBase:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)badgesAsyncWithDelegate:(id<PBBadges_ResponseHandler>)delegate
{
    return [self badgesInternalBase:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)badgesAsyncWithBlock:(PBBadges_ResponseBlock)block
{
    return [self badgesInternalBase:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)badgesInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Badges%@", _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_badges andResponse:response];
}

-(PBRequestUnit *)goods:(NSString *)goodId withDelegate:(id<PBGoodsInfo_ResponseHandler>)delegate
{
    return [self goodsInternalBase:goodId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)goods:(NSString *)goodId withBlock:(PBGoodsInfo_ResponseBlock)block
{
    return [self goodsInternalBase:goodId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)goodsAsync:(NSString *)goodId withDelegate:(id<PBGoodsInfo_ResponseHandler>)delegate
{
    return [self goodsInternalBase:goodId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)goodsAsync:(NSString *)goodId withBlock:(PBGoodsInfo_ResponseBlock)block
{
    return [self goodsInternalBase:goodId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)goodsInternalBase:(NSString *)goodId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Goods/%@%@", goodId, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_goodsInfo andResponse:response];
}

-(PBRequestUnit *)goodsList:(NSString *)playerId tags:(NSString *)tags withDelegate:(id<PBGoodsListInfo_ResponseHandler>)delegate
{
    return [self goodsListInternalBase:playerId tags:tags blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)goodsList:(NSString *)playerId tags:(NSString *)tags withBlock:(PBGoodsListInfo_ResponseBlock)block
{
    return [self goodsListInternalBase:playerId tags:tags blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)goodsListAsync:(NSString *)playerId tags:(NSString *)tags withDelegate:(id<PBGoodsListInfo_ResponseHandler>)delegate
{
    return [self goodsListInternalBase:playerId tags:tags blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)goodsListAsync:(NSString *)playerId tags:(NSString *)tags withBlock:(PBGoodsListInfo_ResponseBlock)block
{
    return [self goodsListInternalBase:playerId tags:tags blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)goodsListInternalBase:(NSString *)playerId tags:(NSString *)tags blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Goods%@", _apiKeyParam];
    if (playerId != nil && ![playerId isEqual:@""]) {
        method = [method stringByAppendingString:[NSString stringWithFormat:@"&player_id=%@",playerId]];
    }
    if(tags != nil && ![tags isEqual:@""])
    {
        method = [method stringByAppendingString:[NSString stringWithFormat:@"&tags=%@",tags]];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_goodsListInfo andResponse:response];
}

-(PBRequestUnit *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate
{
    return [self goodsGroupAvailableInternalBase:playerId group:group blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group withBlock:(PBGoodsGroupAvailable_ResponseBlock)block
{
    return  [self goodsGroupAvailableInternalBase:playerId group:group blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)goodsGroupAvailableForPlayerAsync:(NSString *)playerId group:(NSString *)group withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate
{
    return [self goodsGroupAvailableInternalBase:playerId group:group blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)goodsGroupAvailableForPlayerAsync:(NSString *)playerId group:(NSString *)group withBlock:(PBGoodsGroupAvailable_ResponseBlock)block
{
    return [self goodsGroupAvailableInternalBase:playerId group:group blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)goodsGroupAvailableForPlayerAsync_:(NSString *)playerId group:(NSString *)group withBlock:(PBGoodsGroupAvailable_ResponseBlock)block
{
    return [self goodsGroupAvailableInternalBase:playerId group:group blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)goodsGroupAvailableInternalBase:(NSString *)playerId group:(NSString *)group blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Redeem/goodsGroup%@&player_id=%@&group=%@", _apiKeyParam, playerId, group];
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_goodsGroupAvailable andResponse:response];
}

-(PBRequestUnit *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate
{
    return [self goodsGroupAvailableInternalBase:playerId group:group amount:amount blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block
{
    return [self goodsGroupAvailableInternalBase:playerId group:group amount:amount blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)goodsGroupAvailableForPlayerAsync:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate
{
    return [self goodsGroupAvailableInternalBase:playerId group:group amount:amount blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)goodsGroupAvailableForPlayerAsync:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block
{
    return [self goodsGroupAvailableInternalBase:playerId group:group amount:amount blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)goodsGroupAvailableForPlayerAsync_:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block
{
    return [self goodsGroupAvailableInternalBase:playerId group:group amount:amount blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)goodsGroupAvailableInternalBase:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Redeem/goodsGroup%@&player_id=%@&group=%@&amount=%u", _apiKeyParam, playerId, group, amount];
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_goodsGroupAvailable andResponse:response];
}

-(PBRequestUnit *)actionConfigWithDelegate:(id<PBActionConfig_ResponseHandler>)delegate
{
    return [self actionConfigInternalBase:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)actionConfigWithBlock:(PBActionConfig_ResponseBlock)block
{
    return [self actionConfigInternalBase:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)actionConfigAsyncWithDelegate:(id<PBActionConfig_ResponseHandler>)delegate
{
    return [self actionConfigInternalBase:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)actionConfigAsyncWithBlock:(PBActionConfig_ResponseBlock)block
{
    return [self actionConfigInternalBase:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)actionConfigAsyncWithBlock_:(PBAsyncURLRequestResponseBlock)block
{
    return [self actionConfigInternalBase:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)actionConfigInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Engine/actionConfig%@", _apiKeyParam];
    
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
        PBLOG(@"jsonString = %@", data);
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_actionConfig andResponse:response];
}
-(PBRequestUnit *)storeOrganizeList:(NSMutableDictionary *)options withDelegate:(id<PBStoreOrganize_ResponseHandler>)delegate
{
    return [self storeOrganizeListInternalBase:options blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)storeOrganizeList:(NSMutableDictionary *)options withBlock:(PBStoreOrganize_ResponseBlock)block
{
    return [self storeOrganizeListInternalBase:options blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)storeOrganizeListAsync:(NSMutableDictionary *)options withDelegate:(id<PBStoreOrganize_ResponseHandler>)delegate
{
    return [self storeOrganizeListInternalBase:options blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)storeOrganizeListAsync:(NSMutableDictionary *)options  withBlock:(PBStoreOrganize_ResponseBlock)block
{
    return [self storeOrganizeListInternalBase:options blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)storeOrganizeListAsync_:(NSMutableDictionary *)options withBlock:(PBStoreOrganize_ResponseBlock)block
{
    return [self storeOrganizeListInternalBase:options blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)storeOrganizeListInternalBase:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    //getList organizations/StoreOrg/organizes
    NSString *method = [NSString stringWithFormat:@"StoreOrg/organizes%@", _apiKeyParam];
    NSString *_id = [options objectForKey:@"id"];
    NSString *search = [options objectForKey:@"search"];
    NSString *sort = [options objectForKey:@"sort"];
    NSString *order = [options objectForKey:@"order"];
    NSString *offset = [options objectForKey:@"offset"];
    NSString *limit = [options objectForKey:@"limit"];
    
    method = _id == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&id=%@",_id]];
    method = search == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&search=%@",search]];
    method = sort == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&sort=%@",sort]];
    method = order == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&order=%@",order]];
    method = offset == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&offset=%@",offset]];
    method = limit == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&limit=%@",limit]];
   
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_storeOrganize andResponse:response];

  
}
-(PBRequestUnit *)storeNodeList:(NSMutableDictionary *)options withDelegate:(id<PBNodeOrganize_ResponseHandler>)delegate
{
    return [self storeNodeListInternalBase:options blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)storeNodeList:(NSMutableDictionary *)options withBlock:(PBNodeOrganize_ResponseBlock)block
{
    return [self storeNodeListInternalBase:options blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)storeNodeListAsync:(NSMutableDictionary *)options withDelegate:(id<PBNodeOrganize_ResponseHandler>)delegate
{
    return [self storeNodeListInternalBase:options blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)storeNodeListAsync:(NSMutableDictionary *)options  withBlock:(PBNodeOrganize_ResponseBlock)block
{
    return [self storeNodeListInternalBase:options blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)storeNodeListAsync_:(NSMutableDictionary *)options withBlock:(PBNodeOrganize_ResponseBlock)block
{
    return [self storeNodeListInternalBase:options blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)storeNodeListInternalBase:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    //getList organizations/StoreOrg/organizes
    NSString *method = [NSString stringWithFormat:@"StoreOrg/nodes%@", _apiKeyParam];
    NSString *_id = [options objectForKey:@"id"];
    NSString *organize = [options objectForKey:@"organize_id"];
    NSString *parent = [options objectForKey:@"parent_id"];
    NSString *search = [options objectForKey:@"search"];
    NSString *sort = [options objectForKey:@"sort"];
    NSString *order = [options objectForKey:@"order"];
    NSString *offset = [options objectForKey:@"offset"];
    NSString *limit = [options objectForKey:@"limit"];
    
    method = _id == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&id=%@",_id]];
    method = organize == nil? method : [method stringByAppendingString:[NSString stringWithFormat:@"&organize_id=%@",organize]];
    method = parent == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&parent_id=%@",parent]];
    method = search == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&search=%@",search]];
    method = sort == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&sort=%@",sort]];
    method = order == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&order=%@",order]];
    method = offset == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&offset=%@",offset]];
    method = limit == nil? method : [method stringByAppendingString:[NSString stringWithFormat:@"&limit=%@",limit]];
    
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_nodeOrganize andResponse:response];
    
    
}
-(PBRequestUnit *)childNodeList:(NSString *)node_id layer:(NSString *)layer withDelegate:(id<PBNodeOrganize_ResponseHandler>)delegate
{
    return [self childNodeListInternalBase:node_id layer:layer blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)childNodeList:(NSString *)node_id layer:(NSString *)layer withBlock:(PBNodeOrganize_ResponseBlock)block
{
    return [self childNodeListInternalBase:node_id layer:layer blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)childNodeListAsync:(NSString *)node_id layer:(NSString *)layer withDelegate:(id<PBNodeOrganize_ResponseHandler>)delegate
{
    return [self childNodeListInternalBase:node_id layer:layer blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)childNodeListAsync:(NSString *)node_id layer:(NSString *)layer  withBlock:(PBNodeOrganize_ResponseBlock)block
{
    return [self childNodeListInternalBase:node_id layer:layer blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)childNodeListAsync_:(NSString *)node_id layer:(NSString *)layer withBlock:(PBNodeOrganize_ResponseBlock)block
{
    return [self childNodeListInternalBase:node_id layer:layer blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)childNodeListInternalBase:(NSString *)node_id layer:(NSString *)layer blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    layer = !layer ? @":layer" : layer;
    NSString *method = [NSString stringWithFormat:@"StoreOrg/nodes/%@/getChildNode/%@%@",node_id,layer,_apiKeyParam];
    
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_nodeOrganize andResponse:response];
    
    
}
-(PBRequestUnit *)playerListFromNode:(NSString *)node_id role:(NSString *)role withDelegate:(id<PBPlayerListFromNode_ResponseHandler>)delegate
{
    return [self playerListFromNodeInternalBase:node_id role:role blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerListFromNode:(NSString *)node_id role:(NSString *)role withBlock:(PBPlayerListFromNode_ResponseBlock)block
{
    return [self playerListFromNodeInternalBase:node_id role:role blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerListFromNodeAsync:(NSString *)node_id role:(NSString *)role withDelegate:(id<PBPlayerListFromNode_ResponseHandler>)delegate
{
    return [self playerListFromNodeInternalBase:node_id role:role blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerListFromNodeAsync:(NSString *)node_id role:(NSString *)role  withBlock:(PBPlayerListFromNode_ResponseBlock)block
{
    return [self playerListFromNodeInternalBase:node_id role:role blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerListFromNodeAsync_:(NSString *)node_id role:(NSString *)role withBlock:(PBPlayerListFromNode_ResponseBlock)block
{
    return [self playerListFromNodeInternalBase:node_id role:role blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerListFromNodeInternalBase:(NSString *)node_id role:(NSString *)role blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    
    NSString *method = [NSString stringWithFormat:@"StoreOrg/players/%@%@",node_id,_apiKeyParam];
    method = role == nil? method : [method stringByAppendingString:[NSString stringWithFormat:@"&role=%@",role]];
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_playerListFromNode andResponse:response];
    
    
}
-(PBRequestUnit *)saleHistory:(NSString *)node_id count:(NSString *)count options:(NSMutableDictionary *)options withDelegate:(id<PBSaleHistory_ResponseHandler>)delegate
{
    return [self saleHistoryInternalBase:node_id count:count options:options blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)saleHistory:(NSString *)node_id count:(NSString *)count options:(NSMutableDictionary *)options withBlock:(PBSaleHistory_ResponseBlock)block
{
    return [self saleHistoryInternalBase:node_id count:count options:options blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)saleHistoryAsync:(NSString *)node_id count:(NSString *)count options:(NSMutableDictionary *)options withDelegate:(id<PBSaleHistory_ResponseHandler>)delegate
{
    return [self saleHistoryInternalBase:node_id count:count options:options blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)saleHistoryAsync:(NSString *)node_id count:(NSString *)count options:(NSMutableDictionary *)options  withBlock:(PBSaleHistory_ResponseBlock)block
{
    return [self saleHistoryInternalBase:node_id count:count options:options blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)saleHistoryAsync_:(NSString *)node_id count:(NSString *)count options:(NSMutableDictionary *)options withBlock:(PBSaleHistory_ResponseBlock)block
{
    return [self saleHistoryInternalBase:node_id count:count options:options blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)saleHistoryInternalBase:(NSString *)node_id count:(NSString *)count options:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *month = [options objectForKey:@"month"];
    NSString *year = [options objectForKey:@"year"];
    NSString *action = [options objectForKey:@"action"];
    NSString *parameter = [options objectForKey:@"parameter"];
    
    NSString *method =  [NSString stringWithFormat:@"StoreOrg/nodes/%@/saleHistory/%@%@",node_id,count,_apiKeyParam];
    
    method = month == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&month=%@",month]];
    method = year  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&year=%@",year]];
    method = action  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&action=%@",action]];
    method = parameter  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&parameter=%@",parameter]];
    
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_saleHistory andResponse:response];
    
    
}
////Sale Board
-(PBRequestUnit *)saleBoard:(NSString *)node_id layer:(NSString *)layer options:(NSMutableDictionary *)options withDelegate:(id<PBSaleBoard_ResponseHandler>)delegate
{
    return [self saleBoardInternalBase:node_id layer:layer options:options blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)saleBoard:(NSString *)node_id layer:(NSString *)layer options:(NSMutableDictionary *)options withBlock:(PBSaleBoard_ResponseBlock)block
{
    return [self saleBoardInternalBase:node_id layer:layer options:options blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)saleBoardAsync:(NSString *)node_id layer:(NSString *)layer options:(NSMutableDictionary *)options withDelegate:(id<PBSaleBoard_ResponseHandler>)delegate
{
    return [self saleBoardInternalBase:node_id layer:layer options:options blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)saleBoardAsync:(NSString *)node_id layer:(NSString *)layer options:(NSMutableDictionary *)options  withBlock:(PBSaleBoard_ResponseBlock)block
{
    return [self saleBoardInternalBase:node_id layer:layer options:options blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)saleBoardAsync_:(NSString *)node_id layer:(NSString *)layer options:(NSMutableDictionary *)options withBlock:(PBSaleBoard_ResponseBlock)block
{
    return [self saleBoardInternalBase:node_id layer:layer options:options blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)saleBoardInternalBase:(NSString *)node_id layer:(NSString *)layer options:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *month = [options objectForKey:@"month"];
    NSString *year = [options objectForKey:@"year"];
    NSString *action = [options objectForKey:@"action"];
    NSString *parameter = [options objectForKey:@"parameter"];
    
    NSString *method =  [NSString stringWithFormat:@"StoreOrg/nodes/%@/saleBoard/%@%@",node_id,layer,_apiKeyParam];
    
    method = month == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&month=%@",month]];
    method = year  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&year=%@",year]];
    method = action  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&action=%@",action]];
    method = parameter  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&parameter=%@",parameter]];
    
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_saleBoard andResponse:response];
    
    
}
////LeaderBoard
-(PBRequestUnit *)leaderBoard:(NSString *)node_id rank:(NSString *)rank options:(NSMutableDictionary *)options withDelegate:(id<PBLeaderBoard_ResponseHandler>)delegate;
{
    return [self leaderBoardInternalBase:node_id rank:rank options:options blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)leaderBoard:(NSString *)node_id rank:(NSString *)rank options:(NSMutableDictionary *)options withBlock:(PBLeaderBoard_ResponseBlock)block;
{
    return [self leaderBoardInternalBase:node_id rank:rank options:options blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)leaderBoardAsync:(NSString *)node_id rank:(NSString *)rank options:(NSMutableDictionary *)options withDelegate:(id<PBLeaderBoard_ResponseHandler>)delegate;
{
    return [self leaderBoardInternalBase:node_id rank:rank options:options blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
 -(PBRequestUnit *)leaderBoardAsync:(NSString *)node_id rank:(NSString *)rank options:(NSMutableDictionary *)options  withBlock:(PBLeaderBoard_ResponseBlock)block;
{
    return [self leaderBoardInternalBase:node_id rank:rank options:options blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)leaderBoardAsync_:(NSString *)node_id rank:(NSString *)rank options:(NSMutableDictionary *)options withBlock:(PBLeaderBoard_ResponseBlock)block;
{
    return [self leaderBoardInternalBase:node_id rank:rank options:options blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)leaderBoardInternalBase:(NSString *)node_id rank:(NSString *)rank options:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *month = [options objectForKey:@"month"];
    NSString *year = [options objectForKey:@"year"];
    NSString *role = [options objectForKey:@"role"];
    NSString *player_id = [options objectForKey:@"player_id"];
    NSString *limit = [options objectForKey:@"limit"];
    NSString *under_org = [options objectForKey:@"under_org"];
    
    NSString *method =  [NSString stringWithFormat:@"StoreOrg/rankPeer/%@/%@%@",node_id,rank,_apiKeyParam];
    
    method = month == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&month=%@",month]];
    method = year  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&year=%@",year]];
    method = role  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&role=%@",role]];
    method = player_id  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&player_id=%@",player_id]];
    method = limit  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&limit=%@",limit]];
    method = under_org  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&under_org=%@",under_org]];
    
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_leaderBoard andResponse:response];
    
    
}
////LeaderBoard By Action
-(PBRequestUnit *)leaderBoardByAction:(NSString *)node_id action:(NSString *)action parameter:(NSString *)parameter options:(NSMutableDictionary *)options withDelegate:(id<PBLeaderBoard_ResponseHandler>)delegate;
{
    return [self leaderBoardByActionInternalBase:node_id action:action parameter:parameter options:options blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)leaderBoardByAction:(NSString *)node_id action:(NSString *)action parameter:(NSString *)parameter options:(NSMutableDictionary *)options withBlock:(PBLeaderBoard_ResponseBlock)block;
{
    return [self leaderBoardByActionInternalBase:node_id action:action parameter:parameter options:options blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)leaderBoardByActionAsync:(NSString *)node_id action:(NSString *)action parameter:(NSString *)parameter options:(NSMutableDictionary *)options withDelegate:(id<PBLeaderBoard_ResponseHandler>)delegate;
{
    return [self leaderBoardByActionInternalBase:node_id action:action parameter:parameter options:options blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)leaderBoardByActionAsync:(NSString *)node_id action:(NSString *)action parameter:(NSString *)parameter options:(NSMutableDictionary *)options  withBlock:(PBLeaderBoard_ResponseBlock)block;
{
    return [self leaderBoardByActionInternalBase:node_id action:action parameter:parameter options:options blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)leaderBoardByActionAsync_:(NSString *)node_id action:(NSString *)action parameter:(NSString *)parameter options:(NSMutableDictionary *)options withBlock:(PBLeaderBoard_ResponseBlock)block;
{
    return [self leaderBoardByActionInternalBase:node_id action:action parameter:parameter options:options blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)leaderBoardByActionInternalBase:(NSString *)node_id action:(NSString *)action parameter:(NSString *)parameter options:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *month = [options objectForKey:@"month"];
    NSString *year = [options objectForKey:@"year"];
    NSString *player_id = [options objectForKey:@"player_id"];
    NSString *limit = [options objectForKey:@"limit"];
    NSString *role = [options objectForKey:@"role"];
    
    NSString *method =  [NSString stringWithFormat:@"StoreOrg/rankPeerByAccAction/%@/%@/%@%@",node_id,action,parameter,_apiKeyParam];
    method = role  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&role=%@",role]];
    method = month == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&month=%@",month]];
    method = year  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&year=%@",year]];
    method = player_id  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&player_id=%@",player_id]];
    method = limit  == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&limit=%@",limit]];
    
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_leaderBoardByAction andResponse:response];
    
    
}
//// Get Content
-(PBRequestUnit *)getContent:(NSMutableDictionary *)options withDelegate:(id<PBContent_ResponseHandler>)delegate
{
    return [self getContentInternalBase:options blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)getContent:(NSMutableDictionary *)options withBlock:(PBContent_ResponseBlock)block
{
    return [self getContentInternalBase:options blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)getContentAsync:(NSMutableDictionary *)options withDelegate:(id<PBContent_ResponseHandler>)delegate
{
    return [self getContentInternalBase:options blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)getContentAsync:(NSMutableDictionary *)options  withBlock:(PBContent_ResponseBlock)block
{
    return [self getContentInternalBase:options blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)getContentAsync_:(NSMutableDictionary *)options withBlock:(PBContent_ResponseBlock)block
{
    return [self getContentInternalBase:options blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)getContentInternalBase:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    //getList organizations/StoreOrg/organizes
    NSString *method = [NSString stringWithFormat:@"Content%@", _apiKeyParam];
    
    NSString *_id = [options objectForKey:@"_id"];
    NSString *name = [options objectForKey:@"name"];
    NSString *category = [options objectForKey:@"category"];
    NSString *date_check = [options objectForKey:@"date_check"];
    NSString *sort = [options objectForKey:@"sort"];
    NSString *order = [options objectForKey:@"order"];
    NSString *offset = [options objectForKey:@"offset"];
    NSString *limit = [options objectForKey:@"limit"];
    NSString *fullHtml = [options objectForKey:@"full_html"];
    
    
    method = _id == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&id=%@",_id]];
    method = name == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&name=%@",name]];
    method = category == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&category=%@",category]];
    method = date_check == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&date_check=%@",date_check]];
    method = sort == nil? method : [method stringByAppendingString:[NSString stringWithFormat:@"&sort=%@",sort]];
    method = order == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&order=%@",order]];
    method = offset == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&offset=%@",offset]];
    method = limit == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&limit=%@",limit]];
    method = fullHtml == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&full_html=%@",fullHtml]];
    
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_content andResponse:response];
    
    
}
//// Count Content
-(PBRequestUnit *)countContent:(NSMutableDictionary *)options withDelegate:(id<PBContent_ResponseHandler>)delegate
{
    return [self countContentInternalBase:options blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)countContent:(NSMutableDictionary *)options withBlock:(PBContent_ResponseBlock)block
{
    return [self countContentInternalBase:options blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)countContentAsync:(NSMutableDictionary *)options withDelegate:(id<PBContent_ResponseHandler>)delegate
{
    return [self countContentInternalBase:options blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)countContentAsync:(NSMutableDictionary *)options  withBlock:(PBContent_ResponseBlock)block
{
    return [self countContentInternalBase:options blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)countContentAsync_:(NSMutableDictionary *)options withBlock:(PBContent_ResponseBlock)block
{
    return [self countContentInternalBase:options blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)countContentInternalBase:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    //getList organizations/StoreOrg/organizes
    NSString *method = [NSString stringWithFormat:@"Content/count%@", _apiKeyParam];
    
    NSString *category = [options objectForKey:@"category"];
    NSString *player_exclude = [options objectForKey:@"player_exclude"];
    
    method = category == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&category=%@",category]];
    method = player_exclude == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&player_exclude=%@",player_exclude]];
    
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_content andResponse:response];
    
    
}
//// Create Content
//
// @param	...[vararg]     Varargs of String for additional parameters to be sent to the create method.
// 							Each element is a string in the format of key=value, for example: category=news
// 							The following keys are supported:
// 							- image
// 							- status
// 							- date_start    format YYYY-MM-DD (ex.1982-09-29)
//							- date_end      format YYYY-MM-DD (ex.1982-09-29)
// 							- player_id
// 							- pin
// 							- tags          Specific tag(s) to add (e.g. foo,bar)
// 							- key           custom field keys separated by comma
//                          - value         custom field values separated by comma

-(PBRequestUnit *)createContentWithTitle:(NSString *)title summary:(NSString *)summary detail:(NSString *)detail andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self createContentWithTitleInternalBase:title summary:summary detail:detail blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)createContentWithTitle:(NSString *)title summary:(NSString *)summary detail:(NSString *)detail andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self createContentWithTitleInternalBase:title summary:summary detail:detail blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)createContentWithTitleAsync:(NSString *)title summary:(NSString *)summary detail:(NSString *)detail andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self createContentWithTitleInternalBase:title summary:summary detail:detail blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)createContentWithTitleAsync:(NSString *)title summary:(NSString *)summary detail:(NSString *)detail andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self createContentWithTitleInternalBase:title summary:summary detail:detail blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)createContentWithTitleAsync_:(NSString *)title summary:(NSString *)summary detail:(NSString *)detail andBlock:(PBAsyncURLRequestResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self createContentWithTitleInternalBase:title summary:summary detail:detail blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)createContentWithTitleInternalBase:(NSString *)title summary:(NSString *)summary detail:(NSString *)detail blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response withParams:(va_list)params
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Content/addContent%@", _apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@&title=%@&summary=%@&detail=%@", _token, title, summary, detail];
    
    // create data final that will be used at the end of the process
    NSString *dataFinal = nil;
    
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
        // create a data final
        dataFinal = [NSString stringWithString:data];
    }
    else
    {
        // form async url request data
        dataFinal = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:dataFinal responseType:responseType_registerUser andResponse:response];
}
//// Update Content
//
// @param	...[vararg]     Varargs of String for additional parameters to be sent to the create method.
// 							Each element is a string in the format of key=value, for example: title = sample title
// 							The following keys are supported:
//                          - summary
//                          - detail
//                          - category
// 							- image
// 							- status
// 							- date_start    format YYYY-MM-DD (ex.1982-09-29)
//							- date_end      format YYYY-MM-DD (ex.1982-09-29)
// 							- player_id
// 							- pin
// 							- tags          Specific tag(s) to add (e.g. foo,bar)
// 							- key           custom field keys separated by comma
//                          - value         custom field values separated by comma

-(PBRequestUnit *)updateContent:(NSString *)content_id andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self updateContentInternalBase:content_id blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)updateContent:(NSString *)content_id andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self updateContentInternalBase:content_id blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)updateContentAsync:(NSString *)content_id andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self updateContentInternalBase:content_id blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)updateContentAsync:(NSString *)content_id andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self updateContentInternalBase:content_id blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)updateContentAsync_:(NSString *)content_id andBlock:(PBAsyncURLRequestResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self updateContentInternalBase:content_id blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)updateContentInternalBase:(NSString *)content_id blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response withParams:(va_list)params
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Content/%@/update%@", content_id,_apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@", _token];
    
    // create data final that will be used at the end of the process
    NSString *dataFinal = nil;
    
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
        // create a data final
        dataFinal = [NSString stringWithString:data];
    }
    else
    {
        // form async url request data
        dataFinal = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:dataFinal responseType:responseType_registerUser andResponse:response];
}
// Delete Content
-(PBRequestUnit *)deleteContent:(NSString *)content_id withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self deleteContentInternalBase:content_id blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)deleteContent:(NSString *)content_id withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self deleteContentInternalBase:content_id blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deleteContentAsync:(NSString *)content_id withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self deleteContentInternalBase:content_id blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)deleteContentAsync:(NSString *)content_id withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self deleteContentInternalBase:content_id blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deleteContentAsync_:(NSString *)content_id withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self deleteContentInternalBase:content_id blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deleteContentInternalBase:(NSString *)content_id blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Content/%@/delete%@", content_id, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", _token];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_deleteUser andResponse:response];
}

//// Get Content Category
-(PBRequestUnit *)getContentCategory:(NSMutableDictionary *)options withDelegate:(id<PBResponseHandler>)delegate
{
    return [self getContentCategoryInternalBase:options blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)getContentCategory:(NSMutableDictionary *)options withBlock:(PBResponseBlock)block
{
    return [self getContentCategoryInternalBase:options blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)getContentCategoryAsync:(NSMutableDictionary *)options withDelegate:(id<PBResponseHandler>)delegate
{
    return [self getContentCategoryInternalBase:options blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)getContentCategoryAsync:(NSMutableDictionary *)options  withBlock:(PBResponseBlock)block
{
    return [self getContentCategoryInternalBase:options blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)getContentCategoryInternalBase:(NSMutableDictionary *)options withBlock:(PBResponseBlock)block
{
    return [self getContentInternalBase:options blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)getContentCategoryInternalBase:(NSMutableDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    //getList organizations/StoreOrg/organizes
    NSString *method = [NSString stringWithFormat:@"Content/category%@", _apiKeyParam];
    
    NSString *_id = [options objectForKey:@"_id"];
    NSString *date_check = [options objectForKey:@"date_check"];
    NSString *sort = [options objectForKey:@"sort"];
    NSString *order = [options objectForKey:@"order"];
    NSString *offset = [options objectForKey:@"offset"];
    NSString *limit = [options objectForKey:@"limit"];
    
    
    method = _id == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&id=%@",_id]];
    method = date_check == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&date_check=%@",date_check]];
    method = sort == nil? method : [method stringByAppendingString:[NSString stringWithFormat:@"&sort=%@",sort]];
    method = order == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&order=%@",order]];
    method = offset == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&offset=%@",offset]];
    method = limit == nil ? method : [method stringByAppendingString:[NSString stringWithFormat:@"&limit=%@",limit]];
    
    NSString *data = nil;
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_normal andResponse:response];
    
    
}
//// Create Content Category
-(PBRequestUnit *)createContentCategory:(NSString *)name withDelegate:(id<PBResponseHandler>)delegate
{
    return [self createCategoryInternalBase:name blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)createContentCategory:(NSString *)name withBlock:(PBResponseBlock)block
{
    return [self createCategoryInternalBase:name blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)createContentCategoryAsync:(NSString *)name withDelegate:(id<PBResponseHandler>)delegate
{
    return [self createCategoryInternalBase:name blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)createContentCategoryAsync:(NSString *)name  withBlock:(PBResponseBlock)block
{
    return [self createCategoryInternalBase:name blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)createContentCategoryInternalBase:(NSString *)name withBlock:(PBResponseBlock)block
{
    return [self createCategoryInternalBase:name blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)createCategoryInternalBase:(NSString *)name blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Content/category/create%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&name=%@", _token,name];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_deleteUser andResponse:response];
    
    
}

//// Update Content Category
-(PBRequestUnit *)updateContentCategory:(NSString *)category_id name:(NSString *)name withDelegate:(id<PBResponseHandler>)delegate
{
    return [self updateCategoryInternalBase:category_id name:name blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)updateContentCategory:(NSString *)category_id name:(NSString *)name withBlock:(PBResponseBlock)block
{
    return [self updateCategoryInternalBase:category_id name:name blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)updateContentCategoryAsync:(NSString *)category_id name:(NSString *)name withDelegate:(id<PBResponseHandler>)delegate
{
    return [self updateCategoryInternalBase:category_id name:name blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)updateContentCategoryAsync:(NSString *)category_id name:(NSString *)name  withBlock:(PBResponseBlock)block
{
    return [self updateCategoryInternalBase:category_id name:name blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)updateContentCategoryInternalBase:(NSString *)category_id name:(NSString *)name  withBlock:(PBResponseBlock)block
{
    return [self updateCategoryInternalBase:category_id name:name blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)updateCategoryInternalBase:(NSString *)category_id name:(NSString *)name blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Content/category/update%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&id=%@&name=%@", _token,category_id,name];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_deleteUser andResponse:response];
    
    
}
//// Delete Content Category
-(PBRequestUnit *)deleteContentCategory:(NSString *)category_id withDelegate:(id<PBResponseHandler>)delegate
{
    return [self deleteCategoryInternalBase:category_id blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)deleteContentCategory:(NSString *)category_id withBlock:(PBResponseBlock)block
{
    return [self deleteCategoryInternalBase:category_id blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deleteContentCategoryAsync:(NSString *)category_id withDelegate:(id<PBResponseHandler>)delegate
{
    return [self deleteCategoryInternalBase:category_id blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)deleteContentCategoryAsync:(NSString *)category_id  withBlock:(PBResponseBlock)block
{
    return [self deleteCategoryInternalBase:category_id blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deleteContentCategoryInternalBase:(NSString *)category_id withBlock:(PBResponseBlock)block
{
    return [self deleteCategoryInternalBase:category_id blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)deleteCategoryInternalBase:(NSString *)category_id blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Content/category/delete%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&id=%@", _token,category_id];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_deleteUser andResponse:response];
    
    
}
//// Action Like Content
//
// @param	...[vararg]     Varargs of String for additional parameters to be sent to the create method.
// 							Each element is a string in the format of key=value, for example: 
// 							The following keys are supported:
// 							- key           custom field keys separated by comma
//                          - value         custom field values separated by comma

-(PBRequestUnit *)actionLikeContent:(NSString *)content_id player_id:(NSString *)player_id andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self actionLikeContentInternalBase:content_id player_id:player_id blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)actionLikeContent:(NSString *)content_id player_id:(NSString *)player_id andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self actionLikeContentInternalBase:content_id player_id:player_id blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)actionLikeContentAsync:(NSString *)content_id player_id:(NSString *)player_id andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self actionLikeContentInternalBase:content_id player_id:player_id blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)actionLikeContentAsync:(NSString *)content_id player_id:(NSString *)player_id andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self actionLikeContentInternalBase:content_id player_id:player_id blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)actionLikeContentAsync_:(NSString *)content_id player_id:(NSString *)player_id andBlock:(PBAsyncURLRequestResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self actionLikeContentInternalBase:content_id player_id:player_id blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)actionLikeContentInternalBase:(NSString *)content_id player_id:(NSString *)player_id blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response withParams:(va_list)params
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Content/%@/player/%@/like%@",content_id,player_id,_apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@", _token];
    
    // create data final that will be used at the end of the process
    NSString *dataFinal = nil;
    
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
        // create a data final
        dataFinal = [NSString stringWithString:data];
    }
    else
    {
        // form async url request data
        dataFinal = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:dataFinal responseType:responseType_registerUser andResponse:response];
}
//// Action DisLike Content
//
// @param	...[vararg]     Varargs of String for additional parameters to be sent to the create method.
// 							Each element is a string in the format of key=value, for example:
// 							The following keys are supported:
// 							- key           custom field keys separated by comma
//                          - value         custom field values separated by comma

-(PBRequestUnit *)actionDisLikeContent:(NSString *)content_id player_id:(NSString *)player_id andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self actionDisLikeContentInternalBase:content_id player_id:player_id blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)actionDisLikeContent:(NSString *)content_id player_id:(NSString *)player_id andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self actionDisLikeContentInternalBase:content_id player_id:player_id blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)actionDisLikeContentAsync:(NSString *)content_id player_id:(NSString *)player_id andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self actionDisLikeContentInternalBase:content_id player_id:player_id blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)actionDisLikeContentAsync:(NSString *)content_id player_id:(NSString *)player_id andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self actionDisLikeContentInternalBase:content_id player_id:player_id blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)actionDisLikeContentAsync_:(NSString *)content_id player_id:(NSString *)player_id andBlock:(PBAsyncURLRequestResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self actionDisLikeContentInternalBase:content_id player_id:player_id blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)actionDisLikeContentInternalBase:(NSString *)content_id player_id:(NSString *)player_id blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response withParams:(va_list)params
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Content/%@/player/%@/dislike%@",content_id,player_id,_apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@", _token];
    
    // create data final that will be used at the end of the process
    NSString *dataFinal = nil;
    
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
        // create a data final
        dataFinal = [NSString stringWithString:data];
    }
    else
    {
        // form async url request data
        dataFinal = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:dataFinal responseType:responseType_registerUser andResponse:response];
}
//// Give Feedback Content
//
// @param	...[vararg]     Varargs of String for additional parameters to be sent to the create method.
// 							Each element is a string in the format of key=value, for example:
// 							The following keys are supported:
// 							- key           custom field keys separated by comma
//                          - value         custom field values separated by comma

-(PBRequestUnit *)giveFeedbackContent:(NSString *)content_id player_id:(NSString *)player_id feedback:(NSString *)feedback andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self giveFeedbackContentInternalBase:content_id player_id:player_id feedback:feedback blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)giveFeedbackContent:(NSString *)content_id player_id:(NSString *)player_id feedback:(NSString *)feedback andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self giveFeedbackContentInternalBase:content_id player_id:player_id feedback:feedback blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)giveFeedbackContentAsync:(NSString *)content_id player_id:(NSString *)player_id feedback:(NSString *)feedback andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self giveFeedbackContentInternalBase:content_id player_id:player_id feedback:feedback blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)giveFeedbackContentAsync:(NSString *)content_id player_id:(NSString *)player_id feedback:(NSString *)feedback andBlock:(PBResultStatus_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self giveFeedbackContentInternalBase:content_id player_id:player_id feedback:feedback blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)giveFeedbackContentAsync_:(NSString *)content_id player_id:(NSString *)player_id feedback:(NSString *)feedback andBlock:(PBAsyncURLRequestResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    return [self giveFeedbackContentInternalBase:content_id player_id:player_id feedback:feedback blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)giveFeedbackContentInternalBase:(NSString *)content_id player_id:(NSString *)player_id feedback:(NSString *)feedback blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response withParams:(va_list)params
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Content/%@/player/%@/feedback%@",content_id,player_id,_apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@", _token];
    
    // create data final that will be used at the end of the process
    NSString *dataFinal = nil;
    
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
        // create a data final
        dataFinal = [NSString stringWithString:data];
    }
    else
    {
        // form async url request data
        dataFinal = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:dataFinal responseType:responseType_registerUser andResponse:response];
}

//// Get Player Associate Node
-(PBRequestUnit *)getAssociatedNode:(NSString *)playerId withDelegate:(id<PBAssociatedNode_ResponseHandler>)delegate
{
    return [self getAssociatedNodeInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)getAssociatedNode:(NSString *)playerId withBlock:(PBAssociatedNode_ResponseBlock)block
{
    return [self getAssociatedNodeInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)getAssociatedNodeAsync:(NSString *)playerId withDelegate:(id<PBAssociatedNode_ResponseHandler>)delegate
{
    return [self getAssociatedNodeInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)getAssociatedNodeAsync:(NSString *)playerId withBlock:(PBAssociatedNode_ResponseBlock)block
{
    return [self getAssociatedNodeInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
- (PBRequestUnit *)getAssociatedNodeInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/getAssociatedNode%@", playerId, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_associated andResponse:response];
}
///////Get Player Role

-(PBRequestUnit *)playerRole:(NSString *)playerId nodeId:(NSString *)node withDelegate:(id<PBPlayerRole_ResponseHandler>)delegate
{
    return [self playerRoleInternalBase:playerId nodeId:node blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerRole:(NSString *)playerId nodeId:(NSString *)node withBlock:(PBPlayerRole_ResponseBlock)block
{
    return [self playerRoleInternalBase:playerId nodeId:(NSString *)node blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)playerRoleAsync:(NSString *)playerId nodeId:(NSString *)node withDelegate:(id<PBPlayer_ResponseHandler>)delegate
{
    return [self playerRoleInternalBase:playerId nodeId:(NSString *)node blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)playerRoleAsync:(NSString *)playerId nodeId:(NSString *)node withBlock:(PBPlayerRole_ResponseBlock)block
{
    return [self playerRoleInternalBase:playerId nodeId:(NSString *)node blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
- (PBRequestUnit *)playerRoleInternalBase:(NSString *)playerId nodeId:(NSString *)node blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/getRole/%@%@", playerId,node, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_playerRole andResponse:response];
}
///////Add Player to Node
-(PBRequestUnit *)addPlayerToNode:(NSString *)nodeId playerId:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self addPlayerToNodeInternalBase:nodeId playerId:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)addPlayerToNode:(NSString *)nodeId playerId:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self addPlayerToNodeInternalBase:nodeId playerId:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)addPlayerToNodeAsync:(NSString *)nodeId playerId:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self addPlayerToNodeInternalBase:nodeId playerId:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)addPlayerToNodeAsync:(NSString *)nodeId playerId:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self addPlayerToNodeInternalBase:nodeId playerId:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)addPlayerToNodeInternalBase:(NSString *)nodeId playerId:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"StoreOrg/nodes/%@/addPlayer/%@%@", nodeId,playerId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", _token];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}
///////Remove Player to Node
-(PBRequestUnit *)removePlayerToNode:(NSString *)nodeId playerId:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self removePlayerToNodeInternalBase:nodeId playerId:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)removePlayerToNode:(NSString *)nodeId playerId:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self removePlayerToNodeInternalBase:nodeId playerId:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)removePlayerToNodeAsync:(NSString *)nodeId playerId:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self removePlayerToNodeInternalBase:nodeId playerId:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)removePlayerToNodeAsync:(NSString *)nodeId playerId:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self removePlayerToNodeInternalBase:nodeId playerId:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)removePlayerToNodeInternalBase:(NSString *)nodeId playerId:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    
    //removePlayer/:player_id

    NSString *method = [NSString stringWithFormat:@"StoreOrg/nodes/%@/removePlayer/%@%@", nodeId,playerId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", _token];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];


}

///////Set Player Role.
-(PBRequestUnit *)setPlayerRole:(NSString *)nodeId playerId:(NSString *)playerId role:(NSString *)role withDelegate:(id<PBResponseHandler>)delegate
{
    return [self setPlayerRoleInternalBase:nodeId playerId:playerId role:role blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)setPlayerRole:(NSString *)nodeId playerId:(NSString *)playerId role:(NSString *)role withBlock:(PBResponseBlock)block
{
    return [self setPlayerRoleInternalBase:nodeId playerId:playerId role:role blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)setPlayerRoleAsync:(NSString *)nodeId playerId:(NSString *)playerId role:(NSString *)role withDelegate:(id<PBResponseHandler>)delegate
{
    return [self setPlayerRoleInternalBase:nodeId playerId:playerId role:role blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)setPlayerRoleAsync:(NSString *)nodeId playerId:(NSString *)playerId role:(NSString *)role withBlock:(PBResponseBlock)block
{
    return [self setPlayerRoleInternalBase:nodeId playerId:playerId role:role blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)setPlayerRoleInternalBase:(NSString *)nodeId playerId:(NSString *)playerId role:(NSString *)role blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    
    NSString *method = [NSString stringWithFormat:@"StoreOrg/nodes/%@/setPlayerRole/%@%@", nodeId,playerId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&role=%@", _token,role];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];


}

///////UnSet Player Role.
-(PBRequestUnit *)unsetPlayerRole:(NSString *)nodeId playerId:(NSString *)playerId role:(NSString *)role withDelegate:(id<PBResponseHandler>)delegate
{
    return [self unsetPlayerRoleInternalBase:nodeId playerId:playerId role:role blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)unsetPlayerRole:(NSString *)nodeId playerId:(NSString *)playerId role:(NSString *)role withBlock:(PBResponseBlock)block
{
    return [self unsetPlayerRoleInternalBase:nodeId playerId:playerId role:role blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)unsetPlayerRoleAsync:(NSString *)nodeId playerId:(NSString *)playerId role:(NSString *)role withDelegate:(id<PBResponseHandler>)delegate
{
    return [self unsetPlayerRoleInternalBase:nodeId playerId:playerId role:role blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)unsetPlayerRoleAsync:(NSString *)nodeId playerId:(NSString *)playerId role:(NSString *)role withBlock:(PBResponseBlock)block
{
    return [self unsetPlayerRoleInternalBase:nodeId playerId:playerId role:role blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)unsetPlayerRoleInternalBase:(NSString *)nodeId playerId:(NSString *)playerId role:(NSString *)role blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");

    //unsetPlayerRole/:player_id

    NSString *method = [NSString stringWithFormat:@"StoreOrg/nodes/%@/unsetPlayerRole/%@%@", nodeId,playerId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&role=%@", _token,role];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];


}
///////Send Email.
-(PBRequestUnit *)sendEmail:(NSString *)from to:(NSString *)to bcc:(NSString *)bcc subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self sendEmailInternalBase:from to:to bcc:bcc subject:subject message:message blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];

}
-(PBRequestUnit *)sendEmail:(NSString *)from to:(NSString *)to bcc:(NSString *)bcc subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self sendEmailInternalBase:from to:to bcc:bcc subject:subject message:message blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailAsync:(NSString *)from to:(NSString *)to bcc:(NSString *)bcc subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self sendEmailInternalBase:from to:to bcc:bcc subject:subject message:message blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendEmailAsync:(NSString *)from to:(NSString *)to bcc:(NSString *)bcc subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self sendEmailInternalBase:from to:to bcc:bcc subject:subject message:message blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailInternalBase:(NSString *)from to:(NSString *)to bcc:(NSString *)bcc subject:(NSString *)subject message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    
    //unsetPlayerRole/:player_id
    
    NSString *method = [NSString stringWithFormat:@"Email/sendTo%@",_apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&from=%@&to=%@&bcc=%@&subject=%@&message=%@", _token,from,to,bcc,subject,message];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
    
    
}

/////// upload photo for player
-(PBRequestUnit *)uploadImageAsync:(NSData *)image withBlock:(PBResponseBlock)block
{
    return [self uploadImageInternalBase:image blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)uploadImageInternalBase:(NSData *)image blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    
    //unsetPlayerRole/:player_id
    
    NSString *method = [NSString stringWithFormat:@"File/upload/"];
    NSString *data = [NSString stringWithFormat:@"token=%@&image=%@", _token,image];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}


//
// @param	...[vararg]     Varargs of String for additional parameters to be sent to the rule method.
// 							Each element is a string in the format of key=value, for example: url=playbasis.com
// 							The following keys are supported:
// 							- url		url or filter string (for triggering non-global actions)
// 							- reward	name of the custom-point reward to give (for triggering rules with custom-point reward)
// 							- quantity	amount of points to give (for triggering rules with custom-point reward)
//
-(PBRequestUnit *)ruleForPlayer:(NSString *)playerId action:(NSString *)action withDelegate:(id<PBRule_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    return [self ruleForPlayerInternalBase:playerId action:action blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    va_end(argumentList);
}
-(PBRequestUnit *)ruleForPlayer:(NSString *)playerId action:(NSString *)action withBlock:(PBRule_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    
    return [self ruleForPlayerInternalBase:playerId action:action blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    
    va_end(argumentList);
}
-(PBRequestUnit *)ruleForPlayerAsync:(NSString *)playerId action:(NSString *)action withDelegate:(id<PBRule_ResponseHandler>)delegate, ...
{
    va_list argumentList;
    va_start(argumentList, delegate);
    
    return [self ruleForPlayerInternalBase:playerId action:action blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate withParams:argumentList];
    
    va_end(argumentList);
}
-(PBRequestUnit *)ruleForPlayerAsync:(NSString *)playerId action:(NSString *)action withBlock:(PBRule_ResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    
    return [self ruleForPlayerInternalBase:playerId action:action blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block withParams:argumentList];
    
    va_end(argumentList);
}
-(PBRequestUnit *)ruleForPlayerAsync_:(NSString *)playerId action:(NSString *)action withBlock:(PBAsyncURLRequestResponseBlock)block, ...
{
    va_list argumentList;
    va_start(argumentList, block);
    
    return [self ruleForPlayerInternalBase:playerId action:action blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block withParams:argumentList];
    
    va_end(argumentList);
}

-(PBRequestUnit *)ruleForPlayerInternalBase:(NSString *)playerId action:(NSString *)action blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response withParams:(va_list)params
{
    NSAssert(_token, @"access token is nil");
    
    NSString *method = [NSString stringWithFormat:@"Engine/rule%@", _apiKeyParam];
    NSMutableString *data = [NSMutableString stringWithFormat:@"token=%@&player_id=%@&action=%@", _token, playerId, action];
    NSString *dataFinal = nil;
    
    if(params != nil)
    {
        id optionalData;
        while ((optionalData = va_arg(params, NSString *)))
        {
            [data appendFormat:@"&%@", optionalData];
        }
    }
    
    if(!syncUrl)
    {
        // convert back from mutable string
        dataFinal = [NSString stringWithString:data];
        // set back to final data
        dataFinal = [self formAsyncUrlRequestJsonDataStringFromData:dataFinal method:method];
    }
    else
    {
        // set data final to data
        dataFinal = [NSString stringWithString:data];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:dataFinal responseType:responseType_rule andResponse:response];
}

-(PBRequestUnit *)ruleDetailForPlayer:(NSString *)playeId ruleId:(NSString *)ruleId withDelegate:(id<PBRuleDetail_ResponseHandler>)delegate
{
    return [self ruleDetailInternalBase:playeId ruleId:ruleId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}

-(PBRequestUnit *)ruleDetailForPlayer:(NSString *)playeId ruleId:(NSString *)ruleId withBlock:(PBRuleDetail_ResponseBlock)block
{
    return [self ruleDetailInternalBase:playeId ruleId:ruleId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}

-(PBRequestUnit *)ruleDetailForPlayerAsync:(NSString *)playeId ruleId:(NSString *)ruleId withDelegate:(id<PBRuleDetail_ResponseHandler>)delegate
{
    return [self ruleDetailInternalBase:playeId ruleId:ruleId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}

-(PBRequestUnit *)ruleDetailForPlayerAsync:(NSString *)playeId ruleId:(NSString *)ruleId withBlock:(PBRuleDetail_ResponseBlock)block
{
    return [self ruleDetailInternalBase:playeId ruleId:ruleId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}

-(PBRequestUnit *)ruleDetailInternalBase:playeId ruleId:(NSString *)ruleId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
        NSString *method = @"";
        if((![playeId isEqualToString:@""])||(playeId != NULL))
        {
            method = [NSString stringWithFormat:@"Engine/rule/%@%@&player_id=%@", ruleId,_apiKeyParam,playeId];

        }else
        {
            method = [NSString stringWithFormat:@"Engine/rule/%@%@", ruleId, _apiKeyParam];
        }
        return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_ruleDetail andResponse:response];
}

-(PBRequestUnit *)questListWithDelegate:(id<PBQuestList_ResponseHandler>)delegate
{
    return [self questListInternalBase:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questListWithBlock:(PBQuestList_ResponseBlock)block
{
    return [self questListInternalBase:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questListWithDelegateAsync:(id<PBQuestList_ResponseHandler>)delegate
{
    return [self questListInternalBase:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questListWithBlockAsync:(PBQuestList_ResponseBlock)block
{
    return [self questListInternalBase:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questListInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quest%@", _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questList andResponse:response];
}

-(PBRequestUnit *)quest:(NSString *)questId withDelegate:(id<PBQuestInfo_ResponseHandler>)delegate
{
    return [self questInternalBase:questId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quest:(NSString *)questId withBlock:(PBQuestInfo_ResponseBlock)block
{
    return [self questInternalBase:questId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questAsync:(NSString *)questId withDelegate:(id<PBQuestInfo_ResponseHandler>)delegate
{
    return [self questInternalBase:questId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questAsync:(NSString *)questId withBlock:(PBQuestInfo_ResponseBlock)block
{
    return [self questInternalBase:questId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questInternalBase:(NSString *)questId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@%@", questId, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questInfo andResponse:response];
}

-(PBRequestUnit *)mission:(NSString *)missionId ofQuest:(NSString *)questId withDelegate:(id<PBMissionInfo_ResponseHandler>)delegate
{
    return [self missionInternalBase:missionId ofQuest:questId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)mission:(NSString *)missionId ofQuest:(NSString *)questId withBlock:(PBMissionInfo_ResponseBlock)block
{
    return [self missionInternalBase:missionId ofQuest:questId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)missionAsync:(NSString *)missionId ofQuest:(NSString *)questId withDelegate:(id<PBMissionInfo_ResponseHandler>)delegate
{
    return [self missionInternalBase:missionId ofQuest:questId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)missionAsync:(NSString *)missionId ofQuest:(NSString *)questId withBlock:(PBMissionInfo_ResponseBlock)block
{
    return [self missionInternalBase:missionId ofQuest:questId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)missionInternalBase:(NSString *)missionId ofQuest:(NSString *)questId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@/mission/%@%@", questId, missionId, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_missionInfo andResponse:response];
}

-(PBRequestUnit *)questListAvailableForPlayer:(NSString *)playerId withDelegate:(id<PBQuestListAvailableForPlayer_ResponseHandler>)delegate
{
    return [self questListAvailableForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questListAvailableForPlayer:(NSString *)playerId withBlock:(PBQuestListAvailableForPlayer_ResponseBlock)block
{
    return [self questListAvailableForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questListAvailableForPlayerAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self questListAvailableForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questListAvailableForPlayerAsync:(NSString *)playerId withBlock:(PBQuestListAvailableForPlayer_ResponseBlock)block
{
    return [self questListAvailableForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questListAvailableForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quest/available%@&player_id=%@", _apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questListAvailableForPlayer andResponse:response];
}

-(PBRequestUnit *)questAvailable:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestAvailableForPlayer_ResponseHandler>)delegate
{
    return [self questAvailableInternalBase:questId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questAvailable:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBQuestAvailableForPlayer_ResponseBlock)block
{
    return [self questAvailableInternalBase:questId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questAvailableAsync:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestAvailableForPlayer_ResponseHandler>)delegate
{
    return [self questAvailableInternalBase:questId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)questAvailableAsync:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBQuestAvailableForPlayer_ResponseBlock)block
{
    return [self questAvailableInternalBase:questId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)questAvailableInternalBase:(NSString *)questId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quest/%@/available%@&player_id=%@", questId, _apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questAvailableForPlayer andResponse:response];
}

-(PBRequestUnit *)joinQuest:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBJoinQuest_ResponseHandler>)delegate
{
    return [self joinQuestInternalBase:questId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)joinQuest:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBJoinQuest_ResponseBlock)block
{
    return [self joinQuestInternalBase:questId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)joinQuestAsync:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBJoinQuest_ResponseHandler>)delegate
{
    return [self joinQuestInternalBase:questId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)joinQuestAsync:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBJoinQuest_ResponseBlock)block
{
    return [self joinQuestInternalBase:questId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)joinQuestAsync_:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self joinQuestInternalBase:questId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)joinQuestInternalBase:(NSString *)questId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quest/%@/join%@", questId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@", _token, playerId];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_joinQuest andResponse:response];
}

-(PBRequestUnit *)joinAllQuestsForPlayer:(NSString *)playerId withDelegate:(id<PBJoinAllQuests_ResponseHandler>)delegate
{
    return [self joinAllQuestsForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)joinAllQuestsForPlayer:(NSString *)playerId withBlock:(PBJoinAllQuests_ResponseBlock)block
{
    return [self joinAllQuestsForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)joinAllQuestsForPlayerAsync:(NSString *)playerId withDelegate:(id<PBJoinAllQuests_ResponseHandler>)delegate
{
    return [self joinAllQuestsForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)joinAllQuestsForPlayerAsync:(NSString *)playerId withBlock:(PBJoinAllQuests_ResponseBlock)block
{
    return [self joinAllQuestsForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)joinAllQuestsForPlayerAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self joinAllQuestsForPlayerInternalBase:playerId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)joinAllQuestsForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quest/joinAll%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@", _token, playerId];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_joinAllQuests andResponse:response];
}

-(PBRequestUnit *)cancelQuest:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBCancelQuest_ResponseHandler>)delegate
{
    return [self cancelQuestInternalBase:questId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)cancelQuest:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBCancelQuest_ResponseBlock)block
{
    return [self cancelQuestInternalBase:questId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)cancelQuestAsync:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBCancelQuest_ResponseHandler>)delegate
{
    return [self cancelQuestInternalBase:questId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)cancelQuestAsync:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBCancelQuest_ResponseBlock)block
{
    return [self cancelQuestInternalBase:questId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)cancelQuestAsync_:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self cancelQuestInternalBase:questId forPlayer:playerId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)cancelQuestInternalBase:(NSString *)questId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quest/%@/cancel%@", questId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@", _token, playerId];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_cancelQuest andResponse:response];
}

-(PBRequestUnit *)redeemGoods:(NSString *)goodsId forPlayer:(NSString *)playerId withDelegate:(id<PBRedeemGoods_ResponseHandler>)delegate
{
    return [self redeemGoodsInternalBase:goodsId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)redeemGoods:(NSString *)goodsId forPlayer:(NSString *)playerId withBlock:(PBRedeemGoods_ResponseBlock)block
{
    return [self redeemGoodsInternalBase:goodsId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemGoodsAsync:(NSString *)goodsId forPlayer:(NSString *)playerId withDelegate:(id<PBRedeemGoods_ResponseHandler>)delegate
{
    return [self redeemGoodsInternalBase:goodsId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)redeemGoodsAsync:(NSString *)goodsId forPlayer:(NSString *)playerId withBlock:(PBRedeemGoods_ResponseBlock)block
{
    return [self redeemGoodsInternalBase:goodsId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemGoodsAsync_:(NSString *)goodsId forPlayer:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self redeemGoodsInternalBase:goodsId forPlayer:playerId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemGoodsInternalBase:(NSString *)goodsId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    
    NSString *method = [NSString stringWithFormat:@"Redeem/goods%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&goods_id=%@&player_id=%@", _token, goodsId, playerId];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_redeemGoods andResponse:response];
}

-(PBRequestUnit *)redeemGoods:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withDelegate:(id<PBRedeemGoods_ResponseHandler>)delegate
{
    return [self redeemGoodsInternalBase:goodsId forPlayer:playerId amount:amount blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)redeemGoods:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBRedeemGoods_ResponseBlock)block
{
    return [self redeemGoodsInternalBase:goodsId forPlayer:playerId amount:amount blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemGoodsAsync:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withDelegate:(id<PBRedeemGoods_ResponseHandler>)delegate
{
    return [self redeemGoodsInternalBase:goodsId forPlayer:playerId amount:amount blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)redeemGoodsAsync:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBRedeemGoods_ResponseBlock)block
{
    return [self redeemGoodsInternalBase:goodsId forPlayer:playerId amount:amount blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemGoodsAsync_:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self redeemGoodsInternalBase:goodsId forPlayer:playerId amount:amount blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemGoodsInternalBase:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    if(amount < 1){
        amount = 1;
    }
    NSString *method = [NSString stringWithFormat:@"Redeem/goods%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&goods_id=%@&player_id=%@&amount=%u", _token, goodsId, playerId, amount];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_redeemGoods andResponse:response];
}

-(PBRequestUnit *)redeemGoodsGroup:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withDelegate:(id<PBResponseHandler>)delegate
{
    return [self redeemGoodsGroupInternalBase:goodsId forPlayer:playerId group:group blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)redeemGoodsGroup:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withBlock:(PBResponseBlock)block
{
    return [self redeemGoodsGroupInternalBase:goodsId forPlayer:playerId group:group blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemGoodsGroupAsync:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withDelegate:(id<PBResponseHandler>)delegate
{
    return [self redeemGoodsGroupInternalBase:goodsId forPlayer:playerId group:group blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)redeemGoodsGroupAsync:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withBlock:(PBResponseBlock)block
{
    return [self redeemGoodsGroupInternalBase:goodsId forPlayer:playerId group:group blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemGoodsGroupAsync_:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withBlock:(PBResponseBlock)block
{
    return [self redeemGoodsGroupInternalBase:goodsId forPlayer:playerId group:group blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemGoodsGroupInternalBase:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    
    NSString *method = [NSString stringWithFormat:@"Redeem/goods%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&goods_id=%@&player_id=%@&group=%@", _token, goodsId, playerId, group];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequestUnit *)redeemGoodsGroup:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBResponseHandler>)delegate
{
    return [self redeemGoodsGroupInternalBase:goodsId forPlayer:playerId group:group amount:amount blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)redeemGoodsGroup:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBResponseBlock)block
{
    return [self redeemGoodsGroupInternalBase:goodsId forPlayer:playerId group:group amount:amount blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemGoodsGroupAsync:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBResponseHandler>)delegate
{
    return [self redeemGoodsGroupInternalBase:goodsId forPlayer:playerId group:group amount:amount blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)redeemGoodsGroupAsync:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBResponseBlock)block
{
    return [self redeemGoodsGroupInternalBase:goodsId forPlayer:playerId group:group amount:amount blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemGoodsGroupAsync_:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBResponseBlock)block
{
    return [self redeemGoodsGroupInternalBase:goodsId forPlayer:playerId group:group amount:amount blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)redeemGoodsGroupInternalBase:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    if(amount < 1){
        amount = 1;
    }
    NSString *method = [NSString stringWithFormat:@"Redeem/goods%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&goods_id=%@&player_id=%@&group=%@&amount=%u", _token, goodsId, playerId, group, amount];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}


-(PBRequestUnit *)recentPointWithOffset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate
{
    return [self recentPointWithOffsetInternalBase:offset limit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)recentPointWithOffset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block
{
    return [self recentPointWithOffsetInternalBase:offset limit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)recentPointWithOffsetAsync:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate
{
    return [self recentPointWithOffsetInternalBase:offset limit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)recentPointWithOffsetAsync:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block
{
    return [self recentPointWithOffsetInternalBase:offset limit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)recentPointWithOffsetInternalBase:(unsigned int)offset limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Service/recent_point%@&offset=%u&limit=%u", _apiKeyParam, offset, limit];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_recentPoint andResponse:response];
}

- (PBRequestUnit *)recentPointByName:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate
{
    return [self recentPointByNameInternalBase:pointName offset:offset limit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)recentPointByName:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block
{
    return [self recentPointByNameInternalBase:pointName offset:offset limit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)recentPointByNameAsync:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate
{
    return [self recentPointByNameInternalBase:pointName offset:offset limit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)recentPointByNameAsync:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block
{
    return [self recentPointByNameInternalBase:pointName offset:offset limit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)recentPointByNameInternalBase:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Service/recent_point%@&offset=%u&limit=%u&point_name=%@", _apiKeyParam, offset, limit, pointName];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_recentPoint andResponse:response];
}

-(PBRequestUnit *)resetPointForAllPlayersWithDelegate:(id<PBResetPoint_ResponseHandler>)delegate
{
    return [self resetPointForAllPlayersWithBlockingCallInternalBase:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)resetPointForAllPlayersWithBlock:(PBResetPoint_ResponseBlock)block
{
    return [self resetPointForAllPlayersWithBlockingCallInternalBase:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)resetPointForAllPlayersWithDelegateAsync:(id<PBResetPoint_ResponseHandler>)delegate
{
    return [self resetPointForAllPlayersWithBlockingCallInternalBase:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)resetPointForAllPlayersWithBlockAsync:(PBResetPoint_ResponseBlock)block
{
    return [self resetPointForAllPlayersWithBlockingCallInternalBase:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)resetPointForAllPlayersWithBlockAsync_:(PBAsyncURLRequestResponseBlock)block
{
    return [self resetPointForAllPlayersWithBlockingCallInternalBase:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)resetPointForAllPlayersWithBlockingCallInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Service/reset_point%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", _token];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_resetPoint andResponse:response];
}

-(PBRequestUnit *)resetPointForAllPlayersForPoint:(NSString *)pointName withDelegate:(id<PBResetPoint_ResponseHandler>)delegate
{
    return [self resetPointForAllPlayersForPointInternalBase:pointName blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)resetPointForAllPlayersForPoint:(NSString *)pointName withBlock:(PBResetPoint_ResponseBlock)block
{
    return [self resetPointForAllPlayersForPointInternalBase:pointName blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)resetPointForAllPlayersForPointAsync:(NSString *)pointName withDelegate:(id<PBResetPoint_ResponseHandler>)delegate
{
    return [self resetPointForAllPlayersForPointInternalBase:pointName blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)resetPointForAllPlayersForPointAsync:(NSString *)pointName withBlock:(PBResetPoint_ResponseBlock)block
{
    return [self resetPointForAllPlayersForPointInternalBase:pointName blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)resetPointForAllPlayersForPointAsync_:(NSString *)pointName withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self resetPointForAllPlayersForPointInternalBase:pointName blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)resetPointForAllPlayersForPointInternalBase:(NSString *)pointName blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Service/reset_point%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&point_name=%@", _token, pointName];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_resetPoint andResponse:response];
}

-(PBRequestUnit *)sendEmailForPlayer:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self sendEmailForPlayerInternalBase:playerId subject:subject message:message blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendEmailForPlayer:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self sendEmailForPlayerInternalBase:playerId subject:subject message:message blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailForPlayerAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self sendEmailForPlayerInternalBase:playerId subject:subject message:message blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendEmailForPlayerAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self sendEmailForPlayerInternalBase:playerId subject:subject message:message blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailForPlayerAsync_:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self sendEmailForPlayerInternalBase:playerId subject:subject message:message blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailForPlayerInternalBase:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Email/send%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&subject=%@&message=%@", _token, playerId, subject, message];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_sendEmail andResponse:response];
}

-(PBRequestUnit *)sendEmailForPlayer:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self sendEmailForPlayerInternalBase:playerId subject:subject message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendEmailForPlayer:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self sendEmailForPlayerInternalBase:playerId subject:subject message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailForPlayerAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self sendEmailForPlayerInternalBase:playerId subject:subject message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendEmailForPlayerAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self sendEmailForPlayerInternalBase:playerId subject:subject message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailForPlayerAsync_:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self sendEmailForPlayerInternalBase:playerId subject:subject message:message template:templateId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailForPlayerInternalBase:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Email/send%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&subject=%@&message=%@&template_id=%@", _token, playerId, subject, message, templateId];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_sendEmail andResponse:response];
}

-(PBRequestUnit *)sendEmailCouponForPlayer:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self sendEmailCouponForPlayerInternalBase:playerId ref:refId subject:subject message:message blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendEmailCouponForPlayer:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self sendEmailCouponForPlayerInternalBase:playerId ref:refId subject:subject message:message blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self sendEmailCouponForPlayerInternalBase:playerId ref:refId subject:subject message:message blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendEmailCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self sendEmailCouponForPlayerInternalBase:playerId ref:refId subject:subject message:message blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailCouponForPlayerAsync_:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self sendEmailCouponForPlayerInternalBase:playerId ref:refId subject:subject message:message blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailCouponForPlayerInternalBase:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Email/goods%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&subject=%@&ref_id=%@&message=%@", _token, playerId, subject, refId, message];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_sendEmailCoupon andResponse:response];
}

-(PBRequestUnit *)sendEmailCouponForPlayer:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self sendEmailCouponForPlayerInternalBase:playerId ref:refId subject:subject message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendEmailCouponForPlayer:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self sendEmailCouponForPlayerInternalBase:playerId ref:refId subject:subject message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate
{
    return [self sendEmailCouponForPlayerInternalBase:playerId ref:refId subject:subject message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendEmailCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResultStatus_ResponseBlock)block
{
    return [self sendEmailCouponForPlayerInternalBase:playerId ref:refId subject:subject message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailCouponForPlayerAsync_:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self sendEmailCouponForPlayerInternalBase:playerId ref:refId subject:subject message:message template:templateId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendEmailCouponForPlayerInternalBase:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Email/goods%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&subject=%@&ref_id=%@&message=%@&template_id=%@", _token, playerId, subject, refId, message, templateId];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_sendEmailCoupon andResponse:response];
}

-(PBRequestUnit *)quizListWithDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate
{
    return [self quizListWithBlockingCallInternalBase:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizListWithBlock:(PBActiveQuizList_ResponseBlock)block
{
    return [self quizListWithBlockingCallInternalBase:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizListWithDelegateAsync:(NSString *)playerId withDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate
{
    return [self quizListWithBlockingCallInternalBase:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizListWithBlockAsync:(PBActiveQuizList_ResponseBlock)block
{
    return [self quizListWithBlockingCallInternalBase:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizListWithBlockingCallInternalBase:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/list%@", _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_activeQuizList andResponse:response];
}

-(PBRequestUnit *)quizListOfPlayer:(NSString *)playerId type:(NSString *)type tags:(NSString *)tags withDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate
{
    return [self quizListOfPlayerInternalBase:playerId type:type tags:tags blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizListOfPlayer:(NSString *)playerId type:(NSString *)type tags:(NSString *)tags withBlock:(PBActiveQuizList_ResponseBlock)block
{
    return [self quizListOfPlayerInternalBase:playerId type:type tags:tags blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizListOfPlayerAsync:(NSString *)playerId type:(NSString *)type tags:(NSString *)tags withDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate
{
    return [self quizListOfPlayerInternalBase:playerId type:type tags:tags blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizListOfPlayerAsync:(NSString *)playerId type:(NSString *)type tags:(NSString *)tags withBlock:(PBActiveQuizList_ResponseBlock)block
{
    return [self quizListOfPlayerInternalBase:playerId type:type tags:tags blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizListOfPlayerInternalBase:(NSString *)playerId type:(NSString *)type tags:(NSString *)tags blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/list%@&player_id=%@", _apiKeyParam, playerId];
    
    if(type != nil && ![type isEqualToString:@""])
    {
        method = [method stringByAppendingString:[NSString stringWithFormat:@"&type=%@",type]];
    }
    if(tags != nil && ![tags isEqualToString:@""])
    {
        method = [method stringByAppendingString:[NSString stringWithFormat:@"&tags=%@",tags]];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_activeQuizList andResponse:response];
}

-(PBRequestUnit *)quizDetail:(NSString *)quizId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate
{
    return [self quizDetailInternalBase:quizId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizDetail:(NSString *)quizId withBlock:(PBQuizDetail_ResponseBlock)block
{
    return [self quizDetailInternalBase:quizId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizDetailAsync:(NSString *)quizId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate
{
    return [self quizDetailInternalBase:quizId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizDetailAsync:(NSString *)quizId withBlock:(PBQuizDetail_ResponseBlock)block
{
    return [self quizDetailInternalBase:quizId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizDetailInternalBase:(NSString *)quizId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/detail%@", quizId, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_quizDetail andResponse:response];
}

-(PBRequestUnit *)quizDetail:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate
{
    return [self quizDetailInternalBase:quizId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizDetail:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuizDetail_ResponseBlock)block
{
    return [self quizDetailInternalBase:quizId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizDetailAsync:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate
{
    return [self quizDetailInternalBase:quizId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizDetailAsync:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuizDetail_ResponseBlock)block
{
    return [self quizDetailInternalBase:quizId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizDetailInternalBase:(NSString *)quizId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/detail%@&player_id=%@", quizId, _apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_quizDetail andResponse:response];
}

-(PBRequestUnit *)quizRandomForPlayer:(NSString *)playerId withDelegate:(id<PBQuizRandom_ResponseHandler>)delegate
{
    return [self quizRandomForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizRandomForPlayer:(NSString *)playerId withBlock:(PBQuizRandom_ResponseBlock)block
{
    return [self quizRandomForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizRandomForPlayerAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self quizRandomForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizRandomForPlayerAsync:(NSString *)playerId withBlock:(PBQuizRandom_ResponseBlock)block
{
    return [self quizRandomForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizRandomForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/random%@&player_id=%@", _apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_quizRandom andResponse:response];
}

-(PBRequestUnit *)quizDoneForPlayer:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizDoneList_ResponseHandler>)delegate
{
    return [self quizDoneForPlayerInternalBase:playerId limit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizDoneForPlayer:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizDoneList_ResponseBlock)block
{
    return [self quizDoneForPlayerInternalBase:playerId limit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizDoneForPlayerAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizDoneList_ResponseHandler>)delegate
{
    return [self quizDoneForPlayerInternalBase:playerId limit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizDoneForPlayerAsync:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizDoneList_ResponseBlock)block
{
    return [self quizDoneForPlayerInternalBase:playerId limit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizDoneForPlayerInternalBase:(NSString *)playerId limit:(NSInteger)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/player/%@/%ld%@", playerId, (long)limit, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_quizDoneListByPlayer andResponse:response];
}

-(PBRequestUnit *)quizPendingOfPlayer:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizPendings_ResponseHandler>)delegate
{
    return [self quizPendingOfPlayerInternalBase:playerId limit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizPendingOfPlayer:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizPendings_ResponseBlock)block
{
    return [self quizPendingOfPlayerInternalBase:playerId limit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizPendingOfPlayerAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizPendings_ResponseHandler>)delegate
{
    return [self quizPendingOfPlayerInternalBase:playerId limit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizPendingOfPlayerAsync:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizPendings_ResponseBlock)block
{
    return [self quizPendingOfPlayerInternalBase:playerId limit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizPendingOfPlayerInternalBase:(NSString *)playerId limit:(NSInteger)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/player/%@/pending/%ld%@", playerId, (long)limit, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_quizPendingsByPlayer andResponse:response];
}

-(PBRequestUnit *)quizQuestion:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestion_ResponseHandler>)delegate
{
    return [self quizQuestionInternalBase:quizId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizQuestion:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuestion_ResponseBlock)block
{
    return [self quizQuestionInternalBase:quizId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizQuestionAsync:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestion_ResponseHandler>)delegate
{
    return [self quizQuestionInternalBase:quizId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizQuestionAsync:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuestion_ResponseBlock)block
{
    return [self quizQuestionInternalBase:quizId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizQuestionInternalBase:(NSString *)quizId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/question%@&player_id=%@", quizId, _apiKeyParam, playerId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questionFromQuiz andResponse:response];
}

#if PBSandBoxEnabled==1
-(PBRequestUnit *)quizQuestion:(NSString *)quizId lastQuestion:(NSString *)lastQuestionId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestion_ResponseHandler>)delegate
{
    return [self quizQuestionInternalBase:quizId lastQuestion:lastQuestionId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizQuestion:(NSString *)quizId lastQuestion:(NSString *)lastQuestionId forPlayer:(NSString *)playerId withBlock:(PBQuestion_ResponseBlock)block
{
    return [self quizQuestionInternalBase:quizId lastQuestion:lastQuestionId forPlayer:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizQuestionAsync:(NSString *)quizId lastQuestion:(NSString *)lastQuestionId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestion_ResponseHandler>)delegate
{
    return [self quizQuestionInternalBase:quizId lastQuestion:lastQuestionId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizQuestionAsync:(NSString *)quizId lastQuestion:(NSString *)lastQuestionId forPlayer:(NSString *)playerId withBlock:(PBQuestion_ResponseBlock)block
{
    return [self quizQuestionInternalBase:quizId lastQuestion:lastQuestionId forPlayer:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizQuestionInternalBase:(NSString *)quizId lastQuestion:(NSString *)lastQuestionId forPlayer:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/question%@&player_id=%@&question_id=%@", quizId, _apiKeyParam, playerId, lastQuestionId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_questionFromQuiz andResponse:response];
}
#endif

-(PBRequestUnit *)quizAnswer:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withDelegate:(id<PBQuestionAnswered_ResponseHandler>)delegate
{
    return [self quizAnswerInternalBase:quizId optionId:optionId forPlayer:playerId ofQuestionId:questionId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizAnswer:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBQuestionAnswered_ResponseBlock)block
{
    return [self quizAnswerInternalBase:quizId optionId:optionId forPlayer:playerId ofQuestionId:questionId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizAnswerAsync:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withDelegate:(id<PBQuestionAnswered_ResponseHandler>)delegate
{
    return [self quizAnswerInternalBase:quizId optionId:optionId forPlayer:playerId ofQuestionId:questionId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizAnswerAsync:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBQuestionAnswered_ResponseBlock)block
{
    return [self quizAnswerInternalBase:quizId optionId:optionId forPlayer:playerId ofQuestionId:questionId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizAnswerAsync_:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBQuestionAnswered_ResponseBlock)block
{
    return [self quizAnswerInternalBase:quizId optionId:optionId forPlayer:playerId ofQuestionId:questionId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizAnswerInternalBase:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/answer%@", quizId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&question_id=%@&option_id=%@", _token, playerId, questionId, optionId];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_questionAnswered andResponse:response];
}

-(PBRequestUnit *)quizScoreRank:(NSString *)quizId limit:(NSInteger)limit withDelegate:(id<PBPlayersQuizRank_ResponseHandler>)delegate
{
    return [self quizScoreRankInternalBase:quizId limit:limit blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizScoreRank:(NSString *)quizId limit:(NSInteger)limit withBlock:(PBPlayersQuizRank_ResponseBlock)block
{
    return [self quizScoreRankInternalBase:quizId limit:limit blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizScoreRankAsync:(NSString *)quizId limit:(NSInteger)limit withDelegate:(id<PBPlayersQuizRank_ResponseHandler>)delegate
{
    return [self quizScoreRankInternalBase:quizId limit:limit blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)quizScoreRankAsync:(NSString *)quizId limit:(NSInteger)limit withBlock:(PBPlayersQuizRank_ResponseBlock)block
{
    return [self quizScoreRankInternalBase:quizId limit:limit blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)quizScoreRankInternalBase:(NSString *)quizId limit:(NSInteger)limit blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Quiz/%@/rank/%ld%@", quizId, (long)limit, _apiKeyParam];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_playersQuizRank andResponse:response];
}

-(PBRequestUnit *)sendSMSForPlayer:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBSendSMS_ResponseHandler>)delegate
{
    return [self sendSMSForPlayerInternalBase:playerId message:message blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendSMSForPlayer:(NSString *)playerId message:(NSString *)message withBlock:(PBSendSMS_ResponseBlock)block
{
    return [self sendSMSForPlayerInternalBase:playerId message:message blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendSMSForPlayerAsync:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBSendSMS_ResponseHandler>)delegate
{
    return [self sendSMSForPlayerInternalBase:playerId message:message blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendSMSForPlayerAsync:(NSString *)playerId message:(NSString *)message withBlock:(PBSendSMS_ResponseBlock)block
{
    return [self sendSMSForPlayerInternalBase:playerId message:message blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendSMSForPlayerAsync_:(NSString *)playerId message:(NSString *)message withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self sendSMSForPlayerInternalBase:playerId message:message blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendSMSForPlayerInternalBase:(NSString *)playerId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token , @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Sms/send%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@", _token, playerId, message];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_sendSMS andResponse:response];
}

-(PBRequestUnit *)sendSMSForPlayer:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBSendSMS_ResponseHandler>)delegate
{
    return [self sendSMSForPlayerInternalBase:playerId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendSMSForPlayer:(NSString *)playerId message:(NSString *)message tempalte:(NSString *)templateId withBlock:(PBSendSMS_ResponseBlock)block
{
    return [self sendSMSForPlayerInternalBase:playerId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendSMSForPlayerAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBSendSMS_ResponseHandler>)delegate
{
    return [self sendSMSForPlayerInternalBase:playerId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendSMSForPlayerAsync:(NSString *)playerId message:(NSString *)message tempalte:(NSString *)templateId withBlock:(PBSendSMS_ResponseBlock)block
{
    return [self sendSMSForPlayerInternalBase:playerId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendSMSForPlayerAsync_:(NSString *)playerId message:(NSString *)message tempalte:(NSString *)templateId withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self sendSMSForPlayerInternalBase:playerId message:message template:templateId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendSMSForPlayerInternalBase:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token , @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Sms/send%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@&template_id=%@", _token, playerId, message, templateId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_sendSMS andResponse:response];
}

-(PBRequestUnit *)sendSMSCouponForPlayer:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withDelegate:(id<PBSendSMS_ResponseHandler>)delegate
{
    return [self sendSMSCouponForPlayerInternalBase:playerId ref:refId message:message blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendSMSCouponForPlayer:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBSendSMS_ResponseBlock)block
{
    return [self sendSMSCouponForPlayerInternalBase:playerId ref:refId message:message blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendSMSCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withDelegate:(id<PBSendSMS_ResponseHandler>)delegate
{
    return [self sendSMSCouponForPlayerInternalBase:playerId ref:refId message:message blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendSMSCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBSendSMS_ResponseBlock)block
{
    return [self sendSMSCouponForPlayerInternalBase:playerId ref:refId message:message blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendSMSCouponForPlayerAsync_:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self sendSMSCouponForPlayerInternalBase:playerId ref:refId message:message blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendSMSCouponForPlayerInternalBase:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Sms/goods%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&ref_id=%@&message=%@", _token, playerId, refId, message];
    
    if(!syncUrl)
    {
        data = [self formAsyncUrlRequestJsonDataStringFromData:data method:method];
    }
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_sendSMSCoupon andResponse:response];
}

-(PBRequestUnit *)sendSMSCouponForPlayer:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBSendSMS_ResponseHandler>)delegate
{
    return [self sendSMSCouponForPlayerInternalBase:playerId ref:refId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendSMSCouponForPlayer:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBSendSMS_ResponseBlock)block
{
    return [self sendSMSCouponForPlayerInternalBase:playerId ref:refId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendSMSCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBSendSMS_ResponseHandler>)delegate
{
    return [self sendSMSCouponForPlayerInternalBase:playerId ref:refId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)sendSMSCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBSendSMS_ResponseBlock)block
{
    return [self sendSMSCouponForPlayerInternalBase:playerId ref:refId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendSMSCouponForPlayerAsync_:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBAsyncURLRequestResponseBlock)block
{
    return [self sendSMSCouponForPlayerInternalBase:playerId ref:refId message:message template:templateId blockingCall:NO syncUrl:NO useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)sendSMSCouponForPlayerInternalBase:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Sms/goods%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&ref_id=%@&message=%@&template_id=%@", _token, playerId, refId, message, templateId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data responseType:responseType_sendSMSCoupon andResponse:response];
}

-(PBRequestUnit *)pushNotificationForPlayer:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pushNotificationForPlayerInternalBase:playerId message:message blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pushNotificationForPlayer:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self pushNotificationForPlayerInternalBase:playerId message:message blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pushNotificationForPlayerAsync:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pushNotificationForPlayerInternalBase:playerId message:message blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pushNotificationForPlayerAsync:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self pushNotificationForPlayerInternalBase:playerId message:message blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pushNotificationForPlayerInternalBase:(NSString *)playerId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    
    // check if device token is there and set before making a request
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    if(deviceToken == nil)
    {
        PBLOG(@"No device token acquired just yet.");
        return nil;
    }
    
    NSString *method = [NSString stringWithFormat:@"Push/send%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@", _token, playerId, message];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequestUnit *)pushNotificationForPlayer:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pushNotificationForPlayerInternalBase:playerId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pushNotificationForPlayer:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self pushNotificationForPlayerInternalBase:playerId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pushNotificationForPlayerAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pushNotificationForPlayerInternalBase:playerId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pushNotificationForPlayerAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self pushNotificationForPlayerInternalBase:playerId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pushNotificationForPlayerInternalBase:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    
    // check if device token is there and set before making a request
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    if(deviceToken == nil)
    {
        PBLOG(@"No device token acquired just yet.");
        return nil;
    }
    
    NSString *method = [NSString stringWithFormat:@"Push/send%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&message=%@&template_id=%@", _token, playerId, message, templateId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequestUnit *)pushNotificationCouponForPlayer:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pushNotificationCouponForPlayerInternalBase:playerId refId:refId message:message blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pushNotificationCouponForPlayer:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self pushNotificationCouponForPlayerInternalBase:playerId refId:refId message:message blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pushNotificationCouponForPlayerAsync:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pushNotificationCouponForPlayerInternalBase:playerId refId:refId message:message blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pushNotificationCouponForPlayerAsync:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block
{
    return [self pushNotificationCouponForPlayerInternalBase:playerId refId:refId message:message blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pushNotificationCouponForPlayerInternalBase:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    
    // check if device token is there and set before making a request
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    if(deviceToken == nil)
    {
        PBLOG(@"No device token acquired just yet.");
        return nil;
    }
    
    NSString *method = [NSString stringWithFormat:@"Push/goods%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&ref_id=%@&message=%@", _token, playerId, refId, message];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequestUnit *)pushNotificationCouponForPlayer:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pushNotificationCouponForPlayerInternalBase:playerId refId:refId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pushNotificationCouponForPlayer:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self pushNotificationCouponForPlayerInternalBase:playerId refId:refId message:message template:templateId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pushNotificationCouponForPlayerAsync:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self pushNotificationCouponForPlayerInternalBase:playerId refId:refId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)pushNotificationCouponForPlayerAsync:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block
{
    return [self pushNotificationCouponForPlayerInternalBase:playerId refId:refId message:message template:templateId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)pushNotificationCouponForPlayerInternalBase:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    
    // check if device token is there and set before making a request
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    if(deviceToken == nil)
    {
        PBLOG(@"No device token acquired just yet.");
        return nil;
    }
    
    NSString *method = [NSString stringWithFormat:@"Push/goods%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@&ref_id=%@&message=%@&template_id=%@", _token, playerId, refId, message, templateId];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}
-(PBRequestUnit *)registerForPushNotificationPlayerId:(NSString *)playerId options:(NSDictionary *)options withBlock:(PBResponseBlock)block
{
    return [self registerForPushNotificationPlayerInternalBase:playerId options:options blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)registerForPushNotificationPlayerInternalBase:(NSString *)playerId options:(NSDictionary *)options blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response

{
    NSAssert(_token, @"access token is nil");
    
    // get device token from what we save in NSUserDefaults
    //NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    //NSAssert(deviceToken, @"device token is nil");
    
    NSString *method = [NSString stringWithFormat:@"Push/deviceRegistration%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&player_id=%@", _token,playerId];
    
    NSString *device_token = [options objectForKey:@"device_token"];
    NSString *device_description = [options objectForKey:@"device_description"];
    NSString *device_name = [options objectForKey:@"device_name"];
    NSString *os_type = @"IOS";
    
    data = device_token == nil ? data : [data stringByAppendingString:[NSString stringWithFormat:@"&device_token=%@",device_token]];
    data = device_description == nil ? data : [data stringByAppendingString:[NSString stringWithFormat:@"&device_description=%@",device_description]];
    data = device_name == nil ? data : [data stringByAppendingString:[NSString stringWithFormat:@"&device_name=%@",device_name]];
    data = os_type == nil ? data : [data stringByAppendingString:[NSString stringWithFormat:@"&os_type=%@",os_type]];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}
-(PBRequestUnit *)forgotPasswordForEmail:(NSString *)email withDelegate:(id<PBResponseHandler>)delegate
{
    return [self forgotPasswordForEmailInternalBase:email blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)forgotPasswordForEmail:(NSString *)email withBlock:(PBResponseBlock)block
{
    return [self forgotPasswordForEmailInternalBase:email blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)forgotPasswordForEmailAsync:(NSString *)email withDelegate:(id<PBResponseHandler>)delegate
{
    return [self forgotPasswordForEmailInternalBase:email blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)forgotPasswordForEmailAsync:(NSString *)email withBlock:(PBResponseBlock)block
{
    return [self forgotPasswordForEmailInternalBase:email blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)forgotPasswordForEmailInternalBase:(NSString *)email blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response

{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/password/email%@", _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&email=%@", _token,email];
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
    
}
-(PBRequestUnit *)requestOTP:(NSString *)player_id deviceToken:(NSString *)deviceToken description:(NSString *)description deviceName:(NSString *)deviceName os_type:(NSString *)os_type withDelegate:(id<PBResponseHandler>)delegate
{
    return [self requestOTPInternalBase:player_id deviceToken:deviceToken description:description deviceName:deviceName os_type:os_type blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)requestOTP:(NSString *)player_id deviceToken:(NSString *)deviceToken description:(NSString *)description deviceName:(NSString *)deviceName os_type:(NSString *)os_type withBlock:(PBResponseBlock)block
{
    return [self requestOTPInternalBase:player_id deviceToken:deviceToken description:description deviceName:deviceName os_type:os_type blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)requestOTPAsync:(NSString *)player_id deviceToken:(NSString *)deviceToken description:(NSString *)description deviceName:(NSString *)deviceName os_type:(NSString *)os_type withDelegate:(id<PBResponseHandler>)delegate
{
    return [self requestOTPInternalBase:player_id deviceToken:deviceToken description:description deviceName:deviceName os_type:os_type blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)requestOTPAsync:(NSString *)player_id deviceToken:(NSString *)deviceToken description:(NSString *)description deviceName:(NSString *)deviceName os_type:(NSString *)os_type withBlock:(PBResponseBlock)block
{
    return [self requestOTPInternalBase:player_id deviceToken:deviceToken description:description deviceName:deviceName os_type:os_type blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)requestOTPInternalBase:(NSString *)player_id deviceToken:(NSString *)deviceToken description:(NSString *)description deviceName:(NSString *)deviceName os_type:(NSString *)os_type blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response

{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/auth/%@/requestOTPCode%@",player_id , _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", _token];
    data = deviceToken != nil ? [data stringByAppendingString:[NSString stringWithFormat:@"&device_token=%@",deviceToken]] : data ;
    data = description != nil ? [data stringByAppendingString:[NSString stringWithFormat:@"&device_description=%@",description]] : data ;
    data = deviceName != nil ? [data stringByAppendingString:[NSString stringWithFormat:@"&device_name=%@",deviceName]] : data ;
    data = os_type != nil ? [data stringByAppendingString:[NSString stringWithFormat:@"&os_type=%@",os_type]] : data ;
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
    
}

-(PBRequestUnit *)performOTP:(NSString *)player_id code:(NSString *)code withDelegate:(id<PBResponseHandler>)delegate
{
    return [self performOTPInternalBase:player_id code:code blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)performOTP:(NSString *)player_id code:(NSString *)code withBlock:(PBResponseBlock)block
{
    return [self performOTPInternalBase:player_id code:code blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)performOTPAsync:(NSString *)player_id code:(NSString *)code withDelegate:(id<PBResponseHandler>)delegate
{
    return [self performOTPInternalBase:player_id code:code blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)performOTPAsync:(NSString *)player_id code:(NSString *)code withBlock:(PBResponseBlock)block
{
    return [self performOTPInternalBase:player_id code:code blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)performOTPInternalBase:(NSString *)player_id code:(NSString *)code blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response

{
    NSAssert(_token, @"access token is nil");
    NSString *method = [NSString stringWithFormat:@"Player/auth/%@/verifyOTPCode%@",player_id, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&code=%@", _token,code];

    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
    
}
-(PBRequestUnit *)listActiveSessionForPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self listActiveSessionForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)listActiveSessionForPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self listActiveSessionForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)listActiveSessionForPlayerAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self listActiveSessionForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)listActiveSessionForPlayerAsync:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self listActiveSessionForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)listActiveSessionForPlayerInternalBase:(NSString *)playerId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/%@/sessions%@", playerId, _apiKeyParam];
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil andResponse:response];
}
-(PBRequestUnit *)findPlayerBySession:(NSString *)sessionId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self findPlayerBySessionInternalBase:sessionId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)findPlayerBySession:(NSString *)sessionId withBlock:(PBResponseBlock)block
{
    return [self findPlayerBySessionInternalBase:sessionId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)findPlayerBySessionAsync:(NSString *)sessionId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self findPlayerBySessionInternalBase:sessionId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)findPlayerBySessionAsync:(NSString *)sessionId withBlock:(PBResponseBlock)block
{
    return [self findPlayerBySessionInternalBase:sessionId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)findPlayerBySessionInternalBase:(NSString *)sessionId blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSString *method = [NSString stringWithFormat:@"Player/session/%@%@", sessionId, _apiKeyParam];
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:nil responseType:responseType_player
                                                  andResponse:response];
}

-(PBRequestUnit *)setupPhoneForPlayer:(NSString *)playerId phoneNumber:(NSString *)phoneNumber deviceToken:(NSString *)deviceToken description:(NSString *)description deviceName:(NSString *)deviceName os_type:(NSString *)os_type withDelegate:(id<PBResponseHandler>)delegate
{
    return [self setupPhoneForPlayerInternalBase:playerId phoneNumber:phoneNumber deviceToken:deviceToken description:description deviceName:deviceName os_type:os_type blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}

-(PBRequestUnit *)setupPhoneForPlayer:(NSString *)playerId phoneNumber:(NSString *)phoneNumber deviceToken:(NSString *)deviceToken description:(NSString *)description deviceName:(NSString *)deviceName os_type:(NSString *)os_type  withBlock:(PBResponseBlock)block
{
    return [self setupPhoneForPlayerInternalBase:playerId phoneNumber:phoneNumber deviceToken:deviceToken description:description deviceName:deviceName os_type:os_type blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)setupPhoneForPlayerAsync:(NSString *)playerId phoneNumber:(NSString *)phoneNumber deviceToken:(NSString *)deviceToken description:(NSString *)description deviceName:(NSString *)deviceName os_type:(NSString *)os_type  withDelegate:(id<PBResponseHandler>)delegate
{
    return [self setupPhoneForPlayerInternalBase:playerId phoneNumber:phoneNumber deviceToken:deviceToken description:description deviceName:deviceName os_type:os_type blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)setupPhoneForPlayerAsync:(NSString *)playerId phoneNumber:(NSString *)phoneNumber deviceToken:(NSString *)deviceToken description:(NSString *)description deviceName:(NSString *)deviceName os_type:(NSString *)os_type  withBlock:(PBResponseBlock)block
{
    return [self setupPhoneForPlayerInternalBase:playerId phoneNumber:phoneNumber deviceToken:deviceToken description:description deviceName:deviceName os_type:os_type blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)setupPhoneForPlayerInternalBase:(NSString *)playerId phoneNumber:(NSString *)phoneNumber deviceToken:(NSString *)deviceToken description:(NSString *)description deviceName:(NSString *)deviceName os_type:(NSString *)os_type blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    
    // check if device token is there and set before making a request
    //NSString *deviceID = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    if(deviceToken == nil)
    {
        PBLOG(@"No device token acquired just yet.");
        return nil;
    }
    
    NSString *method = [NSString stringWithFormat:@"Player/auth/%@/setupPhone%@", playerId,_apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@&phone_number=%@&device_token=%@&device_description=%@&device_name=%@&os_type=%@", _token, phoneNumber, deviceToken, description, deviceName , os_type];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

-(PBRequestUnit *)requestOTPCodeForPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self requestOTPCodeForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)requestOTPCodeForPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    return [self requestOTPCodeForPlayerInternalBase:playerId blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)requestOTPCodeForPlayerAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate
{
    return [self requestOTPCodeForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(PBRequestUnit *)requestOTPCodeForPlayerAsync:(NSString *)playerId  withBlock:(PBResponseBlock)block
{
    return [self requestOTPCodeForPlayerInternalBase:playerId blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(PBRequestUnit *)requestOTPCodeForPlayerInternalBase:(NSString *)playerId  blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    NSAssert(_token, @"access token is nil");
    
    // check if device token is there and set before making a request
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    if(deviceToken == nil)
    {
        PBLOG(@"No device token acquired just yet.");
        return nil;
    }
    
    NSString *method = [NSString stringWithFormat:@"Player/auth/%@/requestOTPCode%@",playerId, _apiKeyParam];
    NSString *data = [NSString stringWithFormat:@"token=%@", _token];
    
    return [self refactoredInternalBaseReturnWithBlockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withMethod:method andData:data andResponse:response];
}

#if TARGET_OS_IOS
-(void)trackPlayer:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController *)view withBlock:(PBAsyncURLRequestResponseBlock)block
{
    // it's always async url request, thus non-blocking call
    [self trackPlayerInternalBase:playerId forAction:action fromView:view useDelegate:NO withResponse:block];
}
// TODO: Fix this method, it's broken after we introduce PBPlayerApi and removed old
-(void)trackPlayerInternalBase:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController *)view useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    // begin entire sequence in async way
    // as track is in async way
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // the sequence should be in sequencial thus we use blocking call
        
        // check if user exists in the system or not
        [PBPlayerApi player:self playerId:playerId andCompletion:^(PBPlayer *result, NSError *error) {
            // user doesn't exist
            if(result == nil && error != nil && error.code == PBERROR_USER_NOT_EXIST)
            {
                PBLOG(@"Player doesn't exist");
                
                // show registration form
                if(view != nil)
                {
                    [self showRegistrationFormFromView:view intendedPlayerId:playerId withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
                        if(!error)
                        {
                            PBLOG(@"Register successfully, then do rule().");
                            // register successfully, then do the work
                            // now it's time to track
                            [self ruleForPlayerInternalBase:playerId action:action blockingCall:NO syncUrl:NO useDelegate:useDelegate withResponse:response withParams:nil];
                        }
                        else
                        {
                            PBLOG(@"Register failed, then send error back to response.");

                            PBAsyncURLRequestResponseBlock sb = (PBAsyncURLRequestResponseBlock)response;
                            sb([PBManualSetResultStatus_Response resultStatusWithFailure], nil, error);
                        }
                    }];
                }
                // otherwise, response back with error
                else
                {
                    PBLOG(@"No view set, then send back with error to reponse.");
                    // if there's no view input, then directly send back response with error
                    /*PBAsyncURLRequestResponseBlock sb = (PBAsyncURLRequestResponseBlock)response;
                    sb([PBManualSetResultStatus_Response resultStatusWithFailure], url, error);*/
                }
            }
            // player exists
            else if(result != nil && error == nil)
            {
                PBLOG(@"Player exists as following info: %@", result);
                
                // now it's time to track
                // response back to the root response
                [self ruleForPlayerInternalBase:playerId action:action blockingCall:NO syncUrl:NO useDelegate:useDelegate withResponse:response withParams:nil];
            }
            // error
            else
            {
                PBLOG(@"Error occurs: %@", error);
                
                // direct response back
                if(response != nil)
                {
                    /*PBAsyncURLRequestResponseBlock sb = (PBAsyncURLRequestResponseBlock)response;
                    sb([PBManualSetResultStatus_Response resultStatusWithFailure], url, error);*/
                }
            }
        }];
    });
}

-(void)doPlayer:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withDelegate:(id<PBResponseHandler>)delegate
{
    [self doPlayerInternalBase:playerId forAction:action fromView:view blockingCall:YES syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(void)doPlayer:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withBlock:(PBResponseBlock)block
{
    [self doPlayerInternalBase:playerId forAction:action fromView:view blockingCall:YES syncUrl:YES useDelegate:NO withResponse:block];
}
-(void)doPlayerAsync:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withDelegate:(id<PBResponseHandler>)delegate
{
    [self doPlayerInternalBase:playerId forAction:action fromView:view blockingCall:NO syncUrl:YES useDelegate:YES withResponse:delegate];
}
-(void)doPlayerAsync:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withBlock:(PBResponseBlock)block
{
    [self doPlayerInternalBase:playerId forAction:action fromView:view blockingCall:NO syncUrl:YES useDelegate:NO withResponse:block];
}
-(void)doPlayerInternalBase:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    // check if user exists in the system or not
    [self playerInternalBase:playerId blockingCall:blockingCall syncUrl:YES useDelegate:NO withResponse:^(PBPlayer_Response *player, NSURL *url, NSError *error) {
        // user doesn't exist
        if(player == nil && error != nil && error.code == PBERROR_USER_NOT_EXIST)
        {
            PBLOG(@"Player doesn't exist");
            
            // show registration form
            if(view != nil)
            {
                [self showRegistrationFormFromView:view intendedPlayerId:playerId withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
                    if(!error)
                    {
                        PBLOG(@"Register successfully, then do rule().");
                        // register successfully, then do the work
                        // now it's time to track
                        [self ruleForPlayerInternalBase:playerId action:action blockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withResponse:response withParams:nil];
                    }
                    else
                    {
                        PBLOG(@"Register failed, then send error back to response.");

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
                PBLOG(@"No view set, then send back with error to reponse.");
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
            PBLOG(@"Player exists as following info: %@", player);
            
            // now it's time to track
            // response back to the root response
            [self ruleForPlayerInternalBase:playerId action:action blockingCall:blockingCall syncUrl:syncUrl useDelegate:useDelegate withResponse:response withParams:nil];
        }
        // error
        else
        {
            PBLOG(@"Error occurs: %@", error);
            
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
#endif

-(PBRequestUnit *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andDelegate:(id<PBResponseHandler>)delegate
{
    return [self callInternalBase:method withData:data blockingCall:YES syncURLRequest:syncURLRequest useDelegate:YES withResponse:delegate];
}

-(PBRequestUnit *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest responseType:(pbResponseType)responseType andDelegate:(id<PBResponseHandler>)delegate
{
    return [self callInternalBase:method withData:data blockingCall:YES syncURLRequest:syncURLRequest useDelegate:YES responseType:responseType withResponse:delegate];
}

-(PBRequestUnit *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andBlock:(PBResponseBlock)block
{
    return [self callInternalBase:method withData:data blockingCall:YES syncURLRequest:syncURLRequest useDelegate:NO withResponse:block];
}

-(PBRequestUnit *)call:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest responseType:(pbResponseType)responseType andBlock:(PBResponseBlock)block
{
    return [self callInternalBase:method withData:data blockingCall:YES syncURLRequest:syncURLRequest useDelegate:NO responseType:responseType withResponse:block];
}

-(PBRequestUnit *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andDelegate:(id<PBResponseHandler>)delegate
{
    return [self callInternalBase:method withData:data blockingCall:NO syncURLRequest:syncURLRequest useDelegate:YES withResponse:delegate];
}

-(PBRequestUnit *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest responseType:(pbResponseType)responseType andDelegate:(id<PBResponseHandler>)delegate
{
    return [self callInternalBase:method withData:data blockingCall:NO syncURLRequest:syncURLRequest useDelegate:YES responseType:responseType withResponse:delegate];
}

-(PBRequestUnit *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest andBlock:(PBResponseBlock)block
{
    return [self callInternalBase:method withData:data blockingCall:NO syncURLRequest:syncURLRequest useDelegate:NO withResponse:block];
}

-(PBRequestUnit *)callAsync:(NSString *)method withData:(NSString *)data syncURLRequest:(BOOL)syncURLRequest responseType:(pbResponseType)responseType andBlock:(PBResponseBlock)block
{
    return [self callInternalBase:method withData:data blockingCall:NO syncURLRequest:syncURLRequest useDelegate:NO responseType:responseType withResponse:block];
}


-(PBRequestUnit *)callInternalBase:(NSString *)method withData:(NSString *)data blockingCall:(BOOL)blockingCall syncURLRequest:(BOOL)syncURLRequest useDelegate:(BOOL)useDelegate responseType:(pbResponseType)responseType withResponse:(id)response
{
    // create an http request that we will modify its header later on below
    NSMutableURLRequest *request = nil;
    
    // in case of PBSandBoxEnabled is set to 0, then we go for normal (build). Otherwise, we go for sandbox mode.
#if PBSandBoxEnabled==0
    // set the default mode to sync mode
    NSString *urlRequest = BASE_URL;
    // if it goes to async mode, then set it accordingly
    if(!syncURLRequest)
        urlRequest = BASE_ASYNC_URL;
#else
    // set the default mode to sync mode
    NSString *urlRequest = BASE_URL;
    
    if(syncURLRequest)
    {
        if(responseType == responseType_rule)
        {
            // for engine's rule
            // sample supports only "click", "like", and "onclick"
            NSArray *params = [data componentsSeparatedByString:@"&"];
            for(NSString *paramString in params)
            {
                // split string by '='
                NSArray *paramsSub2 = [paramString componentsSeparatedByString:@"="];
                
                // get name of parameter
                NSString *paramToCheck = paramsSub2[0];
                
                // if it's action, then we check for what we support
                if([paramToCheck isEqualToString:@"action"])
                {
                    // get action name
                    NSString *actionToCheck = paramsSub2[1];
                    
                    // check action against what we support
                    if([actionToCheck isEqualToString:@"like"] ||
                       [actionToCheck isEqualToString:@"click"] ||
                       [actionToCheck isEqualToString:@"onclick"])
                    {
                        urlRequest = SAMPLE_BASE_URL;
                        PBLOG(@"Set urlRequest to %@ for rule", SAMPLE_BASE_URL);
                        
                        break;
                    }
                }
            }
        }
        else if(responseType == responseType_auth ||
           responseType == responseType_renew ||
           responseType == responseType_goodsListInfo ||
           responseType == responseType_goodsInfo ||
           responseType == responseType_playerPublic ||
           responseType == responseType_player ||
           responseType == responseType_questList ||
           responseType == responseType_questInfo ||
           responseType == responseType_activeQuizList ||
           responseType == responseType_questionFromQuiz ||
           responseType == responseType_questionAnswered)
        {
            urlRequest = SAMPLE_BASE_URL;
            PBLOG(@"Set urlRequest to %@", SAMPLE_BASE_URL);
        }
    }
#endif
    
    id url = nil;
    
    // if it's sync url request then append method into base url
    if(syncURLRequest)
        url = [NSURL URLWithString:[urlRequest stringByAppendingString:method]];
    // otherwise, no need to append anything to the base url
    else
        url = [NSURL URLWithString:urlRequest];
    
    if(!data)
    {
        request = [NSMutableURLRequest requestWithURL:url];
        PBLOG(@"Get request");
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
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        PBLOG(@"Post request");
    }
    
    // set all relevant headers for the requests
    // set date header
    // note: this is saved for the originality of timestamp for this request being sent later even thoguh it will be save for later dispatching if network cannot be reached
    
    // get http date string
    NSString *httpDateStr = [[PBUtils sharedInstance].dateFormatter stringFromDate:[NSDate date]];

    PBLOG(@"dateStr: %@", httpDateStr);
    
    // set to request's date header
    [request setValue:httpDateStr forHTTPHeaderField:@"Date"];
    
    // set custom http headers
    [request setValue: [NSString stringWithFormat:@"%.0f", _customDeviceInfoHttpHeaderFieldsVar.screenHeight] forHTTPHeaderField:@"screenHeight"];
    [request setValue: [NSString stringWithFormat:@"%.0f", _customDeviceInfoHttpHeaderFieldsVar.screenWidth] forHTTPHeaderField:@"screenWidth"];
    [request setValue: _customDeviceInfoHttpHeaderFieldsVar.os forHTTPHeaderField:@"os"];
    [request setValue: _customDeviceInfoHttpHeaderFieldsVar.osVersion forHTTPHeaderField:@"osVersion"];
    [request setValue: _customDeviceInfoHttpHeaderFieldsVar.deviceBrand forHTTPHeaderField:@"deviceBrand"];
    [request setValue: _customDeviceInfoHttpHeaderFieldsVar.deviceName forHTTPHeaderField:@"deviceName"];
    [request setValue: _customDeviceInfoHttpHeaderFieldsVar.sdkVersion forHTTPHeaderField:@"sdkVersion"];
    [request setValue:_customDeviceInfoHttpHeaderFieldsVar.appBundle forHTTPHeaderField:@"AppBundle"];
    
    // create PBRequestUnit with delegate callback
    PBRequestUnit* pbRequest = nil;
    if(useDelegate)
    {
        pbRequest = [[PBRequestUnit alloc] initWithURLRequest:request blockingCall:blockingCall syncUrl:syncURLRequest responseType:responseType andDelegate:response];
    }
    // create PBRequestUnit with block callback
    else
    {
        pbRequest = [[PBRequestUnit alloc] initWithURLRequest:request blockingCall:blockingCall syncUrl:syncURLRequest responseType:responseType andBlock:response];
    }
    
    // if network is reachable then dispatch it immediately
    if(_isNetworkReachable)
    {
        // start the request
        [pbRequest start];
    }
    // otherwise, then add into the queue
    else
    {
        // add PBRequestUnit into operational queue
        [_requestOptQueue enqueue:pbRequest];
        
        PBLOG(@"Queue size = %lu", (unsigned long)[_requestOptQueue count]);
    }

    return pbRequest;
}

-(PBRequestUnit *)callInternalBase:(NSString *)method withData:(NSString *)data blockingCall:(BOOL)blockingCall syncURLRequest:(BOOL)syncURLRequest useDelegate:(BOOL)useDelegate withResponse:(id)response
{
    return [self callInternalBase:method withData:data blockingCall:blockingCall syncURLRequest:syncURLRequest useDelegate:useDelegate responseType:responseType_normal withResponse:response];
}

-(void)setToken:(NSString *)newToken
{
    _token = newToken;
    
    PBLOG(@"token assigned: %@", _token);
}

-(void)dispatchFirstRequestInQueue:(NSTimer *)dt
{
    //PBLOG(@"Called dispatchFirstRequestInQueue");
    
    // only dispatch a first found request if network can be reached, and
    // operational queue is not empty
    if(_isNetworkReachable && ![_requestOptQueue empty])
    {
        [[self getRequestOperationalQueue] dequeueAndStart];
        PBLOG(@"Dispatched first founed request in queue");
    }
}

-(void)checkNetworkStatus:(NSNotification *)notice
{
    NetworkStatus networkStatus = [_reachability currentReachabilityStatus];
    switch(networkStatus)
    {
        case NotReachable:
            _isNetworkReachable = FALSE;
            PBLOG(@"Network is not reachable");
            break;
        case ReachableViaWiFi:
            _isNetworkReachable = TRUE;
            PBLOG(@"Network is reachable via WiFi");
            break;
        case ReachableViaWWAN:
            _isNetworkReachable = TRUE;
            PBLOG(@"Network is reachable via WWAN");
            break;
    }
    
    // raising the event
    [self.networkStatusChangedDelegate networkStatusChanged:networkStatus];
}

-(void)onApplicationDidFinishLaunching:(NSNotification *)notif
{
    PBLOG(@"called onApplicationDidFinishLaunching()");
    
    // only track when tracking player-id is set, and confirm status is set
    if(_intendedLoginPlayerId != nil && _isIntendedLoginPlayerIdConfirmed)
    {
        NSString *action = @"appdidfinishlaunching";
        
        [self ruleForPlayerAsync:_intendedLoginPlayerId action:action withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
            if(!error)
            {
                PBLOG(@"Successfully sent phone event of '%@' to Playbasis.", action);
                PBLOG(@"%@", response);
            }
            else
            {
                PBLOG(@"Failed to send phone event of '%@' to Playbasis.", action);
            }
        }, nil];
    }
}

-(void)onApplicationWillResignActive:(NSNotification *)notif
{
    PBLOG(@"called onApplicatoinWillResignActive()");
    
    // only track when tracking player-id is set, and confirm status is set
    if(_intendedLoginPlayerId != nil && _isIntendedLoginPlayerIdConfirmed)
    {
        NSString *action = @"appwillresignactive";
        
        [self ruleForPlayerAsync:_intendedLoginPlayerId action:action withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
            if(!error)
            {
                PBLOG(@"Successfully sent phone event of '%@' to Playbasis.", action);
                PBLOG(@"%@", response);
            }
            else
            {
                PBLOG(@"Failed to send phone event of '%@' to Playbasis.", action);
            }
        }, nil];
    }
}

-(void)onApplicationDidEnterBackground:(NSNotification *)notif
{
    PBLOG(@"called onApplicationDidEnterBackground()");
    
    // serialize and save all requests in queue
    [[[Playbasis sharedPB] getRequestOperationalQueue] serializeAndSaveToFile];
    
    // only track when tracking player-id is set, and confirm status is set
    if(_intendedLoginPlayerId != nil && _isIntendedLoginPlayerIdConfirmed)
    {
        NSString *action = @"appdidenterbackground";
        
        [self ruleForPlayerAsync:_intendedLoginPlayerId action:action withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
            if(!error)
            {
                PBLOG(@"Successfully sent phone event of '%@' to Playbasis.", action);
                PBLOG(@"%@", response);
            }
            else
            {
                PBLOG(@"Failed to send phone event of '%@' to Playbasis.", action);
            }
        }, nil];
    }
}

-(void)onApplicationWillEnterForeground:(NSNotification *)notif
{
    PBLOG(@"called onApplicationWillEnterForeground()");
    
    // load saved requests from file
    [[[Playbasis sharedPB] getRequestOperationalQueue] load];
    
    // only track when tracking player-id is set, and confirm status is set
    if(_intendedLoginPlayerId != nil && _isIntendedLoginPlayerIdConfirmed)
    {
        NSString *action = @"appwillenterforeground";
        
        [self ruleForPlayerAsync:_intendedLoginPlayerId action:action withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
            if(!error)
            {
                PBLOG(@"Successfully sent phone event of '%@' to Playbasis.", action);
                PBLOG(@"%@", response);
            }
            else
            {
                PBLOG(@"Failed to send phone event of '%@' to Playbasis.", action);
            }
        }, nil];
    }
}

-(void)onApplicationDidBecomeActive:(NSNotification *)notif
{
    PBLOG(@"called onApplicationDidBecomeActive()");
    
    // only track when tracking player-id is set, and confirm status is set
    if(_intendedLoginPlayerId != nil && _isIntendedLoginPlayerIdConfirmed)
    {
        NSString *action = @"appdidbecomeactive";
        
        [self ruleForPlayerAsync:_intendedLoginPlayerId action:action withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
            if(!error)
            {
                PBLOG(@"Successfully sent phone event of '%@' to Playbasis.", action);
                PBLOG(@"%@", response);
            }
            else
            {
                PBLOG(@"Failed to send phone event of '%@' to Playbasis.", action);
            }
        }, nil];
    }
}

-(void)onApplicationWillTerminate:(NSNotification *)notif
{
    PBLOG(@"called onApplicationWillTerminate()");
    
    // serialize and save all requests in queue
    [[[Playbasis sharedPB] getRequestOperationalQueue] serializeAndSaveToFile];
    
    // only track when tracking player-id is set, and confirm status is set
    if(_intendedLoginPlayerId != nil && _isIntendedLoginPlayerIdConfirmed)
    {
        NSString *action = @"appwillterminate";
        
        [self ruleForPlayer:_intendedLoginPlayerId action:action withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
            if(!error)
            {
                PBLOG(@"Successfully sent phone event of '%@' to Playbasis.", action);
                PBLOG(@"%@", response);
            }
            else
            {
                PBLOG(@"Failed to send phone event of '%@' to Playbasis.", action);
            }
        }, nil];
    }
}

#if TARGET_OS_IOS
//--------------------------------------------------
// UI
//--------------------------------------------------
-(void)showRegistrationFormFromView:(UIViewController *)view withBlock:(PBResponseBlock)block
{
    [self showRegistrationFormFromView:view intendedPlayerId:nil withBlock:block];
}

-(void)showRegistrationFormFromView:(UIViewController *)view intendedPlayerId:(NSString *)playerId withBlock:(PBResponseBlock)block
{
    // locate storyboard file from within framework
    NSBundle *bundle = [NSBundle bundleForClass:[Playbasis class]];
    
    // get playbasis's storyboard
    UIStoryboard *pbStoryboard = [UIStoryboard storyboardWithName:@"PBStoryboard" bundle:bundle];
    
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

-(void)showFeedbackStatusUpdateWithText:(NSString *)text
{
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor grayColor];
    contentView.layer.cornerRadius = 12.0;
    
    UILabel* statusLabel = [[UILabel alloc] init];
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.font = [UIFont boldSystemFontOfSize:12.0];
    statusLabel.numberOfLines = 0;  // cover all lines
    statusLabel.text = text;
    
    [contentView addSubview:statusLabel];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(contentView, statusLabel);
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(16)-[statusLabel]-(10)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(36)-[statusLabel]-(36)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    // save to persistent klcpopup for us to close it later
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeClear dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    // show it permanently, will required user to close it later
    [popup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom) duration:0.0];
}

-(void)showFeedbackStatusUpdateWithText:(NSString *)text duration:(NSTimeInterval)duration
{
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor grayColor];
    contentView.layer.cornerRadius = 12.0;
    
    UILabel* statusLabel = [[UILabel alloc] init];
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.font = [UIFont boldSystemFontOfSize:12.0];
    statusLabel.numberOfLines = 0;  // cover all lines
    statusLabel.text = text;
    
    [contentView addSubview:statusLabel];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(contentView, statusLabel);
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(16)-[statusLabel]-(10)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(36)-[statusLabel]-(36)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeClear dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [popup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom) duration:duration];
}

-(void)showFeedbackEventPopupWithImage:(UIImage *)image title:(NSString *)title description:(NSString *)description
{
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor grayColor];
    contentView.layer.cornerRadius = 12.0;
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.translatesAutoresizingMaskIntoConstraints = YES;
    imageView.frame = CGRectMake(0, 0, 150, 150);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleLabel.contentMode = UIViewContentModeCenter;
    titleLabel.text = title;
    
    UILabel* descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    descriptionLabel.frame = CGRectMake(0, 0, 250, 80);
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.font = [UIFont boldSystemFontOfSize:15.0];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.contentMode = UIViewContentModeCenter;
    descriptionLabel.text = description;
    
    UIButton* dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    dismissButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    dismissButton.backgroundColor = [UIColor orangeColor];
    [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dismissButton setTitleColor:[[dismissButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    dismissButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [dismissButton setTitle:@"Ok" forState:UIControlStateNormal];
    dismissButton.layer.cornerRadius = 6.0;
    [dismissButton addTarget:self action:@selector(klcPopup_dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:titleLabel];
    [contentView addSubview:imageView];
    [contentView addSubview:descriptionLabel];
    [contentView addSubview:dismissButton];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(contentView, titleLabel, imageView, descriptionLabel, dismissButton);
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[imageView]-(20)-[titleLabel]-(10)-[descriptionLabel]-(10)-[dismissButton]-(24)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(36)-[titleLabel]-(36)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    [popup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
}

-(void)showFeedbackEventPopupWithContent:(UIView *)contentView image:(UIImage *)image title:(NSString *)title description:(NSString *)description
{
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    [popup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
}

-(void)dismissAllFeedbackPopups
{
    [KLCPopup dismissAllPopups];
}

- (void)klcPopup_dismissButtonPressed:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
}

-(void)showHUDFromView:(UIView *)view
{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

-(void)showHUDFromView:(UIView *)view withText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
}

-(void)showTextHUDFromView:(UIView *)view withText:(NSString *)text forDuration:(NSTimeInterval)duration
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud hide:YES afterDelay:duration];
}

-(void)hideHUDFromView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

-(void)hideAllHUDFromView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}
#endif

@end