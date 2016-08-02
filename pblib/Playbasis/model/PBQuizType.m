//
//  PBQuizType.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/1/16.
//
//

#import "PBQuizType.h"

@implementation PBQuizType

-(instancetype)initWithValue:(NSString *)type
{
    self = [super init];
    
    if ([type isEqualToString:@"quiz"]) {
        self.type = pbQuizTypeQuiz;
    }
    else if ([type isEqualToString:@"poll"]) {
        self.type = pbQuizTypePoll;
    }
    else {
        self.type = pbQuizTypeUnknown;
    }
    
    return self;
}

@end
