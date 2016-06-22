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

void goodsInfoCallback(void* data, int errorCode)
{
    goodsInfo* cdata = (goodsInfo*)data;
    [expectation fulfill];
}

void goodsInfoListCallback(void* data, int errorCode)
{
    goodsInfoList* cdata = (goodsInfoList*)data;
    [expectation fulfill];
}

void questInfoCallback(void* data, int errorCode) {
	questInfo* cdata = (questInfo*)data;
	[expectation fulfill];
}

void questInfoListCallback(void* data, int errorCode) {
	questInfoList* cdata = (questInfoList*)data;
	[expectation fulfill];
}

void missionInfoCallback(void* data, int errorCode) {
	missionInfo* cdata = (missionInfo*)data;
	[expectation fulfill];
}

void questInfoListForPlayerCallback(void* data, int errorCode) {
	questInfoList* cdata = (questInfoList*)data;
    [expectation fulfill];
}

void questAvailableForPlayerCallback(void* data, int errorCode) {
	questAvailableForPlayer* cdata = (questAvailableForPlayer*)data;
	[expectation fulfill];
}

void joinQuestCallback(void* data, int errorCode) {
    joinQuest* cdata = (joinQuest*)data;
    [expectation fulfill];
}

void cancelQuestCallback(void* data, int errorCode) {
	cancelQuest* cdata = (cancelQuest*)data;
	[expectation fulfill];
}

void joinAllQuestsCallback(bool success) {
	[expectation fulfill];
}

@interface pblibWrapperTest : XCTestCase

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
    _rule("jontestuser", "visit", ruleCallback);
    [self wait:@"rule"];
}

- (void)testRuleWithUrl {
	_ruleWithUrl("jontestuser", "visit", "quest1_mission2", ruleCallback);
	[self wait:@"ruleWithUrl"];
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

- (void)testGoodsInfo
{
    _goodsInfo("5757b73ebe120b7c178b4ea6", goodsInfoCallback);
    [self wait:@"goodsInfo"];
}

- (void)testGoodsInfoList
{
    _goodsInfoList("jontestuser", goodsInfoListCallback);
    [self wait:@"goodsInfoList"];
}

- (void)testQuestInfo {
	_questInfo("576a6e6abe120bf63d8b5bcf", questInfoCallback);
	[self wait:@"questInfo"];
}

- (void)testQuestInfoList {
	_questInfoList(questInfoListCallback);
	[self wait:@"questInfoList"];
}

- (void)testMissionInfo {
	_missionInfo("576a6e6abe120bf63d8b5bcf", "576a6e69be120bf63d8b5bcd", missionInfoCallback);
	[self wait:@"missionInfo"];
}

- (void)testQuestInfoListForPlayer {
	_questInfoListForPlayer("jontestuser", questInfoListForPlayerCallback);
	[self wait:@"questInfoListForPlayer"];
}

- (void)testQuestAvailableForPlayer {
	_questAvailableForPlayer("576a6e6abe120bf63d8b5bcf", "jontestuser", questAvailableForPlayerCallback);
	[self wait:@"questAvailableForPlayer"];
}

- (void)testJoinQuest {
	_joinQuest("576a6e6abe120bf63d8b5bcf", "jontestuser", joinQuestCallback);
	[self wait:@"joinQuest"];
}

- (void)testJoinAllQuests {
	_joinAllQuests("jontestuser", joinAllQuestsCallback);
	[self wait:@"joinAllQuests"];
}

- (void)testCancelQuest {
	_cancelQuest("576a6e6abe120bf63d8b5bcf", "jontestuser", cancelQuestCallback);
	[self wait:@"cancelQuest"];
}

@end
