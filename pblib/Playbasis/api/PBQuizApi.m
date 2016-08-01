//
//  PBQuizApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/1/16.
//
//

#import "PBQuizApi.h"
#import "Playbasis.h"
#import "../helper/PBValidator.h"
#import "PBApiMacros.h"

@implementation PBQuizApi

+ (void)activeQuizList:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(NSArray<PBQuiz *> *, NSError *))completion
{
    API_VALIDATE_PBOBJ(playbasis)
    
    API_CREATE_METHOD_VARS(playbasis.apiKey, @"Quiz/list?player_id=%@", playerId, nil)
    
    PBRequestUnit<NSArray<PBQuiz *>*> *request = [[PBRequestUnit<NSArray<PBQuiz *>*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion withJsonResultSubKey:@"result" forResultClass:[PBQuiz class]];
    
    [playbasis fireRequestIfNecessary:request];
}

@end
