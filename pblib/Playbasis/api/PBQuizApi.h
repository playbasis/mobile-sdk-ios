//
//  PBQuizApi.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/1/16.
//
//

#import <Foundation/Foundation.h>
#import "PBQuiz.h"

@class Playbasis;

@interface PBQuizApi : NSObject


/**
 Return list of active quiz.

 @param playbasis  playbasis
 @param playerId   player id
 @param completion completion callback
 */
+ (void)activeQuizList:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void(^)(NSArray<PBQuiz*> *result, NSError *error))completion;

@end
