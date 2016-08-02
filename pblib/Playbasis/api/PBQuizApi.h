//
//  PBQuizApi.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/1/16.
//
//

#import <Foundation/Foundation.h>
#import "PBQuiz.h"
#import "PBQuizDetail.h"

@class Playbasis;

@interface PBQuizApi : NSObject


/**
 Return list of active quiz.

 @param playbasis  playbasis
 @param playerId   player id
 @param completion completion callback
 */
+ (void)activeQuizList:(nonnull Playbasis *)playbasis playerId:(nonnull NSString *)playerId andCompletion:(nonnull void(^)(NSArray<PBQuiz*>* _Nullable result, NSError * _Nullable error))completion;


/**
 Return detail of quiz

 @param playbasis  playbasis
 @param quizId     quiz id to get detail information
 @param playerId   player id
 @param completion completion callback
 */
+ (void)detailedQuiz:(nonnull Playbasis *)playbasis quizId:(nonnull NSString *)quizId playerId:(nonnull NSString *)playerId andCompletion:(nonnull void(^)(PBQuizDetail* _Nullable result, NSError* _Nullable error))completion;

@end
