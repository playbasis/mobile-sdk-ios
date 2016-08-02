//
//  PBQuizApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/1/16.
//
//

#import "PBQuizApi.h"
#import "Playbasis.h"
#import "../helper/PBValidator.h"
#import "PBApiMacros.h"

@implementation PBQuizApi

+(void)activeQuizList:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(NSArray<PBQuiz *> * _Nullable, NSError * _Nullable))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Quiz/list?player_id=%@", playerId, nil)
    
    PBRequestUnit<NSArray<PBQuiz *>*> *request = [[PBRequestUnit<NSArray<PBQuiz *>*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion withJsonResultSubKey:@"result" forResultClass:[PBQuiz class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)detailedQuiz:(Playbasis *)playbasis quizId:(NSString *)quizId playerId:(NSString *)playerId andCompletion:(void (^)(PBQuizDetail * _Nullable, NSError * _Nullable))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Quiz/%@/detail?player_id=%@", quizId, playerId, nil)
    
    PBRequestUnit *request = [[PBRequestUnit<PBQuizDetail*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion withJsonResultSubKey:@"result" forResultClass:[PBQuizDetail class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)randomQuiz:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(PBQuiz * _Nullable, NSError * _Nullable))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Quiz/random?player_id=%@", playerId, nil)
    
    PBRequestUnit *request = [[PBRequestUnit<PBQuiz*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion withJsonResultSubKey:@"result" forResultClass:[PBQuiz class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+ (void)question:(Playbasis *)playbasis quizId:(NSString *)quizId playerId:(NSString *)playerId andCompletion:(void (^)(PBQuestion * _Nullable, NSError * _Nullable))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Quiz/%@/question?player_id=%@", quizId, playerId, nil)
    
    PBRequestUnit *request = [[PBRequestUnit<PBQuestion*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion withJsonResultSubKey:@"result" forResultClass:[PBQuestion class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)pendingQuizList:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(NSArray<PBPendingQuiz *> * _Nullable, NSError * _Nullable))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Quiz/player/%@/pending/5", playerId, nil)
    
    PBRequestUnit *request = [[PBRequestUnit<NSArray<PBPendingQuiz*>*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion withJsonResultSubKey:@"result" forResultClass:[PBPendingQuiz class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)quizDoneList:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(NSArray<PBQuizDone *> * _Nullable, NSError * _Nullable))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Quiz/player/%@/5", playerId, nil)
    
    PBRequestUnit *request = [[PBRequestUnit<NSArray<PBQuizDone*>*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion withJsonResultSubKey:@"result" forResultClass:[PBQuizDone class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)answerQuestion:(Playbasis *)playbasis playerId:(NSString *)playerId quizId:(NSString *)quizId questionId:(NSString *)questionId optionId:(NSString *)optionId andCompletion:(void (^)(PBQuestionAnswer * _Nullable, NSError * _Nullable))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Quiz/%@/answer", quizId, nil)
    API_CREATE_DATA_VARS(playbasis.token, @"token", playerId, @"player_id", questionId, @"question_id", optionId, @"option_id", nil)
    
    PBRequestUnit *request = [[PBRequestUnit<PBQuestionAnswer*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:completion withJsonResultSubKey:@"result" forResultClass:[PBQuestionAnswer class]];
    
    [playbasis fireRequestIfNecessary:request];
}

+(void)resetQuiz:(Playbasis *)playbasis playerId:(NSString *)playerId quizId:(NSString *)quizId andCompletion:(void (^)(PBSuccessStatus * _Nullable, NSError * _Nullable))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Quiz/reset", nil)
    API_CREATE_DATA_VARS(playbasis.token, @"token", playerId, @"player_id", quizId, @"quiz_id", nil)
    
    PBRequestUnit *request = [[PBRequestUnit<PBSuccessStatus*> alloc] initWithMethodWithApikey:method withData:data isAsync:NO completion:completion forResultClass:[PBSuccessStatus class]];
    
    [playbasis fireRequestIfNecessary:request];
}

@end
