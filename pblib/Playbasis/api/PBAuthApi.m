//
//  PBAuthApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import "PBAuthApi.h"
#import "Playbasis.h"
#import "../helper/PBValidator.h"
#import "PBApiMacros.h"

@implementation PBAuthApi

+ (void)auth:(Playbasis *)playbasis bundleId:(NSString *)bundleId andCompletion:(void (^)(PBAuth *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Auth", nil)
    API_CREATE_DATA_VARS(playbasis.apiKey, @"api_key", playbasis.apiSecret, @"api_secret", bundleId, @"pkg_name", nil)
    
    PBRequestUnit<PBAuth*> *request = [[PBRequestUnit<PBAuth*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:^(PBAuth* result, NSError *error) {
        // save token
        if (error == nil)
        {
            playbasis.token = result.token;
        }
        
        // call normal callback block
        if (completion != nil)
            completion(result, error);
    } forResultClass:[PBAuth class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+ (void)renew:(Playbasis *)playbasis completion:(void (^)(PBAuth *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Auth", nil)
    API_CREATE_DATA_VARS(playbasis.apiKey, @"api_key", playbasis.apiSecret, @"api_secret", nil)
    
    PBRequestUnit<PBAuth*> *request = [[PBRequestUnit<PBAuth*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:^(PBAuth* result, NSError *error) {
        if (error == nil)
        {
            playbasis.token = result.token;
        }
        
        // call normal callback block
        if (completion != nil)
            completion(result, error);
    } forResultClass:[PBAuth class]];
    
    [playbasis fireRequestIfNecessary:request];
}

@end
