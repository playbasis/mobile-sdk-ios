//
//  PBPlayer.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import "PBPlayer.h"

@implementation PBPlayer

+(void)configure:(InCodeMappingProvider *)mappingProvider
{
    // map gender to object PBGender
    [mappingProvider mapFromDictionaryKey:@"gender" toPropertyKey:@"gender" forClass:[PBPlayer class] withTransformer:^id(id currentNode, id parentNode) {
        return [[PBGender alloc] initWithValue:currentNode];
    }];
}

@end
