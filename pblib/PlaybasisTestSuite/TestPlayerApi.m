//
//  TestPlayerApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/17/16.
//
//

#import <XCTest/XCTest.h>
#import "Macros.h"
#import "Playbasis.h"

#define TIMEOUT 6.0f
INIT_VARS_STATIC

@interface TestPlayerApi : XCTestCase
{
    INIT_VARS_LOCAL
}

@end

@implementation TestPlayerApi

- (void)setUp {
    [super setUp];
    
    INIT_PLAYBASIS
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPlayerPublic {
    EXP_CREATE(@"playerPublic")
    
    [PBPlayerApi playerPublic:[Playbasis sharedPB] playerId:@"jontestuser" andCompletion:^(PBPlayer *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testPlayer {
    EXP_CREATE(@"player")
    
    BEGIN_AUTHWRAP
    [PBPlayerApi player:[Playbasis sharedPB] playerId:@"jontestuser" andCompletion:^(PBPlayer *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    END_AUTHWRAP
    
    EXP_WAIT(TIMEOUT)
}

@end
