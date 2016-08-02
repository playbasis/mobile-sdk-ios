//
//  PBQuestionAnswer.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import "PBQuestionAnswer.h"

@implementation PBQuestionAnswer

+(void)configure:(InCodeMappingProvider *)mappingProvider
{
    [mappingProvider mapFromDictionaryKey:@"options" toPropertyKey:@"options" withObjectType:[PBQuestionOptionAnswer class] forClass:[PBQuestionAnswer class]];
    
    [mappingProvider mapFromDictionaryKey:@"rewards" toPropertyKey:@"rewards" withObjectType:[PBQuestionAnswerReward class] forClass:[PBQuestionAnswer class]];
}

@end
