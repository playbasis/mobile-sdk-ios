//
//  PBCommunicationApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/19/16.
//
//

#import "PBCommunicationApi.h"
#import "Playbasis.h"
#import "../helper/PBValidator.h"
#import "PBApiMacros.h"

@implementation PBCommunicationApi

+(void)deviceRegistration:(Playbasis *)playbasis playerId:(NSString *)playerId deviceToken:(NSString *)deviceToken deviceDescription:(NSString *)deviceDesc deviceName:(NSString *)deviceName osType:(NSString *)osType andCompletion:(void (^)(PBSuccessStatus *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Push/deviceRegistration", nil)
    API_CREATE_DATA_VARS(playbasis.token, @"token", playerId, @"player_id", deviceToken, @"device_token", deviceDesc, @"device_description", deviceName, @"device_name", osType, @"os_type", nil)
    
    PBRequestUnit *request = [[PBRequestUnit<PBSuccessStatus*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:completion forResultClass:[PBSuccessStatus class]];
    
    [playbasis fireRequestIfNecessary:request];
}

@end
