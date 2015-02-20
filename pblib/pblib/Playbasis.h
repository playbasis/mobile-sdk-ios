//
//  Playbasis.h
//  Playbasis
//
//  Created by Playbasis.
//  Copyright (c) 2556 Playbasisß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "libs/Reachability/Reachability.h"
#import "JSONKit.h"
#import "PBTypes.h"
#import "PBRequest.h"
#import "NSMutableArray+QueueAndSerializationAdditions.h"
#import "PBResponses.h"

/**
 Inclusion for all UIs.
 */
#import "ui/PBUI.h"

/**
 Playbasis
 Handle the API end-point calls from client side.
 */
@interface Playbasis : NSObject
{
    NSString *token;
    NSString *_apiKey;
    NSString *apiKeyParam;
    id<PBAuth_ResponseHandler> authDelegate;
    NSMutableArray *requestOptQueue;
}

@property (nonatomic, readonly) NSString* token;
@property (nonatomic, readonly) NSString* apiKey;

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
 Get the singleton instance of Playbasis.
 */
+(Playbasis*)sharedPB;

-(id)initWithCoder:(NSCoder *)decoder;
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)init;
-(void)dealloc;

/**
 Get request-operational-queue.
 It holds all created http requests. Those requests are not dispatched or sent just yet. It's after dequeing, it will start sending those request one by one.
 */
-(const NSMutableArray *)getRequestOperationalQueue;

/**
 Authenticate and get access token.
 */
-(PBRequest *)authWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret andDelegate:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequest *)authWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret andBlock:(PBAuth_ResponseBlock)block;
-(PBRequest *)authWithApiKeyAsync:(NSString *)apiKey apiSecret:(NSString *)apiSecret andDelegate:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequest *)authWithApiKeyAsync:(NSString *)apiKey apiSecret:(NSString *)apiSecret andBlock:(PBAuth_ResponseBlock)block;

/**
 Request a new access token, and discard the current one.
 */
-(PBRequest *)renewWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret andDelegate:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequest *)renewWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret andBlock:(PBAuth_ResponseBlock)block;
-(PBRequest *)renewWithApiKeyAsync:(NSString *)apiKey apiSecret:(NSString *)apiSecret andDelegate:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequest *)renewWithApiKeyAsync:(NSString *)apiKey apiSecret:(NSString *)apiSecret andBlock:(PBAuth_ResponseBlock)block;

/** 
 Get player's public information.
 It will send request via GET method.
 */
-(PBRequest *)playerPublic:(NSString *)playerId withDelegate:(id<PBPlayerPublic_ResponseHandler>)delegate;
-(PBRequest *)playerPublic:(NSString *)playerId withBlock:(PBPlayerPublic_ResponseBlock)block;
-(PBRequest *)playerPublicAsync:(NSString *)playerId withDelegate:(id<PBPlayerPublic_ResponseHandler>)delegate;
-(PBRequest *)playerPublicAsync:(NSString *)playerId withBlock:(PBPlayerPublic_ResponseBlock)block;

/** 
 Get player's both private and public information.
 */
-(PBRequest *)player:(NSString *)playerId withDelegate:(id<PBPlayer_ResponseHandler>)delegate;
-(PBRequest *)player:(NSString *)playerId withBlock:(PBPlayer_ResponseBlock)block;
-(PBRequest *)playerAsync:(NSString *)playerId withDelegate:(id<PBPlayer_ResponseHandler>)delegate;
-(PBRequest *)playerAsync:(NSString *)playerId withBlock:(PBPlayer_ResponseBlock)block;

/**
 Get basic information of list of players.
 playerListId is in the format of id separated by "," ie. "1,2,3".
 */
-(PBRequest *)playerList:(NSString *)playerListId withDelegate:(id<PBPlayerList_ResponseHandler>)delegate;
-(PBRequest *)playerList:(NSString *)playerListId withBlock:(PBPlayerList_ResponseBlock)block;
-(PBRequest *)playerListAsync:(NSString *)playerListId withDelegate:(id<PBPlayerList_ResponseHandler>)delegate;
-(PBRequest *)playerListAsync:(NSString *)playerListId withBlock:(PBPlayerList_ResponseBlock)block;

/**
 Get player's detailed public information including points and badge.
 */
-(PBRequest *)playerDetailPublic:(NSString *)playerId withDelegate:(id<PBPlayerDetailedPublic_ResponseHandler>)delegate;
-(PBRequest *)playerDetailPublic:(NSString *)playerId withBlock:(PBPlayerDetailedPublic_ResponseBlock)block;
-(PBRequest *)playerDetailPublicAsync:(NSString *)playerId withDelegate:(id<PBPlayerDetailedPublic_ResponseHandler>)delegate;
-(PBRequest *)playerDetailPublicAsync:(NSString *)playerId withBlock:(PBPlayerDetailedPublic_ResponseBlock)block;

/**
 Get player's detailed information both private and public one including points and badges.
 */
-(PBRequest *)playerDetail:(NSString *)playerId withDelegate:(id<PBPlayerDetailed_ResponseHandler>)delegate;
-(PBRequest *)playerDetail:(NSString *)playerId withBlock:(PBPlayerDetailed_ResponseBlock)block;
-(PBRequest *)playerDetailAsync:(NSString *)playerId withDelegate:(id<PBPlayerDetailed_ResponseHandler>)delegate;
-(PBRequest *)playerDetailAsync:(NSString *)playerId withBlock:(PBPlayerDetailed_ResponseBlock)block;

/**
 Register from the client side as a Playbasis player.
 */
-(PBRequest *)registerUserWithPlayerId:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...;
-(PBRequest *)registerUserWithPlayerId:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andBlock:(PBResultStatus_ResponseBlock)block, ...;
-(PBRequest *)registerUserWithPlayerIdAsync:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andDelegate:(id<PBResultStatus_ResponseHandler>)delegate, ...;
-(PBRequest *)registerUserWithPlayerIdAsync:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andBlock:(PBResultStatus_ResponseBlock)block, ...;
-(PBRequest *)registerUserWithPlayerIdAsync_:(NSString *)playerId username:(NSString *)username email:(NSString *)email imageUrl:(NSString *)imageUrl andBlock:(PBAsyncURLRequestResponseBlock)block, ...;

/**
 Update player information.
 */
-(PBRequest *)updateUserForPlayerId:(NSString *)playerId firstArg:(NSString *)firstArg andDelegate:(id<PBResponseHandler>)delegate, ...;
-(PBRequest *)updateUserForPlayerId:(NSString *)playerId firstArg:(NSString *)firstArg andBlock:(PBResponseBlock)block, ...;
-(PBRequest *)updateUserForPlayerIdAsync:(NSString *)playerId firstArg:(NSString *)firstArg andDelegate:(id<PBResponseHandler>)delegate, ...;
-(PBRequest *)updateUserForPlayerIdAsync:(NSString *)playerId firstArg:(NSString *)firstArg andBlock:(PBResponseBlock)block, ...;
-(PBRequest *)updateUserForPlayerIdAsync_:(NSString *)playerId firstArg:(NSString *)firstArg andBlock:(PBAsyncURLRequestResponseBlock)block, ...;

/**
 Permanently delete user from Playbasis's database.
 */
-(PBRequest *)deleteUserWithPlayerId:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)deleteUserWithPlayerId:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)deleteUserWithPlayerIdAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)deleteUserWithPlayerIdAsync:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)deleteUserWithPlayerIdAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Tell Playbasis system that player has logged in.
 It uses delegate callback.
 */
-(PBRequest *)loginPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)loginPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)loginPlayerAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)loginPlayerAsync:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)loginPlayerAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Tell Playbasis system that player has logged out.
 */
-(PBRequest *)logoutPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)logoutPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)logoutPlayerAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)logoutPlayerAsync:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)logoutPlayerAsync_:(NSString *)playerId withBlock:(PBResponseBlock)block;

/**
 Returns information about all point-based rewards that a player currently have.
 */
-(PBRequest *)pointsOfPlayer:(NSString *)playerId withDelegate:(id<PBPoints_ResponseHandler>)delegate;
-(PBRequest *)pointsOfPlayer:(NSString *)playerId withBlock:(PBPoints_ResponseBlock)block;
-(PBRequest *)pointsOfPlayerAsync:(NSString *)playerId withDelegate:(id<PBPoints_ResponseHandler>)delegate;
-(PBRequest *)pointsOfPlayerAsync:(NSString *)playerId withBlock:(PBPoints_ResponseBlock)block;


/**
 Returns how much of specified the point-based reward a player currently have.
 */
-(PBRequest *)pointOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName withDelegate:(id<PBPoint_ResponseHandler>)delegate;
-(PBRequest *)pointOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName withBlock:(PBPoint_ResponseBlock)block;
-(PBRequest *)pointOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName withDelegate:(id<PBPoint_ResponseHandler>)delegate;
-(PBRequest *)pointOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName withBlock:(PBPoint_ResponseBlock)block;

/**
 Get history point of user.
 With an optional parameter of 'point_name'.
 */
-(PBRequest *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName andBlock:(PBPointHistory_ResponseBlock)block;
-(PBRequest *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName andBlock:(PBPointHistory_ResponseBlock)block;

/**
 Get history point of user.
 With an optional parameter of 'offset'.
 */
-(PBRequest *)pointHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset andBlock:(PBPointHistory_ResponseBlock)block;
-(PBRequest *)pointHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset andBlock:(PBPointHistory_ResponseBlock)block;

/**
 Get history point of user.
 With an optional parameter of 'limit'.
 */
-(PBRequest *)pointHistoryOfPlayer:(NSString *)playerId withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistoryOfPlayer:(NSString *)playerId withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;
-(PBRequest *)pointHistoryOfPlayerAsync:(NSString *)playerId withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistoryOfPlayerAsync:(NSString *)playerId withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;

/**
 Get history point of user.
 With optional parameters of 'point_name', and 'offset'.
 */
-(PBRequest *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset andBlock:(PBPointHistory_ResponseBlock)block;
-(PBRequest *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset andBlock:(PBPointHistory_ResponseBlock)block;

/**
 Get history point of user.
 With optional parameters of 'point_name', and 'limit'.
 */
-(PBRequest *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;
-(PBRequest *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;

/**
 Get history point of user.
 With all of optional parameters 'point_name', 'offset', and 'limit'.
 */
-(PBRequest *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistoryOfPlayer:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;
-(PBRequest *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistoryOfPlayerAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;

/**
 Get the latest time for the specified action that player has performed.
 */
-(PBRequest *)actionTimeForPlayer:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionTime_ResponseHandler>)delegate;
-(PBRequest *)actionTimeForPlayer:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionTime_ResponseBlock)block;
-(PBRequest *)actionTimeForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionTime_ResponseHandler>)delegate;
-(PBRequest *)actionTimeForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionTime_ResponseBlock)block;

/**
 Return the time and action that player has performed.
 */
-(PBRequest *)actionLastPerformedForPlayer:(NSString *)playerId withDelegate:(id<PBLastAction_ResponseHandler>)delegate;
-(PBRequest *)actionLastPerformedForPlayer:(NSString *)playerId withBlock:(PBLastAction_ResponseBlock)block;
-(PBRequest *)actionLastPerformedForPlayerAsync:(NSString *)playerId withDelegate:(id<PBLastAction_ResponseHandler>)delegate;
-(PBRequest *)actionLastPerformedForPlayerAsync:(NSString *)playerId withBlock:(PBLastAction_ResponseBlock)block;

/**
 Get the latest time of specified action that player has performed.
 */
-(PBRequest *)actionLastPerformedTimeForPlayer:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)actionLastPerformedTimeForPlayer:(NSString *)playerId action:(NSString *)actionName withBlock:(PBResponseBlock)block;
-(PBRequest *)actionLastPerformedTimeForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)actionLastPerformedTimeForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withBlock:(PBResponseBlock)block;

/**
 Return the number of times that player has performed the specified action.
 */
-(PBRequest *)actionPerformedCountForPlayer:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionCount_ResponseHandler>)delegate;
-(PBRequest *)actionPerformedCountForPlayer:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionCount_ResponseBlock)block;
-(PBRequest *)actionPerformedCountForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withDelegate:(id<PBActionCount_ResponseHandler>)delegate;
-(PBRequest *)actionPerformedCountForPlayerAsync:(NSString *)playerId action:(NSString *)actionName withBlock:(PBActionCount_ResponseBlock)block;

/**
 Return information about all badges that player has earned.
 */
-(PBRequest *)badgeOwnedForPlayer:(NSString *)playerId withDelegate:(id<PBPlayerBadges_ResponseHandler>)delegate;
-(PBRequest *)badgeOwnedForPlayer:(NSString *)playerId withBlock:(PBPlayerBadges_ResponseBlock)block;
-(PBRequest *)badgeOwnedForPlayerAsync:(NSString *)playerId withDelegate:(id<PBPlayerBadges_ResponseHandler>)delegate;
-(PBRequest *)badgeOwnedForPlayerAsync:(NSString *)playerId withBlock:(PBPlayerBadges_ResponseBlock)block;

/**
 Returns list of players sorted by the specified point type.
 */
-(PBRequest *)rankBy:(NSString *)rankedBy andDelegate:(id<PBRank_ResponseHandler>)delegate;
-(PBRequest *)rankBy:(NSString *)rankedBy andBlock:(PBRank_ResponseBlock)block;
-(PBRequest *)rankByAsync:(NSString *)rankedBy andDelegate:(id<PBRank_ResponseHandler>)delegate;
-(PBRequest *)rankByAsync:(NSString *)rankedBy andBlock:(PBRank_ResponseBlock)block;
/**
 Returns list of players sorted by the specified point type.
 With optional parameter 'limit'
 */
-(PBRequest *)rankBy:(NSString *)rankedBy withLimit:(unsigned int)limit andDelegate:(id<PBRank_ResponseHandler>)delegate;
-(PBRequest *)rankBy:(NSString *)rankedBy withLimit:(unsigned int)limit andBlock:(PBRank_ResponseBlock)block;
-(PBRequest *)rankByAsync:(NSString *)rankedBy withLimit:(unsigned int)limit andDelegate:(id<PBRank_ResponseHandler>)delegate;
-(PBRequest *)rankByAsync:(NSString *)rankedBy withLimit:(unsigned int)limit andBlock:(PBRank_ResponseBlock)block;

/**
 Return list of players sorted by each point type.
 */
-(PBRequest *)ranksWithLimit:(unsigned int)limit withDelegate:(id<PBRanks_ResponseHandler>)delegate;
-(PBRequest *)ranksWithLimit:(unsigned int)limit withBlock:(PBRanks_ResponseBlock)block;
-(PBRequest *)ranksWithLimitAsync:(unsigned int)limit withDelegate:(id<PBRanks_ResponseHandler>)delegate;
-(PBRequest *)ranksWithLimitAsync:(unsigned int)limit withBlock:(PBRanks_ResponseBlock)block;

/**
 Return detail of level.
 */
-(PBRequest *)level:(unsigned int)level withDelegate:(id<PBLevel_ResponseHandler>)delegate;
-(PBRequest *)level:(unsigned int)level withBlock:(PBLevel_ResponseBlock)block;
-(PBRequest *)levelAsync:(unsigned int)level withDelegate:(id<PBLevel_ResponseHandler>)delegate;
-(PBRequest *)levelAsync:(unsigned int)level withBlock:(PBLevel_ResponseBlock)block;

/**
 Return all detail of levels.
 */
-(PBRequest *)levelsWithDelegate:(id<PBLevels_ResponseHandler>)delegate;
-(PBRequest *)levelsWithBlock:(PBLevels_ResponseBlock)block;
-(PBRequest *)levelsAsyncWithDelegate:(id<PBLevels_ResponseHandler>)delegate;
-(PBRequest *)levelsAsyncWithBlock:(PBLevels_ResponseBlock)block;

/**
 Claim a badge that player has earned.
 */
-(PBRequest *)claimBadgeForPlayer:(NSString *)playerId badgeId:(NSString *)badgeId andDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)claimBadgeForPlayer:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block;
-(PBRequest *)claimBadgeForPlayerAsync:(NSString *)playerId badgeId:(NSString *)badgeId andDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)claimBadgeForPlayerAsync:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block;
-(PBRequest *)claimBadgeForPlayerAsync_:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block;

/**
 Redeem a badge that player has claimed.
 */
-(PBRequest *)redeemBadgeForPlayer:(NSString *)playerId badgeId:(NSString *)badgeId andDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemBadgeForPlayer:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block;
-(PBRequest *)redeemBadgeForPlayerAsync:(NSString *)playerId badgeId:(NSString *)badgeId andDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemBadgeForPlayerAsync:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block;
-(PBRequest *)redeemBadgeForPlayerAsync_:(NSString *)playerId badgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block;

/**
 Return information about all goods that player has redeemed.
 */
-(PBRequest *)goodsOwnedOfPlayer:(NSString *)playerId withDelegate:(id<PBPlayerGoodsOwned_ResponseHandler>)delegate;
-(PBRequest *)goodsOwnedOfPlayer:(NSString *)playerId withBlock:(PBPlayerGoodsOwned_ResponseBlock)block;
-(PBRequest *)goodsOwnedOfPlayerAsync:(NSString *)playerId withDelegate:(id<PBPlayerGoodsOwned_ResponseHandler>)delegate;
-(PBRequest *)goodsOwnedOfPlayerAsync:(NSString *)playerId withBlock:(PBPlayerGoodsOwned_ResponseBlock)block;

/**
 Return quest information that player has joined.
 */
-(PBRequest *)questOfPlayer:(NSString *)playerId questId:(NSString *)questId andDelegate:(id<PBQuestOfPlayer_ResponseHandler>)delegate;
-(PBRequest *)questOfPlayer:(NSString *)playerId questId:(NSString *)questId andBlock:(PBQuestOfPlayer_ResponseBlock)block;
-(PBRequest *)questOfPlayerAsync:(NSString *)playerId questId:(NSString *)questId andDelegate:(id<PBQuestOfPlayer_ResponseHandler>)delegate;
-(PBRequest *)questOfPlayerAsync:(NSString *)playerId questId:(NSString *)questId andBlock:(PBQuestOfPlayer_ResponseBlock)block;

/**
 Return list of quest that player has joined.
 */
-(PBRequest *)questListOfPlayer:(NSString *)playerId withDelegate:(id<PBQuestListOfPlayer_ResponseHandler>)delegate;
-(PBRequest *)questListOfPlayer:(NSString *)playerId withBlock:(PBQuestListOfPlayer_ResponseBlock)block;
-(PBRequest *)questListOfPlayerAsync:(NSString *)playerId withDelegate:(id<PBQuestListOfPlayer_ResponseHandler>)delegate;
-(PBRequest *)questListOfPlayerAsync:(NSString *)playerId withBlock:(PBQuestListOfPlayer_ResponseBlock)block;

/**
 Return quest reward history of player.
 With optional parameter 'offset'.
 */
-(PBRequest *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequest *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;
-(PBRequest *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequest *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;

/**
 Return quest reward history of player.
 With optional parameter 'limit'.
 */
-(PBRequest *)questRewardHistoryOfPlayer:(NSString *)playerId limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequest *)questRewardHistoryOfPlayer:(NSString *)playerId limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;
-(PBRequest *)questRewardHistoryOfPlayerAsync:(NSString *)playerId limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequest *)questRewardHistoryOfPlayerAsync:(NSString *)playerId limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;

/**
 Return quest reward history of player.
 With optional parameter 'offset', and 'limit'.
 */
-(PBRequest *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequest *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;
-(PBRequest *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequest *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;

/**
 Deduct reward from a given player.
 */
-(PBRequest *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withBlock:(PBResponseBlock)block;
-(PBRequest *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withBlock:(PBResponseBlock)block;
-(PBRequest *)deductRewardFromPlayerAsync_:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount withBlock:(PBAsyncURLRequestResponseBlock)block;
/**
 Deduct reward from a given player.
 With optional parameter 'force'.
 */
-(PBRequest *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)deductRewardFromPlayer:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withBlock:(PBResponseBlock)block;
-(PBRequest *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)deductRewardFromPlayerAsync:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withBlock:(PBResponseBlock)block;
-(PBRequest *)deductRewardFromPlayerAsync_:(NSString *)playerId reward:(NSString *)reward amount:(NSUInteger)amount force:(NSUInteger)force withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Return information of specified badge.
 */
-(PBRequest *)badge:(NSString *)badgeId withDelegate:(id<PBBadge_ResponseHandler>)delegate;
-(PBRequest *)badge:(NSString *)badgeId withBlock:(PBBadge_ResponseBlock)block;
-(PBRequest *)badgeAsync:(NSString *)badgeId withDelegate:(id<PBBadge_ResponseHandler>)delegate;
-(PBRequest *)badgeAsync:(NSString *)badgeId withBlock:(PBBadge_ResponseBlock)block;

/**
 Return information about all badges of the current site.
 */
-(PBRequest *)badgesWithDelegate:(id<PBBadges_ResponseHandler>)delegate;
-(PBRequest *)badgesWithBlock:(PBBadges_ResponseBlock)block;
-(PBRequest *)badgesAsyncWithDelegate:(id<PBBadges_ResponseHandler>)delegate;
-(PBRequest *)badgesAsyncWithBlock:(PBBadges_ResponseBlock)block;

/**
 Return information about goods for the specified id.
 */
-(PBRequest *)goods:(NSString *)goodId withDelegate:(id<PBGoodsInfo_ResponseHandler>)delegate;
-(PBRequest *)goods:(NSString *)goodId withBlock:(PBGoodsInfo_ResponseBlock)block;
-(PBRequest *)goodsAsync:(NSString *)goodId withDelegate:(id<PBGoodsInfo_ResponseHandler>)delegate;
-(PBRequest *)goodsAsync:(NSString *)goodId withBlock:(PBGoodsInfo_ResponseBlock)block;

/**
 Return information about all available goods on the current site.
 */
-(PBRequest *)goodsListWithDelegate:(id<PBGoodsListInfo_ResponseHandler>)delegate;
-(PBRequest *)goodsListWithBlock:(PBGoodsListInfo_ResponseBlock)block;
-(PBRequest *)goodsListAsyncWithDelegate:(id<PBGoodsListInfo_ResponseHandler>)delegate;
-(PBRequest *)goodsListAsyncWithBlock:(PBGoodsListInfo_ResponseBlock)block;

/**
 Find number of available goods given group.
 */
-(PBRequest *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate;
-(PBRequest *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;
-(PBRequest *)goodsGroupAvailableForPlayerAsync:(NSString *)playerId group:(NSString *)group withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate;
-(PBRequest *)goodsGroupAvailableForPlayerAsync:(NSString *)playerId group:(NSString *)group withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;
-(PBRequest *)goodsGroupAvailableForPlayerAsync_:(NSString *)playerId group:(NSString *)group withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;
/**
 Find number of available goods given group.
 With optional parameter 'amount'.
 */
-(PBRequest *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate;
-(PBRequest *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;
-(PBRequest *)goodsGroupAvailableForPlayerAsync:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate;
-(PBRequest *)goodsGroupAvailableForPlayerAsync:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;
-(PBRequest *)goodsGroupAvailableForPlayerAsync_:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;

/**
 Return the name of actions that can trigger game's rules within a client's website.
 */
-(PBRequest *)actionConfigWithDelegate:(id<PBActionConfig_ResponseHandler>)delegate;
-(PBRequest *)actionConfigWithBlock:(PBActionConfig_ResponseBlock)block;
-(PBRequest *)actionConfigAsyncWithDelegate:(id<PBActionConfig_ResponseHandler>)delegate;
-(PBRequest *)actionConfigAsyncWithBlock:(PBActionConfig_ResponseBlock)block;
-(PBRequest *)actionConfigAsyncWithBlock_:(PBAsyncURLRequestResponseBlock)block;

/**
 Process an action through all the game's rules defined for client's website.
 */
-(PBRequest *)ruleForPlayer:(NSString *)playerId action:(NSString *)action withDelegate:(id<PBResponseHandler>)delegate, ...;
-(PBRequest *)ruleForPlayer:(NSString *)playerId action:(NSString *)action withBlock:(PBResponseBlock)block, ...;
-(PBRequest *)ruleForPlayerAsync:(NSString *)playerId action:(NSString *)action withDelegate:(id<PBResponseHandler>)delegate, ...;
-(PBRequest *)ruleForPlayerAsync:(NSString *)playerId action:(NSString *)action withBlock:(PBResponseBlock)block, ...;
-(PBRequest *)ruleForPlayerAsync_:(NSString *)playerId action:(NSString *)action withBlock:(PBAsyncURLRequestResponseBlock)block, ...;

/**
 Return information about all quests in current site.
 */
-(PBRequest *)questListWithDelegate:(id<PBQuestList_ResponseHandler>)delegate;
-(PBRequest *)questListWithBlock:(PBQuestList_ResponseBlock)block;
-(PBRequest *)questListWithDelegateAsync:(id<PBQuestList_ResponseHandler>)delegate;
-(PBRequest *)questListWithBlockAsync:(PBQuestList_ResponseBlock)block;

/**
 Return information about quest with the specified id.
 */
-(PBRequest *)quest:(NSString *)questId withDelegate:(id<PBQuestInfo_ResponseHandler>)delegate;
-(PBRequest *)quest:(NSString *)questId withBlock:(PBQuestInfo_ResponseBlock)block;
-(PBRequest *)questAsync:(NSString *)questId withDelegate:(id<PBQuestInfo_ResponseHandler>)delegate;
-(PBRequest *)questAsync:(NSString *)questId withBlock:(PBQuestInfo_ResponseBlock)block;

/**
 Return information about mission with the specified id.
 */
-(PBRequest *)mission:(NSString *)missionId ofQuest:(NSString *)questId withDelegate:(id<PBMissionInfo_ResponseHandler>)delegate;
-(PBRequest *)mission:(NSString *)missionId ofQuest:(NSString *)questId withBlock:(PBMissionInfo_ResponseBlock)block;
-(PBRequest *)missionAsync:(NSString *)missionId ofQuest:(NSString *)questId withDelegate:(id<PBMissionInfo_ResponseHandler>)delegate;
-(PBRequest *)missionAsync:(NSString *)missionId ofQuest:(NSString *)questId withBlock:(PBMissionInfo_ResponseBlock)block;

/**
 Return information about all of the quests available for the player.
 */
-(PBRequest *)questListAvailableForPlayer:(NSString *)playerId withDelegate:(id<PBQuestListAvailableForPlayer_ResponseHandler>)delegate;
-(PBRequest *)questListAvailableForPlayer:(NSString *)playerId withBlock:(PBQuestListAvailableForPlayer_ResponseBlock)block;
-(PBRequest *)questListAvailableForPlayerAsync:(NSString *)playerId withDelegate:(id<PBQuestListAvailableForPlayer_ResponseHandler>)delegate;
-(PBRequest *)questListAvailableForPlayerAsync:(NSString *)playerId withBlock:(PBQuestListAvailableForPlayer_ResponseBlock)block;

/**
 Return information whether the quest is ready for the player.
 */
-(PBRequest *)questAvailable:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestAvailableForPlayer_ResponseHandler>)delegate;
-(PBRequest *)questAvailable:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBQuestAvailableForPlayer_ResponseBlock)block;
-(PBRequest *)questAvailableAsync:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestAvailableForPlayer_ResponseHandler>)delegate;
-(PBRequest *)questAvailableAsync:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBQuestAvailableForPlayer_ResponseBlock)block;

/**
 Player joins a quest.
 */
-(PBRequest *)joinQuest:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)joinQuest:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)joinQuestAsync:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)joinQuestAsync:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)joinQuestAsync_:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;

/**
 Player joins all quests.
 */
-(PBRequest *)joinAllQuestsForPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)joinAllQuestsForPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)joinAllQuestsForPlayerAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)joinAllQuestsForPlayerAsync:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)joinAllQuestsForPlayerAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Player cancels a quest.
 */
-(PBRequest *)cancelQuest:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)cancelQuest:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)cancelQuestAsync:(NSString *)questId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)cancelQuestAsync:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)cancelQuestAsync_:(NSString *)questId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;

/**
 Redeem goods for player.
 */
-(PBRequest *)redeemGoods:(NSString *)goodsId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemGoods:(NSString *)goodsId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)redeemGoodsAsync:(NSString *)goodsId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemGoodsAsync:(NSString *)goodsId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)redeemGoodsAsync_:(NSString *)goodsId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;
/**
 Redeem goods for player.
 With optional parameter 'amount'
 */
-(PBRequest *)redeemGoods:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemGoods:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBResponseBlock)block;
-(PBRequest *)redeemGoodsAsync:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemGoodsAsync:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBResponseBlock)block;
-(PBRequest *)redeemGoodsAsync_:(NSString *)goodsId forPlayer:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBResponseBlock)block;

/**
 Redeem goods group for player.
 */
-(PBRequest *)redeemGoodsGroup:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemGoodsGroup:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withBlock:(PBResponseBlock)block;
-(PBRequest *)redeemGoodsGroupAsync:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemGoodsGroupAsync:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withBlock:(PBResponseBlock)block;
-(PBRequest *)redeemGoodsGroupAsync_:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group withBlock:(PBResponseBlock)block;
/**
 Redeem goods group for player.
 With optional parameter 'amount'
 */
-(PBRequest *)redeemGoodsGroup:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemGoodsGroup:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBResponseBlock)block;
-(PBRequest *)redeemGoodsGroupAsync:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemGoodsGroupAsync:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBResponseBlock)block;
-(PBRequest *)redeemGoodsGroupAsync_:(NSString *)goodsId forPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBResponseBlock)block;

/**
 Return recent activity points of all players.
 With optional parameters 'offset', and 'limit'
 */
-(PBRequest *)recentPointWithOffset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate;
-(PBRequest *)recentPointWithOffset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block;
-(PBRequest *)recentPointWithOffsetAsync:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate;
-(PBRequest *)recentPointWithOffsetAsync:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block;

/**
 Return recent activity points of point name of all players.
 With all optional parameters.
 */
-(PBRequest *)recentPointByName:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)recentPointByName:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBResponseBlock)block;
-(PBRequest *)recentPointByNameAsync:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)recentPointByNameAsync:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBResponseBlock)block;

/**
 Reset point for all players.
 */
-(PBRequest *)resetPointForAllPlayersWithDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)resetPointForAllPlayersWithBlock:(PBResponseBlock)block;
-(PBRequest *)resetPointForAllPlayersWithDelegateAsync:(id<PBResponseHandler>)delegate;
-(PBRequest *)resetPointForAllPlayersWithBlockAsync:(PBResponseBlock)block;
-(PBRequest *)resetPointForAllPlayersWithBlockAsync_:(PBAsyncURLRequestResponseBlock)block;
/**
 Reset point for all players.
 With optional parameter 'point_name'
 */
-(PBRequest *)resetPointForAllPlayersForPoint:(NSString *)pointName withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)resetPointForAllPlayersForPoint:(NSString *)pointName withBlock:(PBResponseBlock)block;
-(PBRequest *)resetPointForAllPlayersForPointAsync:(NSString *)pointName withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)resetPointForAllPlayersForPointAsync:(NSString *)pointName withBlock:(PBResponseBlock)block;
-(PBRequest *)resetPointForAllPlayersForPointAsync_:(NSString *)pointName withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Send Email to a player.
 */
-(PBRequest *)sendEmailForPlayer:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailForPlayer:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailForPlayerAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailForPlayerAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailForPlayerAsync_:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block;

/**
 Send Email to a player with template-id.
 */
-(PBRequest *)sendEmailForPlayer:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailForPlayer:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailForPlayerAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailForPlayerAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailForPlayerAsync_:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;

/**
 Send Email Coupon to a player.
 */
-(PBRequest *)sendEmailCouponForPlayer:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailCouponForPlayer:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailCouponForPlayerAsync_:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block;

/**
 Send Email Coupon to a player with template-id.
 */
-(PBRequest *)sendEmailCouponForPlayer:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailCouponForPlayer:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailCouponForPlayerAsync_:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;

/**
 Return a list of active quizzes.
 */
-(PBRequest *)quizListWithDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate;
-(PBRequest *)quizListWithBlock:(PBActiveQuizList_ResponseBlock)block;
-(PBRequest *)quizListWithDelegateAsync:(NSString *)playerId withDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate;
-(PBRequest *)quizListWithBlockAsync:(PBActiveQuizList_ResponseBlock)block;
/**
 Return a list of active quizzes.
 With optional parameter 'playerId'.
 */
-(PBRequest *)quizListOfPlayer:(NSString *)playerId withDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate;
-(PBRequest *)quizListOfPlayer:(NSString *)playerId withBlock:(PBActiveQuizList_ResponseBlock)block;
-(PBRequest *)quizListOfPlayerAsync:(NSString *)playerId withDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate;
-(PBRequest *)quizListOfPlayerAsync:(NSString *)playerId withBlock:(PBActiveQuizList_ResponseBlock)block;

/**
 Get detail of a quiz.
 */
-(PBRequest *)quizDetail:(NSString *)quizId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate;
-(PBRequest *)quizDetail:(NSString *)quizId withBlock:(PBQuizDetail_ResponseBlock)block;
-(PBRequest *)quizDetailAsync:(NSString *)quizId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate;
-(PBRequest *)quizDetailAsync:(NSString *)quizId withBlock:(PBQuizDetail_ResponseBlock)block;

/**
 Get detail of a quiz by also specifying player-id.
 */
-(PBRequest *)quizDetail:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate;
-(PBRequest *)quizDetail:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuizDetail_ResponseBlock)block;
-(PBRequest *)quizDetailAsync:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuizDetail_ResponseHandler>)delegate;
-(PBRequest *)quizDetailAsync:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuizDetail_ResponseBlock)block;

/**
 Get a random of quiz from available quizzes of player.
 */
-(PBRequest *)quizRandomForPlayer:(NSString *)playerId withDelegate:(id<PBQuizRandom_ResponseHandler>)delegate;
-(PBRequest *)quizRandomForPlayer:(NSString *)playerId withBlock:(PBQuizRandom_ResponseBlock)block;
-(PBRequest *)quizRandomForPlayerAsync:(NSString *)playerId withDelegate:(id<PBQuizRandom_ResponseHandler>)delegate;
-(PBRequest *)quizRandomForPlayerAsync:(NSString *)playerId withBlock:(PBQuizRandom_ResponseBlock)block;

/**
 Get recent quizzes done by player.
 */
-(PBRequest *)quizDoneForPlayer:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizDoneList_ResponseHandler>)delegate;
-(PBRequest *)quizDoneForPlayer:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizDoneList_ResponseBlock)block;
-(PBRequest *)quizDoneForPlayerAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizDoneList_ResponseHandler>)delegate;
-(PBRequest *)quizDoneForPlayerAsync:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizDoneList_ResponseBlock)block;

/**
 Get pending quizzes by player.
 */
-(PBRequest *)quizPendingOfPlayer:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizPendingOfPlayer:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBResponseBlock)block;
-(PBRequest *)quizPendingOfPlayerAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizPendingOfPlayerAsync:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBResponseBlock)block;

/**
 Get a question from a quiz for player.
 */
-(PBRequest *)quizQuestion:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestion_ResponseHandler>)delegate;
-(PBRequest *)quizQuestion:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuestion_ResponseBlock)block;
-(PBRequest *)quizQuestionAsync:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBQuestion_ResponseHandler>)delegate;
-(PBRequest *)quizQuestionAsync:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBQuestion_ResponseBlock)block;

/**
 Answer a question for a given quiz.
 */
-(PBRequest *)quizAnswer:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withDelegate:(id<PBQuestionAnswered_ResponseHandler>)delegate;
-(PBRequest *)quizAnswer:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBQuestionAnswered_ResponseBlock)block;
-(PBRequest *)quizAnswerAsync:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withDelegate:(id<PBQuestionAnswered_ResponseHandler>)delegate;
-(PBRequest *)quizAnswerAsync:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBQuestionAnswered_ResponseBlock)block;
-(PBRequest *)quizAnswerAsync_:(NSString *)quizId optionId:(NSString *)optionId forPlayer:(NSString *)playerId ofQuestionId:(NSString *)questionId withBlock:(PBQuestionAnswered_ResponseBlock)block;

/**
 Rank player by their score for a quiz.
 */
-(PBRequest *)quizScoreRank:(NSString *)quizId limit:(NSInteger)limit withDelegate:(id<PBPlayersQuizRank_ResponseHandler>)delegate;
-(PBRequest *)quizScoreRank:(NSString *)quizId limit:(NSInteger)limit withBlock:(PBPlayersQuizRank_ResponseBlock)block;
-(PBRequest *)quizScoreRankAsync:(NSString *)quizId limit:(NSInteger)limit withDelegate:(id<PBPlayersQuizRank_ResponseHandler>)delegate;
-(PBRequest *)quizScoreRankAsync:(NSString *)quizId limit:(NSInteger)limit withBlock:(PBPlayersQuizRank_ResponseBlock)block;

/**
 Send SMS to a player.
 */
-(PBRequest *)sendSMSForPlayer:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendSMSForPlayer:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)sendSMSForPlayerAsync:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendSMSForPlayerAsync:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)sendSMSForPlayerAsync_:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block;

/**
 Send SMS to a player with a template-id.
 */
-(PBRequest *)sendSMSForPlayer:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendSMSForPlayer:(NSString *)playerId message:(NSString *)message tempalte:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)sendSMSForPlayerAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendSMSForPlayerAsync:(NSString *)playerId message:(NSString *)message tempalte:(NSString *)templateId withBlock:(PBResponseBlock)block;

/**
 Send SMS Coupon to a player via SMS.
 */
-(PBRequest *)sendSMSCouponForPlayer:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendSMSCouponForPlayer:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)sendSMSCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendSMSCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)sendSMSCouponForPlayerAsync_:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block;

/**
 Send SMS Coupon to a player via SMS with a template-id.
 */
-(PBRequest *)sendSMSCouponForPlayer:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendSMSCouponForPlayer:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)sendSMSCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendSMSCouponForPlayerAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;

/**
 Push notification for player.
 */
-(PBRequest *)pushNotificationForPlayer:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)pushNotificationForPlayer:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)pushNotificationForPlayerAsync:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)pushNotificationForPlayerAsync:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block;
/**
 Push notification with template id.
 */
-(PBRequest *)pushNotificationForPlayer:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)pushNotificationForPlayer:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)pushNotificationForPlayerAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)pushNotificationForPlayerAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;

/**
 Push notification for player.
 */
-(PBRequest *)pushNotificationCouponForPlayer:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)pushNotificationCouponForPlayer:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)pushNotificationCouponForPlayerAsync:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)pushNotificationCouponForPlayerAsync:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block;
/**
 Push notification with template id.
 */
-(PBRequest *)pushNotificationCouponForPlayer:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)pushNotificationCouponForPlayer:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)pushNotificationCouponForPlayerAsync:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)pushNotificationCouponForPlayerAsync:(NSString *)playerId refId:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;

/**
 Register device for push notification.
 */
-(PBRequest *)registerForPushNotification:(id<PBResponseHandler>)delegate;

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
// UI
//--------------------------------------------------
-(void)showRegistrationFormFromView:(UIViewController *)view withBlock:(PBResponseBlock)block;
-(void)showRegistrationFormFromView:(UIViewController *)view intendedPlayerId:(NSString *)playerId withBlock:(PBResponseBlock)block;

@end
