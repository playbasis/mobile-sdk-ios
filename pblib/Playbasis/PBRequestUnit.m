//
//  PBRequestUnit.m
//  pblib
//
//  Created by Playbasis on 1/22/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "PBRequestUnit.h"
#import "Playbasis.h"
#import <OCMapper/OCMapper.h>
#import "http/CustomDeviceInfoHttpHeaderFields.h"
#import "PBUtils.h"
#import "PBSettings.h"

//
// object for handling requests response
//

@interface PBRequestUnit ()
{
    CustomDeviceInfoHttpHeaderFields *_customDeviceInfoHttpHeaderFieldsVar;
}
@end

@implementation PBRequestUnit

@synthesize state = _state;
@synthesize isBlockingCall = _isBlockingCall;
@synthesize isSyncURLRequest = _isSyncURLRequest;

-(id)initWithURLRequest:(NSURLRequest *)request blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl responseType:(pbResponseType)responseType andDelegate:(id<PBResponseHandler>)delegate
{
    if(!(self = [super init]))
        return nil;
    
    // save NSURLRequest for later creation of NSURLConnection, and retrieve information from it
    _urlRequest = request;
    
    _receivedData = [NSMutableData data];
    
    // save blocking call flag
    _isBlockingCall = blockingCall;
    _isSyncURLRequest = syncUrl;
    
    _responseType = responseType;
    _retryCount = 0;
    
    // in this case use delegate, thus we set block to nil
    _responseDelegate = delegate;
    _responseBlock = nil;
    
    // set state
    _state = ReadyToStart;
    return self;
}

-(id)initWithURLRequest:(NSURLRequest *)request blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl responseType:(pbResponseType)responseType andBlock:(PBResponseBlock)block
{
    if(!(self = [super init]))
        return nil;
    
    // save NSURLRequest for later creation of NSURLConnection, and retrieve information from it
    _urlRequest = request;
    
    _receivedData = [NSMutableData data];
    
    // save blocking call flag
    _isBlockingCall = blockingCall;
    _isSyncURLRequest = syncUrl;
    
    _responseType = responseType;
    _retryCount = 0;
    
    // in this case use block, thus we set delegate to nil
    _responseDelegate = nil;
    _responseBlock = block;
    
    // set state
    _state = ReadyToStart;
    return self;
}

-(instancetype)initWithURLRequest:(NSURLRequest *)request isAsync:(BOOL)async completion:(void (^)(id, NSError *))completion forResultClass:(Class)objClass
{
    if (!(self = [super init]))
        return nil;
    
    
    _urlRequest = request;
    _receivedData = [NSMutableData data];
    _retryCount = 0;
    _isSyncURLRequest = !async;
    _state = ReadyToStart;
    NSLog(@"before setting completion block: null? [%@]", _completion == nil ? @"YES" : @"NO");
    _completion = completion;
    NSLog(@"after setting completion block: null? [%@]", _completion == nil ? @"YES" : @"NO");
    _resultClass = objClass;
    return self;
}

-(instancetype)initWithMethodWithApikey:(NSString *)method withData:(NSString *)data isAsync:(BOOL)async completion:(void (^)(id, NSError *))completion forResultClass:(Class)objClass
{
    if (!(self = [super init]))
        return nil;
    
    // create url request
    NSURLRequest *urlRequest = [self createUrlRequestFromMethodWithApiKey:method withData:data isAsync:async];

    // set state of this request unit
    _urlRequest = urlRequest;
    _receivedData = [NSMutableData data];
    _retryCount = 0;
    _isSyncURLRequest = !async;
    _state = ReadyToStart;
    _completion = completion;
    _resultClass = objClass;
    
    return self;
}

- (NSURLRequest *)createUrlRequestFromMethodWithApiKey:(NSString *)method withData:(NSString *)data isAsync:(BOOL)async
{
    NSMutableURLRequest *request = nil;
    NSURL* url = nil;
    if(async)
    {
        url = [NSURL URLWithString:BASE_ASYNC_URL];
    }
    else
    {
        url = [NSURL URLWithString:[BASE_URL stringByAppendingString:method]];
    }
    
    // form the data
    if(data == nil)
    {
        request = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"Get request");
    }
    else
    {
        request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        
        // if for async then we send it as json
        NSString *reformedData = data;
        if(async)
        {
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            // form async data
            reformedData = [self createAsyncDataFromMethodWithApiKey:method andData:data];
        }
        // otherwise send it as http post data
        else
        {
            [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        }
        
        // at this point data is proper one
        NSData *postData = [reformedData dataUsingEncoding:NSUTF8StringEncoding];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        NSLog(@"Post request");
    }
    
    // set custom headers to url request
    CustomDeviceInfoHttpHeaderFields *headers = [[CustomDeviceInfoHttpHeaderFields alloc] initWithDefault];
    [headers setUrlRequestHeaders:request];
    
    return request;
}

-(NSString *)createAsyncDataFromMethodWithApiKey:(NSString*)method andData:(NSString *)data
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
    
    return dataFinal;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self)
    {
        return nil;
    }

    _urlRequest = [decoder decodeObjectForKey:@"urlRequest"];
    _receivedData = [decoder decodeObjectForKey:@"receivedData"];
    _jsonResponse = [decoder decodeObjectForKey:@"jsonResponse"];
    
    // we need to wrap up integer value into object
    NSNumber *retryCountNumber = [decoder decodeObjectForKey:@"retryCount"];
    _retryCount = [retryCountNumber integerValue];
    
    // we need to wrap up integer value into object
    NSNumber *responseTypeNumberObj = [decoder decodeObjectForKey:@"responseType"];
    _responseType = [responseTypeNumberObj integerValue];
    
    _state = [decoder decodeIntForKey:@"state"];
    _isBlockingCall = [decoder decodeBoolForKey:@"isBlockingCall"];
    _isSyncURLRequest = [decoder decodeBoolForKey:@"isSyncURLRequest"];
    
    // for delegate and block, we don't serialize it as those objects might not be available
    // after queue loaded all requests from file
    // The important thing here is that we execute the API call, result is another story.
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_urlRequest forKey:@"urlRequest"];
    [encoder encodeObject:_receivedData forKey:@"receivedData"];
    [encoder encodeObject:_jsonResponse forKey:@"jsonResponse"];
    [encoder encodeObject:[NSNumber numberWithInteger:_retryCount] forKey:@"retryCount"];
    [encoder encodeObject:[NSNumber numberWithInt:_responseType]  forKey:@"responseType"];
    [encoder encodeInt:_state forKey:@"state"];
    [encoder encodeBool:_isBlockingCall forKey:@"isBlockingCall"];
    [encoder encodeBool:_isSyncURLRequest forKey:@"isSyncURLRequest"];
    
    // for delegate and block, we don't serialize it as those objects might not be available
    // after queue loaded all requests from file
    // The important thing here is that we execute the API call, result is another story.
}

-(NSDictionary *)getResponse
{
    return _jsonResponse;
}

-(void)responseAsyncURLRequestFromStringResponse:(NSString *)strResponse error:(NSError*)error
{
    // if there's not set responseBlock then return immediately
    if(!_responseBlock)
        return;
    
    // for async url request
    // success message contains only "OK", otherwise regards it as failure
    if(strResponse != nil && [strResponse isEqualToString:@"OK"] && error == nil)
    {
        PBAsyncURLRequestResponseBlock sb = (PBAsyncURLRequestResponseBlock)_responseBlock;
        
        // convert back into dictionary object, and send into response
        sb([PBManualSetResultStatus_Response resultStatusWithSuccess], [_urlRequest URL], nil);
    }
    else
    {
        // if there's connection error, then use its object to send to back to response
        if(error)
        {
            // if retry count doesn't reach the limit then retry
            if(_retryCount <= pbRequestRetryCount)
            {
                PBLOG(@"Waiting to make a request to %@ for duration of %.2f", [_urlRequest URL], pbDelayAmountBeforeNextRequestRetry / 1000.0f);
                
                // sleep the current thread that this request is on for set amount of time
                [NSThread sleepForTimeInterval:pbDelayAmountBeforeNextRequestRetry / 1000.0f];
                
                // if network can be reached then retry
                if([Playbasis sharedPB].isNetworkReachable)
                {
                    // after sleep for certain amount of time, then restart the request again
                    PBLOG(@"Retry sending request to %@", [_urlRequest URL]);
                    [self start];
                }
                // otherwise, break out the retry-loop, then save to local storage
                else
                {
                    PBLOG(@"Break out of the loop, and save it into local storage");
                    [[[Playbasis sharedPB] getRequestOperationalQueue] enqueue:self];
                    
                    PBLOG(@"Queue size = %lu", (unsigned long)[[[Playbasis sharedPB] getRequestOperationalQueue] count]);
                }
            }
            else
            {
                PBAsyncURLRequestResponseBlock sb = (PBAsyncURLRequestResponseBlock)_responseBlock;
            
                // response with fail
                sb([PBManualSetResultStatus_Response resultStatusWithFailure], [_urlRequest URL], error);
            }
        }
        else
        {
            PBLOG(@"Give up retrying, sending back error for %@.", [_urlRequest URL]);
            
            // create an error message directly from the response back
            NSString *errorMessage = strResponse != nil && ![strResponse isEqualToString:@""] ? strResponse : [NSString stringWithFormat:@"There's error from async url request %@", [_urlRequest URL]];
            
            // create an userInfo for NSError
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString([NSString stringWithString:errorMessage], nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString([NSString stringWithString:errorMessage], nil)
                                       };
            
            // use default value of error code from Playbasis's domain
            NSInteger nserrorErrorCode = PBERROR_DEFAULT;
            
            // create an NSError
            NSError *userError = [NSError errorWithDomain:@"com.playbasis.iossdk" code:nserrorErrorCode userInfo:userInfo];
            
            PBAsyncURLRequestResponseBlock sb = (PBAsyncURLRequestResponseBlock)_responseBlock;
            
            // response with fail
            sb([PBManualSetResultStatus_Response resultStatusWithFailure], [_urlRequest URL], userError);
        }
    }
}

-(void)responseFromJSONResponse:(NSDictionary *)jsonResponse
{
    // we need to check the error code, and success flag from json-response first before dispatch out either for success or failure
    // check "error_code" and "success"
    BOOL success = [[jsonResponse objectForKey:@"success"] boolValue];
    // get error code from this json message
    NSString *errorCode = [jsonResponse objectForKey:@"error_code"];
    
    NSLog(@"request success? [%@]", success ? @"YES" : @"NO");
    
    // success
    if(success && [errorCode isEqualToString:@"0000"])
    {
        // response success
        [self responseFromJSONResponse:jsonResponse error:nil];
        
        // TODO: Remove this when we completely refactored stuff
        // response success with actual 'response' data in json level
        NSLog(@"executing responseFromJsonResponse2");
        [self responseFromJsonResponse2:[jsonResponse objectForKey:@"response"] error:nil];
    }
    else
    {
        PBLOG(@"Give up retrying, sending back error for %@.", [_urlRequest URL]);
        
        // get error message
        NSString *errorMessage = [jsonResponse objectForKey:@"message"];
        
        // create an userInfo for NSError
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString([NSString stringWithString:errorMessage], nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString([NSString stringWithString:errorMessage], nil)
                                   };
        
        // convert errorCode from Playbasis platform
        NSInteger nserrorErrorCode = [errorCode integerValue];
        
        // create an NSError
        NSError *error = [NSError errorWithDomain:@"com.playbasis.iossdk" code:nserrorErrorCode userInfo:userInfo];
        
        // response with fail
        [self responseFromJSONResponse:nil error:error];
    }
}

// TODO: Use this instead of the former one when we successfully refactored stuff
-(void)responseFromJsonResponse2:(NSDictionary *)jsonResponse error:(NSError *)error
{
    NSLog(@"check _resultClass == nil? [%@]", _resultClass == nil ? @"YES" : @"NO");
    
    if (_resultClass != nil)
    {
        id result = [_resultClass objectFromDictionary:jsonResponse];
        
        NSLog(@"check _completion == nil? [%@]", _completion == nil ? @"YES" : @"NO");
        if (_completion != nil)
        {
            NSLog(@"execute inside if statement of _completion != nil");
            _completion(result, nil);
        }
    }
}

-(void)responseFromJSONResponse:(NSDictionary *)jsonResponse error:(NSError*)error
{
    switch(_responseType)
    {
        case responseType_normal:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponse:withURL:error:)])
                {
                    // generic case
                    [_responseDelegate processResponse:jsonResponse withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                PBResponseBlock sb = (PBResponseBlock)_responseBlock;
                
                // execute block call
                sb(jsonResponse, [_urlRequest URL], error);
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
        case responseType_playerSetCustomFields:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithResultStatus:withURL:error:)])
                {
                    id<PBResultStatus_ResponseHandler> sd = (id<PBResultStatus_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBResultStatus_Response *response = [PBResultStatus_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // track log-in user
                    if(_responseType == responseType_loginUser)
                    {
                        if(error == nil)
                            [[Playbasis sharedPB] confirmIntendedLoginPlayerId:YES];
                        else
                            [[Playbasis sharedPB] confirmIntendedLoginPlayerId:NO];
                    }
                    else if(_responseType == responseType_logoutUser)
                    {
                        if(error == nil)
                            [[Playbasis sharedPB] confirmIntendedLogoutPlayerId:YES];
                        else
                            [[Playbasis sharedPB] confirmIntendedLogoutPlayerId:NO];
                        
                        // reset logout intended player-id
                        // we don't need it anymore
                        [[Playbasis sharedPB] resetIntendedLogoutPlayerId];
                    }
                    
                    // execute
                    [sd processResponseWithResultStatus:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBResultStatus_Response *response = [PBResultStatus_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBResultStatus_ResponseBlock sb = (PBResultStatus_ResponseBlock)_responseBlock;
                
                // track log-in user
                if(_responseType == responseType_loginUser)
                {
                    if(error == nil)
                        [[Playbasis sharedPB] confirmIntendedLoginPlayerId:YES];
                    else
                        [[Playbasis sharedPB] confirmIntendedLoginPlayerId:NO];
                }
                else if(_responseType == responseType_logoutUser)
                {
                    if(error == nil)
                        [[Playbasis sharedPB] confirmIntendedLogoutPlayerId:YES];
                    else
                        [[Playbasis sharedPB] confirmIntendedLogoutPlayerId:NO];
                    
                    // reset logout intended player-id
                    // we don't need it anymore
                    [[Playbasis sharedPB] resetIntendedLogoutPlayerId];
                }
                
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
            // auth:, and renew: are the same
        case responseType_auth:
        case responseType_renew:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithAuth:withURL:error:)])
                {
                    id<PBAuth_ResponseHandler> sd = (id<PBAuth_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBAuth_Response *response = [PBAuth_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithAuth:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBAuth_Response *response = [PBAuth_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBAuth_ResponseBlock sb = (PBAuth_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playerPublic:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithPlayerPublic:withURL:error:)])
                {
                    id<PBPlayerPublic_ResponseHandler> sd = (id<PBPlayerPublic_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerPublic_Response *response = [PBPlayerPublic_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayerPublic:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerPublic_Response *response = [PBPlayerPublic_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBPlayerPublic_ResponseBlock sb = (PBPlayerPublic_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_player:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithPlayer:withURL:error:)])
                {
                    id<PBPlayer_ResponseHandler> sd = (id<PBPlayer_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayer_Response *response = [PBPlayer_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayer:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayer_Response *response = [PBPlayer_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBPlayer_ResponseBlock sb = (PBPlayer_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playerList:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithPlayerList:withURL:error:)])
                {
                    id<PBPlayerList_ResponseHandler> sd = (id<PBPlayerList_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerList_Response *response = [PBPlayerList_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayerList:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerList_Response *response = [PBPlayerList_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBPlayerList_ResponseBlock sb = (PBPlayerList_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playerGetCustomFields:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithPlayerCustomFields:withURL:error:)])
                {
                    id<PBPlayerCustomFields_ResponseHandler> sd = (id<PBPlayerCustomFields_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerCustomFields_Response *response = [PBPlayerCustomFields_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayerCustomFields:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerCustomFields_Response *response = [PBPlayerCustomFields_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBPlayerCustomFields_ResponseBlock sb = (PBPlayerCustomFields_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_point:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithPoint:withURL:error:)])
                {
                    id<PBPoint_ResponseHandler> sd = (id<PBPoint_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPoint_Response *response = [PBPoint_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPoint:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPoint_Response *response = [PBPoint_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBPoint_ResponseBlock sb = (PBPoint_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_points:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithPoints:withURL:error:)])
                {
                    id<PBPoints_ResponseHandler> sd = (id<PBPoints_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPoints_Response *response = [PBPoints_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPoints:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPoints_Response *response = [PBPoints_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBPoints_ResponseBlock sb = (PBPoints_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_badge:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithBadge:withURL:error:)])
                {
                    id<PBBadge_ResponseHandler> sd = (id<PBBadge_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBBadge_Response *response = [PBBadge_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithBadge:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBBadge_Response *response = [PBBadge_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBBadge_ResponseBlock sb = (PBBadge_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_badges:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithBadges:withURL:error:)])
                {
                    id<PBBadges_ResponseHandler> sd = (id<PBBadges_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBBadges_Response *response = [PBBadges_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithBadges:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBBadges_Response *response = [PBBadges_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBBadges_ResponseBlock sb = (PBBadges_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playerBadges:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithPlayerBadges:withURL:error:)])
                {
                    id<PBPlayerBadges_ResponseHandler> sd = (id<PBPlayerBadges_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerBadges_Response *response = [PBPlayerBadges_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayerBadges:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerBadges_Response *response = [PBPlayerBadges_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBPlayerBadges_ResponseBlock sb = (PBPlayerBadges_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playerDetailedPublic:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithPlayerDetailedPublic:withURL:error:)])
                {
                    id<PBPlayerDetailedPublic_ResponseHandler> sd = (id<PBPlayerDetailedPublic_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerDetailedPublic_Response *response = [PBPlayerDetailedPublic_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayerDetailedPublic:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerDetailedPublic_Response *response = [PBPlayerDetailedPublic_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBPlayerDetailedPublic_ResponseBlock sb = (PBPlayerDetailedPublic_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playerDetailed:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithPlayerDetailed:withURL:error:)])
                {
                    id<PBPlayerDetailed_ResponseHandler> sd = (id<PBPlayerDetailed_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerDetailed_Response *response = [PBPlayerDetailed_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayerDetailed:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerDetailed_Response *response = [PBPlayerDetailed_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBPlayerDetailed_ResponseBlock sb = (PBPlayerDetailed_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_pointHistory:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithPointHistory:withURL:error:)])
                {
                    id<PBPointHistory_ResponseHandler> sd = (id<PBPointHistory_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPointHistory_Response *response = [PBPointHistory_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPointHistory:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPointHistory_Response *response = [PBPointHistory_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBPointHistory_ResponseBlock sb = (PBPointHistory_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_actionLastPerformedTime:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithActionLastPerformedTime:withURL:error:)])
                {
                    id<PBActionLastPerformedTime_ResponseHandler> sd = (id<PBActionLastPerformedTime_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBActionLastPerformedTime_Response *response = [PBActionLastPerformedTime_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithActionLastPerformedTime:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBActionLastPerformedTime_Response *response = [PBActionLastPerformedTime_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBActionLastPerformedTime_ResponseBlock sb = (PBActionLastPerformedTime_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_actionTime:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithActionTime:withURL:error:)])
                {
                    id<PBActionTime_ResponseHandler> sd = (id<PBActionTime_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBActionTime_Response *response = [PBActionTime_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithActionTime:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBActionTime_Response *response = [PBActionTime_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBActionTime_ResponseBlock sb = (PBActionTime_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_lastAction:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithLastAction:withURL:error:)])
                {
                    id<PBLastAction_ResponseHandler> sd = (id<PBLastAction_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBLastAction_Response *response = [PBLastAction_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithLastAction:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBLastAction_Response *response = [PBLastAction_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBLastAction_ResponseBlock sb = (PBLastAction_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_actionCount:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithActionCount:withURL:error:)])
                {
                    id<PBActionCount_ResponseHandler> sd = (id<PBActionCount_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBActionCount_Response *response = [PBActionCount_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithActionCount:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBActionCount_Response *response = [PBActionCount_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBActionCount_ResponseBlock sb = (PBActionCount_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_level:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithLevel:withURL:error:)])
                {
                    id<PBLevel_ResponseHandler> sd = (id<PBLevel_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBLevel_Response *response = [PBLevel_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithLevel:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBLevel_Response *response = [PBLevel_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBLevel_ResponseBlock sb = (PBLevel_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_levels:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithLevels:withURL:error:)])
                {
                    id<PBLevels_ResponseHandler> sd = (id<PBLevels_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBLevels_Response *response = [PBLevels_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithLevels:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBLevels_Response *response = [PBLevels_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBLevels_ResponseBlock sb = (PBLevels_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_rank:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithRank:withURL:error:)])
                {
                    id<PBRank_ResponseHandler> sd = (id<PBRank_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBRank_Response *response = [PBRank_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithRank:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBRank_Response *response = [PBRank_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBRank_ResponseBlock sb = (PBRank_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_ranks:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithRanks:withURL:error:)])
                {
                    id<PBRanks_ResponseHandler> sd = (id<PBRanks_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBRanks_Response *response = [PBRanks_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithRanks:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBRanks_Response *response = [PBRanks_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBRanks_ResponseBlock sb = (PBRanks_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_deductReward:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithDeductReward:withURL:error:)])
                {
                    id<PBDeductReward_ResponseHandler> sd = (id<PBDeductReward_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBDeductReward_Response *response = [PBDeductReward_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithDeductReward:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBDeductReward_Response *response = [PBDeductReward_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBDeductReward_ResponseBlock sb = (PBDeductReward_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_goodsInfo:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithGoodsInfo:withURL:error:)])
                {
                    id<PBGoodsInfo_ResponseHandler> sd = (id<PBGoodsInfo_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBGoodsInfo_Response *response = [PBGoodsInfo_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithGoodsInfo:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBGoodsInfo_Response *response = [PBGoodsInfo_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBGoodsInfo_ResponseBlock sb = (PBGoodsInfo_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_goodsListInfo:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithGoodsListInfo:withURL:error:)])
                {
                    id<PBGoodsListInfo_ResponseHandler> sd = (id<PBGoodsListInfo_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBGoodsListInfo_Response *response = [PBGoodsListInfo_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithGoodsListInfo:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBGoodsListInfo_Response *response = [PBGoodsListInfo_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBGoodsListInfo_ResponseBlock sb = (PBGoodsListInfo_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_goodsGroupAvailable:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithGoodsGroupAvailable:withURL:error:)])
                {
                    id<PBGoodsGroupAvailable_ResponseHandler> sd = (id<PBGoodsGroupAvailable_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBGoodsGroupAvailable_Response *response = [PBGoodsGroupAvailable_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithGoodsGroupAvailable:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBGoodsGroupAvailable_Response *response = [PBGoodsGroupAvailable_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBGoodsGroupAvailable_ResponseBlock sb = (PBGoodsGroupAvailable_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playerGoodsOwned:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithPlayerGoodsOwned:withURL:error:)])
                {
                    id<PBPlayerGoodsOwned_ResponseHandler> sd = (id<PBPlayerGoodsOwned_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerGoodsOwned_Response *response = [PBPlayerGoodsOwned_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayerGoodsOwned:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerGoodsOwned_Response *response = [PBPlayerGoodsOwned_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBPlayerGoodsOwned_ResponseBlock sb = (PBPlayerGoodsOwned_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questListOfPlayer:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithQuestListOfPlayer:withURL:error:)])
                {
                    id<PBQuestListOfPlayer_ResponseHandler> sd = (id<PBQuestListOfPlayer_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestListOfPlayer_Response *response = [PBQuestListOfPlayer_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestListOfPlayer:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestListOfPlayer_Response *response = [PBQuestListOfPlayer_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBQuestListOfPlayer_ResponseBlock sb = (PBQuestListOfPlayer_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questOfPlayer:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithQuestOfPlayer:withURL:error:)])
                {
                    id<PBQuestOfPlayer_ResponseHandler> sd = (id<PBQuestOfPlayer_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestOfPlayer_Response *response = [PBQuestOfPlayer_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestOfPlayer:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestOfPlayer_Response *response = [PBQuestOfPlayer_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBQuestOfPlayer_ResponseBlock sb = (PBQuestOfPlayer_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questRewardHistoryOfPlayer:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithQuestRewardHistoryOfPlayer:withURL:error:)])
                {
                    id<PBQuestRewardHistoryOfPlayer_ResponseHandler> sd = (id<PBQuestRewardHistoryOfPlayer_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestRewardHistoryOfPlayer_Response *response = [PBQuestRewardHistoryOfPlayer_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestRewardHistoryOfPlayer:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestRewardHistoryOfPlayer_Response *response = [PBQuestRewardHistoryOfPlayer_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBQuestRewardHistoryOfPlayer_ResponseBlock sb = (PBQuestRewardHistoryOfPlayer_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questList:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithQuestList:withURL:error:)])
                {
                    id<PBQuestList_ResponseHandler> sd = (id<PBQuestList_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestList_Response *response = [PBQuestList_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestList:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestList_Response *response = [PBQuestList_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBQuestList_ResponseBlock sb = (PBQuestList_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questInfo:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithQuestInfo:withURL:error:)])
                {
                    id<PBQuestInfo_ResponseHandler> sd = (id<PBQuestInfo_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestInfo_Response *response = [PBQuestInfo_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestInfo:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestInfo_Response *response = [PBQuestInfo_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBQuestInfo_ResponseBlock sb = (PBQuestInfo_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_actionConfig:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithActionConfig:withURL:error:)])
                {
                    id<PBActionConfig_ResponseHandler> sd = (id<PBActionConfig_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBActionConfig_Response *response = [PBActionConfig_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithActionConfig:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBActionConfig_Response *response = [PBActionConfig_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBActionConfig_ResponseBlock sb = (PBActionConfig_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_rule:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithRule:withURL:error:)])
                {
                    id<PBRule_ResponseHandler> sd = (id<PBRule_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBRule_Response *response = [PBRule_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithRule:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBRule_Response *response = [PBRule_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBRule_ResponseBlock sb = (PBRule_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_recentPoint:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithRecentPoint:withURL:error:)])
                {
                    id<PBRecentPoint_ResponseHandler> sd = (id<PBRecentPoint_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBRecentPointArray_Response *response = [PBRecentPointArray_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithRecentPoint:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBRecentPointArray_Response *response = [PBRecentPointArray_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBRecentPoint_ResponseBlock sb = (PBRecentPoint_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_missionInfo:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithMissionInfo:withURL:error:)])
                {
                    id<PBMissionInfo_ResponseHandler> sd = (id<PBMissionInfo_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBMissionInfo_Response *response = [PBMissionInfo_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithMissionInfo:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBMissionInfo_Response *response = [PBMissionInfo_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBMissionInfo_ResponseBlock sb = (PBMissionInfo_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questListAvailableForPlayer:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithQuestListAvailableForPlayer:withURL:error:)])
                {
                    id<PBQuestListAvailableForPlayer_ResponseHandler> sd = (id<PBQuestListAvailableForPlayer_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestListAvailableForPlayer_Response *response = [PBQuestListAvailableForPlayer_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestListAvailableForPlayer:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestListAvailableForPlayer_Response *response = [PBQuestListAvailableForPlayer_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBQuestListAvailableForPlayer_ResponseBlock sb = (PBQuestListAvailableForPlayer_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questAvailableForPlayer:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithQuestAvailableForPlayer:withURL:error:)])
                {
                    id<PBQuestAvailableForPlayer_ResponseHandler> sd = (id<PBQuestAvailableForPlayer_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestAvailableForPlayer_Response *response = [PBQuestAvailableForPlayer_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestAvailableForPlayer:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestAvailableForPlayer_Response *response = [PBQuestAvailableForPlayer_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBQuestAvailableForPlayer_ResponseBlock sb = (PBQuestAvailableForPlayer_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_joinQuest:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithJoinQuest:withURL:error:)])
                {
                    id<PBJoinQuest_ResponseHandler> sd = (id<PBJoinQuest_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBJoinQuest_Response *response = [PBJoinQuest_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithJoinQuest:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBJoinQuest_Response *response = [PBJoinQuest_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBJoinQuest_ResponseBlock sb = (PBJoinQuest_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_joinAllQuests:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithJoinAllQuests:withURL:error:)])
                {
                    id<PBJoinAllQuests_ResponseHandler> sd = (id<PBJoinAllQuests_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBJoinAllQuests_Response *response = [PBJoinAllQuests_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithJoinAllQuests:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBJoinAllQuests_Response *response = [PBJoinAllQuests_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBJoinAllQuests_ResponseBlock sb = (PBJoinAllQuests_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_cancelQuest:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithCancelQuest:withURL:error:)])
                {
                    id<PBCancelQuest_ResponseHandler> sd = (id<PBCancelQuest_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBCancelQuest_Response *response = [PBCancelQuest_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithCancelQuest:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBCancelQuest_Response *response = [PBCancelQuest_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBCancelQuest_ResponseBlock sb = (PBCancelQuest_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_activeQuizList:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithActiveQuizList:withURL:error:)])
                {
                    id<PBActiveQuizList_ResponseHandler> sd = (id<PBActiveQuizList_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBActiveQuizList_Response *response = [PBActiveQuizList_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithActiveQuizList:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBActiveQuizList_Response *response = [PBActiveQuizList_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBActiveQuizList_ResponseBlock sb = (PBActiveQuizList_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_quizDetail:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithQuizDetail:withURL:error:)])
                {
                    id<PBQuizDetail_ResponseHandler> sd = (id<PBQuizDetail_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuizDetail_Response *response = [PBQuizDetail_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuizDetail:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuizDetail_Response *response = [PBQuizDetail_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBQuizDetail_ResponseBlock sb = (PBQuizDetail_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_quizRandom:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithQuizRandom:withURL:error:)])
                {
                    id<PBQuizRandom_ResponseHandler> sd = (id<PBQuizRandom_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuizRandom_Response *response = [PBQuizRandom_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuizRandom:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuizRandom_Response *response = [PBQuizRandom_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBQuizRandom_ResponseBlock sb = (PBQuizRandom_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_quizDoneListByPlayer:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithQuizDoneList:withURL:error:)])
                {
                    id<PBQuizDoneList_ResponseHandler> sd = (id<PBQuizDoneList_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuizDoneList_Response *response = [PBQuizDoneList_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuizDoneList:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuizDoneList_Response *response = [PBQuizDoneList_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBQuizDoneList_ResponseBlock sb = (PBQuizDoneList_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_quizPendingsByPlayer:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithQuizPendings:withURL:error:)])
                {
                    id<PBQuizPendings_ResponseHandler> sd = (id<PBQuizPendings_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuizPendings_Response *response = [PBQuizPendings_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuizPendings:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuizPendings_Response *response = [PBQuizPendings_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBQuizPendings_ResponseBlock sb = (PBQuizPendings_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_redeemGoods:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithRedeemGoods:withURL:error:)])
                {
                    id<PBRedeemGoods_ResponseHandler> sd = (id<PBRedeemGoods_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBRedeemGoods_Response *response = [PBRedeemGoods_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithRedeemGoods:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBRedeemGoods_Response *response = [PBRedeemGoods_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBRedeemGoods_ResponseBlock sb = (PBRedeemGoods_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questionFromQuiz:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithQuestion:withURL:error:)])
                {
                    id<PBQuestion_ResponseHandler> sd = (id<PBQuestion_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestion_Response *response = [PBQuestion_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestion:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestion_Response *response = [PBQuestion_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBQuestion_ResponseBlock sb = (PBQuestion_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_questionAnswered:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithQuestionAnswered:withURL:error:)])
                {
                    id<PBQuestionAnswered_ResponseHandler> sd = (id<PBQuestionAnswered_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBQuestionAnswered_Response *response = [PBQuestionAnswered_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithQuestionAnswered:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBQuestionAnswered_Response *response = [PBQuestionAnswered_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBQuestionAnswered_ResponseBlock sb = (PBQuestionAnswered_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_playersQuizRank:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithPlayersQuizRank:withURL:error:)])
                {
                    id<PBPlayersQuizRank_ResponseHandler> sd = (id<PBPlayersQuizRank_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayersQuizRank_Response *response = [PBPlayersQuizRank_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithPlayersQuizRank:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBPlayersQuizRank_Response *response = [PBPlayersQuizRank_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBPlayersQuizRank_ResponseBlock sb = (PBPlayersQuizRank_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
            // both send-sms, and send-sms-coupon
        case responseType_sendSMS:
        case responseType_sendSMSCoupon:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithSMS:withURL:error:)])
                {
                    id<PBSendSMS_ResponseHandler> sd = (id<PBSendSMS_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBSendSMS_Response *response = [PBSendSMS_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithSMS:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBSendSMS_Response *response = [PBSendSMS_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBSendSMS_ResponseBlock sb = (PBSendSMS_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_resetPoint:
        {
            if(_responseDelegate)
            {
                if([_responseDelegate respondsToSelector:@selector(processResponseWithResetPoint:withURL:error:)])
                {
                    id<PBResetPoint_ResponseHandler> sd = (id<PBResetPoint_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBResetPoint_Response *response = [PBResetPoint_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    // execute
                    [sd processResponseWithResetPoint:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBResetPoint_Response *response = [PBResetPoint_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBResetPoint_ResponseBlock sb = (PBResetPoint_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_uniqueCode:
        {
            if(_responseDelegate)
            {
                if ([_responseDelegate respondsToSelector:@selector(processResponseWithUniqueCode:withURL:error:)]) {
                    id<PBUniqueCode_ResponseHandler> sd = (id<PBUniqueCode_ResponseHandler>)_responseDelegate;
                    
                    // parse data (get nil if jsonResponse is nil)
                    PBUniqueCode_Response *response = [PBUniqueCode_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    
                    //execute
                    [sd processResponseWithUniqueCode:response withURL:[_urlRequest URL] error:error];
                }
            }
            else if(_responseBlock)
            {
                // parse data (get nil if jsonResponse is nil)
                PBUniqueCode_Response *response = [PBUniqueCode_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                
                PBUniqueCode_ResponseBlock sb = (PBUniqueCode_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            break;
        }
        case responseType_ruleDetail:
        {
            if (_responseDelegate) {
                if ([_responseDelegate respondsToSelector:@selector(processResponseWithRuleDetail:withURL:error:)]) {
                    id<PBRuleDetail_ResponseHandler> sd = (id<PBRuleDetail_ResponseHandler>)_responseDelegate;
                    // parse data (get nil if jsonResponse is nil)
                    PBRuleDetail_Response *response = [PBRuleDetail_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    //execute
                    [sd processResponseWithRuleDetail:response withURL:[_urlRequest URL] error:error];
                }
            } else if (_responseBlock) {
                // parse data (get nil if jsonResponse is nil)
                PBRuleDetail_Response *response = [PBRuleDetail_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                PBRuleDetail_ResponseBlock sb = (PBRuleDetail_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            
            break;
        }
        case responseType_storeOrganize:
        {
            if (_responseDelegate) {
                if ([_responseDelegate respondsToSelector:@selector(processResponseWithOrganizeList:withURL:error:)]) {
                    id<PBStoreOrganize_ResponseHandler> sd = (id<PBStoreOrganize_ResponseHandler>)_responseDelegate;
                    // parse data (get nil if jsonResponse is nil)
                    PBStoreOrganize_Response *response = [PBStoreOrganize_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    //execute
                    [sd processResponseWithOrganizeList:response withURL:[_urlRequest URL] error:error];
                }
            } else if (_responseBlock) {
                // parse data (get nil if jsonResponse is nil)
                PBStoreOrganize_Response *response = [PBStoreOrganize_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                PBStoreOrganize_ResponseBlock sb = (PBStoreOrganize_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            break;
        }
        case responseType_nodeOrganize:
        {
            if (_responseDelegate) {
                if ([_responseDelegate respondsToSelector:@selector(processResponseWithOrganizeList:withURL:error:)]) {
                    id<PBNodeOrganize_ResponseHandler> sd = (id<PBNodeOrganize_ResponseHandler>)_responseDelegate;
                    // parse data (get nil if jsonResponse is nil)
                    PBNodeOrganize_Response *response = [PBNodeOrganize_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    //execute
                    [sd processResponseWithNodeList:response withURL:[_urlRequest URL] error:error];
                }
            } else if (_responseBlock) {
                // parse data (get nil if jsonResponse is nil)
                PBNodeOrganize_Response *response = [PBNodeOrganize_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                PBNodeOrganize_ResponseBlock sb = (PBNodeOrganize_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            break;
        }
        case responseType_leaderBoard:
        {
            if (_responseDelegate) {
                if ([_responseDelegate respondsToSelector:@selector(processResponseWithLeaderBoard:withURL:error:)]) {
                    id<PBLeaderBoard_ResponseHandler> sd = (id<PBLeaderBoard_ResponseHandler>)_responseDelegate;
                    // parse data (get nil if jsonResponse is nil)
                    PBLeaderBoard_Response *response = [PBLeaderBoard_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    //execute
                    [sd processResponseWithLeaderBoard:response withURL:[_urlRequest URL] error:error];
                }
            } else if (_responseBlock) {
                // parse data (get nil if jsonResponse is nil)
                PBLeaderBoard_Response *response = [PBLeaderBoard_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                PBLeaderBoard_ResponseBlock sb = (PBLeaderBoard_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            break;
        }
        case responseType_leaderBoardByAction:
        {
            if (_responseDelegate) {
                if ([_responseDelegate respondsToSelector:@selector(processResponseWithLeaderBoardByAction:withURL:error:)]) {
                    id<PBLeaderBoardByAction_ResponseHandler> sd = (id<PBLeaderBoardByAction_ResponseHandler>)_responseDelegate;
                    // parse data (get nil if jsonResponse is nil)
                    PBLeaderBoardByAction_Response *response = [PBLeaderBoardByAction_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    //execute
                    [sd processResponseWithLeaderBoardByAction:response withURL:[_urlRequest URL] error:error];
                }
            } else if (_responseBlock) {
                // parse data (get nil if jsonResponse is nil)
                PBLeaderBoardByAction_Response *response = [PBLeaderBoardByAction_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                PBLeaderBoardByAction_ResponseBlock sb = (PBLeaderBoardByAction_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            break;
        }
        case responseType_saleHistory:
        {
            if (_responseDelegate) {
                if ([_responseDelegate respondsToSelector:@selector(processResponseWithSaleHistory:withURL:error:)]) {
                    id<PBSaleHistory_ResponseHandler> sd = (id<PBSaleHistory_ResponseHandler>)_responseDelegate;
                    // parse data (get nil if jsonResponse is nil)
                    PBSaleHistory_Response *response = [PBSaleHistory_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    //execute
                    [sd processResponseWithSaleHistory:response withURL:[_urlRequest URL] error:error];
                }
            } else if (_responseBlock) {
                // parse data (get nil if jsonResponse is nil)
                PBSaleHistory_Response *response = [PBSaleHistory_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                PBSaleHistory_ResponseBlock sb = (PBSaleHistory_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            break;
        }
        case responseType_saleBoard:
        {
            if (_responseDelegate) {
                if ([_responseDelegate respondsToSelector:@selector(processResponseWithSaleBoard:withURL:error:)]) {
                    id<PBSaleBoard_ResponseHandler> sd = (id<PBSaleBoard_ResponseHandler>)_responseDelegate;
                    // parse data (get nil if jsonResponse is nil)
                    PBSaleBoard_Response *response = [PBSaleBoard_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    //execute
                    [sd processResponseWithSaleBoard:response withURL:[_urlRequest URL] error:error];
                }
            } else if (_responseBlock) {
                // parse data (get nil if jsonResponse is nil)
                PBSaleBoard_Response *response = [PBSaleBoard_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                PBSaleBoard_ResponseBlock sb = (PBSaleBoard_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            break;
        }
        case responseType_associated:
        {
            if (_responseDelegate) {
                if ([_responseDelegate respondsToSelector:@selector(processResponseWithAssociatedNode:withURL:error:)]) {
                    id<PBAssociatedNode_ResponseHandler> sd = (id<PBAssociatedNode_ResponseHandler>)_responseDelegate;
                    // parse data (get nil if jsonResponse is nil)
                    PBAssociatedNode_Response *response = [PBAssociatedNode_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    //execute
                    [sd processResponseWithAssociatedNode:response withURL:[_urlRequest URL] error:error];
                }
            } else if (_responseBlock) {
                // parse data (get nil if jsonResponse is nil)
                PBAssociatedNode_Response *response = [PBAssociatedNode_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                PBAssociatedNode_ResponseBlock sb = (PBAssociatedNode_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            break;

        }
        case responseType_content:
        {
            if (_responseDelegate) {
                if ([_responseDelegate respondsToSelector:@selector(processResponseWithContent:withURL:error:)]) {
                    id<PBContent_ResponseHandler> sd = (id<PBContent_ResponseHandler>)_responseDelegate;
                    // parse data (get nil if jsonResponse is nil)
                    PBContent_Response *response = [PBContent_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    //execute
                    [sd processResponseWithContent:response withURL:[_urlRequest URL] error:error];
                }
            } else if (_responseBlock) {
                // parse data (get nil if jsonResponse is nil)
                PBContent_Response *response = [PBContent_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                PBContent_ResponseBlock sb = (PBContent_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            break;
        }
        case responseType_playerRole:
        {
            if (_responseDelegate) {
                if ([_responseDelegate respondsToSelector:@selector(processResponseWithPlayerRole:withURL:error:)]) {
                    id<PBPlayerRole_ResponseHandler> sd = (id<PBPlayerRole_ResponseHandler>)_responseDelegate;
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerRole_Response *response = [PBPlayerRole_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    //execute
                    [sd processResponseWithPlayerRole:response withURL:[_urlRequest URL] error:error];
                }
            } else if (_responseBlock) {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerRole_Response *response = [PBPlayerRole_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                PBPlayerRole_ResponseBlock sb = (PBPlayerRole_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            break;
        }
        case responseType_playerListFromNode:
        {
            if (_responseDelegate) {
                if ([_responseDelegate respondsToSelector:@selector(processResponseWithPlayerListFromNode:withURL:error:)]) {
                    id<PBPlayerListFromNode_ResponseHandler> sd = (id<PBPlayerListFromNode_ResponseHandler>)_responseDelegate;
                    // parse data (get nil if jsonResponse is nil)
                    PBPlayerListFromNode_Response *response = [PBPlayerListFromNode_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                    //execute
                    [sd processResponseWithPlayerListFromNode:response withURL:[_urlRequest URL] error:error];
                }
            } else if (_responseBlock) {
                // parse data (get nil if jsonResponse is nil)
                PBPlayerListFromNode_Response *response = [PBPlayerListFromNode_Response parseFromDictionary:jsonResponse startFromFinalLevel:NO];
                PBPlayerListFromNode_ResponseBlock sb = (PBPlayerListFromNode_ResponseBlock)_responseBlock;
                sb(response, [_urlRequest URL], error);
            }
            break;
        }
    }
}

-(void)start
{
    // set to proper state
    _state = Started;
    
    // increase the number of retry-count
    _retryCount++;
    
    // only print out for the first try
    if(_retryCount == 1)
        PBLOG(@"Sending request for %@", [_urlRequest URL]);
    
    // start the request according to the type of request
    // if it's blocking call
    if(_isBlockingCall)
    {
        // create http response & error to get back from request's result
        NSHTTPURLResponse __autoreleasing *httpResponse;
        NSError __autoreleasing *error;
        
        NSData* responseData = [NSURLConnection sendSynchronousRequest:_urlRequest returningResponse:&httpResponse error:&error];
        
        // if both response objects are nil, then return immediately
        if(!_responseDelegate && !_responseBlock)
            return;
        
        // ignore checking to send back response to async url request
        // async url request will be response back via block only
        
        // if all okay
        if(error == nil)
        {
            // set a proper state
            _state = Finished;
            
            // convert response data to string
            NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            // parse string into json
            _jsonResponse = [response objectFromJSONString];

            // response according to the type of response
            [self responseFromJSONResponse:_jsonResponse];
        }
        // otherwise check to retry
        else
        {
            // set to a proper state
            _state = FinishedWithError;
            
            // if retry count doesn't reach the limit then retry
            if(_retryCount <= pbRequestRetryCount)
            {
                PBLOG(@"Waiting to make a request to %@ for duration of %.2f", [_urlRequest URL], pbDelayAmountBeforeNextRequestRetry / 1000.0f);
                
                // sleep the current thread that this request is on for set amount of time
                [NSThread sleepForTimeInterval:pbDelayAmountBeforeNextRequestRetry / 1000.0f];
                
                // if network can be reached then retry
                if([Playbasis sharedPB].isNetworkReachable)
                {
                    // after sleep for certain amount of time, then restart the request again
                    PBLOG(@"Retry sending request to %@", [_urlRequest URL]);
                    [self start];
                }
                // otherwise, break out the retry-loop, then save to local storage
                else
                {
                    // set to a proper state
                    _state = ReadyToStart;
                    
                    PBLOG(@"Break out of the loop, and save it into local storage");
                    [[[Playbasis sharedPB] getRequestOperationalQueue] enqueue:self];
                    
                    PBLOG(@"Queue size = %lu", (unsigned long)[[[Playbasis sharedPB] getRequestOperationalQueue] count]);
                }
            }
            else
            {
                // response fail
                [self responseFromJSONResponse:nil error:error];
            }
        }
    }
    // otherwise, it's non-blocking call
    else
    {
        NSLog(@"inside async request section");
        [NSURLConnection sendAsynchronousRequest:_urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            // if both response objects are nil, then return immediately
            //if(!_responseDelegate && !_responseBlock)
            //    return;
            
            if(_isSyncURLRequest)
            {
                // if data received
                if(error == nil)
                {
                    // set to a proper state
                    _state = Finished;
                    
                    // convert response data to string
                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    // parse string into json
                    _jsonResponse = [responseString objectFromJSONString];
                    
                    // response according to the type of response
                    [self responseFromJSONResponse:_jsonResponse];
                }
                // otherwise, there's an error
                else
                {
                    // set to a proper state
                    _state = FinishedWithError;
                    
                    // response fail
                    [self responseFromJSONResponse:nil error:error];
                }
            }
            else
            {
                if(error == nil)
                {
                    // set to a proper state
                    _state = Finished;
                    
                    // convert data into string
                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    // response to async url request
                    [self responseAsyncURLRequestFromStringResponse:responseString error:nil];
                }
                // otherwise, there's an error
                else
                {
                    // set to a proper state
                    _state = FinishedWithError;
                    
                    // response fail
                    [self responseAsyncURLRequestFromStringResponse:nil error:error];
                }
            }
        }];
    }
}

@end
