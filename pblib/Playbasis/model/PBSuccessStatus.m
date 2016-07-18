//
//  PBSuccessStatus.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/18/16.
//
//

#import "PBSuccessStatus.h"

@implementation PBSuccessStatus

-(instancetype)initWithBool:(BOOL)success
{
    self = [super init];
    
    self.success = success;
    
    return self;
}

@end
