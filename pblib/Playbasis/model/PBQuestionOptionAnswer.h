//
//  PBQuestionOptionAnswer.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import <Foundation/Foundation.h>

@interface PBQuestionOptionAnswer : NSObject

@property (nonatomic, strong) NSString* option;
@property (nonatomic, strong) NSNumber* score;
@property (nonatomic, strong) NSString* explanation;
@property (nonatomic, strong) NSString* optionImage;
@property (nonatomic, strong) NSString* optionId;

@end
