//
//  TestGameApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 10/10/16.
//
//

#import <XCTest/XCTest.h>
#import "Macros.h"
#import "Playbasis.h"

#define TIMEOUT 6.0f
INIT_VARS_STATIC

@interface TestGameApi : XCTestCase
{
    INIT_VARS_LOCAL
}

@end

@implementation TestGameApi

- (void)setUp {
    [super setUp];
    
    INIT_PLAYBASIS_GAME
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRetrieveGameItemStatus {
    EXP_CREATE(@"retrieveGameItemStatus")
    
    [PBGameApi retrieveGameItemStatus:[Playbasis sharedPB] gameName:@"farm" playerId:@"mario" andCompletion:^(PBGameItemStatusRoot *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testRetrieveGameItemStatusSpecificItemId {
    EXP_CREATE(@"retrieveGameItemStatusSpecificItemId")
    
    [PBGameApi retrieveGameItemStatus:[Playbasis sharedPB] gameName:@"farm" playerId:@"mario" itemId:@"5799cd2ee6ab1bf57c8b456b" andCompletion:^(PBItemStatus *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

@end
