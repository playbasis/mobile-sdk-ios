//
//  PBPlayerApi.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import <Foundation/Foundation.h>
#import "PBPlayer.h"

@class Playbasis;

@interface PBPlayerApi : NSObject

+ (void)playerPublic:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void(^)(PBPlayer *result, NSError *error))completion;

@end
