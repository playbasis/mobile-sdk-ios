//
//  pblibTest.m
//  pblibTest
//
//  Created by Wasin Thonkaew on 2/24/16.
//
//

#import <XCTest/XCTest.h>
#import "Playbasis.h"

#define ADD_PLAYER_ID "haxpor1"
#define ADD_PLAYER_EMAIL "haxpor1@gmail.com"
#define ASYNC_CALL_WAIT_DURATION 6.0

typedef NS_ENUM(NSInteger, RequestTagId) {
    Normal,
    RegisterPlayerId,
    DeletePlayerId
};

@interface pblibTest : XCTestCase <PBAuth_ResponseHandler, PBPlayerPublic_ResponseHandler, PBPlayer_ResponseHandler, PBPlayerList_ResponseHandler, PBPlayerDetailedPublic_ResponseHandler, PBPlayerDetailed_ResponseHandler, PBPlayerCustomFields_ResponseHandler, PBResultStatus_ResponseHandler, PBResultStatus_ResponseHandler, PBPoints_ResponseHandler, PBPoint_ResponseHandler, PBPointHistory_ResponseHandler, PBActionTime_ResponseHandler, PBLastAction_ResponseHandler, PBActionLastPerformedTime_ResponseHandler, PBActionCount_ResponseHandler, PBPlayerBadges_ResponseHandler>
{
    RequestTagId tagId;
    XCTestExpectation *expectation;
}

@end

@implementation pblibTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSLog(@"tear up");
    
    // set tag to Normal
    tagId = Normal;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    NSLog(@"tear down");
    
    // clear tag to be Normal
    tagId = Normal;
    expectation = nil;
}

#pragma mark Delegate
- (void)processResponseWithAuth:(PBAuth_Response *)auth withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithPlayerPublic:(PBPlayerPublic_Response *)playerResponse withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithPlayer:(PBPlayer_Response *)playerResponse withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithPlayerList:(PBPlayerList_Response *)playerList withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithPlayerDetailedPublic:(PBPlayerDetailedPublic_Response *)playerDetailedPublic withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithPlayerDetailed:(PBPlayerDetailed_Response *)playerDetailed withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithPlayerCustomFields:(PBPlayerCustomFields_Response *)playerCustomFields withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithResultStatus:(PBResultStatus_Response *)result withURL:(NSURL *)url error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Response result with error %@", [error localizedDescription]);
    }
    
    XCTAssertEqual(error, nil, @"error must be nil");
    XCTAssertEqual(result.success, YES, @"result must be success");
    
    // if it's register user request then delete that user to allow other type of call of register user requests to be tested
    if (tagId == RegisterPlayerId)
    {
        [self subtestDeleteUser_delegateAsync];
    }
    else if (tagId == DeletePlayerId)
    {
        [expectation fulfill];
        
        // clear expectation
        expectation = nil;
    }
    else
    {
        [expectation fulfill];
    }
}

- (void)processResponseWithPoints:(PBPoints_Response *)points withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithPoint:(PBPoint_Response *)points withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithPointHistory:(PBPointHistory_Response *)pointHistory withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithActionTime:(PBActionTime_Response *)actionTime withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithLastAction:(PBLastAction_Response *)lastAction withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithActionLastPerformedTime:(PBActionLastPerformedTime_Response *)response withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithActionCount:(PBActionCount_Response *)actionCount withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

- (void)processResponseWithPlayerBadges:(PBPlayerBadges_Response *)badges withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    
    [expectation fulfill];
}

#pragma mark Authentication with protected resources
- (void)testAuthenticationViaProtectedResources_delegate
{
    // set key to decrypt protected resource
    [Playbasis setProtectedResourcesKey:@"playbasis_2016*"];
    
    NSBundle *bundle = [NSBundle bundleWithURL: [[NSBundle bundleForClass:[self class]] URLForResource:@"pblibResource" withExtension:@"bundle"]];
    NSLog(@"path : %@", [bundle resourcePath]);
    
    [[Playbasis sharedPB] authWithDelegate:self bundle:bundle];
}

- (void)testAuthenticationViaProtectedResources_block
{
    // set key to decrypt protected resource
    [Playbasis setProtectedResourcesKey:@"playbasis_2016*"];
    
    NSBundle *bundle = [NSBundle bundleWithURL: [[NSBundle bundleForClass:[self class]] URLForResource:@"pblibResource" withExtension:@"bundle"]];
    NSLog(@"path : %@", [bundle resourcePath]);
    
    [[Playbasis sharedPB] authWithBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    } bundle:bundle];
}

- (void)testAuthenticationViaProtectedResources_delegateAsync
{
    // set key to decrypt protected resource
    [Playbasis setProtectedResourcesKey:@"playbasis_2016*"];
    
    expectation = [self expectationWithDescription:@"authenticate - delegateAsync"];
    
    NSBundle *bundle = [NSBundle bundleWithURL: [[NSBundle bundleForClass:[self class]] URLForResource:@"pblibResource" withExtension:@"bundle"]];
    NSLog(@"path : %@", [bundle resourcePath]);
    
    [[Playbasis sharedPB] authWithDelegateAsync:self bundle:bundle];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testAuthenticationViaProtectedResources_blockAsync
{
    // set key to decrypt protected resource
    [Playbasis setProtectedResourcesKey:@"playbasis_2016*"];
    
    expectation = [self expectationWithDescription:@"authenticate - blockAsync"];
    
    NSBundle *bundle = [NSBundle bundleWithURL: [[NSBundle bundleForClass:[self class]] URLForResource:@"pblibResource" withExtension:@"bundle"]];
    NSLog(@"path : %@", [bundle resourcePath]);
    
    [[Playbasis sharedPB] authWithBlockAsync:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    } bundle:bundle];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Authentication with direct setting keys
- (void)testAuthenticationViaDirectSettingKeys_delegate
{
    NSString *bundleIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
    
    [[Playbasis sharedPB] authWithApiKey:@"1012718250"  apiSecret:@"a52097fc5a17cb0d8631d20eacd2d9c2" bundleId:bundleIdentifier andDelegate:self];
}

- (void)testAuthenticationViaDirectSettingKeys_delegateAsync
{
    NSString *bundleIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
    
    expectation = [self expectationWithDescription:@"authenticateViaDirectSettingKeys - delegate"];
    
    [[Playbasis sharedPB] authWithApiKeyAsync:@"1012718250"  apiSecret:@"a52097fc5a17cb0d8631d20eacd2d9c2" bundleId:bundleIdentifier andDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testAuthenticationViaDirectSettingKeys_block
{
    NSString *bundleIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
    
    [[Playbasis sharedPB] authWithApiKey:@"1012718250" apiSecret:@"a52097fc5a17cb0d8631d20eacd2d9c2" bundleId:bundleIdentifier andBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testAuthenticationViaDirectSettingKeys_blockAsync
{
    NSString *bundleIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
    
    expectation = [self expectationWithDescription:@"authenticateViaDirectSettingKeys - blockAsync"];
    
    [[Playbasis sharedPB] authWithApiKeyAsync:@"1012718250" apiSecret:@"a52097fc5a17cb0d8631d20eacd2d9c2" bundleId:bundleIdentifier andBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Renew
- (void)testRenew_delegate
{
    // before testing renew, we need to authen first
    [self testAuthenticationViaProtectedResources_delegate];
    
    NSBundle *bundle = [NSBundle bundleWithURL: [[NSBundle bundleForClass:[self class]] URLForResource:@"pblibResource" withExtension:@"bundle"]];
    
    [[Playbasis sharedPB] renewWithDelegate:self bundle:bundle];
}

- (void)testRenew_block
{
    // before testing renew, we need to authen first
    [self testAuthenticationViaProtectedResources_block];
    
    NSBundle *bundle = [NSBundle bundleWithURL: [[NSBundle bundleForClass:[self class]] URLForResource:@"pblibResource" withExtension:@"bundle"]];
    
    [[Playbasis sharedPB] renewWithBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    } bundle:bundle];
}

- (void)testRenew_delegateAsync
{
    // before testing renew, we need to authen first
    [self testAuthenticationViaProtectedResources_delegate];
    
    expectation = [self expectationWithDescription:@"renew - delegate"];
    
    NSBundle *bundle = [NSBundle bundleWithURL: [[NSBundle bundleForClass:[self class]] URLForResource:@"pblibResource" withExtension:@"bundle"]];
    
    [[Playbasis sharedPB] renewWithDelegateAsync:self bundle:bundle];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testRenew_blockAsync
{
    // before testing renew, we need to authen first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"renew - blockAsync"];
    
    NSBundle *bundle = [NSBundle bundleWithURL: [[NSBundle bundleForClass:[self class]] URLForResource:@"pblibResource" withExtension:@"bundle"]];
    
    [[Playbasis sharedPB] renewWithBlockAsync:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    } bundle:bundle];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Player Public
- (void)testGetPlayerPublicInfo_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerPublic:@"haxpor" withDelegate:self];
}

- (void)testGetPlayerPublicInfo_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerPublic:@"haxpor" withBlock:^(PBPlayerPublic_Response *playerResponse, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testGetPlayerPublicInfo_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"getPlayerPublicInfo - delegateAsync"];
    
    [[Playbasis sharedPB] playerPublicAsync:@"haxpor" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testGetPlayerPublicInfo_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"getPlayerPublicInfo - blockAsync"];
    
    [[Playbasis sharedPB] playerPublicAsync:@"haxpor" withBlock:^(PBPlayerPublic_Response *playerResponse, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Player (private and public)
- (void)testGetPlayerInfo_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] player:@"haxpor" withDelegate:self];
}

- (void)testGetPlayerInfo_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] player:@"haxpor" withBlock:^(PBPlayer_Response *player, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testGetPlayerInfo_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"getPlayerInfo - delegateAsync"];
    
    [[Playbasis sharedPB] playerAsync:@"haxpor" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testGetPlayerInfo_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"getPlayerInfo - blockAsync"];
    
    [[Playbasis sharedPB] playerAsync:@"haxpor" withBlock:^(PBPlayer_Response *player, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Player List
- (void)testPlayerList_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerList:@"haxpor" withDelegate:self];
}

- (void)testPlayerList_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerList:@"haxpor" withBlock:^(PBPlayerList_Response *playerList, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testPlayerList_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"playerList - delegateAsybc"];
    
    [[Playbasis sharedPB] playerListAsync:@"haxpor" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testPlayerList_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"playerList - blockAsync"];
    
    [[Playbasis sharedPB] playerListAsync:@"haxpor" withBlock:^(PBPlayerList_Response *playerList, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Player Detail Public
- (void)testPlayerDetailPublic_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerDetailPublic:@"haxpor" withDelegate:self];
}

- (void)testPlayerDetailPublic_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerDetailPublic:@"haxpor" withBlock:^(PBPlayerDetailedPublic_Response *playerDetailedPublic, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testPlayerDetailPublic_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"playerDetailPublic - delegateAsync"];
    
    [[Playbasis sharedPB] playerDetailPublicAsync:@"haxpor" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testPlayerDetailPublic_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"playerDetailPublic - blockAsync"];
    
    [[Playbasis sharedPB] playerDetailPublicAsync:@"haxpor" withBlock:^(PBPlayerDetailedPublic_Response *playerDetailedPublic, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Player Detail
- (void)testPlayerDetail_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerDetail:@"haxpor" withDelegate:self];
}

- (void)testPlayerDetail_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerDetail:@"haxpor" withBlock:^(PBPlayerDetailed_Response *playerDetailed, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testPlayerDetail_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"playerDetail - delegateAsync"];
    
    [[Playbasis sharedPB] playerDetailAsync:@"haxpor" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testPlayerDetail_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"playerDetail - blockAsync"];
    
    [[Playbasis sharedPB] playerDetailAsync:@"haxpor" withBlock:^(PBPlayerDetailed_Response *playerDetailed, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Player's get custom fields
- (void)testPlayerGetCustomFields_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerCustomFields:@"haxpor" withDelegate:self];
}

- (void)testPlayerGetCutomFields_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerCustomFields:@"haxpor" withBlock:^(PBPlayerCustomFields_Response *customFields, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testPlayerGetCustomFields_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"playerGetCustomFields - delgateAsync"];
    
    [[Playbasis sharedPB] playerCustomFieldsAsync:@"haxpor" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testPlayerGetCustomFields_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"playerGetCustomFields - blockAsync"];
    
    [[Playbasis sharedPB] playerCustomFieldsAsync:@"haxpor" withBlock:^(PBPlayerCustomFields_Response *customFields, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Player's set custom fields
- (void)testPlayerSetCustomFields_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerSetCustomFields:@"haxpor" keys:@[@"test1"] values:@[@"test1Value"] withDelegate:self];
}

- (void)testPlayerSetCustomFields_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerSetCustomFields:@"haxpor" keys:@[@"test1"] values:@[@"test1Value"] withBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testPlayerSetCustomFields_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"playerSetCustomFields - delegateAsync"];
    
    [[Playbasis sharedPB] playerSetCustomFieldsAsync:@"haxpor" keys:@[@"test1"] values:@[@"test1Value"] withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testPlayerSetCustomFields_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"playerSetCustomFields - blockAsync"];
    
    [[Playbasis sharedPB] playerSetCustomFieldsAsync:@"haxpor" keys:@[@"test1"] values:@[@"test1Value"] withBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Register user
- (void)testRegisterUserWithPlayerId_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    tagId = RegisterPlayerId;
    
    // make sure to use unique playerId, and e-mail here
    [[Playbasis sharedPB] registerUserWithPlayerId:@ADD_PLAYER_ID username:@ADD_PLAYER_ID email:@ADD_PLAYER_EMAIL imageUrl:nil andDelegate:self , nil];
    
    NSLog(@"finished calling registerd");
}

- (void)testRegisterUserThenDeleteWithPlayerId_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    tagId = RegisterPlayerId;
    
    [[Playbasis sharedPB] registerUserWithPlayerId:@ADD_PLAYER_ID username:@ADD_PLAYER_ID email:@ADD_PLAYER_EMAIL imageUrl:nil andBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        
        [self subtestDeleteUser_block];
    }, nil];
}

- (void)testRegisterUserThenDeleteWithPlayerId_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    tagId = RegisterPlayerId;
    
    // create expectation
    expectation = [self expectationWithDescription:@"registerWithPlayerId - delegateAsync"];
    
    [[Playbasis sharedPB] registerUserWithPlayerIdAsync:@ADD_PLAYER_ID username:@ADD_PLAYER_ID email:@ADD_PLAYER_EMAIL imageUrl:nil andDelegate:self, nil];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
    
    NSLog(@"finished calling request");
}

- (void)testRegisterUserWithPlayerId_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"registerUserWithPlayerId - blockAsync"];
    
    [[Playbasis sharedPB] registerUserWithPlayerIdAsync:@ADD_PLAYER_ID username:@ADD_PLAYER_ID email:@ADD_PLAYER_EMAIL imageUrl:nil andBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        
        [self subtestDeleteUser_blockAsync];
    }, nil];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testRegisterUserWithPlayerId_blockAsync_
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"registerUserWithPlayerId - blockAsync_"];
    
    [[Playbasis sharedPB] registerUserWithPlayerIdAsync_:@ADD_PLAYER_ID username:@ADD_PLAYER_ID email:@ADD_PLAYER_EMAIL imageUrl:nil andBlock:^(PBManualSetResultStatus_Response *status, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        
        [self subtestDeleteUser_blockAsync_];
    }, nil];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Delete user (no need to test individually, it will be automatically called by testRegisterUserWithPlayerId... methods
- (void)subtestDeleteUser_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] deleteUserWithPlayerId:@ADD_PLAYER_ID withDelegate:self];
}

- (void)subtestDeleteUser_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] deleteUserWithPlayerId:@ADD_PLAYER_ID withBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)subtestDeleteUser_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    // change type of request
    tagId = DeletePlayerId;
    
    [[Playbasis sharedPB] deleteUserWithPlayerIdAsync:@ADD_PLAYER_ID withDelegate:self];
}

- (void)subtestDeleteUser_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] deleteUserWithPlayerIdAsync:@ADD_PLAYER_ID withBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
}

- (void)subtestDeleteUser_blockAsync_
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] deleteUserWithPlayerIdAsync_:@ADD_PLAYER_ID withBlock:^(PBManualSetResultStatus_Response *status, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
}

#pragma mark Login player
- (void)testLoginPlayer_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] loginPlayer:@"haxpor" options:nil withDelegate:self];
}

- (void)testLoginPlayer_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] loginPlayer:@"haxpor" options:nil withBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testLoginPlayer_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"loginPlayer - delegateAsync"];
    
    [[Playbasis sharedPB] loginPlayerAsync:@"haxpor" options:nil withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testLoginPlayer_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"loginPlayer - blockAsync"];
    
    [[Playbasis sharedPB] loginPlayerAsync:@"haxpor" options:nil withBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testLoginPlayer_blockAsync_
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"loginPlayer - blockAsync_"];
    
    [[Playbasis sharedPB] loginPlayerAsync_:@"haxpor" options:nil withBlock:^(PBManualSetResultStatus_Response *status, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Logout Player
- (void)testLogoutPlayer_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] logoutPlayer:@"haxpor" sessionId:nil withDelegate:self];
}

- (void)testLogoutPlayer_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] logoutPlayer:@"haxpor" sessionId:nil withBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testLogoutPlayer_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"logoutPlayer - delegateAsync"];
    
    [[Playbasis sharedPB] logoutPlayerAsync:@"haxpor" sessionId:nil withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testLogoutPlayer_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"logoutPlayer - blockAsync"];
    
    [[Playbasis sharedPB] logoutPlayerAsync:@"haxpor" sessionId:nil withBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testLogoutPlayer_delegateAsync_
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"logoutPlayer - blockAsync"];
    
    [[Playbasis sharedPB] logoutPlayerAsync_:@"haxpor" sessionId:nil withBlock:^(PBManualSetResultStatus_Response *status, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Points of player
- (void)testPointsOfPlayer_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointsOfPlayer:@"haxpor" withDelegate:self];
}

- (void)testPointsOfPlayer_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointsOfPlayer:@"haxpor" withBlock:^(PBPoints_Response *points, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testPointsOfPlayer_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointsOfPlayer - delegateAsync"];
    
    [[Playbasis sharedPB] pointsOfPlayerAsync:@"haxpor" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testPointsOfPlayer_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointsOfPlayer - blockAsync"];
    
    [[Playbasis sharedPB] pointsOfPlayerAsync:@"haxpor" withBlock:^(PBPoints_Response *points, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Point of player
- (void)testPointOfPlayer_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointOfPlayer:@"haxpor" forPoint:@"exp" withDelegate:self];
}

- (void)testPointOfPlayer_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointOfPlayer:@"haxpor" forPoint:@"exp" withBlock:^(PBPoint_Response *points, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testPointOfPlayer_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointOfPlayer - delegateAsync"];
    
    [[Playbasis sharedPB] pointOfPlayerAsync:@"haxpor" forPoint:@"exp" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testPointOfPlayer_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointOfPlayer - blockAsync"];
    
    [[Playbasis sharedPB] pointOfPlayerAsync:@"haxpor" forPoint:@"exp" withBlock:^(PBPoint_Response *points, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Point history of player (with forPoint)
- (void)testPointHistoryOfPlayer_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointHistoryOfPlayer:@"haxpor" forPoint:@"exp" andDelegate:self];
}

- (void)testPointHistoryOfPlayer_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointHistoryOfPlayer:@"haxpor" forPoint:@"exp" andBlock:^(PBPointHistory_Response *pointHistory, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testPointHistoryOfPlayer_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointOfHistory - delegateAsync"];
    
    [[Playbasis sharedPB] pointHistoryOfPlayerAsync:@"haxpor" forPoint:@"exp" andDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testPointHistoryOfPlayer_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointOfHistory - blockAsync"];
    
    [[Playbasis sharedPB] pointHistoryOfPlayerAsync:@"haxpor" forPoint:@"exp" andBlock:^(PBPointHistory_Response *pointHistory, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Point history of player (with limit)
- (void)testPointHistoryOfPlayerWithLimit_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointHistoryOfPlayer:@"haxpor" withLimit:5 andDelegate:self];
}

- (void)testPointHistoryOfPlayerWithLimit_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointHistoryOfPlayer:@"haxpor" withLimit:5 andBlock:^(PBPointHistory_Response *pointHistory, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testPointHistoryOfPlayerWithLimit_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointHistoryOfPlayer (forPoint, limit) - delegateAsync"];
    
    [[Playbasis sharedPB] pointHistoryOfPlayerAsync:@"haxpor" withLimit:5 andDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testPointHistoryOfPlayerWithLimit_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointHistoryOfPlayer (forPoint, limit) - blockAsync"];
    
    [[Playbasis sharedPB] pointHistoryOfPlayerAsync:@"haxpor" withLimit:5 andBlock:^(PBPointHistory_Response *pointHistory, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Point history of player (with forPoint, and limit)
- (void)testPointHistoryOfPlayerWithForpointAndLimit_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointHistoryOfPlayer:@"haxpor" forPoint:@"exp" withLimit:5 andDelegate:self];
}

- (void)testPointHistoryOfPlayerWithForpointAndLimit_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointHistoryOfPlayer:@"haxpor" forPoint:@"exp" withLimit:5 andBlock:^(PBPointHistory_Response *pointHistory, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testPointHistoryOfPlayerWithForpointAndLimit_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointHistoryOfPlayer (with forPoint, and limit) - delegateAsync"];
    
    [[Playbasis sharedPB] pointHistoryOfPlayerAsync:@"haxpor" forPoint:@"exp" withLimit:5 andDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testPointHistoryOfPlayerWithForpointAndLimit_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointHistoryOfPlayer (with forPoint, and limit) - blockAsync"];
    
    [[Playbasis sharedPB] pointHistoryOfPlayerAsync:@"haxpor" forPoint:@"exp" withLimit:5 andBlock:^(PBPointHistory_Response *pointHistory, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Point history of player (with offset)
- (void)testPointHistoryOfPlayerWithOffset_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointHistoryOfPlayer:@"haxpor" offset:0 andDelegate:self];
}

- (void)testPointHistoryOfPlayerWithOffset_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointHistoryOfPlayer:@"haxpor" offset:0 andBlock:^(PBPointHistory_Response *pointHistory, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testPointHistoryOfPlayerWithOffset_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointHistoryOfPlayer (with offset) - delegateAsync"];
    
    [[Playbasis sharedPB] pointHistoryOfPlayerAsync:@"haxpor" offset:0 andDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testPointHistoryOfPlayerWithOffset_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointHistoryOfPlayer (with offset) - blockAsync"];
    
    [[Playbasis sharedPB] pointHistoryOfPlayerAsync:@"haxpor" offset:0 andBlock:^(PBPointHistory_Response *pointHistory, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Point history of player (with forPoint, and offset)
- (void)testPointHistoryOfPlayerWithForPointAndOffset_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointHistoryOfPlayer:@"haxpor" forPoint:@"exp" offset:0 andDelegate:self];
}

- (void)testPointHistoryOfPlayerWithForPointAndOffset_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointHistoryOfPlayer:@"haxpor" forPoint:@"exp" offset:0 andBlock:^(PBPointHistory_Response *pointHistory, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testPointHistoryOfPlayerWithForPointAndOffset_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointHistoryOfPlayer (forPoint, offset) - delegateAsync"];
    
    [[Playbasis sharedPB] pointHistoryOfPlayerAsync:@"haxpor" forPoint:@"exp" offset:0 andDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testPointHistoryOfPlayerWithForPointAndOffset_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointHistoryOfPlayer (forPoint, offset) - blockAsync"];
    
    [[Playbasis sharedPB] pointHistoryOfPlayerAsync:@"haxpor" forPoint:@"exp" offset:0 andBlock:^(PBPointHistory_Response *pointHistory, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Point history of player (with forPoint, offset, and limit)
- (void)testPointHistoryOfPlayerWithAllParams_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointHistoryOfPlayer:@"haxpor" forPoint:@"exp" offset:0 withLimit:5 andDelegate:self];
}

- (void)testPointHistoryOfPlayerWithAllParams_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] pointHistoryOfPlayer:@"haxpor" forPoint:@"exp" offset:0 withLimit:5 andBlock:^(PBPointHistory_Response *pointHistory, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testPointHistoryOfPlayerWithAllParams_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointHistoryOfPlayer (with all params) - delegateAsync"];
    
    [[Playbasis sharedPB] pointHistoryOfPlayerAsync:@"haxpor" forPoint:@"exp" offset:0 withLimit:5 andDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testPointHistoryOfPlayerWithAllParams_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"pointOfHistoryOfPlayer (with all params) - blockAsync"];
    
    [[Playbasis sharedPB] pointHistoryOfPlayerAsync:@"haxpor" forPoint:@"exp" offset:0 withLimit:5 andBlock:^(PBPointHistory_Response *pointHistory, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Action time for player
- (void)testActionTimeForPlayer_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] actionTimeForPlayer:@"haxpor" action:@"login" withDelegate:self];
}

- (void)testActionTimeForPlayer_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] actionTimeForPlayer:@"haxpor" action:@"login" withBlock:^(PBActionTime_Response *actionTime, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testActionTimeForPlayer_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"actionTimePlayer - delegateAsync"];
    
    [[Playbasis sharedPB] actionTimeForPlayerAsync:@"haxpor" action:@"login" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testActionTimeForPlayer_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"actionTimePlayer - blockAsync"];
    
    [[Playbasis sharedPB] actionTimeForPlayerAsync:@"haxpor" action:@"login" withBlock:^(PBActionTime_Response *actionTime, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Action last performed for player
- (void)testActionLastPerformedForPlayer_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] actionLastPerformedForPlayer:@"haxpor" withDelegate:self];
}

- (void)testActionLastPerformedForPlayer_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] actionLastPerformedForPlayer:@"haxpor" withBlock:^(PBLastAction_Response *lastAction, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testActionLastPerformedForPlayer_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"actionLastPerformedForPlayer - delegateAsync"];
    
    [[Playbasis sharedPB] actionLastPerformedForPlayerAsync:@"haxpor" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testActionLastPerformedForPlayer_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"actionLastPerformedForPlayer - blockAsync"];
    
    [[Playbasis sharedPB] actionLastPerformedForPlayerAsync:@"haxpor" withBlock:^(PBLastAction_Response *lastAction, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Action last performed time for player
- (void)testActionLastPerformedTimeForPlayer_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] actionLastPerformedTimeForPlayer:@"haxpor" action:@"login" withDelegate:self];
}

- (void)testActionLastPerformedTimeForPlayer_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] actionLastPerformedTimeForPlayer:@"haxpor" action:@"login" withBlock:^(PBActionLastPerformedTime_Response *response, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testActionLastPerformedTimeForPlayer_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"actionLastPerformedTimeForPlayer - delegateAsync"];
    
    [[Playbasis sharedPB] actionLastPerformedTimeForPlayerAsync:@"haxpor" action:@"login" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testActionLastPerformedTimeForPlayer_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"actionLastPerformedTimeForPlayer - blockAsync"];
    
    [[Playbasis sharedPB] actionLastPerformedTimeForPlayerAsync:@"haxpor" action:@"login" withBlock:^(PBActionLastPerformedTime_Response *response, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark Action performed count for player
- (void)testActionPerformedCountForPlayer_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] actionPerformedCountForPlayer:@"haxpor" action:@"login" withDelegate:self];
}

- (void)testActionPerformedCountForPlayer_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] actionPerformedCountForPlayer:@"haxpor" action:@"login" withBlock:^(PBActionCount_Response *actionCount, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error msut be nil");
    }];
}

- (void)testActionPerformedCountForPlayer_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"actionPerformedCountForPlayer - delegateAsync"];
    
    [[Playbasis sharedPB] actionPerformedCountForPlayerAsync:@"haxpor" action:@"login" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testActionPerformedCountForPlayer_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"actionPerformedCountForPlayer - blockAsync"];
    
    [[Playbasis sharedPB] actionPerformedCountForPlayerAsync:@"haxpor" action:@"login" withBlock:^(PBActionCount_Response *actionCount, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

#pragma mark All badges that player has earned
- (void)testBadgeOwnedForPlayer_delegate
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] badgeOwnedForPlayer:@"haxpor" withDelegate:self];
}

- (void)testBadgeOwnedForPlayer_block
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] badgeOwnedForPlayer:@"haxpor" withBlock:^(PBPlayerBadges_Response *badges, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

- (void)testBadgeOwnedForPlayer_delegateAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"badgeOwnedForPlayer - delegateAsync"];
    
    [[Playbasis sharedPB] badgeOwnedForPlayerAsync:@"haxpor" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testBageOwnedForPlayer_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    expectation = [self expectationWithDescription:@"badgeOwnedForPlayer - blockAsync"];
    
    [[Playbasis sharedPB] badgeOwnedForPlayerAsync:@"haxpor" withBlock:^(PBPlayerBadges_Response *badges, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:ASYNC_CALL_WAIT_DURATION handler:nil];
}

- (void)testRule
{
    [[Playbasis sharedPB] authWithApiKey:@"1012718250" apiSecret:@"a52097fc5a17cb0d8631d20eacd2d9c2" bundleId:@"io.wasin.testplugin" andBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        if (error == nil)
        {
            [[Playbasis sharedPB] ruleForPlayer:@"jontestuser" action:@"like" withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
                if (error == nil)
                {
                    NSLog(@"%@", response);
                }
                else
                {
                    NSLog(@"%@", error);
                }
            }, nil];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
}

- (void)testQuizQuestion
{
    [[Playbasis sharedPB] authWithApiKey:@"1012718250" apiSecret:@"a52097fc5a17cb0d8631d20eacd2d9c2" bundleId:@"io.wasin.testplugin" andBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        if (error == nil)
        {
            [[Playbasis sharedPB] quizQuestion:@"56b98a0dbe120bf7238b65f9" forPlayer:@"jontestuser" withBlock:^(PBQuestion_Response *question, NSURL *url, NSError *error) {
                if (error == nil)
                {
                    NSLog(@"%@", question);
                }
                else
                {
                    NSLog(@"%@", error);
                }
            }];
        }
    }];
}

- (void)testQuizAnswer
{
    [[Playbasis sharedPB] authWithApiKey:@"1012718250" apiSecret:@"a52097fc5a17cb0d8631d20eacd2d9c2" bundleId:@"io.wasin.testplugin" andBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        if (error == nil)
        {
            [[Playbasis sharedPB] quizAnswer:@"56b98a0dbe120bf7238b65f9" optionId:@"065112743f8d8224bfcf62d7" forPlayer:@"jontestuser" ofQuestionId:@"029161c8b9d78cb8d175cd6a" withBlock:^(PBQuestionAnswered_Response *questionAnswered, NSURL *url, NSError *error) {
                if (error == nil)
                {
                    NSLog(@"%@", questionAnswered);
                }
                else
                {
                    NSLog(@"%@", error);
                }
            }];
        }
    }];
}

@end
