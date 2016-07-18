//
//  CustomDeviceInfoHttpHeaderFields.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/15/16.
//
//

#import "CustomDeviceInfoHttpHeaderFields.h"
#import "Playbasis.h"
#import "../util/PBUtils.h"

@implementation CustomDeviceInfoHttpHeaderFields

-(instancetype)initWithDefault
{
    self = [super init];
    
    [self setWithDefaultFields];
    
    return self;
}

-(NSURLRequest *)setUrlRequestHeaders:(NSMutableURLRequest *)urlRequest
{
    if (urlRequest != nil)
    {
        // get http date string
        NSString *httpDateStr = [[PBUtils sharedInstance].dateFormatter stringFromDate:[NSDate date]];
        NSLog(@"dateStr: %@", httpDateStr);
        
        // set to request's date header
        [urlRequest setValue:httpDateStr forHTTPHeaderField:@"Date"];
        
        // set custom http headers
        [urlRequest setValue: [NSString stringWithFormat:@"%.0f", self.screenHeight] forHTTPHeaderField:@"screenHeight"];
        [urlRequest setValue: [NSString stringWithFormat:@"%.0f", self.screenWidth] forHTTPHeaderField:@"screenWidth"];
        [urlRequest setValue: self.os forHTTPHeaderField:@"os"];
        [urlRequest setValue: self.osVersion forHTTPHeaderField:@"osVersion"];
        [urlRequest setValue: self.deviceBrand forHTTPHeaderField:@"deviceBrand"];
        [urlRequest setValue: self.deviceName forHTTPHeaderField:@"deviceName"];
        [urlRequest setValue: self.sdkVersion forHTTPHeaderField:@"sdkVersion"];
        [urlRequest setValue:self.appBundle forHTTPHeaderField:@"AppBundle"];
        
        return urlRequest;
    }
    else
        return nil;
}

-(void)setWithDefaultFields
{
    
#if TARGET_OS_IOS
    // get screen resolution
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    // scale (for retina)
    CGFloat scale = [UIScreen mainScreen].scale;
    NSLog(@"scale : %.2f", scale);
    // screen width
    self.screenWidth = screenRect.size.width * scale;
    NSLog(@"screenWidth : %.2f", self.screenWidth);
    
    // screen height
    self.screenHeight = screenRect.size.height * scale;
    NSLog(@"screenHeight : %.2f", self.screenHeight);
    
    // os
    self.os = @"ios";
    NSLog(@"os : %@", self.os);
    
    // osVersion
    self.osVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"osVersion : %@", self.osVersion);
    
    // deviceBrand
    self.deviceBrand = @"Apple";
    NSLog(@"deviceBrand : %@", self.deviceBrand);
    
    // deviceName
    self.deviceName = [[PBUtils sharedInstance] platformString];
    NSLog(@"deviceName : %@", self.deviceName);
    
    // sdkVersion
    self.sdkVersion = [Playbasis version];
    NSLog(@"sdkVersion : %@", self.sdkVersion);
    
    // AppBundle
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *appbundleHeaderValue = [NSString stringWithFormat:@"%@-ios", bundleIdentifier];
    self.appBundle = appbundleHeaderValue;
    NSLog(@"App Bundle : %@", self.appBundle);
#endif
}

@end
