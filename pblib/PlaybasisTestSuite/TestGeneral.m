//
//  TestGeneral.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import <XCTest/XCTest.h>
#import "Playbasis.h"
#import "Macros.h"

#define TIMEOUT 6.0f
INIT_VARS_STATIC

@interface TestGeneral : XCTestCase
{
    INIT_VARS_LOCAL
}

@end

@implementation TestGeneral

- (void)setUp {
    [super setUp];
    
    INIT_PLAYBASIS
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreatePlaybasisObject {
    // test case already in setUp() method
    // if setUp() is passed, then this test case is passed too
}

- (void)testDownloadImageWithUrl {
    EXP_CREATE(@"uiimageDownload")
    
    [UIImage startLoadingImageInTheBackgroundWithUrl:@"http://images.pbapp.net/data/97285abc55573558c6ba0321124f5108.png" complete:^(UIImage *image) {
        XCTAssert(image != nil, @"image must not be nil");
        EXP_FULFILL
    } andError:^(NSError *error) {
        XCTAssert(NO, @"there's an error");
    }];
    
    EXP_WAIT(TIMEOUT)
}

- (void)testDownloadImageWithUrlVariant2 {
    EXP_CREATE(@"uiimageDownloaderVariant2");
    
    [UIImage startLoadingImageWithUrl:@"http://images.pbapp.net/data/97285abc55573558c6ba0321124f5108.png" complete:^(UIImage *image) {
        XCTAssert(image != nil, @"image must not be nil");
        EXP_FULFILL
    } andError:^(NSError *error) {
        XCTAssert(NO, @"there's an error");
    }];
    
    EXP_WAIT(TIMEOUT)
}

@end
