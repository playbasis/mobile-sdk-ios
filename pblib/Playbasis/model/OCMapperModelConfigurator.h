//
//  OCMapperModelConfigurator.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/17/16.
//
//

#import <Foundation/Foundation.h>

/**
 OCMapperModelConfigurator takes care of calling configure method that adhere to protocol OCMapperConfigurable of each model class as configured in specified filename.
 */
@interface OCMapperModelConfigurator : NSObject


/**
 Begin configuration for all model classes as set in specified plist file.

 @param plistFileName plist file name without extention
 */
+ (void)configure:(NSString *)plistFileName;

@end
