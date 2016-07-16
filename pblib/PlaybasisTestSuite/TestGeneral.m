//
//  TestGeneral.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import <XCTest/XCTest.h>
#import "Playbasis.h"

static Playbasis* playbasis = nil;
static BOOL initializedPlaybasis = NO;

@interface TestGeneral : XCTestCase

@end

@implementation TestGeneral

- (void)setUp {
    [super setUp];
    
    if (!initializedPlaybasis)
    {
        playbasis = [[[[Playbasis builder]
                        setApiKey:@"269122575"]
                        setApiSecret:@"c57495174674157dd19317dd79e3c36e"]
                        build];
        initializedPlaybasis = YES;
        XCTAssert(playbasis != nil, @"playbasis instance cannot be nil");
    }
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreatePlaybasisObject {
    // test case already in setUp() method
    // if setUp() is passed, then this test case is passed too
}

@end
