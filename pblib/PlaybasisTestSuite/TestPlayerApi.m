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

- (void)testListPlayer {
    EXP_CREATE(@"listPlayer")
    
    BEGIN_AUTHWRAP
    [PBPlayerApi listPlayer:[Playbasis sharedPB] listPlayerIds:@[@"jontestuser", @"jontestuser2"] andCompletion:^(NSArray<PBPlayer *> *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        XCTAssertEqual(2, [result count]);
        EXP_FULFILL
    }];
    END_AUTHWRAP
    
    EXP_WAIT(TIMEOUT)
}

- (void)testDetailedPlayerPublic {
    EXP_CREATE(@"detailedPlayerPublic")
    
    [PBPlayerApi detailedPlayerPublic:[Playbasis sharedPB] playerId:@"jontestuser" andCompletion:^(PBDetailedPlayer *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testDetailedPlayerPrivate {
    EXP_CREATE(@"detailedPlayerPrivate")
    
    BEGIN_AUTHWRAP
    [PBPlayerApi detailedPlayerPrivate:[Playbasis sharedPB] playerId:@"jontestuser" andCompletion:^(PBPlayer *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    END_AUTHWRAP
    
    EXP_WAIT(TIMEOUT)
}

- (void)testLogin {
    EXP_CREATE(@"login")
    
    BEGIN_AUTHWRAP
    [PBPlayerApi login:[Playbasis sharedPB] playerId:@"jontestuser" andCompletion:^(PBSuccessStatus *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        XCTAssertTrue(result.success, @"success must be true");
        EXP_FULFILL
    }];
    END_AUTHWRAP
    
    EXP_WAIT(TIMEOUT)
}

- (void)testLogout {
    EXP_CREATE(@"logout")
    
    BEGIN_AUTHWRAP
    [PBPlayerApi logout:[Playbasis sharedPB] playerId:@"jontestuser" andCompletion:^(PBSuccessStatus *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        XCTAssertTrue(result.success, @"success must be true");
        EXP_FULFILL
    }];
    END_AUTHWRAP
    
    EXP_WAIT(TIMEOUT)
}

- (void)testPoints {
    EXP_CREATE(@"points")
    
    [PBPlayerApi points:[Playbasis sharedPB] playerId:@"jontestuser" andCompletion:^(NSArray<PBPoint *> *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testPoint {
    EXP_CREATE(@"point")
    
    [PBPlayerApi point:[Playbasis sharedPB] playerId:@"jontestuser" pointName:@"point" andCompletion:^(NSArray<PBPoint *> *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testLevels {
    EXP_CREATE(@"levels")
    
    [PBPlayerApi levels:[Playbasis sharedPB] andCompletion:^(NSArray<PBLevel *> *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testLevel {
    EXP_CREATE(@"level")
    
    [PBPlayerApi level:[Playbasis sharedPB] level:2 andCompletion:^(PBLevel *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testBadges {
    EXP_CREATE(@"badges")
    
    [PBPlayerApi badges:[Playbasis sharedPB] playerId:@"jontestuser" andCompletion:^(NSArray<PBBadge *> *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testBadgesEarned {
    EXP_CREATE(@"badgesEarned")
    
    [PBPlayerApi badgesEarned:[Playbasis sharedPB] playerId:@"jontestuser" andCompletion:^(NSArray<PBBadge *> *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

@end
