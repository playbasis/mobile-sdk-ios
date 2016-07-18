//
//  PBBadge.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/18/16.
//
//

#import "PBBadge.h"

@implementation PBBadge

+(void)configure:(InCodeMappingProvider *)mappingProvider
{
    [mappingProvider mapFromDictionaryKey:@"description" toPropertyKey:@"desc" forClass:[PBBadge class]];
}

@end
