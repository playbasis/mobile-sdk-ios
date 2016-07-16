//
//  Macros.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#ifndef Macros_h
#define Macros_h

#define INIT_VARS_STATIC static Playbasis* playbasis = nil; \
    BOOL initializedPlaybasis;
#define INIT_VARS_LOCAL XCTestExpectation *ex;

#define EXP_CREATE(msg) ex = [self expectationWithDescription:msg];
#define EXP_FULFILL [ex fulfill];
#define EXP_WAIT(time) [self waitForExpectationsWithTimeout:time handler:nil];

#define INIT_PLAYBASIS  if (!initializedPlaybasis) \
{ \
    playbasis = [[[[Playbasis builder] \
                   setApiKey:@"269122575"] \
                  setApiSecret:@"c57495174674157dd19317dd79e3c36e"] \
                 build]; \
    initializedPlaybasis = YES; \
    XCTAssert(playbasis != nil, @"playbasis instance cannot be nil"); \
}

#endif /* Macros_h */
