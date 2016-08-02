//
//  PBPendingQuiz.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import <Foundation/Foundation.h>
#import "PBPendingQuizGrade.h"

@interface PBPendingQuiz : NSObject

@property (nonatomic, strong) NSNumber* value;
@property (nonatomic, strong) PBPendingQuizGrade* grade;
@property (nonatomic, strong) NSNumber* totalCompletedQuestions;
@property (nonatomic, strong) NSNumber* totalPendingQuestions;
@property (nonatomic, strong) NSString* quizId;

@end
