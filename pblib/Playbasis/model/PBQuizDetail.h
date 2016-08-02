//
//  PBQuizDetail.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/1/16.
//
//

#import <Foundation/Foundation.h>
#import "OCMapperConfigurable.h"
#import "PBQuiz.h"
#import "PBQuizType.h"
#import "PBQuizGrade.h"

@interface PBQuizDetail : PBQuiz <OCMapperConfigurable>

@property (nonatomic, strong) NSDate* dateStart;
@property (nonatomic, strong) NSDate* dateExpire;
@property (nonatomic, strong) PBQuizType* type;
@property (nonatomic, strong) NSArray<PBQuizGrade*>* grades;
@property (nonatomic, strong) NSNumber* status;
@property (nonatomic, strong) NSNumber* questionOrder;
@property (nonatomic, strong) NSNumber* deleted;
@property (nonatomic, strong) NSNumber* totalMaxScore;
@property (nonatomic, strong) NSNumber* totalQuestions;
@property (nonatomic, strong) NSNumber* questions;
@property (nonatomic, strong) NSNumber* totalScore;
@property (nonatomic, strong) NSDate* dateJoin;

@end
