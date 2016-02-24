//
//  Playbasis.h
//  Playbasis
//
//  Created by Playbasis.
//  Copyright (c) 2556 Playbasisß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "Reachability.h"
#import "JSONKit.h"
#import "PBTypes.h"
#import "PBRequestUnit.h"
#import "NSMutableArray+QueueAndSerializationAdditions.h"
#import "PBResponses.h"
#import "PBSettings.h"
#import "PBConstants.h"
#import "PBUtils.h"
#import "PBMacros.h"

/**
 Inclusion for all UIs.
 */
#import "PBUI.h"

/**
 Playbasis
 Handle the API end-point calls from client side.
 */
@interface Playbasis : NSObject <CLLocationManagerDelegate>
{
    NSString *_token;
    id<PBAuth_ResponseHandler> _authDelegate;
    NSMutableArray *_requestOptQueue;
    CLLocationManager *_locationManager;
    CMMotionManager *_coreMotionManager;
}

@property (nonatomic, strong, readonly) NSString* token;
@property (nonatomic, readonly) BOOL isNetworkReachable;
@property (nonatomic, strong, readonly) CMMotionManager *coreMotionManager;

/**
 Get / Set whether SDK should receive location.
 */
@property (nonatomic, readwrite) BOOL enableGettingLocation;

// ---------------------------------
// - Event delegates exposed here.
// ---------------------------------
/**
 Network status changed delegate.
 */
@property (nonatomic, strong) id<PBNetworkStatusChangedDelegate> networkStatusChangedDelegate;

/**
 Location updated delegate.
 */
@property (nonatomic, strong) id<PBLocationUpdatedDelegate> locationUpdatedDelegate;

/**
 Utility method to register device for push notification.
 Call this method inside
 */
+(void)registerDeviceForPushNotification;

/**
 Utility method to handle device token data, and convert it into
 a proper format ready to use later, then save it to NSUserDefaults
 for Playbasis SDK to retrieve it and register device for push
 notification later.
 
 @param deviceToken Device token sent in from native iOS platform.
 @param withKey Key string for Playbasis SDK to retrieve the value from later via NSUserDefaults.
 
 */
+(void)saveDeviceToken:(NSData *)deviceToken withKey:(NSString*)key;


/**
 Set protected resources key used to encrypt / decrypt files inside protectedResources.
 
 Default use "abcdefghijklmnopqrstuvwxyz123456" (without quote). You should change this value.
 
 To set this value, call this method before calling the first call of sharedPB() method.
 */
+(void)setProtectedResourcesKey:(NSString *)key;

/**
 Get the singleton instance of Playbasis.
 */
+(Playbasis*)sharedPB;

/**
 Version of sdk.
 */
+(NSString *)version;

-(id)initWithCoder:(NSCoder *)decoder;
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)init;
-(void)dealloc;

/**
 Get request-operational-queue.
 It holds all created http requests. Those requests are not dispatched or sent just yet. It's after dequeing, it will start sending those request one by one.
 */
-(const NSMutableArray *)getRequestOperationalQueue;

//------------------------------
//- Tracking Login of Player-id
//------------------------------
/**
 Set intended player-id that will be logged in.
 It also resets confirm flag immediately.
 User should not use this method. It's used internally.
 */
-(void)setIntendedLoginPlayerIdAndResetConfirmStatus:(NSString *)playerId;

/**
 Confirm intended loging in player-id.
 User should not usel this method. It's used internally.
 */
-(void)confirmIntendedLoginPlayerId:(BOOL)confirm;

/**
 Reset state of both intended player-id and its confirm status.
 */
-(void)resetIntendedLoginPlayerId;

//------------------------------

//------------------------------
//- Tracking Logout of Player-id
//------------------------------
/**
 Set intended player-id that will be logged out.
 It also resets confirm flag immediately.
 User should not use this method. It's used internally.
 */
-(void)setIntendedLogoutPlayerIdAndResetConfirmStatus:(NSString *)playerId;

/**
 Confirm intended loging out player-id.
 If intended login player-id matches intended logout player-id, then it will invalidate intended login player-id as well.
 User should not usel this method. It's used internally.
 */
-(void)confirmIntendedLogoutPlayerId:(BOOL)confirm;

/**
 Reset state of both intended player-id and its confirm status.
 */
-(void)resetIntendedLogoutPlayerId;

//------------------------------

/**
  Secure way to authenticate and get access token.
 */
-(PBRequestUnit *)authWithDelegate:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequestUnit *)authWithBlock:(PBAuth_ResponseBlock)block;
-(PBRequestUnit *)authWithDelegateAsync:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequestUnit *)authWithBlockAsync:(PBAuth_ResponseBlock)block;

-(PBRequestUnit *)authWithDelegate:(id<PBAuth_ResponseHandler>)delegate bundle:(NSBundle*)bundle;
-(PBRequestUnit *)authWithBlock:(PBAuth_ResponseBlock)block bundle:(NSBundle*)bundle;
-(PBRequestUnit *)authWithDelegateAsync:(id<PBAuth_ResponseHandler>)delegate bundle:(NSBundle*)bundle;
-(PBRequestUnit *)authWithBlockAsync:(PBAuth_ResponseBlock)block bundle:(NSBundle*)bundle;

/**
 Authenticate and get access token.
 */
-(PBRequestUnit *)authWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret bundleId:(NSString *)bundleId andDelegate:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequestUnit *)authWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret bundleId:(NSString *)bundleId andBlock:(PBAuth_ResponseBlock)block;
-(PBRequestUnit *)authWithApiKeyAsync:(NSString *)apiKey apiSecret:(NSString *)apiSecret bundleId:(NSString *)bundleId andDelegate:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequestUnit *)authWithApiKeyAsync:(NSString *)apiKey apiSecret:(NSString *)apiSecret bundleId:(NSString *)bundleId andBlock:(PBAuth_ResponseBlock)block;

/**
 Secure way to request a new access token, and discard the current one.
 */
-(PBRequestUnit *)renewWithDelegate:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequestUnit *)renewWithBlock:(PBAuth_ResponseBlock)block;
-(PBRequestUnit *)renewWithDelegateAsync:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequestUnit *)renewWithBlockAsync:(PBAuth_ResponseBlock)block;

/**
 This set of api calls allow input of bundle.
 */
-(PBRequestUnit *)renewWithDelegate:(id<PBAuth_ResponseHandler>)delegate bundle:(NSBundle*)bundle;
-(PBRequestUnit *)renewWithBlock:(PBAuth_ResponseBlock)block bundle:(NSBundle*)bundle;
-(PBRequestUnit *)renewWithDelegateAsync:(id<PBAuth_ResponseHandler>)delegate bundle:(NSBundle*)bundle;
-(PBRequestUnit *)renewWithBlockAsync:(PBAuth_ResponseBlock)block bundle:(NSBundle*)bundle;

/**
 Request a new access token, and discard the current one.
 */
-(PBRequestUnit *)renewWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret andDelegate:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequestUnit *)renewWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret andBlock:(PBAuth_ResponseBlock)block;
-(PBRequestUnit *)renewWithApiKeyAsync:(NSString *)apiKey apiSecret:(NSString *)apiSecret andDelegate:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequestUnit *)renewWithApiKeyAsync:(NSString *)apiKey apiSecret:(NSString *)apiSecret andBlock:(PBAuth_ResponseBlock)block;

/** 
 Get player's public information.
 It will send request via GET method.
 */
-(PBRequestUnit *)playerPublic:(NSString *)playerId withDelegate:(id<PBPlayerPublic_ResponseHandler>)delegate;
-(PBRequestUnit *)playerPublic:(NSString *)playerId withBlock:(PBPlayerPublic_ResponseBlock)block;
-(PBRequestUnit *)playerPublicAsync:(NSString *)playerId withDelegate:(id<PBPlayerPublic_ResponseHandler>)delegate;
-(PBRequestUnit *)playerPublicAsync:(NSString *)playerId withBlock:(PBPlayerPublic_ResponseBlock)block;

/** 
 Get player's both private and public information.
 */
-(PBRequestUnit *)player:(NSString *)playerId withDelegate:(id<PBPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)player:(NSString *)playerId withBlock:(PBPlayer_ResponseBlock)block;
-(PBRequestUnit *)playerAsync:(NSString *)playerId withDelegate:(id<PBPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)playerAsync:(NSString *)playerId withBlock:(PBPlayer_ResponseBlock)block;

/**
 Get basic information of list of players.
 playerListId is in the format of id separated by "," ie. "1,2,3".
 */
-(PBRequestUnit *)playerList:(NSString *)playerListId withDelegate:(id<PBPlayerList_ResponseHandler>)delegate;
-(PBRequestUnit *)playerList:(NSString *)playerListId withBlock:(PBPlayerList_ResponseBlock)block;
-(PBRequestUnit *)playerListAsync:(NSString *)playerListId withDelegate:(id<PBPlayerList_ResponseHandler>)delegate;
-(PBRequestUnit *)playerListAsync:(NSString *)playerListId withBlock:(PBPlayerList_ResponseBlock)block;

/**
 Get player's detailed public information including points and badge.
 */
-(PBRequestUnit *)playerDetailPublic:(NSString *)playerId withDelegate:(id<PBPlayerDetailedPublic_ResponseHandler>)delegate;
-(PBRequestUnit *)playerDetailPublic:(NSString *)playerId withBlock:(PBPlayerDetailedPublic_ResponseBlock)block;
-(PBRequestUnit *)playerDetailPublicAsync:(NSString *)playerId withDelegate:(id<PBPlayerDetailedPublic_ResponseHandler>)delegate;
-(PBRequestUnit *)playerDetailPublicAsync:(NSString *)playerId withBlock:(PBPlayerDetailedPublic_ResponseBlock)block;

/**
 Get player's detailed information both private and public one including points and badges.
 */
-(PBRequestUnit *)playerDetail:(NSString *)playerId withDelegate:(id<PBPlayerDetailed_ResponseHandler>)delegate;
-(PBRequestUnit *)playerDetail:(NSString *)playerId withBlock:(PBPlayerDetailed_ResponseBlock)block;
-(PBRequestUnit *)playerDetailAsync:(NSString *)playerId withDelegate:(id<PBPlayerDetailed_ResponseHandler>)delegate;
-(PBRequestUnit *)playerDetailAsync:(NSString *)playerId withBlock:(PBPlayerDetailed_ResponseBlock)block;

/**
 Set player's custom fields (intended for public data).
 */
-(PBRequestUnit *)playerSetCustomFields:(NSString *)playerId keys:(NSArray<NSString*>*)keys values:(NSArray<NSString*>*)values withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)playerSetCustomFields:(NSString *)playerId keys:(NSArray<NSString*>*)keys values:(NSArray<NSString*>*)values withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)playerSetCustomFieldsAsync:(NSString *)playerId keys:(NSArray<NSString*>*)keys values:(NSArray<NSString*>*)values withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)playerSetCustomFieldsAsync:(NSString *)playerId keys:(NSArray<NSString*>*)keys values:(NSArray<NSString*>*)values withBlock:(PBResultStatus_ResponseBlock)block;

/**
 Get player's custom fields.
 */
-(PBRequestUnit *)playerCustomFields:(NSString *)playerId withDelegate:(id<PBPlayerCustomFields_ResponseHandler>)delegate;
-(PBRequestUnit *)playerCustomFields:(NSString *)playerId withBlock:(PBPlayerCustomFields_ResponseBlock)block;
-(PBRequestUnit *)playerCustomFieldsAsync:(NSString *)playerId withDelegate:(id<PBPlayerCustomFields_ResponseHandler>)delegate;
-(PBRequestUnit *)playerCustomFieldsAsync:(NSString *)playerId withBlock:(PBPlayerCustomFields_ResponseBlock)block;

/**
 Register from the client side as a Playbasis player.
 */
-(PBRequestUnit *)registerUserWithPlayerId:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...;
-(PBRequestUnit *)registerUserWithPlayerId:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andBlock:(PBResultStatus_ResponseBlock)block, ...;
-(PBRequestUnit *)registerUserWithPlayerIdAsync:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...;
-(PBRequestUnit *)registerUserWithPlayerIdAsync:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andBlock:(PBResultStatus_ResponseBlock)block, ...;
-(PBRequestUnit *)registerUserWithPlayerIdAsync_:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andBlock:(PBAsyncURLRequestResponseBlock)block, ...;

/**
 Update player information.
 */
-(PBRequestUnit *)updateUserForPlayerId:(NSString *)playerId firstArg:(NSString *)firstArg andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...;
-(PBRequestUnit *)updateUserForPlayerId:(NSString *)playerId firstArg:(NSString *)firstArg andBlock:(PBResultStatus_ResponseBlock)block, ...;
-(PBRequestUnit *)updateUserForPlayerIdAsync:(NSString *)playerId firstArg:(NSString *)firstArg andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...;
-(PBRequestUnit *)updateUserForPlayerIdAsync:(NSString *)playerId firstArg:(NSString *)firstArg andBlock:(PBResultStatus_ResponseBlock)block, ...;
-(PBRequestUnit *)updateUserForPlayerIdAsync_:(NSString *)playerId firstArg:(NSString *)firstArg andBlock:(PBAsyncURLRequestResponseBlock)block, ...;

/**
 Permanently delete user from Playbasis's database.
 */
-(PBRequestUnit *)deleteUserWithPlayerId:(NSString *)playerId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)deleteUserWithPlayerId:(NSString *)playerId withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)deleteUserWithPlayerIdAsync:(NSString *)playerId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)deleteUserWithPlayerIdAsync:(NSString *)playerId withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)deleteUserWithPlayerIdAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Tell Playbasis system that player has logged in.
 It uses delegate callback.
 */
-(PBRequestUnit *)loginPlayer:(NSString *)playerId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)loginPlayer:(NSString *)playerId withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)loginPlayerAsync:(NSString *)playerId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)loginPlayerAsync:(NSString *)playerId withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)loginPlayerAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Tell Playbasis system that player has logged out.
 */
-(PBRequestUnit *)logoutPlayer:(NSString *)playerId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)logoutPlayer:(NSString *)playerId withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)logoutPlayerAsync:(NSString *)playerId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)logoutPlayerAsync:(NSString *)playerId withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)logoutPlayerAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Returns information about all point-based rewards that a player currently have.
 */
-(PBRequestUnit *)pointsOfPlayer:(NSString *)playerId withDelegate:(id<PBPoints_ResponseHandler>)delegate;
-(PBRequestUnit *)pointsOfPlayer:(NSString *)playerId withBlock:(PBPoints_ResponseBlock)block;
-(PBRequestUnit *)pointsOfPlayerAsync:(NSString *)playerId withDelegate:(id<PBPoints_ResponseHandler>)delegate;
-(PBRequestUnit *)pointsOfPlayerAsync:(NSString *)playerId withBlock:(PBPoints_ResponseBlock)block;


/**
 Returns how much of specified the point-based reward a player currently have.
 */
-(PBRequestUnit *)pointOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName withDelegate:(id<PBPoint_ResponseHandler>)delegate;
-(PBRequestUnit *)pointOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName withBlock:(PBPoint_ResponseBlock)block;
-(PBRequestUnit *)pointOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName withDelegate:(id<PBPoint_ResponseHandler>)delegate;
-(PBRequestUnit *)pointOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName withBlock:(PBPoint_ResponseBlock)block;

/**
 Get history point of user.
 With an optional parameter of 'point_name'.
 */
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName andBlock:(PBPointHistory_ResponseBlock)block;
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName andBlock:(PBPointHistory_ResponseBlock)block;

/**
 Get history point of user.
 With an optional parameter of 'offset'.
 */
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset andBlock:(PBPointHistory_ResponseBlock)block;
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset andBlock:(PBPointHistory_ResponseBlock)block;

/**
 Get history point of user.
 With an optional parameter of 'limit'.
 */
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;

/**
 Get history point of user.
 With optional parameters of 'point_name', and 'offset'.
 */
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset andBlock:(PBPointHistory_ResponseBlock)block;
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset andBlock:(PBPointHistory_ResponseBlock)block;

/**
 Get history point of user.
 With optional parameters of 'point_name', and 'limit'.
 */
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;

/**
 Get history point of user.
 With all of optional parameters 'point_name', 'offset', and 'limit'.
 */
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequestUnit *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequestUnit *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;

/**
 Get the latest time for the specified action that player has performed.
 */
-(PBRequestUnit *)actionTimeForPlayer:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionTime_ResponseHandler>)delegate;
-(PBRequestUnit *)actionTimeForPlayer:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionTime_ResponseBlock)block;
-(PBRequestUnit *)actionTimeForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionTime_ResponseHandler>)delegate;
-(PBRequestUnit *)actionTimeForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionTime_ResponseBlock)block;

/**
 Return the time and action that player has performed.
 */
-(PBRequestUnit *)actionLastPerformedForPlayer:(NSString *)playerId withDelegate:(id<PBLastAction_ResponseHandler>)delegate;
-(PBRequestUnit *)actionLastPerformedForPlayer:(NSString *)playerId withBlock:(PBLastAction_ResponseBlock)block;
-(PBRequestUnit *)actionLastPerformedForPlayerAsync:(NSString *)playerId withDelegate:(id<PBLastAction_ResponseHandler>)delegate;
-(PBRequestUnit *)actionLastPerformedForPlayerAsync:(NSString *)playerId withBlock:(PBLastAction_ResponseBlock)block;

/**
 Get the latest time of specified action that player has performed.
 */
-(PBRequestUnit *)actionLastPerformedTimeForPlayer:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionLastPerformedTime_ResponseHandler>)delegate;
-(PBRequestUnit *)actionLastPerformedTimeForPlayer:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionLastPerformedTime_ResponseBlock)block;
-(PBRequestUnit *)actionLastPerformedTimeForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionLastPerformedTime_ResponseHandler>)delegate;
-(PBRequestUnit *)actionLastPerformedTimeForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionLastPerformedTime_ResponseBlock)block;

/**
 Return the number of times that player has performed the specified action.
 */
-(PBRequestUnit *)actionPerformedCountForPlayer:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionCount_ResponseHandler>)delegate;
-(PBRequestUnit *)actionPerformedCountForPlayer:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionCount_ResponseBlock)block;
-(PBRequestUnit *)actionPerformedCountForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionCount_ResponseHandler>)delegate;
-(PBRequestUnit *)actionPerformedCountForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionCount_ResponseBlock)block;

/**
 Return information about all badges that player has earned.
 */
-(PBRequestUnit *)badgeOwnedForPlayer:(NSString *)playerId withDelegate:(id<PBPlayerBadges_ResponseHandler>)delegate;
-(PBRequestUnit *)badgeOwnedForPlayer:(NSString *)playerId withBlock:(PBPlayerBadges_ResponseBlock)block;
-(PBRequestUnit *)badgeOwnedForPlayerAsync:(NSString *)playerId withDelegate:(id<PBPlayerBadges_ResponseHandler>)delegate;
-(PBRequestUnit *)badgeOwnedForPlayerAsync:(NSString *)playerId withBlock:(PBPlayerBadges_ResponseBlock)block;

/**
 Returns list of players sorted by the specified point type.
 */
-(PBRequestUnit *)rankBy:(NSString *)rankedBy andDelegate:(id<PBRank_ResponseHandler>)delegate;
-(PBRequestUnit *)rankBy:(NSString *)rankedBy andBlock:(PBRank_ResponseBlock)block;
-(PBRequestUnit *)rankByAsync:(NSString *)rankedBy andDelegate:(id<PBRank_ResponseHandler>)delegate;
-(PBRequestUnit *)rankByAsync:(NSString *)rankedBy andBlock:(PBRank_ResponseBlock)block;
/**
 Returns list of players sorted by the specified point type.
 With optional parameter 'limit'
 */
-(PBRequestUnit *)rankBy:(NSString *)rankedBy withLimit:(unsigned int)limit andDelegate:(id<PBRank_ResponseHandler>)delegate;
-(PBRequestUnit *)rankBy:(NSString *)rankedBy withLimit:(unsigned int)limit andBlock:(PBRank_ResponseBlock)block;
-(PBRequestUnit *)rankByAsync:(NSString *)rankedBy withLimit:(unsigned int)limit andDelegate:(id<PBRank_ResponseHandler>)delegate;
-(PBRequestUnit *)rankByAsync:(NSString *)rankedBy withLimit:(unsigned int)limit andBlock:(PBRank_ResponseBlock)block;

/**
 Return list of players sorted by each point type.
 */
-(PBRequestUnit *)ranksWithLimit:(unsigned int)limit withDelegate:(id<PBRanks_ResponseHandler>)delegate;
-(PBRequestUnit *)ranksWithLimit:(unsigned int)limit withBlock:(PBRanks_ResponseBlock)block;
-(PBRequestUnit *)ranksWithLimitAsync:(unsigned int)limit withDelegate:(id<PBRanks_ResponseHandler>)delegate;
-(PBRequestUnit *)ranksWithLimitAsync:(unsigned int)limit withBlock:(PBRanks_ResponseBlock)block;

/**
 Return detail of level.
 */
-(PBRequestUnit *)level:(unsigned int)level withDelegate:(id<PBLevel_ResponseHandler>)delegate;
-(PBRequestUnit *)level:(unsigned int)level withBlock:(PBLevel_ResponseBlock)block;
-(PBRequestUnit *)levelAsync:(unsigned int)level withDelegate:(id<PBLevel_ResponseHandler>)delegate;
-(PBRequestUnit *)levelAsync:(unsigned int)level withBlock:(PBLevel_ResponseBlock)block;

/**
 Return all detail of levels.
 */
-(PBRequestUnit *)levelsWithDelegate:(id<PBLevels_ResponseHandler>)delegate;
-(PBRequestUnit *)levelsWithBlock:(PBLevels_ResponseBlock)block;
-(PBRequestUnit *)levelsAsyncWithDelegate:(id<PBLevels_ResponseHandler>)delegate;
-(PBRequestUnit *)levelsAsyncWithBlock:(PBLevels_ResponseBlock)block;

/**
 Claim a badge that player has earned.
 */
-(PBRequestUnit *)claimBadgeForPlayer:(NSString *)playerId badgeId:(NSString *)badgeId andDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)claimBadgeForPlayer:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)claimBadgeForPlayerAsync:(NSString *)playerId badgeId:(NSString *)badgeId andDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)claimBadgeForPlayerAsync:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)claimBadgeForPlayerAsync_:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Redeem a badge that player has claimed.
 */
-(PBRequestUnit *)redeemBadgeForPlayer:(NSString *)playerId badgeId:(NSString *)badgeId andDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)redeemBadgeForPlayer:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)redeemBadgeForPlayerAsync:(NSString *)playerId badgeId:(NSString *)badgeId andDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)redeemBadgeForPlayerAsync:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)redeemBadgeForPlayerAsync_:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Return information about all goods that player has redeemed.
 */
-(PBRequestUnit *)goodsOwnedOfPlayer:(NSString *)playerId withDelegate:(id<PBPlayerGoodsOwned_ResponseHandler>)delegate;
-(PBRequestUnit *)goodsOwnedOfPlayer:(NSString *)playerId withBlock:(PBPlayerGoodsOwned_ResponseBlock)block;
-(PBRequestUnit *)goodsOwnedOfPlayerAsync:(NSString *)playerId withDelegate:(id<PBPlayerGoodsOwned_ResponseHandler>)delegate;
-(PBRequestUnit *)goodsOwnedOfPlayerAsync:(NSString *)playerId withBlock:(PBPlayerGoodsOwned_ResponseBlock)block;

/**
 Return quest information that player has joined.
 */
-(PBRequestUnit *)questOfPlayer:(NSString *)playerId questId:(NSString *)questId andDelegate:(id<PBQuestOfPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questOfPlayer:(NSString *)playerId questId:(NSString *)questId andBlock:(PBQuestOfPlayer_ResponseBlock)block;
-(PBRequestUnit *)questOfPlayerAsync:(NSString *)playerId questId:(NSString *)questId andDelegate:(id<PBQuestOfPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questOfPlayerAsync:(NSString *)playerId questId:(NSString *)questId andBlock:(PBQuestOfPlayer_ResponseBlock)block;

/**
 Return list of quest that player has joined.
 */
-(PBRequestUnit *)questListOfPlayer:(NSString *)playerId withDelegate:(id<PBQuestListOfPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questListOfPlayer:(NSString *)playerId withBlock:(PBQuestListOfPlayer_ResponseBlock)block;
-(PBRequestUnit *)questListOfPlayerAsync:(NSString *)playerId withDelegate:(id<PBQuestListOfPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questListOfPlayerAsync:(NSString *)playerId withBlock:(PBQuestListOfPlayer_ResponseBlock)block;

/**
 Return quest reward history of player.
 With optional parameter 'offset'.
 */
-(PBRequestUnit *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;
-(PBRequestUnit *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;

/**
 Return quest reward history of player.
 With optional parameter 'limit'.
 */
-(PBRequestUnit *)questRewardHistoryOfPlayer:(NSString *)playerId limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questRewardHistoryOfPlayer:(NSString *)playerId limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;
-(PBRequestUnit *)questRewardHistoryOfPlayerAsync:(NSString *)playerId limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questRewardHistoryOfPlayerAsync:(NSString *)playerId limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;

/**
 Return quest reward history of player.
 With optional parameter 'offset', and 'limit'.
 */
-(PBRequestUnit *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;
-(PBRequestUnit *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;

/**
 Deduct reward from a given player.
 */
-(PBRequestUnit *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withDelegate:(id<PBDeductReward_ResponseHandler>)delegate;
-(PBRequestUnit *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withBlock:(PBDeductReward_ResponseBlock)block;
-(PBRequestUnit *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withDelegate:(id<PBDeductReward_ResponseHandler>)delegate;
-(PBRequestUnit *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withBlock:(PBDeductReward_ResponseBlock)block;
-(PBRequestUnit *)deductRewardFromPlayerAsync_:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withBlock:(PBAsyncURLRequestResponseBlock)block;
/**
 Deduct reward from a given player.
 With optional parameter 'force'.
 */
-(PBRequestUnit *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withDelegate:(id<PBDeductReward_ResponseHandler>)delegate;
-(PBRequestUnit *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withBlock:(PBDeductReward_ResponseBlock)block;
-(PBRequestUnit *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withDelegate:(id<PBDeductReward_ResponseHandler>)delegate;
-(PBRequestUnit *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withBlock:(PBDeductReward_ResponseBlock)block;
-(PBRequestUnit *)deductRewardFromPlayerAsync_:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Returns generated unique code of player, for referral program.
 And generate referral url
 */
-(PBRequestUnit *)playerUniqueCode:(NSString *)playerId withDelegate:(id<PBUniqueCode_ResponseHandler>) delegate;
-(PBRequestUnit *)playerUniqueCode:(NSString *)playerId withBlock:(PBUniqueCode_ResponseBlock) block;
-(PBRequestUnit *)playerUniqueCodeAsync:(NSString *)playerId withDelegate:(id<PBUniqueCode_ResponseHandler>) delegate;
-(PBRequestUnit *)playerUniqueCodeAsync:(NSString *)playerId withBlock:(PBUniqueCode_ResponseBlock) block;

/**
 Return information of specified badge.
 */
-(PBRequestUnit *)badge:(NSString *)badgeId withDelegate:(id<PBBadge_ResponseHandler>)delegate;
-(PBRequestUnit *)badge:(NSString *)badgeId withBlock:(PBBadge_ResponseBlock)block;
-(PBRequestUnit *)badgeAsync:(NSString *)badgeId withDelegate:(id<PBBadge_ResponseHandler>)delegate;
-(PBRequestUnit *)badgeAsync:(NSString *)badgeId withBlock:(PBBadge_ResponseBlock)block;

/**
 Return information about all badges of the current site.
 */
-(PBRequestUnit *)badgesWithDelegate:(id<PBBadges_ResponseHandler>)delegate;
-(PBRequestUnit *)badgesWithBlock:(PBBadges_ResponseBlock)block;
-(PBRequestUnit *)badgesAsyncWithDelegate:(id<PBBadges_ResponseHandler>)delegate;
-(PBRequestUnit *)badgesAsyncWithBlock:(PBBadges_ResponseBlock)block;

/**
 Return information about goods for the specified id.
 */
-(PBRequestUnit *)goods:(NSString *)goodId withDelegate:(id<PBGoodsInfo_ResponseHandler>)delegate;
-(PBRequestUnit *)goods:(NSString *)goodId withBlock:(PBGoodsInfo_ResponseBlock)block;
-(PBRequestUnit *)goodsAsync:(NSString *)goodId withDelegate:(id<PBGoodsInfo_ResponseHandler>)delegate;
-(PBRequestUnit *)goodsAsync:(NSString *)goodId withBlock:(PBGoodsInfo_ResponseBlock)block;

/**
 Return information about all available goods on the current site.
 */
-(PBRequestUnit *)goodsListWithDelegate:(id<PBGoodsListInfo_ResponseHandler>)delegate;
-(PBRequestUnit *)goodsListWithBlock:(PBGoodsListInfo_ResponseBlock)block;
-(PBRequestUnit *)goodsListAsyncWithDelegate:(id<PBGoodsListInfo_ResponseHandler>)delegate;
-(PBRequestUnit *)goodsListAsyncWithBlock:(PBGoodsListInfo_ResponseBlock)block;

/**
 Find number of available goods given group.
 */
-(PBRequestUnit *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate;
-(PBRequestUnit *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;
-(PBRequestUnit *)goodsGroupAvailableForPlayerAsync:(NSString *)playerId group:(NSString *)group withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate;
-(PBRequestUnit *)goodsGroupAvailableForPlayerAsync:(NSString *)playerId group:(NSString *)group withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;
-(PBRequestUnit *)goodsGroupAvailableForPlayerAsync_:(NSString *)playerId group:(NSString *)group withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;
/**
 Find number of available goods given group.
 With optional parameter 'amount'.
 */
-(PBRequestUnit *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate;
-(PBRequestUnit *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;
-(PBRequestUnit *)goodsGroupAvailableForPlayerAsync:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate;
-(PBRequestUnit *)goodsGroupAvailableForPlayerAsync:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;
-(PBRequestUnit *)goodsGroupAvailableForPlayerAsync_:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;

/**
 Return the name of actions that can trigger game's rules within a client's website.
 */
-(PBRequestUnit *)actionConfigWithDelegate:(id<PBActionConfig_ResponseHandler>)delegate;
-(PBRequestUnit *)actionConfigWithBlock:(PBActionConfig_ResponseBlock)block;
-(PBRequestUnit *)actionConfigAsyncWithDelegate:(id<PBActionConfig_ResponseHandler>)delegate;
-(PBRequestUnit *)actionConfigAsyncWithBlock:(PBActionConfig_ResponseBlock)block;
-(PBRequestUnit *)actionConfigAsyncWithBlock_:(PBAsyncURLRequestResponseBlock)block;

/**
 Process an action through all the game's rules defined for client's website.
 */
-(PBRequestUnit *)ruleForPlayer:(NSString *)playerId action:(NSString *)action withDelegate:(id<PBRule_ResponseHandler>)delegate, ...;
-(PBRequestUnit *)ruleForPlayer:(NSString *)playerId action:(NSString *)action withBlock:(PBRule_ResponseBlock)block, ...;
-(PBRequestUnit *)ruleForPlayerAsync:(NSString *)playerId action:(NSString *)action withDelegate:(id<PBRule_ResponseHandler>)delegate, ...;
-(PBRequestUnit *)ruleForPlayerAsync:(NSString *)playerId action:(NSString *)action withBlock:(PBRule_ResponseBlock)block, ...;
-(PBRequestUnit *)ruleForPlayerAsync_:(NSString *)playerId action:(NSString *)action withBlock:(PBAsyncURLRequestResponseBlock)block, ...;

/**
 + Return information about engine rule.
 + */
-(PBRequestUnit *)ruleDetailForPlayer:(NSString *)ruleId withDelegate:(id<PBRuleDetail_ResponseHandler>)delegate;
-(PBRequestUnit *)ruleDetailForPlayer:(NSString *)ruleId withBlock:(PBRuleDetail_ResponseBlock)block;
-(PBRequestUnit *)ruleDetailForPlayerAsync:(NSString *)ruleId withDelegate:(id<PBRuleDetail_ResponseHandler>)delegate;
-(PBRequestUnit *)ruleDetailForPlayerAsync:(NSString *)ruleId withBlock:(PBRuleDetail_ResponseBlock)block;

  
/**
 Return information about all quests in current site.
 */
-(PBRequestUnit *)questListWithDelegate:(id<PBQuestList_ResponseHandler>)delegate;
-(PBRequestUnit *)questListWithBlock:(PBQuestList_ResponseBlock)block;
-(PBRequestUnit *)questListWithDelegateAsync:(id<PBQuestList_ResponseHandler>)delegate;
-(PBRequestUnit *)questListWithBlockAsync:(PBQuestList_ResponseBlock)block;

/**
 Return information about quest with the specified id.
 */
-(PBRequestUnit *)quest:(NSString *)questId withDelegate:(id<PBQuestInfo_ResponseHandler>)delegate;
-(PBRequestUnit *)quest:(NSString *)questId withBlock:(PBQuestInfo_ResponseBlock)block;
-(PBRequestUnit *)questAsync:(NSString *)questId withDelegate:(id<PBQuestInfo_ResponseHandler>)delegate;
-(PBRequestUnit *)questAsync:(NSString *)questId withBlock:(PBQuestInfo_ResponseBlock)block;

/**
 Return information about mission with the specified id.
 */
-(PBRequestUnit *)mission:(NSString *)missionId ofQuest:(NSString *)questId withDelegate:(id<PBMissionInfo_ResponseHandler>)delegate;
-(PBRequestUnit *)mission:(NSString *)missionId ofQuest:(NSString *)questId withBlock:(PBMissionInfo_ResponseBlock)block;
-(PBRequestUnit *)missionAsync:(NSString *)missionId ofQuest:(NSString *)questId withDelegate:(id<PBMissionInfo_ResponseHandler>)delegate;
-(PBRequestUnit *)missionAsync:(NSString *)missionId ofQuest:(NSString *)questId withBlock:(PBMissionInfo_ResponseBlock)block;

/**
 Return information about all of the quests available for the player.
 */
-(PBRequestUnit *)questListAvailableForPlayer:(NSString *)playerId withDelegate:(id<PBQuestListAvailableForPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questListAvailableForPlayer:(NSString *)playerId withBlock:(PBQuestListAvailableForPlayer_ResponseBlock)block;
-(PBRequestUnit *)questListAvailableForPlayerAsync:(NSString *)playerId withDelegate:(id<PBQuestListAvailableForPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questListAvailableForPlayerAsync:(NSString *)playerId withBlock:(PBQuestListAvailableForPlayer_ResponseBlock)block;

/**
 Return information whether the quest is ready for the player.
 */
-(PBRequestUnit *)questAvailable:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestAvailableForPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questAvailable:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBQuestAvailableForPlayer_ResponseBlock)block;
-(PBRequestUnit *)questAvailableAsync:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestAvailableForPlayer_ResponseHandler>)delegate;
-(PBRequestUnit *)questAvailableAsync:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBQuestAvailableForPlayer_ResponseBlock)block;

/**
 Player joins a quest.
 */
-(PBRequestUnit *)joinQuest:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBJoinQuest_ResponseHandler>)delegate;
-(PBRequestUnit *)joinQuest:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBJoinQuest_ResponseBlock)block;
-(PBRequestUnit *)joinQuestAsync:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBJoinQuest_ResponseHandler>)delegate;
-(PBRequestUnit *)joinQuestAsync:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBJoinQuest_ResponseBlock)block;
-(PBRequestUnit *)joinQuestAsync_:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Player joins all quests.
 */
-(PBRequestUnit *)joinAllQuestsForPlayer:(NSString *)playerId withDelegate:(id<PBJoinAllQuests_ResponseHandler>)delegate;
-(PBRequestUnit *)joinAllQuestsForPlayer:(NSString *)playerId withBlock:(PBJoinAllQuests_ResponseBlock)block;
-(PBRequestUnit *)joinAllQuestsForPlayerAsync:(NSString *)playerId withDelegate:(id<PBJoinAllQuests_ResponseHandler>)delegate;
-(PBRequestUnit *)joinAllQuestsForPlayerAsync:(NSString *)playerId withBlock:(PBJoinAllQuests_ResponseBlock)block;
-(PBRequestUnit *)joinAllQuestsForPlayerAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Player cancels a quest.
 */
-(PBRequestUnit *)cancelQuest:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBCancelQuest_ResponseHandler>)delegate;
-(PBRequestUnit *)cancelQuest:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBCancelQuest_ResponseBlock)block;
-(PBRequestUnit *)cancelQuestAsync:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBCancelQuest_ResponseHandler>)delegate;
-(PBRequestUnit *)cancelQuestAsync:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBCancelQuest_ResponseBlock)block;
-(PBRequestUnit *)cancelQuestAsync_:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Redeem goods for player.
 */
-(PBRequestUnit *)redeemGoods:(NSString *)goodsId forPlayer:(NSString *)playerId withDelegate:(id<PBRedeemGoods_ResponseHandler>)delegate;
-(PBRequestUnit *)redeemGoods:(NSString *)goodsId forPlayer:(NSString *)playerId withBlock:(PBRedeemGoods_ResponseBlock)block;
-(PBRequestUnit *)redeemGoodsAsync:(NSString *)goodsId forPlayer:(NSString *)playerId withDelegate:(id<PBRedeemGoods_ResponseHandler>)delegate;
-(PBRequestUnit *)redeemGoodsAsync:(NSString *)goodsId forPlayer:(NSString *)playerId withBlock:(PBRedeemGoods_ResponseBlock)block;
-(PBRequestUnit *)redeemGoodsAsync_:(NSString *)goodsId forPlayer:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block;
/**
 Redeem goods for player.
 With optional parameter 'amount'
 */
-(PBRequestUnit *)redeemGoods:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withDelegate:(id<PBRedeemGoods_ResponseHandler>)delegate;
-(PBRequestUnit *)redeemGoods:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBRedeemGoods_ResponseBlock)block;
-(PBRequestUnit *)redeemGoodsAsync:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withDelegate:(id<PBRedeemGoods_ResponseHandler>)delegate;
-(PBRequestUnit *)redeemGoodsAsync:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBRedeemGoods_ResponseBlock)block;
-(PBRequestUnit *)redeemGoodsAsync_:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Redeem goods group for player.
 */
-(PBRequestUnit *)redeemGoodsGroup:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequestUnit *)redeemGoodsGroup:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withBlock:(PBResponseBlock)block;
-(PBRequestUnit *)redeemGoodsGroupAsync:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequestUnit *)redeemGoodsGroupAsync:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withBlock:(PBResponseBlock)block;
-(PBRequestUnit *)redeemGoodsGroupAsync_:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withBlock:(PBResponseBlock)block;
/**
 Redeem goods group for player.
 With optional parameter 'amount'
 */
-(PBRequestUnit *)redeemGoodsGroup:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequestUnit *)redeemGoodsGroup:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBResponseBlock)block;
-(PBRequestUnit *)redeemGoodsGroupAsync:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequestUnit *)redeemGoodsGroupAsync:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBResponseBlock)block;
-(PBRequestUnit *)redeemGoodsGroupAsync_:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBResponseBlock)block;

/**
 Return recent activity points of all players.
 With optional parameters 'offset', and 'limit'
 */
-(PBRequestUnit *)recentPointWithOffset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate;
-(PBRequestUnit *)recentPointWithOffset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block;
-(PBRequestUnit *)recentPointWithOffsetAsync:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate;
-(PBRequestUnit *)recentPointWithOffsetAsync:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block;

/**
 Return recent activity points of point name of all players.
 With all optional parameters.
 */
-(PBRequestUnit *)recentPointByName:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate;
-(PBRequestUnit *)recentPointByName:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block;
-(PBRequestUnit *)recentPointByNameAsync:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate;
-(PBRequestUnit *)recentPointByNameAsync:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block;

/**
 Reset point for all players.
 */
-(PBRequestUnit *)resetPointForAllPlayersWithDelegate:(id<PBResetPoint_ResponseHandler>)delegate;
-(PBRequestUnit *)resetPointForAllPlayersWithBlock:(PBResetPoint_ResponseBlock)block;
-(PBRequestUnit *)resetPointForAllPlayersWithDelegateAsync:(id<PBResetPoint_ResponseHandler>)delegate;
-(PBRequestUnit *)resetPointForAllPlayersWithBlockAsync:(PBResetPoint_ResponseBlock)block;
-(PBRequestUnit *)resetPointForAllPlayersWithBlockAsync_:(PBAsyncURLRequestResponseBlock)block;
/**
 Reset point for all players.
 With optional parameter 'point_name'
 */
-(PBRequestUnit *)resetPointForAllPlayersForPoint:(NSString *)pointName withDelegate:(id<PBResetPoint_ResponseHandler>)delegate;
-(PBRequestUnit *)resetPointForAllPlayersForPoint:(NSString *)pointName withBlock:(PBResetPoint_ResponseBlock)block;
-(PBRequestUnit *)resetPointForAllPlayersForPointAsync:(NSString *)pointName withDelegate:(id<PBResetPoint_ResponseHandler>)delegate;
-(PBRequestUnit *)resetPointForAllPlayersForPointAsync:(NSString *)pointName withBlock:(PBResetPoint_ResponseBlock)block;
-(PBRequestUnit *)resetPointForAllPlayersForPointAsync_:(NSString *)pointName withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Send Email to a player.
 */
-(PBRequestUnit *)sendEmailForPlayer:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)sendEmailForPlayer:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)sendEmailForPlayerAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)sendEmailForPlayerAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)sendEmailForPlayerAsync_:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Send Email to a player with template-id.
 */
-(PBRequestUnit *)sendEmailForPlayer:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)sendEmailForPlayer:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)sendEmailForPlayerAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)sendEmailForPlayerAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)sendEmailForPlayerAsync_:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Send Email Coupon to a player.
 */
-(PBRequestUnit *)sendEmailCouponForPlayer:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)sendEmailCouponForPlayer:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)sendEmailCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)sendEmailCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)sendEmailCouponForPlayerAsync_:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Send Email Coupon to a player with template-id.
 */
-(PBRequestUnit *)sendEmailCouponForPlayer:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)sendEmailCouponForPlayer:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)sendEmailCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResultStatus_ResponseHandler>)delegate;
-(PBRequestUnit *)sendEmailCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResultStatus_ResponseBlock)block;
-(PBRequestUnit *)sendEmailCouponForPlayerAsync_:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Return a list of active quizzes.
 */
-(PBRequestUnit *)quizListWithDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate;
-(PBRequestUnit *)quizListWithBlock:(PBActiveQuizList_ResponseBlock)block;
-(PBRequestUnit *)quizListWithDelegateAsync:(NSString *)playerId withDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate;
-(PBRequestUnit *)quizListWithBlockAsync:(PBActiveQuizList_ResponseBlock)block;
/**
 Return a list of active quizzes.
 With optional parameter 'playerId'.
 */
-(PBRequestUnit *)quizListOfPlayer:(NSString *)playerId withDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate;
-(PBRequestUnit *)quizListOfPlayer:(NSString *)playerId withBlock:(PBActiveQuizList_ResponseBlock)block;
-(PBRequestUnit *)quizListOfPlayerAsync:(NSString *)playerId withDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate;
-(PBRequestUnit *)quizListOfPlayerAsync:(NSString *)playerId withBlock:(PBActiveQuizList_ResponseBlock)block;

/**
 Get detail of a quiz.
 */
-(PBRequestUnit *)quizDetail:(NSString *)quizId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate;
-(PBRequestUnit *)quizDetail:(NSString *)quizId withBlock:(PBQuizDetail_ResponseBlock)block;
-(PBRequestUnit *)quizDetailAsync:(NSString *)quizId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate;
-(PBRequestUnit *)quizDetailAsync:(NSString *)quizId withBlock:(PBQuizDetail_ResponseBlock)block;

/**
 Get detail of a quiz by also specifying player-id.
 */
-(PBRequestUnit *)quizDetail:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate;
-(PBRequestUnit *)quizDetail:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuizDetail_ResponseBlock)block;
-(PBRequestUnit *)quizDetailAsync:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate;
-(PBRequestUnit *)quizDetailAsync:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuizDetail_ResponseBlock)block;

/**
 Get a random of quiz from available quizzes of player.
 */
-(PBRequestUnit *)quizRandomForPlayer:(NSString *)playerId withDelegate:(id<PBQuizRandom_ResponseHandler>)delegate;
-(PBRequestUnit *)quizRandomForPlayer:(NSString *)playerId withBlock:(PBQuizRandom_ResponseBlock)block;
-(PBRequestUnit *)quizRandomForPlayerAsync:(NSString *)playerId withDelegate:(id<PBQuizRandom_ResponseHandler>)delegate;
-(PBRequestUnit *)quizRandomForPlayerAsync:(NSString *)playerId withBlock:(PBQuizRandom_ResponseBlock)block;

/**
 Get recent quizzes done by player.
 */
-(PBRequestUnit *)quizDoneForPlayer:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizDoneList_ResponseHandler>)delegate;
-(PBRequestUnit *)quizDoneForPlayer:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizDoneList_ResponseBlock)block;
-(PBRequestUnit *)quizDoneForPlayerAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizDoneList_ResponseHandler>)delegate;
-(PBRequestUnit *)quizDoneForPlayerAsync:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizDoneList_ResponseBlock)block;

/**
 Get pending quizzes by player.
 */
-(PBRequestUnit *)quizPendingOfPlayer:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizPendings_ResponseHandler>)delegate;
-(PBRequestUnit *)quizPendingOfPlayer:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizPendings_ResponseBlock)block;
-(PBRequestUnit *)quizPendingOfPlayerAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizPendings_ResponseHandler>)delegate;
-(PBRequestUnit *)quizPendingOfPlayerAsync:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizPendings_ResponseBlock)block;

/**
 Get a question from a quiz for player.
 */
-(PBRequestUnit *)quizQuestion:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestion_ResponseHandler>)delegate;
-(PBRequestUnit *)quizQuestion:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuestion_ResponseBlock)block;
-(PBRequestUnit *)quizQuestionAsync:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestion_ResponseHandler>)delegate;
-(PBRequestUnit *)quizQuestionAsync:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuestion_ResponseBlock)block;

#if PBSandBoxEnabled==1
-(PBRequestUnit *)quizQuestion:(NSString *)quizId lastQuestion:(NSString*)lastQuestionId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestion_ResponseHandler>)delegate;
-(PBRequestUnit *)quizQuestion:(NSString *)quizId lastQuestion:(NSString*)lastQuestionId forPlayer:(NSString *)playerId withBlock:(PBQuestion_ResponseBlock)block;
-(PBRequestUnit *)quizQuestionAsync:(NSString *)quizId lastQuestion:(NSString*)lastQuestionId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestion_ResponseHandler>)delegate;
-(PBRequestUnit *)quizQuestionAsync:(NSString *)quizId lastQuestion:(NSString*)lastQuestionId forPlayer:(NSString *)playerId withBlock:(PBQuestion_ResponseBlock)block;
#endif

/**
 Answer a question for a given quiz.
 */
-(PBRequestUnit *)quizAnswer:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withDelegate:(id<PBQuestionAnswered_ResponseHandler>)delegate;
-(PBRequestUnit *)quizAnswer:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBQuestionAnswered_ResponseBlock)block;
-(PBRequestUnit *)quizAnswerAsync:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withDelegate:(id<PBQuestionAnswered_ResponseHandler>)delegate;
-(PBRequestUnit *)quizAnswerAsync:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBQuestionAnswered_ResponseBlock)block;
-(PBRequestUnit *)quizAnswerAsync_:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBQuestionAnswered_ResponseBlock)block;

/**
 Rank player by their score for a quiz.
 */
-(PBRequestUnit *)quizScoreRank:(NSString *)quizId limit:(NSInteger)limit withDelegate:(id<PBPlayersQuizRank_ResponseHandler>)delegate;
-(PBRequestUnit *)quizScoreRank:(NSString *)quizId limit:(NSInteger)limit withBlock:(PBPlayersQuizRank_ResponseBlock)block;
-(PBRequestUnit *)quizScoreRankAsync:(NSString *)quizId limit:(NSInteger)limit withDelegate:(id<PBPlayersQuizRank_ResponseHandler>)delegate;
-(PBRequestUnit *)quizScoreRankAsync:(NSString *)quizId limit:(NSInteger)limit withBlock:(PBPlayersQuizRank_ResponseBlock)block;

/**
 Send SMS to a player.
 */
-(PBRequestUnit *)sendSMSForPlayer:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBSendSMS_ResponseHandler>)delegate;
-(PBRequestUnit *)sendSMSForPlayer:(NSString *)playerId message:(NSString *)message withBlock:(PBSendSMS_ResponseBlock)block;
-(PBRequestUnit *)sendSMSForPlayerAsync:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBSendSMS_ResponseHandler>)delegate;
-(PBRequestUnit *)sendSMSForPlayerAsync:(NSString *)playerId message:(NSString *)message withBlock:(PBSendSMS_ResponseBlock)block;
-(PBRequestUnit *)sendSMSForPlayerAsync_:(NSString *)playerId message:(NSString *)message withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Send SMS to a player with a template-id.
 */
-(PBRequestUnit *)sendSMSForPlayer:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBSendSMS_ResponseHandler>)delegate;
-(PBRequestUnit *)sendSMSForPlayer:(NSString *)playerId message:(NSString *)message tempalte:(NSString *)templateId withBlock:(PBSendSMS_ResponseBlock)block;
-(PBRequestUnit *)sendSMSForPlayerAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBSendSMS_ResponseHandler>)delegate;
-(PBRequestUnit *)sendSMSForPlayerAsync:(NSString *)playerId message:(NSString *)message tempalte:(NSString *)templateId withBlock:(PBSendSMS_ResponseBlock)block;
-(PBRequestUnit *)sendSMSForPlayerAsync_:(NSString *)playerId message:(NSString *)message tempalte:(NSString *)templateId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Send SMS Coupon to a player via SMS.
 */
-(PBRequestUnit *)sendSMSCouponForPlayer:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withDelegate:(id<PBSendSMS_ResponseHandler>)delegate;
-(PBRequestUnit *)sendSMSCouponForPlayer:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBSendSMS_ResponseBlock)block;
-(PBRequestUnit *)sendSMSCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withDelegate:(id<PBSendSMS_ResponseHandler>)delegate;
-(PBRequestUnit *)sendSMSCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBSendSMS_ResponseBlock)block;
-(PBRequestUnit *)sendSMSCouponForPlayerAsync_:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Send SMS Coupon to a player via SMS with a template-id.
 */
-(PBRequestUnit *)sendSMSCouponForPlayer:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBSendSMS_ResponseHandler>)delegate;
-(PBRequestUnit *)sendSMSCouponForPlayer:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBSendSMS_ResponseBlock)block;
-(PBRequestUnit *)sendSMSCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBSendSMS_ResponseHandler>)delegate;
-(PBRequestUnit *)sendSMSCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBSendSMS_ResponseBlock)block;
-(PBRequestUnit *)sendSMSCouponForPlayerAsync_:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Push notification for player.
 */
-(PBRequestUnit *)pushNotificationForPlayer:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequestUnit *)pushNotificationForPlayer:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequestUnit *)pushNotificationForPlayerAsync:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequestUnit *)pushNotificationForPlayerAsync:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block;
/**
 Push notification with template id.
 */
-(PBRequestUnit *)pushNotificationForPlayer:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequestUnit *)pushNotificationForPlayer:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequestUnit *)pushNotificationForPlayerAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequestUnit *)pushNotificationForPlayerAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;

/**
 Push notification for player.
 */
-(PBRequestUnit *)pushNotificationCouponForPlayer:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequestUnit *)pushNotificationCouponForPlayer:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequestUnit *)pushNotificationCouponForPlayerAsync:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequestUnit *)pushNotificationCouponForPlayerAsync:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block;
/**
 Push notification with template id.
 */
-(PBRequestUnit *)pushNotificationCouponForPlayer:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequestUnit *)pushNotificationCouponForPlayer:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequestUnit *)pushNotificationCouponForPlayerAsync:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequestUnit *)pushNotificationCouponForPlayerAsync:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;

/**
 Register device for push notification.
 */
-(PBRequestUnit *)registerForPushNotification:(id<PBResponseHandler>)delegate;

/**
 Track player with an action.
 */
-(void)trackPlayer:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Do player for a given action.
 This is similar to track but will get payload back in response.
 */
-(void)doPlayer:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withDelegate:(id<PBResponseHandler>)delegate;
-(void)doPlayer:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withBlock:(PBResponseBlock)block;
-(void)doPlayerAsync:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withDelegate:(id<PBResponseHandler>)delegate;
-(void)doPlayerAsync:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withBlock:(PBResponseBlock)block;

//--------------------------------------------------
// UI - for KLCPopup
//--------------------------------------------------
-(void)showRegistrationFormFromView:(UIViewController *)view withBlock:(PBResponseBlock)block;
-(void)showRegistrationFormFromView:(UIViewController *)view intendedPlayerId:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(void)showFeedbackStatusUpdateWithText:(NSString *)text;
-(void)showFeedbackStatusUpdateWithText:(NSString *)text duration:(NSTimeInterval)duration;
-(void)showFeedbackEventPopupWithImage:(UIImage *)image title:(NSString *)title description:(NSString*)description;
-(void)showFeedbackEventPopupWithContent:(UIView *)contentView image:(UIImage *)image title:(NSString *)title description:(NSString*)description;
-(void)dismissAllFeedbackPopups;

//--------------------------------------------------
// UI - for MBProgressHUD
//--------------------------------------------------
-(void)showHUDFromView:(UIView *)view;
-(void)showHUDFromView:(UIView *)view withText:(NSString *)text;
-(void)showTextHUDFromView:(UIView *)view withText:(NSString *)text forDuration:(NSTimeInterval)duration;
-(void)hideHUDFromView:(UIView *)view;
-(void)hideAllHUDFromView:(UIView *)view;

@end
