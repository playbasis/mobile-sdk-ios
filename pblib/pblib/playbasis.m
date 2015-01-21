//
//  playbasis.m
//  playbasis
//
//  Created by Playbasis.
//  Copyright (c) 2556 Playbasis. All rights reserved.
//

#import "playbasis.h"
#import "JSONKit.h"

static NSString * const BASE_URL = @"https://api.pbapp.net/";

//
// object for handling requests response
//
@implementation PBRequest

-(id)initWithURLRequest:(NSURLRequest *)request
{
    return [self initWithURLRequest:request andDelegate:nil];
}

-(id)initWithURLRequest:(NSURLRequest *)request andDelegate:(id<PBResponseHandler>)delegate
{
    if(!(self = [super init]))
        return nil;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!connection)
        return nil;
    
    url = [request URL];
    
#if __has_feature(objc_arc)
    receivedData = [NSMutableData data];
#else
    receivedData = [[NSMutableData data] retain];
#endif
    responseDelegate = delegate;
    state = Started;
    return self;
}

-(void)dealloc
{
#if __has_feature(objc_arc)
    // do nothing
#else
    [url release];
    [super dealloc];
#endif
}

-(PBRequestState)getRequestState
{
    return state;
}

-(NSDictionary *)getResponse
{
    return jsonResponse;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
    state = ResponseReceived;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
    state = ReceivingData;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
#if __has_feature(objc_arc)
    //do nothing
#else
    [connection release];
    [receivedData release];
#endif
    //error inform user of error
    state = FinishedWithError;
    NSLog(@"request from %@ failed: %ld - %@ - %@", [url absoluteString], (long)[error code], [error domain], [error helpAnchor]);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //process data received
    NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    jsonResponse = [response objectFromJSONString];
    if(responseDelegate && ([responseDelegate respondsToSelector:@selector(processResponse:withURL:)]))
        [responseDelegate processResponse:jsonResponse withURL:url];

#if __has_feature(objc_arc)
    //do nothing
#else
    [connection release];
    [receivedData release];
#endif
    state = Finished;
    NSLog(@"request from %@ finished", [url absoluteString]);
}
@end

//
// additional interface for private methods
//
@interface Playbasis ()
-(void)setToken:(NSString *)newToken;
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
-(id)initWithPlaybasis:(Playbasis*)playbasis andDelegate:(id<PBResponseHandler>)delegate;
-(BOOL)isFinished;
-(void)processResponse:(NSDictionary *)jsonResponse withURL:(NSURL *) url;
@end

@implementation PBAuthDelegate

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

-(id)init
{
    if(!(self = [super init]))
        return nil;
    token = nil;
    apiKeyParam = nil;
    authDelegate = nil;
    return self;
}

-(void)dealloc
{
#if __has_feature(objc_arc)
    // do nothing
#else
    if(token)
        [token release];
    if(authDelegate)
        [authDelegate release];
    [super dealloc];
#endif
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

-(PBRequest *)registerForPushNotification:(NSString *)deviceToken :(id<PBResponseHandler>)delegate
{
    NSAssert(token, @"access token is nil");
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
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
    }
    id pbRequest = [[PBRequest alloc] initWithURLRequest:request andDelegate:delegate];
    
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

@end
