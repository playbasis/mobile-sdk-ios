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

@end
