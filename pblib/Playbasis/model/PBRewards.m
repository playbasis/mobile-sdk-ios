//
//  PBRewards.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/1/16.
//
//

#import "PBRewards.h"

@implementation PBRewards

+(void)configure:(InCodeMappingProvider *)mappingProvider
{
    [mappingProvider mapFromDictionaryKey:@"badge" toPropertyKey:@"badge" withObjectType:[PBBadgeValue class] forClass:[PBRewards class]];
}

@end
