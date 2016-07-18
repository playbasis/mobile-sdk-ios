//
//  PBGoods.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/18/16.
//
//

#import "PBGoods.h"

@implementation PBGoods

+(void)configure:(InCodeMappingProvider *)mappingProvider
{
    [mappingProvider mapFromDictionaryKey:@"description" toPropertyKey:@"desc" forClass:[PBGoods class]];
}

@end
