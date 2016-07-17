//
//  PBAuthApi.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import <Foundation/Foundation.h>
#import "PBAuth.h"

@class Playbasis;

@interface PBAuthApi : NSObject

+ (void)auth:(Playbasis *)playbasis bundleId:(NSString *)bundleId andCompletion:(void(^)(PBAuth* result, NSError* error))completion;

+ (void)renew:(Playbasis *)playbasis completion:(void(^)(PBAuth* result, NSError* error))completion;

@end
