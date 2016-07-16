//
//  TestAuthApi.m
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
#import "Macros.h"
#import "Playbasis.h"

#define TIMEOUT 6.0f

INIT_VARS_STATIC

@interface TestAuthApi : XCTestCase
{
    INIT_VARS_LOCAL
}

@end

@implementation TestAuthApi

- (void)setUp {
    [super setUp];
    
    INIT_PLAYBASIS
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAuth {
    EXP_CREATE(@"auth")
    
    [PBAuthApi auth:[Playbasis sharedPB] bundleId:@"io.wasin.playbasisapitest" andCompletion:^(PBAuth *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        EXP_FULFILL
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testRenew {
    EXP_CREATE(@"renew")
    
    [PBAuthApi auth:[Playbasis sharedPB] bundleId:@"io.wasin.playbasisapitest" andCompletion:^(PBAuth *result, NSError *error) {
        XCTAssert(error == nil, @"error must be nil");
        
        [PBAuthApi renew:[  Playbasis sharedPB] completion:^(PBAuth *result, NSError *error) {
            XCTAssert(error == nil, @"error must be nil");
            EXP_FULFILL
        }];
    }];
    
    EXP_WAIT(TIMEOUT)
}

@end
