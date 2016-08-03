//
//  PBQuestion.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import <Foundation/Foundation.h>
#import "OCMapperConfigurable.h"
#import "PBQuestionOption.h"

@interface PBQuestion : NSObject <OCMapperConfigurable>

@property (nonatomic, strong) NSString* question;
@property (nonatomic, strong) NSString* questionImage;
@property (nonatomic, strong) NSNumber* timelimit;
@property (nonatomic, strong) NSNumber* questionNumber;
@property (nonatomic, strong) NSArray<PBQuestionOption*>* options;
@property (nonatomic, strong) NSNumber* index;
@property (nonatomic, strong) NSNumber* total;
@property (nonatomic, strong) NSString* questionId;

@end
