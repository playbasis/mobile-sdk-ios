//
//  PBPlayerApi.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import <Foundation/Foundation.h>
#import "PBPlayer.h"
#import "PBDetailedPlayer.h"
#import "PBSuccessStatus.h"
#import "PBPoint.h"
#import "PBLevel.h"

@class Playbasis;

@interface PBPlayerApi : NSObject

/**
 Get player's public informatoin

 @param playbasis  instance of Playbasis
 @param playerId   player id
 @param completion completion handler
 */
+ (void)playerPublic:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void(^)(PBPlayer *result, NSError *error))completion;

/**
 Get player information included private data.

 @param playbasis  instance of Playbasis
 @param playerId   player id
 @param completion completion handler
 */
+ (void)player:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void(^)(PBPlayer *result, NSError *error))completion;

/**
 Get list of basic information of player

 @param playbasis instance of Playbasis
 @param listPlayerIds array of player id
 @param completion   completion handler
 */
+ (void)listPlayer:(Playbasis *)playbasis listPlayerIds:(NSArray<NSString*>*)listPlayerIds andCompletion:(void(^)(NSArray<PBPlayer*> *result, NSError *error))completion;

/**
 Get player's public detailed information.

 @param playbasis  instance of Playbasis
 @param playerId   player id
 @param completion completion handler
 */
+ (void)detailedPlayerPublic:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void(^)(PBDetailedPlayer *result, NSError *error))completion;

/**
 Get player's detailed information both public and private.

 @param playbasis  instance of Playbasis
 @param playerId   player id
 @param completion completion handler
 */
+ (void)detailedPlayerPrivate:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void(^)(PBPlayer *result, NSError *error))completion;

/**
 Login for player

 @param playbasis  instance of Playbasis
 @param playerId   player id
 @param completion completion handler
 */
+ (void)login:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void(^)(PBSuccessStatus *result, NSError *error))completion;

/**
 Logout for player

 @param playbasis  instance of Playbasis
 @param playerId   player id
 @param completion completion handler
 */
+ (void)logout:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void(^)(PBSuccessStatus *result, NSError *error))completion;

/**
 Return information about all point-based rewards that a player currently has.

 @param playbasis  instance of Playbasis
 @param playerId   player id
 @param completion completion handler
 */
+ (void)points:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void(^)(NSArray<PBPoint*> *result, NSError *error))completion;

/**
 Return information about specified point-based reward a player currently has.

 @param playbasis  instance of Playbasis
 @param playerId   player id
 @param pointName  point-based name
 @param completion completion handler
 */
+ (void)point:(Playbasis *)playbasis playerId:(NSString *)playerId pointName:(NSString *)pointName andCompletion:(void(^)(NSArray<PBPoint*> *result, NSError *error))completion;

/**
 Return all detail of levels

 @param playbasis  instance of Playbasis
 @param completion completion handler
 */
+ (void)levels:(Playbasis *)playbasis andCompletion:(void(^)(NSArray<PBLevel*> *result, NSError *error))completion;

/**
 Return level information

 @param playbasis  instance of Playbasis
 @param level      level number
 @param completion completion handler
 */
+ (void)level:(Playbasis *)playbasis level:(NSInteger)level andCompletion:(void(^)(PBLevel *result, NSError *error))completion;

/**
 Return information about all the badges that player has or can earn as well as amount for ones that has earned

 @param playbasis  instance of Playbasis
 @param playerId   player id
 @param completion completion handler
 */
+ (void)badges:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void(^)(NSArray<PBBadge*> *result, NSError *error))completion;

/**
 Return information about all badges that player has earned.

 @param playbasis  playbasis of Playbasis
 @param playerId   player id
 @param completion completion handler
 */
+ (void)badgesEarned:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void(^)(NSArray<PBBadge*> *result, NSError *error))completion;

/**
 Return information about all the good that player has redeemed

 @param playbasis  instance of Playbasis
 @param playerId   player id
 @param completion completion handler
 */
+ (void)goods:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void(^)(NSArray<PBGoods*> *result, NSError *error))completion;

@end
