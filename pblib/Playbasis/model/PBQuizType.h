//
//  PBQuizType.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/1/16.
//
//

#import <Foundation/Foundation.h>

/**
 Quiz type

 - pbQuizTypeQuiz: Quiz
 - pbQuizTypePoll: Poll
 */
typedef NS_ENUM(NSInteger, pbQuizType) {
    pbQuizTypeQuiz,
    pbQuizTypePoll,
    pbQuizTypeUnknown
};


/**
 Quiz type
 */
@interface PBQuizType : NSObject


/**
 Get enumerated quiz type
 */
@property (nonatomic) pbQuizType type;


/**
 Initialize with type string

 @param type type string

 @return PBQuizType
 */
-(instancetype)initWithValue:(NSString *)type;

@end
