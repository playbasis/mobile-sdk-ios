//
//  PBQuizDone.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import <Foundation/Foundation.h>
#import "PBQuizDoneGrade.h"

@interface PBQuizDone : NSObject

@property (nonatomic, strong) NSNumber* value;
@property (nonatomic, strong) PBQuizDoneGrade* grade;
@property (nonatomic, strong) NSNumber* totalCompletedQuestions;
@property (nonatomic, strong) NSString* quizId;

@end
