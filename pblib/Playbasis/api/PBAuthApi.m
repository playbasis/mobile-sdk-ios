//
//  PBAuthApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import "PBAuthApi.h"
#import "../PBUtils.h"
#import "../PBRequestUnit.h"
#import "Playbasis.h"

static NSString* s_apiKey = nil;
static NSString* s_apiSecret = nil;
static NSString* s_token = nil;

@implementation PBAuthApi

+(NSString *)getApiKey
{
    return s_apiKey;
}

+(NSString *)getToken
{
    return s_token;
}

+ (void)auth:(Playbasis *)playbasis apiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret bundleId:(NSString *)bundleId andCompletion:(void (^)(PBAuth *, NSError *))completion
{
    // save api key, and api secret
    s_apiKey = apiKey;
    s_apiSecret = apiSecret;
    
    NSString *method = [[PBUtils sharedInstance] createMethodWithApiKeyUrlFromMethod:@"Auth" andApiKey:apiKey];
    NSString *data = [[PBUtils sharedInstance] createPostDataStringFromDictionary:@{@"api_key" : apiKey, @"api_secret" : apiSecret, @"pkg_name" : bundleId}];
    
    PBRequestUnit<PBAuth*> *request = [[PBRequestUnit<PBAuth*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:^(PBAuth* result, NSError *error) {
        // save token
        if (error == nil)
        {
            s_token = result.token;
        }
        
        // call normal callback block
        if (completion != nil)
            completion(result, error);
    } forResultClass:[PBAuth class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+ (void)renew:(Playbasis *)playbasis completion:(void (^)(PBAuth *, NSError *))completion
{
    // throw exception if auth api has never been called before
    if (s_apiKey == nil || s_apiSecret == nil)
        [NSException raise:@"auth() has never been called before" format:@"either apiKey or apiSecret is not set, or invalid"];
    
    NSString *method = [[PBUtils sharedInstance] createMethodWithApiKeyUrlFromMethod:@"Auth" andApiKey:s_apiKey];
    NSString *data = [[PBUtils sharedInstance] createPostDataStringFromDictionary:@{@"api_key" : s_apiKey, @"api_secret" : s_apiSecret}];
    
    PBRequestUnit<PBAuth*> *request = [[PBRequestUnit<PBAuth*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:^(PBAuth* result, NSError *error) {
        if (error == nil)
        {
            s_token = result.token;
        }
        
        // call normal callback block
        if (completion != nil)
            completion(result, error);
    } forResultClass:[PBAuth class]];
    
    [playbasis fireRequestIfNecessary:request];
}

@end
