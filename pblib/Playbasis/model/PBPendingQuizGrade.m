//
//  PBPendingQuizGrade.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import "PBPendingQuizGrade.h"

@implementation PBPendingQuizGrade

+(void)configure:(InCodeMappingProvider *)mappingProvider
{
    [mappingProvider mapFromDictionaryKey:@"rewards" toPropertyKey:@"rewards" withObjectType:[PBPendingQuizGradeReward class] forClass:[PBPendingQuizGrade class]];
}

@end
