    //
//  PBRequest.m
//  pblib
//
//  Created by haxpor on 1/22/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "PBRequest.h"
#import "JSONKit.h"

//
// object for handling requests response
//
@implementation PBRequest

@synthesize state;
@synthesize isBlockingCall;
@synthesize isSyncURLRequest;

-(id)initWithURLRequest:(NSURLRequest *)request blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl responseType:(pbResponseType)_responseType andDelegate:(id<PBResponseHandler>)delegate
{
    if(!(self = [super init]))
        return nil;
    
    // save NSURLRequest for later creation of NSURLConnection, and retrieve information from it
    urlRequest = request;
    
#if __has_feature(objc_arc)
    receivedData = [NSMutableData data];
#else
    receivedData = [[NSMutableData data] retain];
#endif
    
    // save blocking call flag
    isBlockingCall = blockingCall;
    isSyncURLRequest = syncUrl;
    
    responseType = _responseType;
    
    // in this case use delegate, thus we set block to nil
    responseDelegate = delegate;
    responseBlock = nil;
    
    // set state
    state = ReadyToStart;
    return self;
}

-(id)initWithURLRequest:(NSURLRequest *)request blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl responseType:(pbResponseType)_responseType andBlock:(PBResponseBlock)block
{
    if(!(self = [super init]))
        return nil;
    
    // save NSURLRequest for later creation of NSURLConnection, and retrieve information from it
    urlRequest = request;
    
#if __has_feature(objc_arc)
    receivedData = [NSMutableData data];
#else
    receivedData = [[NSMutableData data] retain];
#endif
    
    // save blocking call flag
    isBlockingCall = blockingCall;
    isSyncURLRequest = syncUrl;
    
    responseType = _responseType;
    
    // in this case use block, thus we set delegate to nil
    responseDelegate = nil;
    responseBlock = block;
    
    // set state
    state = ReadyToStart;
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self)
    {
        return nil;
    }

    urlRequest = [decoder decodeObjectForKey:@"urlRequest"];
    receivedData = [decoder decodeObjectForKey:@"receivedData"];
    jsonResponse = [decoder decodeObjectForKey:@"jsonResponse"];
    
    // we need to wrap up integer value into object
    NSNumber *responseTypeNumberObj = [decoder decodeObjectForKey:@"responseType"];
    responseType = [responseTypeNumberObj integerValue];
    
    state = [decoder decodeIntForKey:@"state"];
    isBlockingCall = [decoder decodeBoolForKey:@"isBlockingCall"];
    isSyncURLRequest = [decoder decodeBoolForKey:@"isSyncURLRequest"];
    
    // for delegate and block, we don't serialize it as those objects might not be available
    // after queue loaded all requests from file
    // The important thing here is that we execute the API call, result is another story.
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:urlRequest forKey:@"urlRequest"];
    [encoder encodeObject:receivedData forKey:@"receivedData"];
    [encoder encodeObject:jsonResponse forKey:@"jsonResponse"];
    [encoder encodeObject:[NSNumber numberWithInt:responseType]  forKey:@"responseType"];
    [encoder encodeInt:state forKey:@"state"];
    [encoder encodeBool:isBlockingCall forKey:@"isBlockingCall"];
    [encoder encodeBool:isSyncURLRequest forKey:@"isSyncURLRequest"];
    
    // for delegate and block, we don't serialize it as those objects might not be available
    // after queue loaded all requests from file
    // The important thing here is that we execute the API call, result is another story.
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

-(NSDictionary *)getResponse
{
    return jsonResponse;
}

-(void)responseAsyncURLRequestFromStringResponse:(NSString *)strResponse error:(NSError*)error
{
    // if there's not set responseBlock then return immediately
    if(!responseBlock)
        return;
    
    // for async url request
    // success message contains only "OK", otherwise regards it as failure
    if(strResponse != nil && [strResponse isEqualToString:@"OK"] && error == nil)
    {
        PBAsyncURLRequestResponseBlock sb = (PBAsyncURLRequestResponseBlock)responseBlock;
        
        // convert back into dictionary object, and send into response
        sb([PBManualSetResultStatus_Response resultStatusWithSuccess], [urlRequest URL], nil);
    }
    else
    {
        // if there's connection error, then use its object to send to back to response
        if(error)
        {
            PBAsyncURLRequestResponseBlock sb = (PBAsyncURLRequestResponseBlock)responseBlock;
            
            // response with fail
            sb([PBManualSetResultStatus_Response resultStatusWithFailure], [urlRequest URL], error);
        }
        else
        {
            // create an error message directly from the response back
            NSString *errorMessage = strResponse != nil && ![strResponse isEqualToString:@""] ? strResponse : [NSString stringWithFormat:@"There's error from async url request %@", [urlRequest URL]];
            
            // create an userInfo for NSError
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString([NSString stringWithString:errorMessage], nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString([NSString stringWithString:errorMessage], nil)
                                       };
            
            // fix at specific value, because the response might not have any value
            NSInteger nserrorErrorCode = 99;
            
            // create an NSError
            NSError *userError = [NSError errorWithDomain:[[urlRequest URL] path]  code:nserrorErrorCode userInfo:userInfo];
            
            PBAsyncURLRequestResponseBlock sb = (PBAsyncURLRequestResponseBlock)responseBlock;
            
            // response with fail
            sb([PBManualSetResultStatus_Response resultStatusWithFailure], [urlRequest URL], userError);
        }
    }
}

-(void)responseFromJSONResponse:(NSDictionary *)_jsonResponse
{
    // we need to check the error code, and success flag from json-response first before dispatch out either for success or failure
    // check "error_code" and "success"
    BOOL success = [[_jsonResponse objectForKey:@"success"] boolValue];
    NSString *errorCode = [_jsonResponse objectForKey:@"error_code"];
    
    // success
    if(success && [errorCode isEqualToString:@"0000"])
    {
        // response success
        [self responseFromJSONResponse:_jsonResponse error:nil];
    }
    else
    {
        // get error message
        NSString *errorMessage = [_jsonResponse objectForKey:@"message"];
        
        // create an userInfo for NSError
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString([NSString stringWithString:errorMessage], nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString([NSString stringWithString:errorMessage], nil)
                                   };
        
        // convert errorCode from Playbasis platform
        NSInteger nserrorErrorCode = [errorCode integerValue];
        
        // create an NSError
        NSError *error = [NSError errorWithDomain:[[urlRequest URL] path]  code:nserrorErrorCode userInfo:userInfo];
        
        // response with fail
        [self responseFromJSONResponse:nil error:error];
    }
}

-(void)responseFromJSONResponse:(NSDictionary *)_jsonResponse error:(NSError*)error
{
    switch(responseType)
    {
        case responseType_normal:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponse:withURL:error:)])
                {
                    // generic case
                    [responseDelegate processResponse:_jsonResponse withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                PBResponseBlock sb = (PBResponseBlock)responseBlock;
                
                // execute block call
                sb(jsonResponse, [urlRequest URL], error);
            }
            
            break;
        }
            // handle all cases of response that need only result status
        case responseType_registerUser:
        case responseType_updateUser:
        case responseType_deleteUser:
        case responseType_loginUser:
        case responseType_logoutUser:
        case responseType_claimBadge:
        case responseType_redeemBadge:
        case responseType_sendEmail:
        case responseType_sendEmailCoupon:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithResultStatus:withURL:error:)])
                {
                    id<PBResultStatus_ResponseHandler> sd = (id<PBResultStatus_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBResultStatus_Response *response = [PBResultStatus_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithResultStatus:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBResultStatus_Response *response = [PBResultStatus_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBResultStatus_ResponseBlock sb = (PBResultStatus_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
            // auth:, and renew: are the same
        case responseType_auth:
        case responseType_renew:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithAuth:withURL:error:)])
                {
                    id<PBAuth_ResponseHandler> sd = (id<PBAuth_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBAuth_Response *response = [PBAuth_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithAuth:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBAuth_Response *response = [PBAuth_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBAuth_ResponseBlock sb = (PBAuth_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playerPublic:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithPlayerPublic:withURL:error:)])
                {
                    id<PBPlayerPublic_ResponseHandler> sd = (id<PBPlayerPublic_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerPublic_Response *response = [PBPlayerPublic_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayerPublic:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerPublic_Response *response = [PBPlayerPublic_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBPlayerPublic_ResponseBlock sb = (PBPlayerPublic_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_player:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithPlayer:withURL:error:)])
                {
                    id<PBPlayer_ResponseHandler> sd = (id<PBPlayer_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayer_Response *response = [PBPlayer_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayer:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayer_Response *response = [PBPlayer_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBPlayer_ResponseBlock sb = (PBPlayer_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playerList:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithPlayerList:withURL:error:)])
                {
                    id<PBPlayerList_ResponseHandler> sd = (id<PBPlayerList_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerList_Response *response = [PBPlayerList_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayerList:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerList_Response *response = [PBPlayerList_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBPlayerList_ResponseBlock sb = (PBPlayerList_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_point:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithPoint:withURL:error:)])
                {
                    id<PBPoint_ResponseHandler> sd = (id<PBPoint_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPoint_Response *response = [PBPoint_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPoint:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPoint_Response *response = [PBPoint_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBPoint_ResponseBlock sb = (PBPoint_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_points:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithPoints:withURL:error:)])
                {
                    id<PBPoints_ResponseHandler> sd = (id<PBPoints_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPoints_Response *response = [PBPoints_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPoints:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPoints_Response *response = [PBPoints_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBPoints_ResponseBlock sb = (PBPoints_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_badge:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithBadge:withURL:error:)])
                {
                    id<PBBadge_ResponseHandler> sd = (id<PBBadge_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBBadge_Response *response = [PBBadge_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithBadge:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBBadge_Response *response = [PBBadge_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBBadge_ResponseBlock sb = (PBBadge_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_badges:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithBadges:withURL:error:)])
                {
                    id<PBBadges_ResponseHandler> sd = (id<PBBadges_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBBadges_Response *response = [PBBadges_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithBadges:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBBadges_Response *response = [PBBadges_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBBadges_ResponseBlock sb = (PBBadges_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playerBadges:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithPlayerBadge:withURL:error:)])
                {
                    id<PBPlayerBadges_ResponseHandler> sd = (id<PBPlayerBadges_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerBadges_Response *response = [PBPlayerBadges_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayerBadges:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerBadges_Response *response = [PBPlayerBadges_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBPlayerBadges_ResponseBlock sb = (PBPlayerBadges_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playerDetailedPublic:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithPlayerDetailedPublic:withURL:error:)])
                {
                    id<PBPlayerDetailedPublic_ResponseHandler> sd = (id<PBPlayerDetailedPublic_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerDetailedPublic_Response *response = [PBPlayerDetailedPublic_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayerDetailedPublic:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerDetailedPublic_Response *response = [PBPlayerDetailedPublic_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBPlayerDetailedPublic_ResponseBlock sb = (PBPlayerDetailedPublic_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playerDetailed:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithPlayerDetailed:withURL:error:)])
                {
                    id<PBPlayerDetailed_ResponseHandler> sd = (id<PBPlayerDetailed_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerDetailed_Response *response = [PBPlayerDetailed_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayerDetailed:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerDetailed_Response *response = [PBPlayerDetailed_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBPlayerDetailed_ResponseBlock sb = (PBPlayerDetailed_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_pointHistory:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithPointHistory:withURL:error:)])
                {
                    id<PBPointHistory_ResponseHandler> sd = (id<PBPointHistory_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPointHistory_Response *response = [PBPointHistory_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPointHistory:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPointHistory_Response *response = [PBPointHistory_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBPointHistory_ResponseBlock sb = (PBPointHistory_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_actionLastPerformedTime:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithActionLastPerformedTime:withURL:error:)])
                {
                    id<PBActionLastPerformedTime_ResponseHandler> sd = (id<PBActionLastPerformedTime_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBActionLastPerformedTime_Response *response = [PBActionLastPerformedTime_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithActionLastPerformedTime:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBActionLastPerformedTime_Response *response = [PBActionLastPerformedTime_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBActionLastPerformedTime_ResponseBlock sb = (PBActionLastPerformedTime_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_actionTime:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithActionTime:withURL:error:)])
                {
                    id<PBActionTime_ResponseHandler> sd = (id<PBActionTime_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBActionTime_Response *response = [PBActionTime_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithActionTime:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBActionTime_Response *response = [PBActionTime_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBActionTime_ResponseBlock sb = (PBActionTime_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_lastAction:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithLastAction:withURL:error:)])
                {
                    id<PBLastAction_ResponseHandler> sd = (id<PBLastAction_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBLastAction_Response *response = [PBLastAction_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithLastAction:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBLastAction_Response *response = [PBLastAction_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBLastAction_ResponseBlock sb = (PBLastAction_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_actionCount:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithActionCount:withURL:error:)])
                {
                    id<PBActionCount_ResponseHandler> sd = (id<PBActionCount_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBActionCount_Response *response = [PBActionCount_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithActionCount:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBActionCount_Response *response = [PBActionCount_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBActionCount_ResponseBlock sb = (PBActionCount_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_level:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithLevel:withURL:error:)])
                {
                    id<PBLevel_ResponseHandler> sd = (id<PBLevel_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBLevel_Response *response = [PBLevel_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithLevel:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBLevel_Response *response = [PBLevel_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBLevel_ResponseBlock sb = (PBLevel_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_levels:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithLevels:withURL:error:)])
                {
                    id<PBLevels_ResponseHandler> sd = (id<PBLevels_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBLevels_Response *response = [PBLevels_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithLevels:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBLevels_Response *response = [PBLevels_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBLevels_ResponseBlock sb = (PBLevels_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_rank:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithRank:withURL:error:)])
                {
                    id<PBRank_ResponseHandler> sd = (id<PBRank_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBRank_Response *response = [PBRank_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithRank:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBRank_Response *response = [PBRank_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBRank_ResponseBlock sb = (PBRank_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_ranks:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithRanks:withURL:error:)])
                {
                    id<PBRanks_ResponseHandler> sd = (id<PBRanks_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBRanks_Response *response = [PBRanks_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithRanks:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBRanks_Response *response = [PBRanks_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBRanks_ResponseBlock sb = (PBRanks_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_goodsInfo:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithGoodsInfo:withURL:error:)])
                {
                    id<PBGoodsInfo_ResponseHandler> sd = (id<PBGoodsInfo_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBGoodsInfo_Response *response = [PBGoodsInfo_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithGoodsInfo:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBGoodsInfo_Response *response = [PBGoodsInfo_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBGoodsInfo_ResponseBlock sb = (PBGoodsInfo_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_goodsListInfo:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithGoodsListInfo:withURL:error:)])
                {
                    id<PBGoodsListInfo_ResponseHandler> sd = (id<PBGoodsListInfo_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBGoodsListInfo_Response *response = [PBGoodsListInfo_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithGoodsListInfo:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBGoodsListInfo_Response *response = [PBGoodsListInfo_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBGoodsListInfo_ResponseBlock sb = (PBGoodsListInfo_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_goodsGroupAvailable:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithGoodsGroupAvailable:withURL:error:)])
                {
                    id<PBGoodsGroupAvailable_ResponseHandler> sd = (id<PBGoodsGroupAvailable_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBGoodsGroupAvailable_Response *response = [PBGoodsGroupAvailable_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithGoodsGroupAvailable:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBGoodsGroupAvailable_Response *response = [PBGoodsGroupAvailable_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBGoodsGroupAvailable_ResponseBlock sb = (PBGoodsGroupAvailable_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playerGoodsOwned:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithPlayerGoodsOwned:withURL:error:)])
                {
                    id<PBPlayerGoodsOwned_ResponseHandler> sd = (id<PBPlayerGoodsOwned_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerGoodsOwned_Response *response = [PBPlayerGoodsOwned_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayerGoodsOwned:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerGoodsOwned_Response *response = [PBPlayerGoodsOwned_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBPlayerGoodsOwned_ResponseBlock sb = (PBPlayerGoodsOwned_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questListOfPlayer:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithQuestListOfPlayer:withURL:error:)])
                {
                    id<PBQuestListOfPlayer_ResponseHandler> sd = (id<PBQuestListOfPlayer_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestListOfPlayer_Response *response = [PBQuestListOfPlayer_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestListOfPlayer:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestListOfPlayer_Response *response = [PBQuestListOfPlayer_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBQuestListOfPlayer_ResponseBlock sb = (PBQuestListOfPlayer_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questOfPlayer:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithQuestOfPlayer:withURL:error:)])
                {
                    id<PBQuestOfPlayer_ResponseHandler> sd = (id<PBQuestOfPlayer_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestOfPlayer_Response *response = [PBQuestOfPlayer_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestOfPlayer:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestOfPlayer_Response *response = [PBQuestOfPlayer_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBQuestOfPlayer_ResponseBlock sb = (PBQuestOfPlayer_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questRewardHistoryOfPlayer:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithQuestRewardHistoryOfPlayer:withURL:error:)])
                {
                    id<PBQuestRewardHistoryOfPlayer_ResponseHandler> sd = (id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestRewardHistoryOfPlayer_Response *response = [PBQuestRewardHistoryOfPlayer_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestRewardHistoryOfPlayer:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestRewardHistoryOfPlayer_Response *response = [PBQuestRewardHistoryOfPlayer_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBQuestRewardHistoryOfPlayer_ResponseBlock sb = (PBQuestRewardHistoryOfPlayer_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questList:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithQuestList:withURL:error:)])
                {
                    id<PBQuestList_ResponseHandler> sd = (id<PBQuestList_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestList_Response *response = [PBQuestList_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestList:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestList_Response *response = [PBQuestList_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBQuestList_ResponseBlock sb = (PBQuestList_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questInfo:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithQuestInfo:withURL:error:)])
                {
                    id<PBQuestInfo_ResponseHandler> sd = (id<PBQuestInfo_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestInfo_Response *response = [PBQuestInfo_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestInfo:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestInfo_Response *response = [PBQuestInfo_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBQuestInfo_ResponseBlock sb = (PBQuestInfo_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_actionConfig:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithActionConfig:withURL:error:)])
                {
                    id<PBActionConfig_ResponseHandler> sd = (id<PBActionConfig_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBActionConfig_Response *response = [PBActionConfig_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithActionConfig:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBActionConfig_Response *response = [PBActionConfig_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBActionConfig_ResponseBlock sb = (PBActionConfig_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_rule:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithRule:withURL:error:)])
                {
                    id<PBRule_ResponseHandler> sd = (id<PBRule_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBRule_Response *response = [PBRule_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithRule:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBRule_Response *response = [PBRule_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBRule_ResponseBlock sb = (PBRule_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_recentPoint:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithRecentPoint:withURL:error:)])
                {
                    id<PBRecentPoint_ResponseHandler> sd = (id<PBRecentPoint_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBRecentPointArray_Response *response = [PBRecentPointArray_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithRecentPoint:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBRecentPointArray_Response *response = [PBRecentPointArray_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBRecentPoint_ResponseBlock sb = (PBRecentPoint_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_missionInfo:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithMissionInfo:withURL:error:)])
                {
                    id<PBMissionInfo_ResponseHandler> sd = (id<PBMissionInfo_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBMissionInfo_Response *response = [PBMissionInfo_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithMissionInfo:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBMissionInfo_Response *response = [PBMissionInfo_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBMissionInfo_ResponseBlock sb = (PBMissionInfo_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questListAvailableForPlayer:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithQuestListAvailableForPlayer:withURL:error:)])
                {
                    id<PBQuestListAvailableForPlayer_ResponseHandler> sd = (id<PBQuestListAvailableForPlayer_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestListAvailableForPlayer_Response *response = [PBQuestListAvailableForPlayer_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestListAvailableForPlayer:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestListAvailableForPlayer_Response *response = [PBQuestListAvailableForPlayer_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBQuestListAvailableForPlayer_ResponseBlock sb = (PBQuestListAvailableForPlayer_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questAvailableForPlayer:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithQuestAvailableForPlayer:withURL:error:)])
                {
                    id<PBQuestAvailableForPlayer_ResponseHandler> sd = (id<PBQuestAvailableForPlayer_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestAvailableForPlayer_Response *response = [PBQuestAvailableForPlayer_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestAvailableForPlayer:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestAvailableForPlayer_Response *response = [PBQuestAvailableForPlayer_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBQuestAvailableForPlayer_ResponseBlock sb = (PBQuestAvailableForPlayer_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_joinQuest:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithJoinQuest:withURL:error:)])
                {
                    id<PBJoinQuest_ResponseHandler> sd = (id<PBJoinQuest_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBJoinQuest_Response *response = [PBJoinQuest_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithJoinQuest:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBJoinQuest_Response *response = [PBJoinQuest_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBJoinQuest_ResponseBlock sb = (PBJoinQuest_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_joinAllQuests:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithJoinAllQuests:withURL:error:)])
                {
                    id<PBJoinAllQuests_ResponseHandler> sd = (id<PBJoinAllQuests_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBJoinAllQuests_Response *response = [PBJoinAllQuests_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithJoinAllQuests:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBJoinAllQuests_Response *response = [PBJoinAllQuests_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBJoinAllQuests_ResponseBlock sb = (PBJoinAllQuests_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_cancelQuest:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithCancelQuest:withURL:error:)])
                {
                    id<PBCancelQuest_ResponseHandler> sd = (id<PBCancelQuest_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBCancelQuest_Response *response = [PBCancelQuest_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithCancelQuest:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBCancelQuest_Response *response = [PBCancelQuest_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBCancelQuest_ResponseBlock sb = (PBCancelQuest_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_activeQuizList:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithActiveQuizList:withURL:error:)])
                {
                    id<PBActiveQuizList_ResponseHandler> sd = (id<PBActiveQuizList_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBActiveQuizList_Response *response = [PBActiveQuizList_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithActiveQuizList:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBActiveQuizList_Response *response = [PBActiveQuizList_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBActiveQuizList_ResponseBlock sb = (PBActiveQuizList_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_quizDetail:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithQuizDetail:withURL:error:)])
                {
                    id<PBQuizDetail_ResponseHandler> sd = (id<PBQuizDetail_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuizDetail_Response *response = [PBQuizDetail_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuizDetail:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuizDetail_Response *response = [PBQuizDetail_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBQuizDetail_ResponseBlock sb = (PBQuizDetail_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_quizRandom:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithQuizRandom:withURL:error:)])
                {
                    id<PBQuizRandom_ResponseHandler> sd = (id<PBQuizRandom_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuizRandom_Response *response = [PBQuizRandom_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuizRandom:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuizRandom_Response *response = [PBQuizRandom_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBQuizRandom_ResponseBlock sb = (PBQuizRandom_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_quizDoneListByPlayer:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithQuizDoneList:withURL:error:)])
                {
                    id<PBQuizDoneList_ResponseHandler> sd = (id<PBQuizDoneList_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuizDoneList_Response *response = [PBQuizDoneList_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuizDoneList:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuizDoneList_Response *response = [PBQuizDoneList_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBQuizDoneList_ResponseBlock sb = (PBQuizDoneList_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_redeemGoods:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithRedeemGoods:withURL:error:)])
                {
                    id<PBRedeemGoods_ResponseHandler> sd = (id<PBRedeemGoods_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBRedeemGoods_Response *response = [PBRedeemGoods_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithRedeemGoods:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBRedeemGoods_Response *response = [PBRedeemGoods_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBRedeemGoods_ResponseBlock sb = (PBRedeemGoods_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questionFromQuiz:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithQuestion:withURL:error:)])
                {
                    id<PBQuestion_ResponseHandler> sd = (id<PBQuestion_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestion_Response *response = [PBQuestion_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestion:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestion_Response *response = [PBQuestion_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBQuestion_ResponseBlock sb = (PBQuestion_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questionAnswered:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithQuestionAnswered:withURL:error:)])
                {
                    id<PBQuestionAnswered_ResponseHandler> sd = (id<PBQuestionAnswered_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestionAnswered_Response *response = [PBQuestionAnswered_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestionAnswered:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestionAnswered_Response *response = [PBQuestionAnswered_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBQuestionAnswered_ResponseBlock sb = (PBQuestionAnswered_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playersQuizRank:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithPlayersQuizRank:withURL:error:)])
                {
                    id<PBPlayersQuizRank_ResponseHandler> sd = (id<PBPlayersQuizRank_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayersQuizRank_Response *response = [PBPlayersQuizRank_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayersQuizRank:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayersQuizRank_Response *response = [PBPlayersQuizRank_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBPlayersQuizRank_ResponseBlock sb = (PBPlayersQuizRank_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
            // both send-sms, and send-sms-coupon
        case responseType_sendSMS:
        case responseType_sendSMSCoupon:
        {
            if(responseDelegate)
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithSMS:withURL:error:)])
                {
                    id<PBSendSMS_ResponseHandler> sd = (id<PBSendSMS_ResponseHandler>)responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBSendSMS_Response *response = [PBSendSMS_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithSMS:response withURL:[urlRequest URL] error:error];
                }
            }
            else if(responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBSendSMS_Response *response = [PBSendSMS_Response parseFromDictionary:_jsonResponse startFromFinalLevel:NO];
                
                PBSendSMS_ResponseBlock sb = (PBSendSMS_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], error);
            }
            
            break;
        }
    }
}

-(void)start
{
    // start the request according to the type of request
    // if it's blocking call
    if(isBlockingCall)
    {
        // create http response & error to get back from request's result
        NSHTTPURLResponse __autoreleasing *httpResponse;
        NSError __autoreleasing *error;
        
        NSData* responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&httpResponse error:&error];
        
        // if both response objects are nil, then return immediately
        if(!responseDelegate && !responseBlock)
            return;
        
        // ignore checking to send back response to async url request
        // async url request will be response back via block only
        
        // if all okay
        if(error == nil)
        {
            // convert response data to string
            NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            // parse string into json
            jsonResponse = [response objectFromJSONString];

            // response according to the type of response
            [self responseFromJSONResponse:jsonResponse];
        }
        // otherwise print out error
        else
        {
            // respnose fail
            [self responseFromJSONResponse:nil error:error];
        }
    }
    // otherwise, it's non-blocking call
    else
    {
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            // if both response objects are nil, then return immediately
            if(!responseDelegate && !responseBlock)
                return;
            
            if(isSyncURLRequest)
            {
                // if data received
                if(error == nil)
                {
                    // convert response data to string
                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    // parse string into json
                    jsonResponse = [responseString objectFromJSONString];
                    
                    // response according to the type of response
                    [self responseFromJSONResponse:jsonResponse];
                }
                // otherwise, there's an error
                else
                {
                    // response fail
                    [self responseFromJSONResponse:nil error:error];
                }
            }
            else
            {
                if(error == nil)
                {
                    // convert data into string
                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    // response to async url request
                    [self responseAsyncURLRequestFromStringResponse:responseString error:nil];
                }
                // otherwise, there's an error
                else
                {
                    // response fail
                    [self responseAsyncURLRequestFromStringResponse:nil error:error];
                }
            }
        }];
    }
}

@end
