//
//  PBResponses.h
//  pblib
//
//  Created by haxpor on 2/6/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#ifndef pblib_PBResponses_h
#define pblib_PBResponses_h

#import <Foundation/Foundation.h>

///--------------------------------------
/// Type of Response
///--------------------------------------
typedef enum
{
    responseType_normal,
    responseType_auth,
    responseType_playerPublic,
    responseType_player,
    responseType_playerList,
    responseType_point,
    responseType_points,
    responseType_badge,
    responseType_badges,
    responseType_playerBadges,
    responseType_playerDetailedPublic,
    responseType_playerDetailed,
    responseType_pointHistory,
    responseType_actionTime
}pbResponseType;

///--------------------------------------
/// Base - Response
/// Do not use this class directly.
/// All response classes subclasses this class.
///--------------------------------------
@interface PBBase_Response : NSObject

@end

///--------------------------------------
/// Auth
///--------------------------------------
@interface PBAuth_Response : PBBase_Response

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSDate *dateExpire;

+(PBAuth_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end
///--------------------------------------
/// Player Info - Public Data Only
///--------------------------------------
@interface PBPlayerPublic_Response : PBBase_Response

@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *userName;
@property (nonatomic) NSUInteger exp;
@property (nonatomic) NSUInteger level;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (nonatomic) NSUInteger gender;
@property (strong, nonatomic) NSDate *registered;
@property (strong, nonatomic) NSDate *lastLogin;
@property (strong, nonatomic) NSDate *lastLogout;
@property (strong, nonatomic) NSString* clPlayerId;

+(PBPlayerPublic_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Player Info - Included Private Data
///--------------------------------------
@interface PBPlayer_Response : PBBase_Response

@property (strong, nonatomic) PBPlayerPublic_Response *playerPublic;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;

+(PBPlayer_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerList
///--------------------------------------
@interface PBPlayerList_Response : PBBase_Response

@property (strong, nonatomic) NSArray *players;

+(PBPlayerList_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Point - No Response
///--------------------------------------
@interface PBPoint : PBBase_Response

@property (strong, nonatomic) NSString *rewardId;
@property (strong, nonatomic) NSString *rewardName;
@property (nonatomic) NSUInteger value;

+(PBPoint*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Point
///--------------------------------------
@interface PBPoint_Response : PBBase_Response

@property (strong, nonatomic) NSArray* point;

+(PBPoint_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Points
///--------------------------------------
@interface PBPoints_Response : PBBase_Response

@property (strong, nonatomic) NSArray* points;

+(PBPoints_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Badge
///--------------------------------------
@interface PBBadge_Response : PBBase_Response

@property (strong, nonatomic) NSString* badgeId;
@property (strong, nonatomic) NSString* image;
@property (nonatomic) NSUInteger sortOrder;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* description_;
@property (strong, nonatomic) NSString* hint;
@property (nonatomic) BOOL sponsor;
@property (nonatomic) BOOL claim;
@property (nonatomic) BOOL redeem;

+(PBBadge_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Badges
///--------------------------------------
@interface PBBadges_Response : PBBase_Response

@property (strong, nonatomic) NSArray* badges;

+(PBBadges_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerBadge - No Response
///--------------------------------------
@interface PBPlayerBadge : PBBase_Response

@property (strong, nonatomic) NSString *badgeId;
@property (nonatomic) BOOL redeemed;
@property (nonatomic) BOOL claimed;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description_;
@property (nonatomic) NSUInteger amount;
@property (strong, nonatomic) NSString *hint;

+(PBPlayerBadge*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerBadge
///--------------------------------------
@interface PBPlayerBadges_Response : PBBase_Response

@property (strong, nonatomic) NSArray *playerBadges;

+(PBPlayerBadges_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerDetailedPublic
///--------------------------------------
@interface PBPlayerDetailedPublic_Response : PBBase_Response

@property (strong, nonatomic) PBPlayerPublic_Response *playerPublic;
@property (nonatomic) float percentOfLevel;
@property (strong, nonatomic) NSString *levelTitle;
@property (strong, nonatomic) NSString *levelImage;
@property (strong, nonatomic) PBPlayerBadges_Response *badges;
@property (strong, nonatomic) PBPoints_Response *points;

+(PBPlayerDetailedPublic_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerDetailed
///--------------------------------------
@interface PBPlayerDetailed_Response : PBBase_Response

@property (strong, nonatomic) PBPlayer_Response *player;
@property (nonatomic) float percentOfLevel;
@property (strong, nonatomic) NSString *levelTitle;
@property (strong, nonatomic) NSString *levelImage;
@property (strong, nonatomic) PBPlayerBadges_Response *badges;
@property (strong, nonatomic) PBPoints_Response *points;

+(PBPlayerDetailed_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PointHistory - No Response
///--------------------------------------
@interface PBPointHistory : PBBase_Response

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *rewardId;
@property (strong, nonatomic) NSString *rewardName;
@property (nonatomic) NSUInteger value;
@property (strong, nonatomic) NSDate *dateAdded;
@property (strong, nonatomic) NSString *actionName;
@property (strong, nonatomic) NSString *stringFilter;
@property (strong, nonatomic) NSString *actionIcon;

+(PBPointHistory*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PointHistory
///--------------------------------------
@interface PBPointHistory_Response : PBBase_Response

@property (strong, nonatomic) NSArray *pointHistory;

+(PBPointHistory_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ActionTime
///--------------------------------------
@interface PBActionTime_Response : PBBase_Response

@property (strong, nonatomic) NSString *actionId;
@property (strong, nonatomic) NSString *actionName;
@property (strong, nonatomic) NSDate *time;

+(PBActionTime_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

#endif
