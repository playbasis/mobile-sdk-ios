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
    [self configure:mappingProvider forClass:[PBQuiz class]];
}

+(void)configure:(InCodeMappingProvider *)mappingProvider forClass:(Class)cls
{
    [mappingProvider mapFromDictionaryKey:@"description" toPropertyKey:@"desc" forClass:cls];
}

@end
