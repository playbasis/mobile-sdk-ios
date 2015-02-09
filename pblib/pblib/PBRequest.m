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

-(id)initWithURLRequest:(NSURLRequest *)request blockingCall:(BOOL)blockingCall responseType:(pbResponseType)_responseType andDelegate:(id<PBResponseHandler>)delegate
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
    
    responseType = _responseType;
    
    // in this case use delegate, thus we set block to nil
    responseDelegate = delegate;
    responseBlock = nil;
    
    // set state
    state = ReadyToStart;
    return self;
}

-(id)initWithURLRequest:(NSURLRequest *)request blockingCall:(BOOL)blockingCall responseType:(pbResponseType)_responseType andBlock:(PBResponseBlock)block
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
    state = [decoder decodeIntForKey:@"state"];
    isBlockingCall = [decoder decodeBoolForKey:@"isBlockingCall"];
    
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
    [encoder encodeInt:state forKey:@"state"];
    [encoder encodeBool:isBlockingCall forKey:@"isBlockingCall"];
    
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

-(PBRequestState)getRequestState
{
    return state;
}

-(NSDictionary *)getResponse
{
    return jsonResponse;
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
    // if both response objects are nil, then return immediately
    if(!responseDelegate && !responseBlock)
        return;
    
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
                // execute block call
                responseBlock(jsonResponse, [urlRequest URL], error);
            }
            
            break;
        }
        case responseType_auth:
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
            
            // if data received
            if(error == nil)
            {
                // convert response data to string
                NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                // parse string into json
                jsonResponse = [response objectFromJSONString];
                
                // response according to the type of response
                [self responseFromJSONResponse:jsonResponse];
            }
            // otherwise, there's an error
            else
            {
                // respnose fail
                [self responseFromJSONResponse:nil error:error];
            }
        }];
    }
}

@end
