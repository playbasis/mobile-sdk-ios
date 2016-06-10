//
//  pblibWrapperTest.mm
//  pblibWrapperTest
//
//  Created by Wasin Thonkaew on 6/10/16.
//
//

#import <XCTest/XCTest.h>
#import "Playbasis.h"
#import "PlaybasisWrapper.h"

@interface pblibWrapperTest : XCTestCase
{
    XCTestExpectation *expectation;
}

@end

@implementation pblibWrapperTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
