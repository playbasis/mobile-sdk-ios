//
//  TestQuizApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/1/16.
//
//

#import <XCTest/XCTest.h>
#import "Macros.h"
#import "Playbasis.h"

#define TIMEOUT 6.0f
INIT_VARS_STATIC

@interface TestQuizApi : XCTestCase
{
    INIT_VARS_LOCAL
}

@end

@implementation TestQuizApi

- (void)setUp {
    [super setUp];
    
    INIT_PLAYBASIS
}

- (void)tearDown {
    [super tearDown];
}

- (void)testActiveQuizList {
    EXP_CREATE(@"activeQuizList")
    
    [PBQuizApi activeQuizList:[Playbasis sharedPB] playerId:@"jontestuser" andCompletion:^(NSArray<PBQuiz *> * _Nullable result, NSError * _Nullable error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testDetailedQuiz {
    EXP_CREATE(@"detailedQuiz")
    
    [PBQuizApi detailedQuiz:[Playbasis sharedPB] quizId:@"5796b47772d3e1a5108b5ec9" playerId:@"jontestuser" andCompletion:^(PBQuizDetail * _Nullable result, NSError * _Nullable error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testQuiz {
    EXP_CREATE(@"quiz")
    
    [PBQuizApi randomQuiz:[Playbasis sharedPB] playerId:@"jontestuser" andCompletion:^(PBQuiz * _Nullable result, NSError * _Nullable error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testQuestion {
    EXP_CREATE(@"question")
    
    [PBQuizApi question:[Playbasis sharedPB] quizId:@"5796b47772d3e1a5108b5ec9" playerId:@"jontestuser" andCompletion:^(PBQuestion * _Nullable result, NSError * _Nullable error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testPendingQuizList {
    EXP_CREATE(@"pendingQuizList")
    
    [PBQuizApi pendingQuizList:[Playbasis sharedPB] playerId:@"jontestuser" andCompletion:^(NSArray<PBPendingQuiz *> * _Nullable result, NSError * _Nullable error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
    
}

- (void)testQuizDoneList {
    EXP_CREATE(@"quizDoneList")
    
    [PBQuizApi quizDoneList:[Playbasis sharedPB] playerId:@"jontestuser" andCompletion:^(NSArray<PBQuizDone *> * _Nullable result, NSError * _Nullable error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testAnswerQuestion {
    EXP_CREATE(@"answerQuestion")
    
    BEGIN_AUTHWRAP
    [PBQuizApi answerQuestion:[Playbasis sharedPB] playerId:@"jontestuser" quizId:@"5796b32272d3e1a5108b5def" questionId:@"861037cc8fc4616b6baf1782" optionId:@"86488952584b01e3add8de57" andCompletion:^(PBQuestionAnswer * _Nullable result, NSError * _Nullable error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    END_AUTHWRAP
   
    
    EXP_WAIT(TIMEOUT)
}

- (void)testResetQuiz {
    EXP_CREATE(@"answerQuestion")
    
    BEGIN_AUTHWRAP
    [PBQuizApi resetQuiz:[Playbasis sharedPB] playerId:@"jontestuser" quizId:@"5796b32272d3e1a5108b5def" andCompletion:^(PBSuccessStatus * _Nullable result, NSError * _Nullable error) {
        XCTAssert(result.success == YES, @"success must be set to true");
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    END_AUTHWRAP
    
    EXP_WAIT(TIMEOUT)
}

@end
