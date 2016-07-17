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

@implementation PBAuthApi

+ (void)auth:(Playbasis *)playbasis bundleId:(NSString *)bundleId andCompletion:(void (^)(PBAuth *, NSError *))completion
{
    if (![PBValidator isValid:playbasis])
        [NSException raise:@"playbasis instance is needed" format:@"playbasis instance cannot be nil"];
    
    NSString *method = [[PBUtils sharedInstance] createMethodWithApiKeyUrlFromMethod:@"Auth" andApiKey:playbasis.apiKey];
    NSString *data = [[PBUtils sharedInstance] createPostDataStringFromDictionary:@{@"api_key" : playbasis.apiKey, @"api_secret" : playbasis.apiSecret, @"pkg_name" : bundleId}];
    
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
    if (![PBValidator isValid:playbasis])
        [NSException raise:@"playbasis instance is needed" format:@"playbasis instance cannot be nil"];
    
    NSString *method = [[PBUtils sharedInstance] createMethodWithApiKeyUrlFromMethod:@"Auth" andApiKey:playbasis.apiKey];
    NSString *data = [[PBUtils sharedInstance] createPostDataStringFromDictionary:@{@"api_key" : playbasis.apiKey, @"api_secret" : playbasis.apiSecret}];
    
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
