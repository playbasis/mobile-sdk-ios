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

@interface pblibWrapperTest : XCTestCase
{
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

- (void)testQuizList {
    expectation = [self expectationWithDescription:@"rule test"];
    
    [[Playbasis sharedPB] authWithApiKey:@"1012718250" apiSecret:@"a52097fc5a17cb0d8631d20eacd2d9c2" bundleId:@"io.wasin.testplugin" andBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        if (error == nil)
        {
            _quizList(quizListCallback);
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
    
    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

- (void)testRule {
    expectation = [self expectationWithDescription:@"rule test"];
    
    [[Playbasis sharedPB] authWithApiKey:@"1012718250" apiSecret:@"a52097fc5a17cb0d8631d20eacd2d9c2" bundleId:@"io.wasin.testplugin" andBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        if (error == nil)
        {
            _rule("jontestuser", "like", ruleCallback);
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
    
    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

- (void)testQuizListOfPlayer
{
    expectation = [self expectationWithDescription:@"rule test"];
    
    [[Playbasis sharedPB] authWithApiKey:@"1012718250" apiSecret:@"a52097fc5a17cb0d8631d20eacd2d9c2" bundleId:@"io.wasin.testplugin" andBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        if (error == nil)
        {
            _quizListOfPlayer("jontestuser", quizListOfPlayerCallback);
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
    
    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

@end
