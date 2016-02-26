//
//  pblibTest.m
//  pblibTest
//
//  Created by Wasin Thonkaew on 2/24/16.
//
//

#import <XCTest/XCTest.h>
#import "Playbasis.h"

@interface pblibTest : XCTestCase <PBAuth_ResponseHandler, PBPlayerPublic_ResponseHandler, PBPlayer_ResponseHandler, PBPlayerList_ResponseHandler, PBPlayerDetailedPublic_ResponseHandler, PBPlayerDetailed_ResponseHandler, PBPlayerCustomFields_ResponseHandler, PBResultStatus_ResponseHandler>

@end

@implementation pblibTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark Delegate
- (void)processResponseWithAuth:(PBAuth_Response *)auth withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
}

- (void)processResponseWithPlayerPublic:(PBPlayerPublic_Response *)playerResponse withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
}

- (void)processResponseWithPlayer:(PBPlayer_Response *)playerResponse withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
}

- (void)processResponseWithPlayerList:(PBPlayerList_Response *)playerList withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
}

- (void)processResponseWithPlayerDetailedPublic:(PBPlayerDetailedPublic_Response *)playerDetailedPublic withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
}

- (void)processResponseWithPlayerDetailed:(PBPlayerDetailed_Response *)playerDetailed withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
}

- (void)processResponseWithPlayerCustomFields:(PBPlayerCustomFields_Response *)playerCustomFields withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
}

- (void)processResponseWithResultStatus:(PBResultStatus_Response *)result withURL:(NSURL *)url error:(NSError *)error
{
    XCTAssertEqual(error, nil, @"error must be nil");
    XCTAssertEqual(result.success, YES, @"result must be success");
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
    
    NSBundle *bundle = [NSBundle bundleWithURL: [[NSBundle bundleForClass:[self class]] URLForResource:@"pblibResource" withExtension:@"bundle"]];
    NSLog(@"path : %@", [bundle resourcePath]);
    
    [[Playbasis sharedPB] authWithDelegateAsync:self bundle:bundle];
}

- (void)testAuthenticationViaProtectedResources_blockAsync
{
    // set key to decrypt protected resource
    [Playbasis setProtectedResourcesKey:@"playbasis_2016*"];
    
    NSBundle *bundle = [NSBundle bundleWithURL: [[NSBundle bundleForClass:[self class]] URLForResource:@"pblibResource" withExtension:@"bundle"]];
    NSLog(@"path : %@", [bundle resourcePath]);
    
    [[Playbasis sharedPB] authWithBlockAsync:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    } bundle:bundle];
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
    
    [[Playbasis sharedPB] authWithApiKeyAsync:@"1012718250"  apiSecret:@"a52097fc5a17cb0d8631d20eacd2d9c2" bundleId:bundleIdentifier andDelegate:self];
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
    
    [[Playbasis sharedPB] authWithApiKeyAsync:@"1012718250" apiSecret:@"a52097fc5a17cb0d8631d20eacd2d9c2" bundleId:bundleIdentifier andBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
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
    
    NSBundle *bundle = [NSBundle bundleWithURL: [[NSBundle bundleForClass:[self class]] URLForResource:@"pblibResource" withExtension:@"bundle"]];
    
    [[Playbasis sharedPB] renewWithDelegateAsync:self bundle:bundle];
}

- (void)testRenew_blockAsync
{
    // before testing renew, we need to authen first
    [self testAuthenticationViaProtectedResources_block];
    
    NSBundle *bundle = [NSBundle bundleWithURL: [[NSBundle bundleForClass:[self class]] URLForResource:@"pblibResource" withExtension:@"bundle"]];
    
    [[Playbasis sharedPB] renewWithBlockAsync:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    } bundle:bundle];
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
    
    [[Playbasis sharedPB] playerPublicAsync:@"haxpor" withDelegate:self];
}

- (void)testGetPlayerPublicInfo_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerPublicAsync:@"haxpor" withBlock:^(PBPlayerPublic_Response *playerResponse, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
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
    
    [[Playbasis sharedPB] playerAsync:@"haxpor" withDelegate:self];
}

- (void)testGetPlayerInfo_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerAsync:@"haxpor" withBlock:^(PBPlayer_Response *player, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
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
    
    [[Playbasis sharedPB] playerListAsync:@"haxpor" withDelegate:self];
}

- (void)testPlayerList_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerListAsync:@"haxpor" withBlock:^(PBPlayerList_Response *playerList, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
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
    
    [[Playbasis sharedPB] playerDetailPublicAsync:@"haxpor" withDelegate:self];
}

- (void)testPlayerDetailPublic_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerDetailPublicAsync:@"haxpor" withBlock:^(PBPlayerDetailedPublic_Response *playerDetailedPublic, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
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
    
    [[Playbasis sharedPB] playerDetailAsync:@"haxpor" withDelegate:self];
}

- (void)testPlayerDetail_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerDetailAsync:@"haxpor" withBlock:^(PBPlayerDetailed_Response *playerDetailed, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
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
    
    [[Playbasis sharedPB] playerCustomFieldsAsync:@"haxpor" withDelegate:self];
}

- (void)testPlayerGetCustomFields_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerCustomFieldsAsync:@"haxpor" withBlock:^(PBPlayerCustomFields_Response *customFields, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
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
    
    [[Playbasis sharedPB] playerSetCustomFieldsAsync:@"haxpor" keys:@[@"test1"] values:@[@"test1Value"] withDelegate:self];
}

- (void)testPlayerSetCustomFields_blockAsync
{
    // authenticate app first
    [self testAuthenticationViaProtectedResources_block];
    
    [[Playbasis sharedPB] playerSetCustomFieldsAsync:@"haxpor" keys:@[@"test1"] values:@[@"test1Value"] withBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
        XCTAssertEqual(error, nil, @"error must be nil");
    }];
}

@end