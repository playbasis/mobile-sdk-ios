//
//  PBRule.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/25/16.
//
//

#import "PBRule.h"
#import "PBEvent.h"

@implementation PBRule

+ (void)configure:(id)mappingProvider
{
    [mappingProvider mapFromDictionaryKey:@"events" toPropertyKey:@"events" withObjectType:[PBEvent class] forClass:[PBRule class]];
}

@end
