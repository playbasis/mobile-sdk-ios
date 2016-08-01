//
//  Playbasis.h
//  Playbasis
//
//  Created by Playbasis.
//  Copyright (c) 2556 Playbasisß. All rights reserved.
//

#import <TargetConditionals.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PBTypes.h"
#import "NSMutableArray+QueueAndSerializationAdditions.h"
#import "PBSettings.h"
#import "PBConstants.h"
#import "PBUtils.h"
#import "PBMacros.h"
#import "Reachability.h"
#import "PBBuilder.h"
#import "PBBuilderConfiguration.h"

// API
#import "PBAuthApi.h"
#import "PBPlayerApi.h"
#import "PBCommunicationApi.h"
#import "PBQuizApi.h"

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "PBUI.h"
#endif

/**
 Playbasis
 Handle the API end-point calls from client side.
 */
@interface Playbasis : NSObject

/**
 Return api key
 */
@property (nonatomic, strong, readonly) NSString* apiKey;

/**
 Return api secret
 */
@property (nonatomic, strong, readonly) NSString* apiSecret;

/**
 Base url used in HTTP request
 */
@property (nonatomic, strong, readonly) NSString* baseUrl;

/**
 Return base async url used in async HTTP request
 */
@property (nonatomic, strong, readonly) NSString* baseAsyncUrl;

/**
 Retuen access token
 */
@property (nonatomic, strong, readwrite) NSString* token;

/**
 Return whether or not at the moment network is reachabled
 */
@property (nonatomic, readonly) BOOL isNetworkReachable;

/**
 Return device token
 */
@property (nonatomic, readonly) NSString* deviceToken;

/**
 Delegate to listen to network availability via Reachability
 */
@property (nonatomic, strong) id<PBNetworkStatusChangedDelegate> networkStatusChangedDelegate;

/**
 Create Playbasis instance by setting its configurations and build.

 @return Playbasis instance
 */
+ (PBBuilder*)builder;

/**
 Get shared instance of Playbasis.
 Create its instance first by calling "bulider" method, otherwise this will return nil.

 @return Playbasis instance, or if not initialized yet via "builder" method then it returns nil
 */
+ (Playbasis*)sharedPB;

/**
 Version of sdk.
 */
+ (NSString *)version;

/**
 Initialize with configuration

 @param configs configurations

 @return Playbasis instance
 */
- (instancetype)initWithConfiguration:(PBBuilderConfiguration *)configs;

/**
 Dealloc
 */
- (void)dealloc;

/**
 Register device for push notification
 */
- (void)registerDeviceForPushNotification;

/**
 Extract and save device token from data

 @param rawData raw data
 */
- (void)extractAndSaveDeviceTokenFrom:(NSData *)rawData;

/**
 * Fire request if necessary.
 * If it cannot do it due to Intenet connection is down, then it will save into queue.
 */
- (void)fireRequestIfNecessary:(PBRequestUnit<id> *)request;

/**
 Get request-operational-queue.
 It holds all created http requests. Those requests are not dispatched or sent just yet. It's after dequeing, it will start sending those request one by one.
 */
- (const NSMutableArray *)getRequestOperationalQueue;

#if TARGET_OS_IOS
/**
 UI - for KLCPopup
 */
- (void)showFeedbackStatusUpdateWithText:(NSString *)text;
- (void)showFeedbackStatusUpdateWithText:(NSString *)text duration:(NSTimeInterval)duration;
- (void)showFeedbackEventPopupWithImage:(UIImage *)image title:(NSString *)title description:(NSString*)description;
- (void)showFeedbackEventPopupWithContent:(UIView *)contentView image:(UIImage *)image title:(NSString *)title description:(NSString*)description;
- (void)dismissAllFeedbackPopups;

/**
 UI - for MBProgressHUD
 */
- (void)showHUDFromView:(UIView *)view;
- (void)showHUDFromView:(UIView *)view withText:(NSString *)text;
- (void)showTextHUDFromView:(UIView *)view withText:(NSString *)text forDuration:(NSTimeInterval)duration;
- (void)hideHUDFromView:(UIView *)view;
- (void)hideAllHUDFromView:(UIView *)view;
#endif

@end


