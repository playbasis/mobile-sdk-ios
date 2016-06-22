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

#define WAIT_TIME 10.0f

static XCTestExpectation *expectation;

void ruleCallback(void* data, int errorCode)
{
    rule *cdata = (rule*)data;
    [expectation fulfill];
}

void quizListCallback(void* data, int errorCode)
{
    // do this as structure is designed to be allocated and freed once.
    // after library passes data to manage code, then it's up to manage code to handle it
    quizList* cdata = (quizList*)data;
    [expectation fulfill];
}

void quizListOfPlayerCallback(void* data, int errorCode)
{
    // do this as structure is designed to be allocated and freed once.
    // after library passes data to manage code, then it's up to manage code to handle it
    quizList* cdata = (quizList*)data;
    [expectation fulfill];
}

void badgesCallback(void* data, int errorCode)
{
    badges* cdata = (badges*)data;
    [expectation fulfill];
}

void badgeCallback(void* data, int errorCode)
{
    badge* cdata = (badge*)data;
    [expectation fulfill];
}

@interface pblibWrapperTest : XCTestCase
{
}

@end

@implementation pblibWrapperTest

- (void)wait:(NSString*)description{
    expectation = [self expectationWithDescription:description];
    [self waitForExpectationsWithTimeout:WAIT_TIME handler:nil];
}

- (void)setUp {
    [super setUp];
    
    // authen every time first
    [[Playbasis sharedPB] authWithApiKey:@"1012718250" apiSecret:@"a52097fc5a17cb0d8631d20eacd2d9c2" bundleId:@"io.wasin.testplugin" andBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        XCTAssert(error == nil, "error must be nil");
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testQuizList {
    _quizList(quizListCallback);
    [self wait:@"quizList"];
}

- (void)testRule {
    _rule("jontestuser", "like", ruleCallback);
    [self wait:@"rule"];
}

- (void)testQuizListOfPlayer
{
    _quizListOfPlayer("jontestuser", quizListOfPlayerCallback);
    [self wait:@"quizListOfPlayer"];
}

- (void)testBadges
{
    _badges(badgesCallback);
    [self wait:@"badges"];
}

- (void)testBadge
{
    _badge("56406f8bbe120bd12c8b4584", badgeCallback);
    [self wait:@"badge"];
}

@end
