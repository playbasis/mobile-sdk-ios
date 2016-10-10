//
//  PBGameApi.h
//  pblib
//
//  Created by Wasin Thonkaew on 10/10/16.
//
//

#import <Foundation/Foundation.h>
#import "PBGameItemStatusRoot.h"

@class Playbasis;

@interface PBGameApi : NSObject


/**
 Retrieve player's item(s) status in game.

 @param playbasis    playbasis instance
 @param gameName     game name
 @param playerId     player id
 @param completion   completion handler
 */
+ (void)retrieveGameItemStatus:(Playbasis *)playbasis gameName:(NSString *)gameName playerId:(NSString *)playerId andCompletion:(void(^)(PBGameItemStatusRoot* result, NSError* error))completion;


/**
 Retrieve player's item(s) status in game

 @param playbasis  playbasis instance
 @param gameName   game name
 @param playerId   player id
 @param itemId     item id
 @param completion completion handler
 */
+ (void)retrieveGameItemStatus:(Playbasis *)playbasis gameName:(NSString *)gameName playerId:(NSString *)playerId itemId:(NSString *)itemId andCompletion:(void(^)(PBItemStatus* result, NSError* error))completion;

@end
