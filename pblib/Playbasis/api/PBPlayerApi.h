//
//  PBPlayerApi.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import <Foundation/Foundation.h>
#import "PBPlayer.h"

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

@end
