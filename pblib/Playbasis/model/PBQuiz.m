//
//  PBQuiz.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/1/16.
//
//

#import "PBQuiz.h"

@implementation PBQuiz

+(void)configure:(InCodeMappingProvider *)mappingProvider
{
    [mappingProvider mapFromDictionaryKey:@"description" toPropertyKey:@"desc" forClass:[PBQuiz class]];
}

@end
