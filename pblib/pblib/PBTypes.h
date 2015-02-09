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
///----------------
/// Normal
///----------------
@protocol PBResponseHandler <NSObject>
-(void)processResponse:(id)jsonResponse withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBResponseBlock)(id jsonResponse, NSURL* url, NSError *error);

///----------------
/// Auth
///----------------
@protocol PBAuth_ResponseHandler <NSObject>
-(void)processResponseWithAuth:(PBAuth_Response*)auth withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBAuth_ResponseBlock)(PBAuth_Response* jsonResponse, NSURL* url, NSError *error);

///----------------
/// PlayerPublic
///----------------
@protocol PBPlayerPublic_ResponseHandler <NSObject>
-(void)processResponseWithPlayerPublic:(PBPlayerPublic_Response*)playerResponse withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBPlayerPublic_ResponseBlock)(PBPlayerPublic_Response *playerResponse, NSURL *url, NSError *error);

///----------------
/// Player
///----------------
@protocol PBPlayer_ResponseHandler <NSObject>
-(void)processResponseWithPlayer:(PBPlayer_Response*)playerResponse withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBPlayer_ResponseBlock)(PBPlayer_Response * player, NSURL *url, NSError *error);

///----------------
/// PlayerList
///----------------
@protocol PBPlayerList_ResponseHandler <NSObject>
-(void)processResponseWithPlayerList:(PBPlayerList_Response*)playerList withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBPlayerList_ResponseBlock)(PBPlayerList_Response * playerList, NSURL *url, NSError *error);

///----------------
/// PlayerDetailPublic
///----------------
@protocol PBPlayerDetailPublic_ResponseHandler <NSObject>
-(void)processResponseWithPlayerList:(PBPlayerList_Response*)playerList withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBPlayerDetailPublic_ResponseBlock)(PBPlayerList_Response * playerList, NSURL *url, NSError *error);

///----------------
/// Point
///----------------
@protocol PBPoint_ResponseHandler <NSObject>
-(void)processResponseWithPoint:(PBPoint_Response*)points withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBPoint_ResponseBlock)(PBPoint_Response * points, NSURL *url, NSError *error);

///----------------
/// Points
///----------------
@protocol PBPoints_ResponseHandler <NSObject>
-(void)processResponseWithPoints:(PBPoints_Response*)points withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBPoints_ResponseBlock)(PBPoints_Response * points, NSURL *url, NSError *error);

///----------------
/// Badge
///----------------
@protocol PBPlayerBadge_ResponseHandler <NSObject>
-(void)processResponseWithPlayerBadge:(PBPlayerBadge_Response*)badge withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBPlayerBadge_ResponseBlock)(PBPlayerBadge_Response * badge, NSURL *url, NSError *error);


#endif
