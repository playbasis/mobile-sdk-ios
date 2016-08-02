//
//  PBRewardData.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import "PBRewardData.h"

@implementation PBRewardData

+(void)configure:(InCodeMappingProvider *)mappingProvider
{
    [mappingProvider mapFromDictionaryKey:@"description" toPropertyKey:@"desc" forClass:[PBRewardData class]];
}

@end
