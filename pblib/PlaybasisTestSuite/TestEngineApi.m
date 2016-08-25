//
//  TestEngineApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/25/16.
//
//

#import <XCTest/XCTest.h>
#import "Macros.h"
#import "Playbasis.h"

#define TIMEOUT 6.0f
INIT_VARS_STATIC

@interface TestEngineApi : XCTestCase
{
    INIT_VARS_LOCAL
}
@end

@implementation TestEngineApi

- (void)setUp {
    [super setUp];
    
    INIT_PLAYBASIS
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRule {
    EXP_CREATE(@"rule")
    
    BEGIN_AUTHWRAP
    [PBEngineApi rule:[Playbasis sharedPB] playerId:@"jontestuser" action:@"click" andCompletion:^(PBRule * _Nullable result, NSError * _Nullable error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    END_AUTHWRAP
    
    EXP_WAIT(TIMEOUT)
}

- (void)testRuleWithCustomFields {
    EXP_CREATE(@"rule - custom fields")
    
    BEGIN_AUTHWRAP
    [PBEngineApi rule:[Playbasis sharedPB] playerId:@"jontestuser" action:@"review" customParamKeys:@[@"level", @"world"] customParamValues:@[@"1", @"1"] andCompletion:^(PBRule * _Nullable result, NSError * _Nullable error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    END_AUTHWRAP
    
    EXP_WAIT(TIMEOUT)
}

@end
