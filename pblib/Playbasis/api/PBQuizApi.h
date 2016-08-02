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
#import "PBQuestion.h"

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


/**
 Random a quiz for player

 @param playbasis  playbasis
 @param playerId   player id
 @param completion completion callback
 */
+ (void)randomQuiz:(nonnull Playbasis *)playbasis playerId:(nonnull NSString *)playerId andCompletion:(nonnull void(^)(PBQuiz* _Nullable result, NSError* _Nullable error))completion;


/**
 Get a question from specified quiz

 @param playbasis  playbasis
 @param quizId     quiz id to get question from
 @param playerId   player id
 @param completion completion callback
 */
+ (void)question:(nonnull Playbasis *)playbasis quizId:(nonnull NSString *)quizId playerId:(nonnull NSString *)playerId andCompletion:(nonnull void(^)(PBQuestion* _Nullable result, NSError* _Nullable error))completion;

@end
