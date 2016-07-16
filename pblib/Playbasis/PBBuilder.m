//
//  PBBuilder.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import "PBBuilder.h"
#import "Playbasis.h"
#import "PBBuilderConfiguration.h"

@interface PBBuilder ()
{
    PBBuilderConfiguration *configs;
}
@end

@implementation PBBuilder

-(instancetype)init
{
    self = [super init];
    
    configs = [[PBBuilderConfiguration alloc] init];
    configs.baseUrl = BASE_URL;
    configs.baseAsyncUrl = BASE_ASYNC_URL;
    
    return self;
}

-(PBBuilder *)setBaseUrl:(NSString *)url
{
    configs.baseUrl = url;
    return self;
}

-(PBBuilder *)setBaseAsyncUrl:(NSString *)url
{
    configs.baseAsyncUrl = url;
    return self;
}

-(PBBuilder *)setApiKey:(NSString *)apiKey
{
    configs.apiKey = apiKey;
    return self;
}

-(PBBuilder *)setApiSecret:(NSString *)apiSecret
{
    configs.apiSecret = apiSecret;
    return self;
}

-(Playbasis *)build
{
    return [[Playbasis alloc] initWithConfiguration:configs];
}

@end
