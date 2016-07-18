//
//  Playbasis.m
//  Playbasis
//
//  Created by Playbasis.
//  Copyright (c) 2556 Playbasis. All rights reserved.
//

#import "Playbasis.h"
#import "RNDecryptor.h"
#import "JSONKit.h"
#import "PBRequestUnit.h"

#import "helper/PBValidator.h"
#import "model/OCMapperModelConfigurator.h"

#if TARGET_OS_IOS
#import "KLCPopup.h"
#import "MBProgressHUD.h"
#endif

// shared instance of Playbasis
static Playbasis *sharedInstance = nil;

/**
 For local management.
 */
@interface Playbasis ()
{
    /**
     Request operation queue
     */
    NSMutableArray *_requestOptQueue;
    
    /**
     Keep track of whether network is available or not
     This works with Reachability
     */
    BOOL _isNetworkReachable;
    
    /**
     Rechability object to detect availability of network
     */
    Reachability *_reachability;
}

// overwrite write access within class only
@property (nonatomic, strong, readwrite) NSString* apiKey;
@property (nonatomic, strong, readwrite) NSString* apiSecret;
@property (nonatomic, strong, readwrite) NSString* baseUrl;
@property (nonatomic, strong, readwrite) NSString* baseAsyncUrl;

/**
 Dispatch a first founded request in the operational queue and only if network
 can be reached.
 */
-(void)dispatchFirstRequestInQueue:(NSTimer*)dt;

/**
 This method will be called whenever network status changed.
 */
-(void)checkNetworkStatus:(NSNotification*)notice;

/**
 List of event listener method to listen to for UIAppliationDelegate
 */
-(void)onApplicationDidFinishLaunching:(NSNotification *)notif;

// TODO: Remove this when we've done all parts except UI
/**
 Generic dismiss method after touching button.
 Use with KLCPopup.
 */
- (void)klcPopup_dismissButtonPressed:(id)sender;

@end

//
// The Playbasis Object
//
@implementation Playbasis

// NSUserDefaults key for Playbasis sdk to retrieve it later
static NSString *sDeviceTokenRetrievalKey = nil;

@synthesize isNetworkReachable = _isNetworkReachable;

+(void)registerDeviceForPushNotification
{
    #if TARGET_OS_IOS
    // register for push notification
    // note: ios 8 changes the way to setup push notification, it's deprecated the old method
    // thus we need to check on this one
    // note 2: we will register device with this device token later with playbasis
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        PBLOG(@"Register device ios %f+", 8.0f);
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
        PBLOG(@"Registered devie ios < %f", 8.0f);
    }
    #endif
}

+(void)saveDeviceToken:(NSData *)deviceToken withKey:(NSString *)key
{
    // we got device token, then we need to trim the brackets, and cut out space
    NSString *device = [deviceToken description];
    device = [device stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    device = [device stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    PBLOG(@"Device token is: %@", device);
    
    // save the key for Playbasis to be able to retrieve it via NSUserDefaults later
    sDeviceTokenRetrievalKey = key;
    
    // save it via NSUserDefaults (non-critical data to be encrypted)
    // we will got this data later in UIViewController-based class
    [[NSUserDefaults standardUserDefaults] setObject:device forKey:sDeviceTokenRetrievalKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getDeviceToken
{
    if (sDeviceTokenRetrievalKey != nil && [sDeviceTokenRetrievalKey isEqualToString:@""])
        return [[NSUserDefaults standardUserDefaults] objectForKey:sDeviceTokenRetrievalKey];
    else
        return nil;
}

+(PBBuilder*)builder
{
    return [[PBBuilder alloc] init];
}

+(Playbasis*)sharedPB
{
    return sharedInstance;
}

+(NSString *)version
{
    return @"1.0";
}

-(instancetype)initWithConfiguration:(PBBuilderConfiguration*)configs
{
    if(!(self = [super init]))
        return nil;
    
    _isNetworkReachable = FALSE;
    
    // create reachability instance
    _reachability = [Reachability reachabilityForInternetConnection];
    // initially set the network status here
    // send 'nil' in has no effect for this method
    [self checkNetworkStatus:nil];
    
    // add notification of network status change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
#if TARGET_OS_IOS
    // add notification of UIApplication
    // we add them here to reduce code user has to add in Delegate class
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
#endif
    
    // start notifier right away
    [_reachability startNotifier];
    
    // create an empty of request opt-queue
    _requestOptQueue = [NSMutableArray array];
    
    // after queue creation then start checking to load requests from file
    [[self getRequestOperationalQueue] load];
    
    // schedule interval call to dispatch request in queue
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(dispatchFirstRequestInQueue:) userInfo:nil repeats:YES];
    
    // check if either apiKey or apiSecret is not valid, then throw exception
    if (![PBValidator isValidString:configs.apiKey] ||
        ![PBValidator isValidString:configs.apiSecret])
        [NSException raise:@"apiKey and apiSecret must be set" format:@"either apiKey or apiSecret is nil, set it via 'builder' method"];
    
    // save configurations
    self.apiKey = configs.apiKey;
    self.apiSecret = configs.apiSecret;
    self.baseUrl = configs.baseUrl;
    self.baseAsyncUrl = configs.baseAsyncUrl;
    // set instance of this to shared instance
    sharedInstance = self;
    
    // configure model classes for OCMapper
    [OCMapperModelConfigurator configure:@"OCMapperModelConfigure"];
    
    return self;
}

-(void)dealloc
{
    // stop notifier
    [_reachability stopNotifier];
    // remove notification of network status change
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
#if TARGET_OS_IOS
    // remove notification of UIApplication
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
#endif
}

-(void)fireRequestIfNecessary:(PBRequestUnit<id> *)request
{
    // if network is reachable then dispatch it immediately
    if(_isNetworkReachable)
    {
        // start the request
        [request start];
    }
    // otherwise, then add into the queue
    else
    {
        // add PBRequestUnit into operational queue
        [_requestOptQueue enqueue:request];
        
        PBLOG(@"Queue size = %lu", (unsigned long)[_requestOptQueue count]);
    }
}

-(const NSMutableArray *)getRequestOperationalQueue
{
    return _requestOptQueue;
}

-(void)dispatchFirstRequestInQueue:(NSTimer *)dt
{
    // only dispatch a first found request if network can be reached, and
    // operational queue is not empty
    if(_isNetworkReachable && ![_requestOptQueue empty])
    {
        [[self getRequestOperationalQueue] dequeueAndStart];
        PBLOG(@"Dispatched first founed request in queue");
    }
}

-(void)checkNetworkStatus:(NSNotification *)notice
{
    NetworkStatus networkStatus = [_reachability currentReachabilityStatus];
    switch(networkStatus)
    {
        case NotReachable:
            _isNetworkReachable = FALSE;
            PBLOG(@"Network is not reachable");
            break;
        case ReachableViaWiFi:
            _isNetworkReachable = TRUE;
            PBLOG(@"Network is reachable via WiFi");
            break;
        case ReachableViaWWAN:
            _isNetworkReachable = TRUE;
            PBLOG(@"Network is reachable via WWAN");
            break;
    }
    
    // raising the event
    [self.networkStatusChangedDelegate networkStatusChanged:networkStatus];
}

// Only for UI related methods
#if TARGET_OS_IOS
-(void)showFeedbackStatusUpdateWithText:(NSString *)text
{
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor grayColor];
    contentView.layer.cornerRadius = 12.0;
    
    UILabel* statusLabel = [[UILabel alloc] init];
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.font = [UIFont boldSystemFontOfSize:12.0];
    statusLabel.numberOfLines = 0;  // cover all lines
    statusLabel.text = text;
    
    [contentView addSubview:statusLabel];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(contentView, statusLabel);
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(16)-[statusLabel]-(10)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(36)-[statusLabel]-(36)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    // save to persistent klcpopup for us to close it later
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeClear dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    // show it permanently, will required user to close it later
    [popup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom) duration:0.0];
}

-(void)showFeedbackStatusUpdateWithText:(NSString *)text duration:(NSTimeInterval)duration
{
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor grayColor];
    contentView.layer.cornerRadius = 12.0;
    
    UILabel* statusLabel = [[UILabel alloc] init];
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.font = [UIFont boldSystemFontOfSize:12.0];
    statusLabel.numberOfLines = 0;  // cover all lines
    statusLabel.text = text;
    
    [contentView addSubview:statusLabel];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(contentView, statusLabel);
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(16)-[statusLabel]-(10)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(36)-[statusLabel]-(36)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeClear dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [popup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom) duration:duration];
}

-(void)showFeedbackEventPopupWithImage:(UIImage *)image title:(NSString *)title description:(NSString *)description
{
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor grayColor];
    contentView.layer.cornerRadius = 12.0;
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.translatesAutoresizingMaskIntoConstraints = YES;
    imageView.frame = CGRectMake(0, 0, 150, 150);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleLabel.contentMode = UIViewContentModeCenter;
    titleLabel.text = title;
    
    UILabel* descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    descriptionLabel.frame = CGRectMake(0, 0, 250, 80);
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.font = [UIFont boldSystemFontOfSize:15.0];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.contentMode = UIViewContentModeCenter;
    descriptionLabel.text = description;
    
    UIButton* dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    dismissButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    dismissButton.backgroundColor = [UIColor orangeColor];
    [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dismissButton setTitleColor:[[dismissButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    dismissButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [dismissButton setTitle:@"Ok" forState:UIControlStateNormal];
    dismissButton.layer.cornerRadius = 6.0;
    [dismissButton addTarget:self action:@selector(klcPopup_dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:titleLabel];
    [contentView addSubview:imageView];
    [contentView addSubview:descriptionLabel];
    [contentView addSubview:dismissButton];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(contentView, titleLabel, imageView, descriptionLabel, dismissButton);
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[imageView]-(20)-[titleLabel]-(10)-[descriptionLabel]-(10)-[dismissButton]-(24)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(36)-[titleLabel]-(36)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    [popup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
}

-(void)showFeedbackEventPopupWithContent:(UIView *)contentView image:(UIImage *)image title:(NSString *)title description:(NSString *)description
{
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    [popup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
}

-(void)dismissAllFeedbackPopups
{
    [KLCPopup dismissAllPopups];
}

- (void)klcPopup_dismissButtonPressed:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
}

-(void)showHUDFromView:(UIView *)view
{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

-(void)showHUDFromView:(UIView *)view withText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
}

-(void)showTextHUDFromView:(UIView *)view withText:(NSString *)text forDuration:(NSTimeInterval)duration
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud hide:YES afterDelay:duration];
}

-(void)hideHUDFromView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

-(void)hideAllHUDFromView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}
#endif

@end
