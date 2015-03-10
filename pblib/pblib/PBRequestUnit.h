//
//  PBRequestUnit.h
//  pblib
//
//  Created by Playbasis on 1/22/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBTypes.h"
#import "PBResponses.h"
#import "JSONKit.h"

/** State of request */
typedef enum
{
    ReadyToStart,
    Started,
    FinishedWithError,
    Finished
}
PBRequestState;

@interface PBRequestUnit : NSObject
{
    NSURLRequest *_urlRequest;
    NSMutableData *_receivedData;
    NSDictionary *_jsonResponse;
    NSUInteger _retryCount;
    
    pbResponseType _responseType;
    
    // the following data need not to be serialized
    // either one or another
    id<PBResponseHandler> _responseDelegate;
    id _responseBlock;
}

@property (nonatomic, readonly) PBRequestState state;
@property (nonatomic, readonly) BOOL isBlockingCall;
@property (nonatomic, readonly) BOOL isSyncURLRequest;

-(id)initWithURLRequest:(NSURLRequest *)request blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl responseType:(pbResponseType)responseType andDelegate:(id<PBResponseHandler>)delegate;
-(id)initWithURLRequest:(NSURLRequest *)request blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl responseType:(pbResponseType)responseType andBlock:(PBResponseBlock)block;
-(id)initWithCoder:(NSCoder*)decoder;
-(void)encodeWithCoder:(NSCoder*)encoder;
-(NSDictionary *)getResponse;


/**
 Start its internal request. This sends request over network.
 */
-(void)start;
@end
