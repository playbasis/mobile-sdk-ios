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

-(id)initWithURLRequest:(NSURLRequest *)request
{
    return [self initWithURLRequest:request andDelegate:nil];
}

-(id)initWithURLRequest:(NSURLRequest *)request andDelegate:(id<PBResponseHandler>)delegate
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
    responseDelegate = delegate;
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
    responseDelegate = [decoder decodeObjectForKey:@"responseDelegate"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:urlRequest forKey:@"urlRequest"];
    [encoder encodeObject:receivedData forKey:@"receivedData"];
    [encoder encodeObject:jsonResponse forKey:@"jsonResponse"];
    [encoder encodeInt:state forKey:@"state"];
    [encoder encodeObject:responseDelegate forKey:@"responseDelegate"];
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

-(BOOL)start
{
    // use urlRequest to create a connection and start it immediately
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    // return FALSE immediately if connection cannot be created
    if(connection == nil)
    {
        NSLog(@"Error creating connection");
        return FALSE;
    }
    
    // return TRUE as it can start successfully
    return TRUE;
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
    NSLog(@"request from %@ failed: %ld - %@ - %@", [[urlRequest URL] absoluteString], (long)[error code], [error domain], [error helpAnchor]);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //process data received
    NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    jsonResponse = [response objectFromJSONString];
    if(responseDelegate && ([responseDelegate respondsToSelector:@selector(processResponse:withURL:)]))
        [responseDelegate processResponse:jsonResponse withURL:[urlRequest URL]];
    
#if __has_feature(objc_arc)
    //do nothing
#else
    [connection release];
    [receivedData release];
#endif
    state = Finished;
    NSLog(@"request from %@ finished", [[urlRequest URL] absoluteString]);
}
@end
