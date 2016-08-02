//
//  PBQuizDoneGrade.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import "PBQuizDoneGrade.h"

@implementation PBQuizDoneGrade

+(void)configure:(InCodeMappingProvider *)mappingProvider
{
    [mappingProvider mapFromDictionaryKey:@"rewards" toPropertyKey:@"rewards" withObjectType:[PBQuizDoneGradeReward class] forClass:[PBQuizDoneGrade class]];
}

@end
