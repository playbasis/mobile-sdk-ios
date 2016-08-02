//
//  PBQuestionAnswer.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import <Foundation/Foundation.h>
#import "OCMapperConfigurable.h"
#import "PBQuestionOptionAnswer.h"
#import "PBQuestionAnswerGrade.h"
#import "PBQuestionAnswerReward.h"

@interface PBQuestionAnswer : NSObject <OCMapperConfigurable>

@property (nonatomic, strong) NSArray<PBQuestionOptionAnswer*>* options;
@property (nonatomic, strong) NSNumber* score;
@property (nonatomic, strong) NSNumber* maxScore;
@property (nonatomic, strong) NSString* explanation;
@property (nonatomic, strong) NSNumber* totalScore;
@property (nonatomic, strong) NSNumber* totalMaxScore;
@property (nonatomic, strong) PBQuestionAnswerGrade* grade;
@property (nonatomic, strong) NSArray<PBQuestionAnswerReward*>* rewards;

@end
