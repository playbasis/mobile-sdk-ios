//
//  PBValidator.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import "PBValidator.h"

@implementation PBValidator

+ (BOOL)isValid:(NSObject *)object
{
    return object != nil;
}

+(BOOL)isValidString:(NSString *)string
{
    return string != nil && ![string isEqualToString:@""];
}

@end
