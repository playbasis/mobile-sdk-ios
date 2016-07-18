//
//  PBRequestUnit.h
//  pblib
//
//  Created by Playbasis on 1/22/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Request state for PBRequestUnit.
 */
typedef NS_ENUM(NSInteger, pbRequestUnitState) {
    pbRequestUnitStateReadyToStart,
    pbRequestUnitStateStarted,
    pbRequestUnitStateFinishedWithError,
    pbRequestUnitStateFinished
};

/**
 Core http request for Playbasis.
 It support generic type that should be returned when it completes the operation.
 */
@interface PBRequestUnit <__covariant ObjectType> : NSObject
{
    /**
     Completion handler applies for generic type as specified via ObjectType
     */
    void(^_completion)(ObjectType result, NSError* error);
}

/**
 State of request for its whole life cycle.
 */
@property (nonatomic, readonly) pbRequestUnitState state;

/**
 Whether request is sync url type or not.
 */
@property (nonatomic, readonly) BOOL isSyncURLRequest;

/**
 Initialize a request

 @param method     method embedded with apikey
 @param data       data
 @param async      whether or not the request is async, NO for async, YES for sync. Async will use different message format to make a request compared to sync.
 @param completion completion handler
 @param objClass   result class

 @return PBRequestUnit instance
 */
-(instancetype)initWithMethodWithApikey:(NSString *)method withData:(NSString *)data isAsync:(BOOL)async completion:(void (^)(ObjectType, NSError *))completion forResultClass:(Class)objClass;

/**
 Intialize a request

 @param method     method embedded with apikey
 @param data       data
 @param async      whether or not the request is async, NO for async, YES for sync. Async will use different message format to make a request compared to sync.
 @param completion completion handler
 @param jsonSubKey sub key for result if it's not in 'response' level
 @param objClass   result class

 @return PBRequestUnit instance
 */
-(instancetype)initWithMethodWithApikey:(NSString *)method withData:(NSString *)data isAsync:(BOOL)async completion:(void (^)(ObjectType, NSError *))completion withJsonResultSubKey:(NSString *)jsonSubKey forResultClass:(Class)objClass;

-(id)initWithCoder:(NSCoder*)decoder;
-(void)encodeWithCoder:(NSCoder*)encoder;

/**
 Get response in json in dictionary.

 @return json response in dictionary
 */
-(NSDictionary *)getResponse;

/**
 Start its internal request. This sends request over network.
 */
-(void)start;
@end
