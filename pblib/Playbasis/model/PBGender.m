//
//  PBGender.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import "PBGender.h"

@implementation PBGender

-(instancetype)initWithValue:(NSNumber *)number
{
    self = [super init];
    
    int setValue = [number intValue];
    if (setValue < 1 || setValue > pbGenderFemale)
        setValue = 1;
    self.gender = setValue;
    
    return self;
}

@end
