//
//  PBQuiz.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/1/16.
//
//

#import <Foundation/Foundation.h>
#import "OCMapperConfigurable.h"

@interface PBQuiz : NSObject <OCMapperConfigurable>

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* image;
@property (nonatomic, strong) NSNumber* weight;
@property (nonatomic, strong) NSMutableArray<NSString*>* tags;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSString* descriptionImage;
@property (nonatomic, strong) NSString* quizId;

+(void)configure:(InCodeMappingProvider *)mappingProvider;

@end
