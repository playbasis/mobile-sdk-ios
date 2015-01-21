//
//  playbasis.h
//  playbasis
//
//  Created by Playbasis.
//  Copyright (c) 2556 Playbasisß. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    Started,
    ResponseReceived,
    ReceivingData,
    FinishedWithError,
    Finished
}
PBRequestState;

@protocol PBResponseHandler <NSObject>
-(void)processResponse:(NSDictionary*)jsonResponse withURL:(NSURL *)url;
@end

@interface PBRequest : NSObject
{
    NSURL* url;
    NSMutableData *receivedData;
    NSDictionary *jsonResponse;
    PBRequestState state;
    id<PBResponseHandler> responseDelegate;
}
-(id)initWithURLRequest:(NSURLRequest *)request;
-(id)initWithURLRequest:(NSURLRequest *)request andDelegate:(id<PBResponseHandler>)delegate;
-(void)dealloc;
-(PBRequestState)getRequestState;
-(NSDictionary *)getResponse;

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end

@interface Playbasis : NSObject
{
    NSString *token;
    NSString *apiKeyParam;
    id<PBResponseHandler> authDelegate;
}
-(id)init;
-(void)dealloc;

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
 */
-(PBRequest *)player:(NSString *)playerId :(id<PBResponseHandler>)delegate;

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
 */
-(PBRequest *)login:(NSString *)playerId :(id<PBResponseHandler>)delegate;

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
-(PBRequest *)rule:(NSString *)playerId :(NSString *)action :(id<PBResponseHandler>)delegate, ...;

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
-(PBRequest *)registerForPushNotification:(NSString *)deviceToken :(id<PBResponseHandler>)delegate;
-(PBRequest *)call:(NSString *)method withData:(NSString *)data andDelegate:(id<PBResponseHandler>)delegate;
@end
