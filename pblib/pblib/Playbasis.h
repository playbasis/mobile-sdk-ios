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
-(PBRequest *)auth:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andDelegate:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequest *)auth:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andBlock:(PBAuth_ResponseBlock)block;
-(PBRequest *)authAsync:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andDelegate:(id<PBAuth_ResponseHandler>)delegate;
-(PBRequest *)authAsync:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andBlock:(PBAuth_ResponseBlock)block;

/**
 Request a new access token, and discard the current one.
 */
-(PBRequest *)renew:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)renew:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andBlock:(PBResponseBlock)block;
-(PBRequest *)renewAsync:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)renewAsync:(NSString *)apiKey withApiSecret:(NSString *)apiSecret andBlock:(PBResponseBlock)block;

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
-(PBRequest *)registerUser:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate :(NSString *)username :(NSString *)email :(NSString *)imageUrl, ...;
-(PBRequest *)registerUser:(NSString *)playerId withBlock:(PBResponseBlock)block :(NSString *)username :(NSString *)email :(NSString *)imageUrl, ...;
-(PBRequest *)registerUserAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate :(NSString *)username :(NSString *)email :(NSString *)imageUrl, ...;
-(PBRequest *)registerUserAsync:(NSString *)playerId withBlock:(PBResponseBlock)block :(NSString *)username :(NSString *)email :(NSString *)imageUrl, ...;
-(PBRequest *)registerUserAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block :(NSString *)username :(NSString *)email :(NSString *)imageUrl, ...;

/**
 Update player information.
 */
-(PBRequest *)updateUser:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate :(NSString *)firstArg ,...;
-(PBRequest *)updateUser:(NSString *)playerId withBlock:(PBResponseBlock)block :(NSString *)firstArg ,...;
-(PBRequest *)updateUserAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate :(NSString *)firstArg ,...;
-(PBRequest *)updateUserAsync:(NSString *)playerId withBlock:(PBResponseBlock)block :(NSString *)firstArg ,...;
-(PBRequest *)updateUserAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block :(NSString *)firstArg ,...;

/**
 Permanently delete user from Playbasis's database.
 */
-(PBRequest *)deleteUser:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)deleteUser:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)deleteUserAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)deleteUserAsync:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)deleteUserAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Tell Playbasis system that player has logged in.
 It uses delegate callback.
 */
-(PBRequest *)login:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)login:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)loginAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)loginAsync:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)loginAsync_:(NSString *)playerId withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Tell Playbasis system that player has logged out.
 */
-(PBRequest *)logout:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)logout:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)logoutAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)logoutAsync:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)logoutAsync_:(NSString *)playerId withBlock:(PBResponseBlock)block;

/**
 Returns information about all point-based rewards that a player currently have.
 */
-(PBRequest *)points:(NSString *)playerId withDelegate:(id<PBPoints_ResponseHandler>)delegate;
-(PBRequest *)points:(NSString *)playerId withBlock:(PBPoints_ResponseBlock)block;
-(PBRequest *)pointsAsync:(NSString *)playerId withDelegate:(id<PBPoints_ResponseHandler>)delegate;
-(PBRequest *)pointsAsync:(NSString *)playerId withBlock:(PBPoints_ResponseBlock)block;


/**
 Returns how much of specified the point-based reward a player currently have.
 */
-(PBRequest *)point:(NSString *)playerId forPoint:(NSString *)pointName withDelegate:(id<PBPoint_ResponseHandler>)delegate;
-(PBRequest *)point:(NSString *)playerId forPoint:(NSString *)pointName withBlock:(PBPoint_ResponseBlock)block;
-(PBRequest *)pointAsync:(NSString *)playerId forPoint:(NSString *)pointName withDelegate:(id<PBPoint_ResponseHandler>)delegate;
-(PBRequest *)pointAsync:(NSString *)playerId forPoint:(NSString *)pointName withBlock:(PBPoint_ResponseBlock)block;

/**
 Get history point of user.
 */
-(PBRequest *)pointHistory:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistory:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;
-(PBRequest *)pointHistoryAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andDelegate:(id<PBPointHistory_ResponseHandler>)delegate;
-(PBRequest *)pointHistoryAsync:(NSString *)playerId forPoint:(NSString *)pointName offset:(unsigned int)offset withLimit:(unsigned int)limit andBlock:(PBPointHistory_ResponseBlock)block;

/**
 Get the latest time for the specified action that player has performed.
 */
-(PBRequest *)actionTime:(NSString *)playerId forAction:(NSString *)actionName withDelegate:(id<PBActionTime_ResponseHandler>)delegate;
-(PBRequest *)actionTime:(NSString *)playerId forAction:(NSString *)actionName withBlock:(PBActionTime_ResponseBlock)block;
-(PBRequest *)actionTimeAsync:(NSString *)playerId forAction:(NSString *)actionName withDelegate:(id<PBActionTime_ResponseHandler>)delegate;
-(PBRequest *)actionTimeAsync:(NSString *)playerId forAction:(NSString *)actionName withBlock:(PBActionTime_ResponseBlock)block;

/**
 Return the time and action that player has performed.
 */
-(PBRequest *)actionLastPerformed:(NSString *)playerId withDelegate:(id<PBLastAction_ResponseHandler>)delegate;
-(PBRequest *)actionLastPerformed:(NSString *)playerId withBlock:(PBLastAction_ResponseBlock)block;
-(PBRequest *)actionLastPerformedAsync:(NSString *)playerId withDelegate:(id<PBLastAction_ResponseHandler>)delegate;
-(PBRequest *)actionLastPerformedAsync:(NSString *)playerId withBlock:(PBLastAction_ResponseBlock)block;

/**
 Get the latest time of specified action that player has performed.
 */
-(PBRequest *)actionLastPerformedTime:(NSString *)playerId forAction:(NSString *)actionName withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)actionLastPerformedTime:(NSString *)playerId forAction:(NSString *)actionName withBlock:(PBResponseBlock)block;
-(PBRequest *)actionLastPerformedTimeAsync:(NSString *)playerId forAction:(NSString *)actionName withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)actionLastPerformedTimeAsync:(NSString *)playerId forAction:(NSString *)actionName withBlock:(PBResponseBlock)block;

/**
 Return the number of times that player has performed the specified action.
 */
-(PBRequest *)actionPerformedCount:(NSString *)playerId forAction:(NSString *)actionName withDelegate:(id<PBActionCount_ResponseHandler>)delegate;
-(PBRequest *)actionPerformedCount:(NSString *)playerId forAction:(NSString *)actionName withBlock:(PBActionCount_ResponseBlock)block;
-(PBRequest *)actionPerformedCountAsync:(NSString *)playerId forAction:(NSString *)actionName withDelegate:(id<PBActionCount_ResponseHandler>)delegate;
-(PBRequest *)actionPerformedCountAsync:(NSString *)playerId forAction:(NSString *)actionName withBlock:(PBActionCount_ResponseBlock)block;

/**
 Return information about all badges that player has earned.
 */
-(PBRequest *)badgeOwned:(NSString *)playerId withDelegate:(id<PBPlayerBadges_ResponseHandler>)delegate;
-(PBRequest *)badgeOwned:(NSString *)playerId withBlock:(PBPlayerBadges_ResponseBlock)block;
-(PBRequest *)badgeOwnedAsync:(NSString *)playerId withDelegate:(id<PBPlayerBadges_ResponseHandler>)delegate;
-(PBRequest *)badgeOwnedAsync:(NSString *)playerId withBlock:(PBPlayerBadges_ResponseBlock)block;

/**
 Returns list of players sorted by the specified point type.
 */
-(PBRequest *)rank:(NSString *)rankedBy withLimit:(unsigned int)limit andDelegate:(id<PBRank_ResponseHandler>)delegate;
-(PBRequest *)rank:(NSString *)rankedBy withLimit:(unsigned int)limit andBlock:(PBRank_ResponseBlock)block;
-(PBRequest *)rankAsync:(NSString *)rankedBy withLimit:(unsigned int)limit andDelegate:(id<PBRank_ResponseHandler>)delegate;
-(PBRequest *)rankAsync:(NSString *)rankedBy withLimit:(unsigned int)limit andBlock:(PBRank_ResponseBlock)block;

/**
 Return list of players sorted by each point type.
 */
-(PBRequest *)ranks:(unsigned int)limit withDelegate:(id<PBRanks_ResponseHandler>)delegate;
-(PBRequest *)ranks:(unsigned int)limit withBlock:(PBRanks_ResponseBlock)block;
-(PBRequest *)ranksAsync:(unsigned int)limit withDelegate:(id<PBRanks_ResponseHandler>)delegate;
-(PBRequest *)ranksAsync:(unsigned int)limit withBlock:(PBRanks_ResponseBlock)block;

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
-(PBRequest *)claimBadge:(NSString *)playerId withBadgeId:(NSString *)badgeId andDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)claimBadge:(NSString *)playerId withBadgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block;
-(PBRequest *)claimBadgeAsync:(NSString *)playerId withBadgeId:(NSString *)badgeId andDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)claimBadgeAsync:(NSString *)playerId withBadgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block;
-(PBRequest *)claimBadgeAsync_:(NSString *)playerId withBadgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block;

/**
 Redeem a badge that player has claimed.
 */
-(PBRequest *)redeemBadge:(NSString *)playerId withBadgeId:(NSString *)badgeId andDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemBadge:(NSString *)playerId withBadgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block;
-(PBRequest *)redeemBadgeAsync:(NSString *)playerId withBadgeId:(NSString *)badgeId andDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemBadgeAsync:(NSString *)playerId withBadgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block;
-(PBRequest *)redeemBadgeAsync_:(NSString *)playerId withBadgeId:(NSString *)badgeId andBlock:(PBResponseBlock)block;

/**
 Return information about all goods that player has redeemed.
 */
-(PBRequest *)goodsOwned:(NSString *)playerId withDelegate:(id<PBPlayerGoodsOwned_ResponseHandler>)delegate;
-(PBRequest *)goodsOwned:(NSString *)playerId withBlock:(PBPlayerGoodsOwned_ResponseBlock)block;
-(PBRequest *)goodsOwnedAsync:(NSString *)playerId withDelegate:(id<PBPlayerGoodsOwned_ResponseHandler>)delegate;
-(PBRequest *)goodsOwnedAsync:(NSString *)playerId withBlock:(PBPlayerGoodsOwned_ResponseBlock)block;

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
 */
// method set with both optional parameters
-(PBRequest *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequest *)questRewardHistoryOfPlayer:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;
-(PBRequest *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)delegate;
-(PBRequest *)questRewardHistoryOfPlayerAsync:(NSString *)playerId offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBQuestRewardHistoryOfPlayer_ResponseBlock)block;

/**
 Deduct reward from a given player.
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
-(PBRequest *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate;
-(PBRequest *)goodsGroupAvailableForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;
-(PBRequest *)goodsGroupAvailableAsyncForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withDelegate:(id<PBGoodsGroupAvailable_ResponseHandler>)delegate;
-(PBRequest *)goodsGroupAvailableAsyncForPlayer:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;
-(PBRequest *)goodsGroupAvailableAsyncForPlayer_:(NSString *)playerId group:(NSString *)group amount:(unsigned int)amount withBlock:(PBGoodsGroupAvailable_ResponseBlock)block;

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
-(PBRequest *)rule:(NSString *)playerId forAction:(NSString *)action withDelegate:(id<PBResponseHandler>)delegate, ...;
-(PBRequest *)rule:(NSString *)playerId forAction:(NSString *)action syncUrl:(BOOL)syncUrl withDelegate:(id<PBResponseHandler>)delegate, ...;

-(PBRequest *)rule:(NSString *)playerId forAction:(NSString *)action withBlock:(PBResponseBlock)block, ...;
-(PBRequest *)rule:(NSString *)playerId forAction:(NSString *)action syncUrl:(BOOL)syncUrl withBlock:(PBResponseBlock)block, ...;

-(PBRequest *)ruleAsync:(NSString *)playerId forAction:(NSString *)action withDelegate:(id<PBResponseHandler>)delegate, ...;
-(PBRequest *)ruleAsync:(NSString *)playerId forAction:(NSString *)action syncUrl:(BOOL)syncUrl withDelegate:(id<PBResponseHandler>)delegate, ...;

-(PBRequest *)ruleAsync:(NSString *)playerId forAction:(NSString *)action withBlock:(PBResponseBlock)block, ...;
-(PBRequest *)ruleAsync:(NSString *)playerId forAction:(NSString *)action syncUrl:(BOOL)syncUrl withBlock:(PBResponseBlock)block, ...;

-(PBRequest *)ruleAsync_:(NSString *)playerId forAction:(NSString *)action withBlock:(PBAsyncURLRequestResponseBlock)block, ...;

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
-(PBRequest *)questWithQuestId:(NSString *)questId withDelegate:(id<PBQuestInfo_ResponseHandler>)delegate;
-(PBRequest *)questWithQuestId:(NSString *)questId withBlock:(PBQuestInfo_ResponseBlock)block;
-(PBRequest *)questWithQuestIdAsync:(NSString *)questId withDelegate:(id<PBQuestInfo_ResponseHandler>)delegate;
-(PBRequest *)questWithQuestIdAsync:(NSString *)questId withBlock:(PBQuestInfo_ResponseBlock)block;

/**
 Return information about mission with the specified id.
 */
-(PBRequest *)mission:(NSString *)questId mission:(NSString *)missionId withDelegate:(id<PBMissionInfo_ResponseHandler>)delegate;
-(PBRequest *)mission:(NSString *)questId mission:(NSString *)missionId withBlock:(PBMissionInfo_ResponseBlock)block;
-(PBRequest *)missionAsync:(NSString *)questId mission:(NSString *)missionId withDelegate:(id<PBMissionInfo_ResponseHandler>)delegate;
-(PBRequest *)missionAsync:(NSString *)questId mission:(NSString *)missionId withBlock:(PBMissionInfo_ResponseBlock)block;

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
-(PBRequest *)joinQuest:(NSString *)questId player:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)joinQuest:(NSString *)questId player:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)joinQuestAsync:(NSString *)questId player:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)joinQuestAsync:(NSString *)questId player:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)joinQuestAsync_:(NSString *)questId player:(NSString *)playerId withBlock:(PBResponseBlock)block;

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
-(PBRequest *)cancelQuest:(NSString *)questId player:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)cancelQuest:(NSString *)questId player:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)cancelQuestAsync:(NSString *)questId player:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)cancelQuestAsync:(NSString *)questId player:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)cancelQuestAsync_:(NSString *)questId player:(NSString *)playerId withBlock:(PBResponseBlock)block;

/**
 Redeem goods for player.
 */
-(PBRequest *)redeemGoods:(NSString *)goodsId player:(NSString *)playerId amount:(unsigned int)amount withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemGoods:(NSString *)goodsId player:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBResponseBlock)block;
-(PBRequest *)redeemGoodsAsync:(NSString *)goodsId player:(NSString *)playerId amount:(unsigned int)amount withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)redeemGoodsAsync:(NSString *)goodsId player:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBResponseBlock)block;
-(PBRequest *)redeemGoodsAsync_:(NSString *)goodsId player:(NSString *)playerId amount:(unsigned int)amount withBlock:(PBResponseBlock)block;

/**
 Return recent activity points of all players.
 */
-(PBRequest *)recentPoint:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate;
-(PBRequest *)recentPoint:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block;
-(PBRequest *)recentPointAsync:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBRecentPoint_ResponseHandler>)delegate;
-(PBRequest *)recentPointAsync:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBRecentPoint_ResponseBlock)block;

/**
 Return recent activity points of point name of all players.
 */
-(PBRequest *)recentPointByName:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)recentPointByName:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBResponseBlock)block;
-(PBRequest *)recentPointByNameAsync:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)recentPointByNameAsync:(NSString *)pointName offset:(unsigned int)offset limit:(unsigned int)limit withBlock:(PBResponseBlock)block;

/**
 Reset point for all players.
 */
-(PBRequest *)resetPointForAllPlayersForPoint:(NSString *)pointName withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)resetPointForAllPlayersForPoint:(NSString *)pointName withBlock:(PBResponseBlock)block;
-(PBRequest *)resetPointForAllPlayersForPointAsync:(NSString *)pointName withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)resetPointForAllPlayersForPointAsync:(NSString *)pointName withBlock:(PBResponseBlock)block;
-(PBRequest *)resetPointForAllPlayersForPointAsync_:(NSString *)pointName withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Send Email to a player.
 */
-(PBRequest *)sendEmail:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmail:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailAsync_:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block;

/**
 Send Email to a player with template-id.
 */
-(PBRequest *)sendEmail:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmail:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailAsync:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailAsync_:(NSString *)playerId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;

/**
 Send Email Coupon to a player.
 */
-(PBRequest *)sendEmailCoupon:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailCoupon:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailCouponAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailCouponAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailCouponAsync_:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message withBlock:(PBResponseBlock)block;

/**
 Send Email Coupon to a player with template-id.
 */
-(PBRequest *)sendEmailCoupon:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailCoupon:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailCouponAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sendEmailCouponAsync:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)sendEmailCouponAsync_:(NSString *)playerId ref:(NSString *)refId subject:(NSString *)subject message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;

/**
 Return a list of active quizzes.
 */
-(PBRequest *)quizList:(NSString *)playerId withDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate;
-(PBRequest *)quizList:(NSString *)playerId withBlock:(PBActiveQuizList_ResponseBlock)block;
-(PBRequest *)quizListAsync:(NSString *)playerId withDelegate:(id<PBActiveQuizList_ResponseHandler>)delegate;
-(PBRequest *)quizListAsync:(NSString *)playerId withBlock:(PBActiveQuizList_ResponseBlock)block;

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
-(PBRequest *)quizRandom:(NSString *)playerId withDelegate:(id<PBQuizRandom_ResponseHandler>)delegate;
-(PBRequest *)quizRandom:(NSString *)playerId withBlock:(PBQuizRandom_ResponseBlock)block;
-(PBRequest *)quizRandomAsync:(NSString *)playerId withDelegate:(id<PBQuizRandom_ResponseHandler>)delegate;
-(PBRequest *)quizRandomAsync:(NSString *)playerId withBlock:(PBQuizRandom_ResponseBlock)block;

/**
 Get recent quizzes done by player.
 */
-(PBRequest *)quizDone:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizDoneList_ResponseHandler>)delegate;
-(PBRequest *)quizDone:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizDoneList_ResponseBlock)block;
-(PBRequest *)quizDoneAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBQuizDoneList_ResponseHandler>)delegate;
-(PBRequest *)quizDoneAsync:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBQuizDoneList_ResponseBlock)block;

/**
 Get pending quizzes by player.
 */
-(PBRequest *)quizPending:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizPending:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBResponseBlock)block;
-(PBRequest *)quizPendingAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizPendingAsync:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBResponseBlock)block;

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
-(PBRequest *)sms:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sms:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)smsAsync:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)smsAsync:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)smsAsync_:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block;

/**
 Send SMS to a player with a template-id.
 */
-(PBRequest *)sms:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)sms:(NSString *)playerId message:(NSString *)message tempalte:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)smsAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)smsAsync:(NSString *)playerId message:(NSString *)message tempalte:(NSString *)templateId withBlock:(PBResponseBlock)block;

/**
 Send SMS Coupon to a player via SMS.
 */
-(PBRequest *)smsCoupon:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)smsCoupon:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)smsCouponAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)smsCouponAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)smsCouponAsync_:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message withBlock:(PBResponseBlock)block;

/**
 Send SMS Coupon to a player via SMS with a template-id.
 */
-(PBRequest *)smsCoupon:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)smsCoupon:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)smsCouponAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)smsCouponAsync:(NSString *)playerId ref:(NSString *)refId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;

/**
 Push message.
 */
-(PBRequest *)push:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)push:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block;
-(PBRequest *)pushAsync:(NSString *)playerId message:(NSString *)message withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)pushAsync:(NSString *)playerId message:(NSString *)message withBlock:(PBResponseBlock)block;

/**
 Push message with template id.
 */
-(PBRequest *)push:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)push:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;
-(PBRequest *)pushAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)pushAsync:(NSString *)playerId message:(NSString *)message template:(NSString *)templateId withBlock:(PBResponseBlock)block;

/**
 Register device for push notification.
 */
-(PBRequest *)registerForPushNotification:(id<PBResponseHandler>)delegate;

/**
 Track player with an action.
 */
-(void)track:(NSString *)playerId forAction:(NSString *)action fromView:(UIViewController*)view withBlock:(PBAsyncURLRequestResponseBlock)block;

/**
 Execute action for player.
 */
-(PBRequest *)do:(NSString *)playerId action:(NSString *)action withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)do:(NSString *)playerId action:(NSString *)action withBlock:(PBResponseBlock)block;
-(PBRequest *)doAsync:(NSString *)playerId action:(NSString *)action withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)doAsync:(NSString *)playerId action:(NSString *)action withBlock:(PBResponseBlock)block;

//--------------------------------------------------
// UI
//--------------------------------------------------
-(void)showRegistrationFormFromView:(UIViewController *)view withBlock:(PBResponseBlock)block;
-(void)showRegistrationFormFromView:(UIViewController *)view intendedPlayerId:(NSString *)playerId withBlock:(PBResponseBlock)block;

@end
