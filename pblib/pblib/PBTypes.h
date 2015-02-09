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
@protocol PBBadge_ResponseHandler <NSObject>
-(void)processResponseWithBadge:(PBBadge_Response*)badge withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBBadge_ResponseBlock)(PBBadge_Response * badge, NSURL *url, NSError *error);

///----------------
/// Badges
///----------------
@protocol PBBadges_ResponseHandler <NSObject>
-(void)processResponseWithBadges:(PBBadges_Response*)badges withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBBadges_ResponseBlock)(PBBadges_Response * badges, NSURL *url, NSError *error);

///----------------
/// PlayerBadge
///----------------
@protocol PBPlayerBadges_ResponseHandler <NSObject>
-(void)processResponseWithPlayerBadges:(PBPlayerBadges_Response*)badges withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBPlayerBadges_ResponseBlock)(PBPlayerBadges_Response * badges, NSURL *url, NSError *error);

///----------------
/// PlayerDetailedPublic
///----------------
@protocol PBPlayerDetailedPublic_ResponseHandler <NSObject>
-(void)processResponseWithPlayerDetailedPublic:(PBPlayerDetailedPublic_Response*)playerDetailedPublic withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBPlayerDetailedPublic_ResponseBlock)(PBPlayerDetailedPublic_Response * playerDetailedPublic, NSURL *url, NSError *error);

///----------------
/// PlayerDetailed
///----------------
@protocol PBPlayerDetailed_ResponseHandler <NSObject>
-(void)processResponseWithPlayerDetailed:(PBPlayerDetailed_Response*)playerDetailed withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBPlayerDetailed_ResponseBlock)(PBPlayerDetailed_Response * playerDetailed, NSURL *url, NSError *error);

///----------------
/// PointHistory
///----------------
@protocol PBPointHistory_ResponseHandler <NSObject>
-(void)processResponseWithPointHistory:(PBPointHistory_Response*)pointHistory withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBPointHistory_ResponseBlock)(PBPointHistory_Response * pointHistory, NSURL *url, NSError *error);

///----------------
/// ActionTime
///----------------
@protocol PBActionTime_ResponseHandler <NSObject>
-(void)processResponseWithActionTime:(PBActionTime_Response*)actionTime withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBActionTime_ResponseBlock)(PBActionTime_Response * actionTime, NSURL *url, NSError *error);

///----------------
/// LastAction
///----------------
@protocol PBLastAction_ResponseHandler <NSObject>
-(void)processResponseWithLastAction:(PBLastAction_Response*)lastAction withURL:(NSURL *)url error:(NSError*)error;
@end

typedef void (^PBLastAction_ResponseBlock)(PBLastAction_Response * lastAction, NSURL *url, NSError *error);

#endif
