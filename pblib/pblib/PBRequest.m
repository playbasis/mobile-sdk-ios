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
        [self responseSuccessFromJSONResponse:_jsonResponse];
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
        [self responseFailFromJSONResponseWithError:error];
    }
}

-(void)responseSuccessFromJSONResponse:(NSDictionary *)_jsonResponse
{
    // response back success doesn't include error, only jsonResponse
    
    // if response via delegate
    if(responseDelegate)
    {
        switch(responseType)
        {
            case responseType_normal:
            {
                if([responseDelegate respondsToSelector:@selector(processResponse:withURL:error:)])
                {
                    // generic case
                    [responseDelegate processResponse:_jsonResponse withURL:[urlRequest URL] error:nil];
                }
                
                break;
            }
            case responseType_playerPublic:
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithPlayerPublic:withURL:error:)])
                {
                    id<PBPlayerPublic_ResponseHandler> sd = (id<PBPlayerPublic_ResponseHandler>)responseDelegate;
                    
                    // parse data
                    PBPlayerPublic_Response *response = [PBPlayerPublic_Response parseFromDictionary:_jsonResponse];
                    
                    // execute
                    [sd processResponseWithPlayerPublic:response withURL:[urlRequest URL] error:nil];
                }
                
                break;
            }
        }
    }
    // if response via block
    else if(responseBlock)
    {
        switch(responseType)
        {
            case responseType_normal:
            {
                // execute block call
                responseBlock(jsonResponse, [urlRequest URL], nil);
                
                break;
            }
            case responseType_playerPublic:
            {
                // parse data
                PBPlayerPublic_Response *response = [PBPlayerPublic_Response parseFromDictionary:_jsonResponse];
                
                PBPlayerPublic_ResponseBlock sb = (PBPlayerPublic_ResponseBlock)responseBlock;
                sb(response, [urlRequest URL], nil);
                
                break;
            }
        }
    }
}

-(void)responseFailFromJSONResponseWithError:(NSError*)error
{
    // response back failure doesn't include jsonResponse, only error
    
    // if response via delegate
    if(responseDelegate)
    {
        switch(responseType)
        {
            case responseType_normal:
            {
                // check if responseDelegate is there, and conforms to the calling format
                if([responseDelegate respondsToSelector:@selector(processResponse:withURL:error:)])
                {
                    [responseDelegate processResponse:nil  withURL:[urlRequest URL] error:error];
                }
                
                break;
            }
            case responseType_playerPublic:
            {
                if([responseDelegate respondsToSelector:@selector(processResponseWithPlayerPublic:withURL:error:)])
                {
                    id<PBPlayerPublic_ResponseHandler> sd = (id<PBPlayerPublic_ResponseHandler>)responseDelegate;
                    
                    // execute
                    [sd processResponseWithPlayerPublic:nil withURL:[urlRequest URL] error:error];
                }
                   
                break;
            }
        }
    }
    else if(responseBlock)
    {
        switch(responseType)
        {
            case responseType_normal:
            {
                // execute block call
                responseBlock(nil, [urlRequest URL], error);
                
                break;
            }
            case responseType_playerPublic:
            {
                PBPlayerPublic_ResponseBlock sb = (PBPlayerPublic_ResponseBlock)responseBlock;
                sb(nil, [urlRequest URL], error);
                
                break;
            }
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
            [self responseFailFromJSONResponseWithError:error];
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
                [self responseFailFromJSONResponseWithError:error];
            }
        }];
    }
}

@end
