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
    
    [mappingProvider mapFromDictionaryKey:@"timelimit" toPropertyKey:@"timelimit" forClass:[PBQuestion class] withTransformer:^id(id currentNode, id parentNode) {
        
        // get current node as string
        NSString *timelimitString = (NSString*)currentNode;
        // split string for ":"
        NSArray<NSString*> *splits = [timelimitString componentsSeparatedByString:@":"];
        
        // convert each split into number
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        
        // hour
        NSNumber *hour = [f numberFromString:splits[0]];
        // minute
        NSNumber *minute = [f numberFromString:splits[1]];
        // seconds
        NSNumber *second = [f numberFromString:splits[2]];
        
        return [NSNumber numberWithInteger:[hour integerValue]*60*60 + [minute integerValue]*60 + [second integerValue]];
    }];
}

@end
