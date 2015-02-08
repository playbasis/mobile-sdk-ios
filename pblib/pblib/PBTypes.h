//
//  PBTypes.h
//  pblib
//
//  Created by haxpor on 1/22/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#ifndef pblib_PBTypes_h
#define pblib_PBTypes_h

#import "PBResponses.h"

///---------------------------------------------
/// @name Delegates and Block Response Handlers
///---------------------------------------------
/**
 Generic Normal
 */
@protocol PBResponseHandler <NSObject>
-(void)processResponse:(id)jsonResponse withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBResponseBlock)(id jsonResponse, NSURL* url, NSError *error);

/**
 PlayerPublic
 */
@protocol PBPlayerPublic_ResponseHandler <NSObject>
-(void)processResponseWithPlayerPublic:(PBPlayerPublic_Response*)playerResponse withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBPlayerPublic_ResponseBlock)(PBPlayerPublic_Response *playerResponse, NSURL *url, NSError *error);

/**
 Player
 */
@protocol PBPlayer_ResponseHandler <NSObject>
-(void)processResponseWithPlayer:(PBPlayer_Response*)playerResponse withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBPlayer_ResponseBlock)(PBPlayer_Response * player, NSURL *url, NSError *error);


#endif
