//
//  PBQuestionAnswerGrade.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import <Foundation/Foundation.h>

@interface PBQuestionAnswerGrade : NSObject

@property (nonatomic, strong) NSNumber* score;
@property (nonatomic, strong) NSNumber* maxScore;
@property (nonatomic, strong) NSString* explanation;
@property (nonatomic, strong) NSNumber* totalScore;
@property (nonatomic, strong) NSNumber* totalMaxScore;

@end
