//
//  TestCommunicationApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/19/16.
//
//

#import <XCTest/XCTest.h>
#import "Macros.h"
#import "Playbasis.h"

#define TIMEOUT 6.0f
INIT_VARS_STATIC

@interface TestCommunicationApi : XCTestCase
{
    INIT_VARS_LOCAL
}
@end

@implementation TestCommunicationApi

- (void)setUp {
    [super setUp];
    INIT_PLAYBASIS
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDeviceRegistration {
    EXP_CREATE(@"deviceRegistration");
    
    BEGIN_AUTHWRAP
    [PBCommunicationApi deviceRegistration:[Playbasis sharedPB] playerId:@"jontestuser" deviceToken:@"9d5142771a5372715e1157e4404d977e86c5f6ee15923779cc477ad7aefba841" deviceDescription:@"ios device" deviceName:@"iPhone6S" osType:@"IOS" andCompletion:^(PBSuccessStatus *result, NSError *error) {
        XCTAssertNil(error, @"error must be nil");
        EXP_FULFILL
    }];
    END_AUTHWRAP
    
    EXP_WAIT(TIMEOUT)
}

@end
