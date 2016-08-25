//
//  PBEngineApi.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/25/16.
//
//

#import <Foundation/Foundation.h>
#import "PBRule.h"

@class Playbasis;

@interface PBEngineApi : NSObject

/**
 Execute rule engine

 @param playbasis  playbasis instance
 @param playerId   player id
 @param action     action
 @param completion completion handler
 */
+ (void)rule:(nonnull Playbasis *)playbasis playerId:(nonnull NSString *)playerId action:(nonnull NSString *)action andCompletion:(nullable void(^)(PBRule* _Nullable result, NSError* _Nullable error))completion;

/**
 Execute rule engine with custom params key-value pairs

 @param playbasis         playbasis instance
 @param playerId          player id
 @param action            action
 @param customParamKeys   custom param keys array
 @param customParamValues custom param values array
 @param completion        completion handler
 */
+ (void)rule:(nonnull Playbasis *)playbasis playerId:(nonnull NSString *)playerId action:(nonnull NSString *)action customParamKeys:(nonnull NSArray<NSString*>*)customParamKeys customParamValues:(nonnull NSArray<NSString*>*)customParamValues andCompletion:(nullable void(^)(PBRule* _Nullable result, NSError* _Nullable error))completion;

@end
