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



@end
