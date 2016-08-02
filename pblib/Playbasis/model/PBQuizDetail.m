//
//  PBQuizDetail.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/1/16.
//
//

#import "PBQuizDetail.h"

@implementation PBQuizDetail

+(void)configure:(InCodeMappingProvider *)mappingProvider
{
    // call super to set up for derived class
    //[super configure:mappingProvider forClass:[PBQuizDetail class]];
    
    // override in level of PBQuizDetail
    [mappingProvider mapFromDictionaryKey:@"type" toPropertyKey:@"type" forClass:[PBQuizDetail class] withTransformer:^id(id currentNode, id parentNode) {
        return [[PBQuizType alloc] initWithValue:(NSString*)currentNode];
    }];
    
    [mappingProvider mapFromDictionaryKey:@"grades" toPropertyKey:@"grades" withObjectType:[PBQuizGrade class] forClass:[PBQuizDetail class]];
}

@end
