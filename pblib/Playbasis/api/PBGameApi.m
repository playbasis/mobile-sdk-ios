//
//  PBGameApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 10/10/16.
//
//

#import "PBGameApi.h"
#import "Playbasis.h"
#import "../helper/PBValidator.h"
#import "PBApiMacros.h"

@implementation PBGameApi

+(void)retrieveGameItemStatus:(Playbasis *)playbasis gameName:(NSString *)gameName playerId:(NSString *)playerId andCompletion:(void (^)(PBGameItemStatusRoot *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Game/playerItemStatus?game_name=%@&player_id=%@", gameName, playerId, nil)
    
    PBRequestUnit<PBGameItemStatusRoot*> *request = [[PBRequestUnit<PBGameItemStatusRoot*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion forResultClass:[PBGameItemStatusRoot class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)retrieveGameItemStatus:(Playbasis *)playbasis gameName:(NSString *)gameName playerId:(NSString *)playerId itemId:(NSString *)itemId andCompletion:(void (^)(PBItemStatus *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Game/playerItemStatus?game_name=%@&player_id=%@&item_id=%@", gameName, playerId, itemId, nil)
    
    PBRequestUnit<PBItemStatus*> *request = [[PBRequestUnit<PBItemStatus*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion forResultClass:[PBItemStatus class]];
    
    [playbasis fireRequestIfNecessary:request];
}

@end
