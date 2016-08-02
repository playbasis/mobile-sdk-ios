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
#import "PBPendingQuiz.h"
#import "PBQuizDone.h"
#import "PBQuestionAnswer.h"
#import "PBSuccessStatus.h"

@class Playbasis;

@interface PBQuizApi : NSObject


/**
 Return list of active quiz.

 @param playbasis  playbasis
 @param playerId   player id
 @param completion completion callback
 */
+ (void)activeQuizList:(nonnull Playbasis *)playbasis playerId:(nonnull NSString *)playerId andCompletion:(nullable void(^)(NSArray<PBQuiz*>* _Nullable result, NSError * _Nullable error))completion;


/**
 Return detail of quiz

 @param playbasis  playbasis
 @param quizId     quiz id to get detail information
 @param playerId   player id
 @param completion completion callback
 */
+ (void)detailedQuiz:(nonnull Playbasis *)playbasis quizId:(nonnull NSString *)quizId playerId:(nonnull NSString *)playerId andCompletion:(nullable void(^)(PBQuizDetail* _Nullable result, NSError* _Nullable error))completion;


/**
 Random a quiz for player

 @param playbasis  playbasis
 @param playerId   player id
 @param completion completion callback
 */
+ (void)randomQuiz:(nonnull Playbasis *)playbasis playerId:(nonnull NSString *)playerId andCompletion:(nullable void(^)(PBQuiz* _Nullable result, NSError* _Nullable error))completion;


/**
 Get a question from specified quiz

 @param playbasis  playbasis
 @param quizId     quiz id to get question from
 @param playerId   player id
 @param completion completion callback
 */
+ (void)question:(nonnull Playbasis *)playbasis quizId:(nonnull NSString *)quizId playerId:(nonnull NSString *)playerId andCompletion:(nullable void(^)(PBQuestion* _Nullable result, NSError* _Nullable error))completion;


/**
 Get pending quiz list

 @param playbasis  playbasis
 @param playerId   player id
 @param completion completion callback
 */
+ (void)pendingQuizList:(nonnull Playbasis *)playbasis playerId:(nonnull NSString *)playerId andCompletion:(nullable void(^)(NSArray<PBPendingQuiz*>* _Nullable result, NSError * _Nullable error))completion;


/**
 Get a list of quiz done

 @param playbasis  playbasis
 @param playerId   player id
 @param completion completion callback
 */
+ (void)quizDoneList:(nonnull Playbasis *)playbasis playerId:(nonnull NSString *)playerId andCompletion:(nullable void(^)(NSArray<PBQuizDone*>* _Nullable result, NSError* _Nullable error))completion;


/**
 Answer a question

 @param playbasis  playbasis
 @param playerId   player id
 @param quizId     quiz id
 @param questionId question id
 @param optionId   option id
 @param completion completion callback
 */
+ (void)answerQuestion:(nonnull Playbasis *)playbasis playerId:(nonnull NSString *)playerId quizId:(nonnull NSString *)quizId questionId:(nonnull NSString *)questionId optionId:(nonnull NSString *)optionId andCompletion:(nullable void(^)(PBQuestionAnswer* _Nullable result, NSError* _Nullable error))completion;


/**
 Reset a particular quiz

 @param playbasis  playbasis
 @param playerId   player id
 @param quizId     quiz id to reset its progress
 @param completion completion callback
 */
+ (void)resetQuiz:(nonnull Playbasis *)playbasis playerId:(nonnull NSString *)playerId quizId:(nonnull NSString *)quizId andCompletion:(nullable void(^)(PBSuccessStatus* _Nullable result, NSError* _Nullable error))completion;

@end
