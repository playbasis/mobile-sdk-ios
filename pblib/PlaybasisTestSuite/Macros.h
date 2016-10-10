//
//  Macros.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#ifndef Macros_h
#define Macros_h

/**
 Initialization before test cases begin.
 */
#define INIT_VARS_STATIC static Playbasis* playbasis = nil; \
    static BOOL initializedPlaybasis;
#define INIT_VARS_LOCAL XCTestExpectation *ex;
#define INIT_PLAYBASIS  if (!initializedPlaybasis) \
{ \
playbasis = [[[[Playbasis builder] \
setApiKey:@"269122575"] \
setApiSecret:@"c57495174674157dd19317dd79e3c36e"] \
build]; \
initializedPlaybasis = YES; \
XCTAssert(playbasis != nil, @"playbasis instance cannot be nil"); \
}

#define INIT_PLAYBASIS_GAME  if (!initializedPlaybasis) \
{ \
playbasis = [[[[Playbasis builder] \
setApiKey:@"175638284"] \
setApiSecret:@"f0ba4d419fa87f1b9b8a7566d1567e17"] \
build]; \
initializedPlaybasis = YES; \
XCTAssert(playbasis != nil, @"playbasis instance cannot be nil"); \
}

/**
 Expectation handling.
 */
#define EXP_CREATE(msg) ex = [self expectationWithDescription:msg];
#define EXP_FULFILL [ex fulfill];
#define EXP_WAIT(time) [self waitForExpectationsWithTimeout:time handler:nil];

/**
 Use these 2 preprocessors when need to use Api call that requires access token.
 */
#define BEGIN_AUTHWRAP [PBAuthApi auth:playbasis bundleId:@"com.playbasis.ios.playbasissdk" andCompletion:^(PBAuth *result, NSError *error) { \
    XCTAssert(error == nil, @"error must be nil"); \
    if (error == nil) { \

#define END_AUTHWRAP } \
    }];

#endif /* Macros_h */
