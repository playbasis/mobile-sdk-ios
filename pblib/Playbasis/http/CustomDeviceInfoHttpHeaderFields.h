//
//  CustomDeviceInfoHttpHeaderFields.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/15/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

@interface CustomDeviceInfoHttpHeaderFields : NSObject

@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;
@property (nonatomic, strong) NSString *os;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *deviceBrand;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *sdkVersion;
@property (nonatomic, strong) NSString *appBundle;

-(instancetype)initWithDefault;
-(NSURLRequest*)setUrlRequestHeaders:(NSMutableURLRequest *)urlRequest;

@end
