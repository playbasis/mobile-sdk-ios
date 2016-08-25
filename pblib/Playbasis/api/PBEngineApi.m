//
//  PBEngineApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/25/16.
//
//

#import "PBEngineApi.h"
#import "Playbasis.h"
#import "../helper/PBValidator.h"
#import "PBApiMacros.h"

@implementation PBEngineApi

+(void)rule:(Playbasis *)playbasis playerId:(NSString *)playerId action:(NSString *)action andCompletion:(void (^)(PBRule * _Nullable, NSError * _Nullable))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Engine/rule", nil)
    API_CREATE_DATA_VARS(playbasis.token, @"token", playerId, @"player_id", action, @"action", nil)
    
    PBRequestUnit *request = [[PBRequestUnit<PBRule*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:completion forResultClass:[PBRule class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)rule:(Playbasis *)playbasis playerId:(NSString *)playerId action:(NSString *)action customParamKeys:(NSArray<NSString *> *)customParamKeys customParamValues:(NSArray<NSString *> *)customParamValues andCompletion:(void (^)(PBRule * _Nullable, NSError * _Nullable))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Engine/rule", nil)
    
    // create a temporary dictionary usd to create a post data string later
    NSMutableDictionary *kvDict = [NSMutableDictionary dictionary];
    [kvDict setValue:playbasis.token forKey:@"token"];
    [kvDict setValue:playerId forKey:@"player_id"];
    [kvDict setValue:action forKey:@"action"];
    
    // if need to process custom param keys, and values
    if (customParamKeys != nil && customParamValues != nil &&
        [customParamKeys count] > 0 && [customParamValues count] > 0 &&
        [customParamKeys count] == [customParamValues count])
    {
        for (int i=0; i < [customParamKeys count]; i++)
        {
            [kvDict setValue:customParamValues[i] forKey:customParamKeys[i]];
        }
    }
    
    // create a resulting post data string
    NSString *data = [[PBUtils sharedInstance] createPostDataStringFromDictionary:kvDict];
    
    PBRequestUnit *request = [[PBRequestUnit<PBRule*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:completion forResultClass:[PBRule class]];
    
    [playbasis fireRequestIfNecessary:request];
}

@end
