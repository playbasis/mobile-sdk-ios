//
//  PBQuestion.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import "PBQuestion.h"

@implementation PBQuestion

+(void)configure:(InCodeMappingProvider *)mappingProvider
{
    [mappingProvider mapFromDictionaryKey:@"options" toPropertyKey:@"options" withObjectType:[PBQuestionOption class] forClass:[PBQuestion class]];
}

@end
