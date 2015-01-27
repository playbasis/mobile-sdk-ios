//
//  playbasis.h
//  playbasis
//
//  Created by Playbasis.
//  Copyright (c) 2556 Playbasisß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "PBTypes.h"
#import "PBRequest.h"
#import "NSMutableArray+QueueAndSerializationAdditions.h"

/**
 Playbasis
 Handle the API end-point calls from client side.
 */
@interface Playbasis : NSObject
{
    NSString *token;
    NSString *apiKeyParam;
    id<PBResponseHandler> authDelegate;
    NSMutableArray *requestOptQueue;
}

@property (nonatomic, readonly) NSString* token;

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
+(id)sharedPB;

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
-(PBRequest *)auth:(NSString *)apiKey :(NSString *)apiSecret :(id<PBResponseHandler>)delegate;

/**
 Request a new access token, and discard the current one.
 */
-(PBRequest *)renew:(NSString *)apiKey :(NSString *)apiSecret :(id<PBResponseHandler>)delegate;

/** 
 Get player's public information.
 It will send request via GET method.
 */
-(PBRequest *)playerPublic:(NSString *)playerId :(id<PBResponseHandler>)delegate;

/** 
 Get player's both private and public information.
 It use delegate callback.
 */
-(PBRequest *)player:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)playerAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;

/**
 Get player's both private and public information.
 It uses block callback.
 */
-(PBRequest *)player:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)playerAsync:(NSString *)playerId withBlock:(PBResponseBlock)block;

/**
 Get basic information of list of players.
 playerListId is in the format of id separated by "," ie. "1,2,3".
 */
-(PBRequest *)playerList:(NSString *)playerListId :(id<PBResponseHandler>)delegate;

/**
 Get player's detailed public information including points and badge.
 */
-(PBRequest *)playerDetailPublic:(NSString *)playerId :(id<PBResponseHandler>)delegate;

/**
 Get player's detailed information both private and public one including points and badges.
 */
-(PBRequest *)playerDetail:(NSString *)playerId :(id<PBResponseHandler>)delegate;

/**
 Register from the client side as a Playbasis player.
 */
-(PBRequest *)registerUser:(NSString *)playerId :(id<PBResponseHandler>)delegate :(NSString *)username :(NSString *)email :(NSString *)imageUrl, ...;

/**
 Update player information.
 */
-(PBRequest *)updateUser:(NSString *)playerId :(id<PBResponseHandler>)delegate :(NSString *)firstArg ,...;

/**
 Permanently delete user from Playbasis's database.
 */
-(PBRequest *)deleteUser:(NSString *)playerId :(id<PBResponseHandler>)delegate;

/**
 Tell Playbasis system that player has logged in.
 It uses delegate callback.
 */
-(PBRequest *)login:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)login:(NSString *)playerId syncUrl:(BOOL)syncUrl withDelegate:(id<PBResponseHandler>)delegate;
/**
 Tell Playbasis system that player has logged in.
 It uses block callback.
 */
-(PBRequest *)login:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)login:(NSString *)playerId syncUrl:(BOOL)syncUrl withBlock:(PBResponseBlock)block;

/**
 Tell Playbasis system that player has logged out.
 */
-(PBRequest *)logout:(NSString *)playerId :(id<PBResponseHandler>)delegate;

/**
 Returns information about all point-based rewards that a player currently have.
 */
-(PBRequest *)points:(NSString *)playerId :(id<PBResponseHandler>)delegate;

/**
 Returns how much of specified the point-based reward a player currently have.
 */
-(PBRequest *)point:(NSString *)playerId :(NSString *)pointName :(id<PBResponseHandler>)delegate;

/**
 Get history point of user.
 */
-(PBRequest *)pointHistory:(NSString *)playerId :(NSString *)pointName :(unsigned int)offset :(unsigned int)limit :(id<PBResponseHandler>)delegate;

/**
 Get the latest time for the specified action that player has performed.
 */
-(PBRequest *)actionTime:(NSString *)playerId :(NSString *)actionName :(id<PBResponseHandler>)delegate;

/**
 Return the time and action that player has performed.
 */
-(PBRequest *)actionLastPerformed:(NSString *)playerId :(id<PBResponseHandler>)delegate;

/**
 Get the latest time of specified action that player has performed.
 */
-(PBRequest *)actionLastPerformedTime:(NSString *)playerId :(NSString *)actionName :(id<PBResponseHandler>)delegate;

/**
 Return the number of times that player has performed the specified action.
 */
-(PBRequest *)actionPerformedCount:(NSString *)playerId :(NSString *)actionName :(id<PBResponseHandler>)delegate;

/**
 Return information about all badges that player has earned.
 */
-(PBRequest *)badgeOwned:(NSString *)playerId :(id<PBResponseHandler>)delegate;

/**
 Returns list of players sorted by the specified point type.
 */
-(PBRequest *)rank:(NSString *)rankedBy :(unsigned int)limit :(id<PBResponseHandler>)delegate;

/**
 Return list of players sorted by each point type.
 */
-(PBRequest *)ranks:(unsigned int)limit :(id<PBResponseHandler>)delegate;

/**
 Return detail of level.
 */
-(PBRequest *)level:(unsigned int)level :(id<PBResponseHandler>)delegate;

/**
 Return all detail of levels.
 */
-(PBRequest *)levels:(id<PBResponseHandler>)delegate;

/**
 Claim a badge that player has earned.
 */
-(PBRequest *)claimBadge:(NSString *)playerId :(NSString *)badgeId :(id<PBResponseHandler>)delegate;

/**
 Redeem a badge that player has claimed.
 */
-(PBRequest *)redeemBadge:(NSString *)playerId :(NSString *)badgeId :(id<PBResponseHandler>)delegate;

/**
 Return information about all goods that player has redeemed.
 */
-(PBRequest *)goodsOwned:(NSString *)playerId :(id<PBResponseHandler>)delegate;

/**
 Return quest information that player has joined.
 */
-(PBRequest *)questOfPlayer:(NSString *)playerId :(NSString *)questId :(id<PBResponseHandler>)delegate;

/**
 Return list of quest that player has joined.
 */
-(PBRequest *)questListOfPlayer:(NSString *)playerId :(id<PBResponseHandler>)delegate;

/**
 Return information of specified badge.
 */
-(PBRequest *)badge:(NSString *)badgeId :(id<PBResponseHandler>)delegate;

/**
 Return information about all badges of the current site.
 */
-(PBRequest *)badges :(id<PBResponseHandler>)delegate;

/**
 Return information about goods for the specified id.
 */
-(PBRequest *)goods:(NSString *)goodId :(id<PBResponseHandler>)delegate;

/**
 Return information about all available goods on the current site.
 */
-(PBRequest *)goodsList :(id<PBResponseHandler>)delegate;

/**
 Return the name of actions that can trigger game's rules within a client's website.
 */
-(PBRequest *)actionConfig :(id<PBResponseHandler>)delegate;

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

/**
 Return information about all quests in current site.
 */
-(PBRequest *)quests:(id<PBResponseHandler>)delegate;

/**
 Return information about quest with the specified id.
 */
-(PBRequest *)quest:(NSString *)questId :(id<PBResponseHandler>)delegate;

/**
 Return information about mission with the specified id.
 */
-(PBRequest *)mission:(NSString *)questId :(NSString *)missionId :(id<PBResponseHandler>)delegate;

/**
 Return information whether the quest is ready for the player.
 */
-(PBRequest *)questAvailable:(NSString *)questId :(NSString *)playerId :(id<PBResponseHandler>)delegate;

/**
 Return information about all of the quests available for the player.
 */
-(PBRequest *)questsAvailable:(NSString *)playerId :(id<PBResponseHandler>)delegate;

/**
 Player joins a quest.
 */
-(PBRequest *)joinQuest:(NSString *)questId :(NSString *)playerId :(id<PBResponseHandler>)delegate;

/**
 Player cancels a quest.
 */
-(PBRequest *)cancelQuest:(NSString *)questId :(NSString *)playerId :(id<PBResponseHandler>)delegate;

/**
 Redeem goods for player.
 */
-(PBRequest *)redeemGoods:(NSString *)goodsId :(NSString *)playerId :(unsigned int)amount :(id<PBResponseHandler>)delegate;

/**
 Return recent activity points of all players.
 */
-(PBRequest *)recentPoint:(unsigned int)offset :(unsigned int)limit :(id<PBResponseHandler>)delegate;

/**
 Return recent activity points of point name of all players.
 */
-(PBRequest *)recentPointByName:(NSString *)pointName :(unsigned int)offset :(unsigned int)limit :(id<PBResponseHandler>)delegate;

/**
 Send Email to a player.
 */
-(PBRequest *)sendEmail:(NSString *)playerId :(NSString *)subject :(NSString *)message :(id<PBResponseHandler>)delegate;

/**
 Send Email to a player with template-id.
 */
-(PBRequest *)sendEmail:(NSString *)playerId :(NSString *)subject :(NSString *)message :(NSString *)templateId :(id<PBResponseHandler>)delegate;

/**
 Send Email Coupon to a player.
 */
-(PBRequest *)sendEmailCoupon:(NSString *)playerId :(NSString *)refId :(NSString *)subject :(NSString *)message :(id<PBResponseHandler>)delegate;

/**
 Send Email Coupon to a player with template-id.
 */
-(PBRequest *)sendEmailCoupon:(NSString *)playerId :(NSString *)refId :(NSString *)subject :(NSString *)message :(NSString *)templateId :(id<PBResponseHandler>)delegate;

/**
 Return a list of active quizzes.
 */
-(PBRequest *)quizList:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizList:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)quizListAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizListAsync:(NSString *)playerId withBlock:(PBResponseBlock)block;

/**
 Get detail of a quiz.
 */
-(PBRequest *)quizDetail:(NSString *)quizId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizDetail:(NSString *)quizId withBlock:(PBResponseBlock)block;
-(PBRequest *)quizDetailAsync:(NSString *)quizId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizDetailAsync:(NSString *)quizId withBlock:(PBResponseBlock)block;

/**
 Get detail of a quiz by also specifying player-id.
 */
-(PBRequest *)quizDetail:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizDetail:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)quizDetailAsync:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizDetailAsync:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;

/**
 Get a random of quiz from available quizzes of player.
 */
-(PBRequest *)quizRandom:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizRandom:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)quizRandomAsync:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizRandomAsync:(NSString *)playerId withBlock:(PBResponseBlock)block;

/**
 Get recent quizzes done by player.
 */
-(PBRequest *)quizDone:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizDone:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBResponseBlock)block;
-(PBRequest *)quizDoneAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizDoneAsync:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBResponseBlock)block;

/**
 Get pending quizzzes by player.
 */
-(PBRequest *)quizPending:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizPending:(NSString *)playerId limit:(NSInteger)limit withBlock:(PBResponseBlock)block;
-(PBRequest *)quizPendingAsync:(NSString *)playerId limit:(NSInteger)limit withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizPendingAsync:(NSString *)playerId limit:(NSInteger *)limit withBlock:(PBResponseBlock)block;

/**
 Get a question from a quiz for player.
 */
-(PBRequest *)quizQuestion:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizQuestion:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;
-(PBRequest *)quizQuestionAsync:(NSString *)quizId forPlayer:(NSString *)playerId withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)quizQuestionAsync:(NSString *)quizId forPlayer:(NSString *)playerId withBlock:(PBResponseBlock)block;

/**
 Send SMS to a player.
 */
-(PBRequest *)sms:(NSString *)playerId :(NSString *)message :(id<PBResponseHandler>)delegate;

/**
 Send SMS to a player with a template-id.
 */
-(PBRequest *)sms:(NSString *)playerId :(NSString *)message :(NSString *)templateId :(id<PBResponseHandler>)delegate;

/**
 Send SMS Coupon to a player via SMS.
 */
-(PBRequest *)smsCoupon:(NSString *)playerId :(NSString *)refId :(NSString *)message :(id<PBResponseHandler>)delegate;

/**
 Send SMS Coupon to a player via SMS with a template-id.
 */
-(PBRequest *)smsCoupon:(NSString *)playerId :(NSString *)refId :(NSString *)message :(NSString *)templateId :(id<PBResponseHandler>)delegate;

/**
 Push message.
 */
-(PBRequest *)push:(NSString *)playerId :(NSString *)message :(id<PBResponseHandler>)delegate;

/**
 Push message with template id.
 */
-(PBRequest *)push:(NSString *)playerId :(NSString *)message :(id<PBResponseHandler>)delegate :(NSString *)templateId;

/**
 Register device for push notification.
 */
-(PBRequest *)registerForPushNotification:(id<PBResponseHandler>)delegate;

/**
 Track player with an action.
 */
-(PBRequest *)track:(NSString *)playerId forAction:(NSString *)action withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)track:(NSString *)playerId forAction:(NSString *)action withBlock:(PBResponseBlock)block;

/**
 Execute action for player.
 */
-(PBRequest *)do:(NSString *)playerId action:(NSString *)action withDelegate:(id<PBResponseHandler>)delegate;
-(PBRequest *)do:(NSString *)playerId action:(NSString *)action withBlock:(PBResponseBlock)block;

@end
