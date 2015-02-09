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
    responseType_point
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
/// PlayerDetailPublic
///--------------------------------------
@interface PBPlayerDetailPublic_Response : PBBase_Response

@property (strong, nonatomic) PBPlayerPublic_Response *playerPublic;
@property (nonatomic) float percentOfLevel;
@property (strong, nonatomic) NSString *levelTitle;
@property (strong, nonatomic) NSString *levelImage;

+(PBPlayerDetailPublic_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Point - No Resposne
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

@property (strong, nonatomic) NSArray* points;

+(PBPoint_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

#endif
