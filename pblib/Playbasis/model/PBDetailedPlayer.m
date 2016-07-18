//
//  PBDetailedPlayer.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/18/16.
//
//

#import "PBDetailedPlayer.h"

@implementation PBDetailedPlayer

+(void)configure:(InCodeMappingProvider *)mappingProvider
{
    [super configure:mappingProvider];
    
    [mappingProvider mapFromDictionaryKey:@"badges" toPropertyKey:@"badges" withObjectType:[PBBadge class] forClass:[PBDetailedPlayer class]];
    [mappingProvider mapFromDictionaryKey:@"goods" toPropertyKey:@"goods" withObjectType:[PBGoods class] forClass:[PBDetailedPlayer class]];
}

@end
