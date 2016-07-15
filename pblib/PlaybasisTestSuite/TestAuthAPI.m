//
//  TestAuthAPI.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/15/16.
//
//

/// Important note:
///
/// Due to the problem with Cocoapod, after building the project, you have to copy all pod's frameworks to be in the same level of .xctest. Right click and open finder in .xctest file in Products group.
///
#import <XCTest/XCTest.h>
#import "Playbasis.h"

#define TIMEOUT 6.0f

@interface TestAuthAPI : XCTestCase
{
    XCTestExpectation *ex;
}

@end

@implementation TestAuthAPI

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAuth {
    ex = [self expectationWithDescription:@"auth"];
    
    [[Playbasis sharedPB] authWithApiKey:@"269122575" apiSecret:@"c57495174674157dd19317dd79e3c36e" bundleId:@"io.wasin.playbasisapitest" andCompletion:^(PBAuth *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        [ex fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:nil];
}

- (void)testRenew {
    ex = [self expectationWithDescription:@"renew"];
    
    [[Playbasis sharedPB] renewWithApikey:@"269122575" apiSecret:@"c57495174674157dd19317dd79e3c36e" andCompletion:^(PBAuth *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        [ex fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TIMEOUT handler:nil];
}

@end
