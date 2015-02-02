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

-(id)initWithURLRequest:(NSURLRequest *)request blockingCall:(BOOL)blockingCall andDelegate:(id<PBResponseHandler>)delegate
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
    
    // in this case use delegate, thus we set block to nil
    responseDelegate = delegate;
    responseBlock = nil;
    
    // set state
    state = ReadyToStart;
    return self;
}

-(id)initWithURLRequest:(NSURLRequest *)request blockingCall:(BOOL)blockingCall andBlock:(PBResponseBlock)block
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

            // check if responseDelegate is there, and conforms to the calling format
            if(responseDelegate && ([responseDelegate respondsToSelector:@selector(processResponse:withURL:error:)]))
            {
                NSLog(@"call delegate");
                
                [responseDelegate processResponse:jsonResponse withURL:[urlRequest URL] error:nil];
            }
            else if(responseBlock)
            {
                NSLog(@"call block");
                
                // execute block call
                responseBlock(jsonResponse, [urlRequest URL], error);
            }
        }
        // otherwise print out error
        else
        {
            NSLog(@"Failed request, error: %@", [error localizedDescription]);
            
            // check if responseDelegate is there, and conforms to the calling format
            if(responseDelegate && ([responseDelegate respondsToSelector:@selector(processResponse:withURL:error:)]))
            {
                NSLog(@"call delegate with error");
                [responseDelegate processResponse:jsonResponse  withURL:[urlRequest URL] error:error];
            }
            else if(responseBlock)
            {
                NSLog(@"call block with error");
                // execute block call
                responseBlock(jsonResponse, [urlRequest URL], error);
            }
        }
    }
    // otherwise, it's non-blocking call
    else
    {
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            // if data received
            if(data)
            {
                // convert response data to string
                NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                // parse string into json
                jsonResponse = [response objectFromJSONString];
                
                // check if responseDelegate is there, and conforms to the calling format
                if(responseDelegate && ([responseDelegate respondsToSelector:@selector(processResponse:withURL:error:)]))
                {
                    NSLog(@"call async delegate");
                    
                    [responseDelegate processResponse:jsonResponse  withURL:[urlRequest URL] error:nil];
                }
                else if(responseBlock)
                {
                    NSLog(@"call async block");
                    
                    // execute block call
                    responseBlock(jsonResponse, [urlRequest URL], connectionError);
                }
            }
            // no data received
            else
            {
                NSLog(@"Failed request, error: %@", [connectionError localizedDescription]);
                
                // check if responseDelegate is there, and conforms to the calling format
                if(responseDelegate && ([responseDelegate respondsToSelector:@selector(processResponse:withURL:error:)]))
                {
                    NSLog(@"call async delegate with error");
                    
                    [responseDelegate processResponse:nil  withURL:[urlRequest URL] error:connectionError];
                }
                else if(responseBlock)
                {
                    NSLog(@"call async block with error");
                    
                    // execute block call
                    responseBlock(nil, [urlRequest URL], connectionError);
                }
            }
        }];
    }
}

@end
