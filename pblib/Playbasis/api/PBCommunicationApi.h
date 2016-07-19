//
//  PBCommunicationApi.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/19/16.
//
//

#import <Foundation/Foundation.h>
#import "PBSuccessStatus.h"

@class Playbasis;

@interface PBCommunicationApi : NSObject

/**
 Register device

 @param playbasis   instance of Playbasis
 @param playerId    player id
 @param deviceToken device token
 @param deviceDesc  device description
 @param deviceName  device name
 @param osType      os type
 @param completion  completion handler
 */
+ (void)deviceRegistration:(Playbasis *)playbasis playerId:(NSString *)playerId deviceToken:(NSString *)deviceToken deviceDescription:(NSString *)deviceDesc deviceName:(NSString *)deviceName osType:(NSString *)osType andCompletion:(void(^)(PBSuccessStatus *result, NSError *error))completion;

@end
