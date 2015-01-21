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

-(id)initWithURLRequest:(NSURLRequest *)request
{
    return [self initWithURLRequest:request andDelegate:nil];
}

-(id)initWithURLRequest:(NSURLRequest *)request andDelegate:(id<PBResponseHandler>)delegate
{
    if(!(self = [super init]))
        return nil;
    
    // we don't start it immediately as we need to send this whole PBRequest into
    // operational queue for it to be dispatched later
    self->connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:FALSE];
    
    // return nil immediately if connection cannot be created
    if(!self->connection)
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

-(void)start
{
    NSAssert(connection != nil, @"connection is nil");
    
    // send the request
    [connection start];
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
