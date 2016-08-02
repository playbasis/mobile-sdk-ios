//
//  PBPendingQuizGrade.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import <Foundation/Foundation.h>
#import "OCMapperConfigurable.h"
#import "PBPendingQuizGradeReward.h"

@interface PBPendingQuizGrade : NSObject <OCMapperConfigurable>

@property (nonatomic, strong) NSString* gradeId;
@property (nonatomic, strong) NSNumber* start;
@property (nonatomic, strong) NSNumber* end;
@property (nonatomic, strong) NSString* grade;
@property (nonatomic, strong) NSString* rank;
@property (nonatomic, strong) NSString* rankImage;
@property (nonatomic, strong) NSArray<PBPendingQuizGradeReward*>* rewards;
@property (nonatomic, strong) NSNumber* score;
@property (nonatomic, strong) NSNumber* maxScore;
@property (nonatomic, strong) NSNumber* totalScore;
@property (nonatomic, strong) NSNumber* totalMaxScore;

@end
