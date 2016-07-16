//
//  PBValidator.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import <Foundation/Foundation.h>

@interface PBValidator : NSObject

+ (BOOL)isValid:(NSObject*)object;
+ (BOOL)isValidString:(NSString*)string;

@end
