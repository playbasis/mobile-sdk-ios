//
//  PBRequest.h
//  pblib
//
//  Created by haxpor on 1/22/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBTypes.h"

typedef enum
{
    Started,
    ResponseReceived,
    ReceivingData,
    FinishedWithError,
    Finished
}
PBRequestState;

@interface PBRequest : NSObject
{
    NSURL* url;
    NSMutableData *receivedData;
    NSDictionary *jsonResponse;
    PBRequestState state;
    id<PBResponseHandler> responseDelegate;
    NSURLConnection *connection;
}

-(id)initWithURLRequest:(NSURLRequest *)request;
-(id)initWithURLRequest:(NSURLRequest *)request andDelegate:(id<PBResponseHandler>)delegate;
-(void)dealloc;
-(PBRequestState)getRequestState;
-(NSDictionary *)getResponse;

/**
 Start its internal request. This sends request over nextwork.
 */
-(void)start;

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end
