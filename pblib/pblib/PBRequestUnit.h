//
//  PBRequestUnit.h
//  pblib
//
//  Created by haxpor on 1/22/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBTypes.h"
#import "PBResponses.h"
#import "JSONKit.h"

typedef enum
{
    ReadyToStart,
    Started,
    ResponseReceived,
    ReceivingData,
    FinishedWithError,
    Finished
}
PBRequestState;

@interface PBRequestUnit : NSObject
{
    NSURLRequest *urlRequest;
    NSMutableData *receivedData;
    NSDictionary *jsonResponse;
    NSUInteger retryCount;
    
    pbResponseType responseType;
    
    // the following data need not to be serialized
    // either one or another
    id<PBResponseHandler> responseDelegate;
    id responseBlock;
}

@property PBRequestState state;
@property (nonatomic, readonly) BOOL isBlockingCall;
@property (nonatomic, readonly) BOOL isSyncURLRequest;

-(id)initWithURLRequest:(NSURLRequest *)request blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl responseType:(pbResponseType)_responseType andDelegate:(id<PBResponseHandler>)delegate;
-(id)initWithURLRequest:(NSURLRequest *)request blockingCall:(BOOL)blockingCall syncUrl:(BOOL)syncUrl responseType:(pbResponseType)_responseType andBlock:(PBResponseBlock)block;
-(id)initWithCoder:(NSCoder*)decoder;
-(void)encodeWithCoder:(NSCoder*)encoder;
-(void)dealloc;
-(NSDictionary *)getResponse;


/**
 Start its internal request. This sends request over network.
 */
-(void)start;
@end
