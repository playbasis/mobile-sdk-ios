//
//  PBPlayerApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import "PBPlayerApi.h"
#import "Playbasis.h"
#import "../helper/PBValidator.h"
#import "PBApiMacros.h"

@implementation PBPlayerApi

+(void)playerPublic:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(PBPlayer *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)

    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Player/%@", playerId, nil)
    
    PBRequestUnit<PBPlayer*> *request = [[PBRequestUnit<PBPlayer*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion withJsonResultSubKey:@"player" forResultClass:[PBPlayer class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)player:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(PBPlayer *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Player/%@", playerId, nil)
    API_CREATE_DATA_VARS(playbasis.token, @"token", nil)
    
    PBRequestUnit<PBPlayer*> *request = [[PBRequestUnit<PBPlayer*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:completion withJsonResultSubKey:@"player" forResultClass:[PBPlayer class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)listPlayer:(Playbasis *)playbasis listPlayerIds:(NSArray<NSString *> *)listPlayerIds andCompletion:(void (^)(NSArray<PBPlayer *> *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    NSString *commaListPlayerIds = @"";
    NSUInteger count = [listPlayerIds count];
    if (listPlayerIds != nil && count > 0)
    {
        commaListPlayerIds = listPlayerIds[0];
        if (count > 1)
        {
            for (int i=1; i<count; i++)
            {
                commaListPlayerIds = [commaListPlayerIds stringByAppendingString:[NSString stringWithFormat:@",%@", listPlayerIds[i]]];
            }
        }
    }
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Player/list", nil)
    API_CREATE_DATA_VARS(playbasis.token, @"token", commaListPlayerIds, @"list_player_id", nil)
    
    PBRequestUnit<NSArray<PBPlayer*>*> *request = [[PBRequestUnit<NSArray<PBPlayer*>*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:completion withJsonResultSubKey:@"player" forResultClass:[PBPlayer class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)detailedPlayerPublic:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(PBDetailedPlayer *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Player/%@/data/all", playerId, nil)
    
    PBRequestUnit<PBDetailedPlayer*> *request = [[PBRequestUnit<PBDetailedPlayer*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion withJsonResultSubKey:@"player" forResultClass:[PBDetailedPlayer class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)detailedPlayerPrivate:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(PBPlayer *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Player/%@/data/all", playerId, nil)
    API_CREATE_DATA_VARS(playbasis.token, @"token", nil)
    
    PBRequestUnit<PBPlayer*> *request = [[PBRequestUnit<PBPlayer*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:completion withJsonResultSubKey:@"player" forResultClass:[PBPlayer class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)login:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(PBSuccessStatus *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Player/%@/login", playerId, nil)
    API_CREATE_DATA_VARS(playbasis.token, @"token", nil)
    
    PBRequestUnit<PBSuccessStatus*> *request = [[PBRequestUnit<PBSuccessStatus*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:completion forResultClass:[PBSuccessStatus class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)logout:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(PBSuccessStatus *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Player/%@/logout", playerId, nil)
    API_CREATE_DATA_VARS(playbasis.token, @"token", nil)
    
    PBRequestUnit<PBSuccessStatus*> *request = [[PBRequestUnit<PBSuccessStatus*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:completion forResultClass:[PBSuccessStatus class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)points:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(NSArray<PBPoint *> *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Player/%@/points", playerId, nil)
    
    PBRequestUnit<NSArray<PBPoint*>*> *request = [[PBRequestUnit<NSArray<PBPoint*>*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion withJsonResultSubKey:@"points" forResultClass:[PBPoint class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)point:(Playbasis *)playbasis playerId:(NSString *)playerId pointName:(NSString *)pointName andCompletion:(void (^)(NSArray<PBPoint *> *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Player/%@/point/%@", playerId, pointName, nil)
    
    PBRequestUnit *request = [[PBRequestUnit<NSArray<PBPoint*>*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion withJsonResultSubKey:@"point" forResultClass:[PBPoint class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)levels:(Playbasis *)playbasis andCompletion:(void (^)(NSArray<PBLevel *> *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Player/levels", nil)
    
    PBRequestUnit *request = [[PBRequestUnit<NSArray<PBLevel*>*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion forResultClass:[PBLevel class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)level:(Playbasis *)playbasis level:(NSInteger)level andCompletion:(void (^)(PBLevel *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Player/level/%ld", level, nil)
    
    PBRequestUnit *request = [[PBRequestUnit<PBLevel*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion forResultClass:[PBLevel class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)badges:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(NSArray<PBBadge *> *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Player/%@/badgeAll", playerId, nil)
    
    PBRequestUnit *request = [[PBRequestUnit<NSArray<PBBadge*>*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion forResultClass:[PBBadge class]];
    
    [playbasis fireRequestIfNecessary:request];
}

@end
