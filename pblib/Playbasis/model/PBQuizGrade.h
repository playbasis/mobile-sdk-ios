//
//  PBQuizGrade.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import <Foundation/Foundation.h>
#import "PBRewards.h"

@interface PBQuizGrade : NSObject

@property (nonatomic, strong) NSString* gradeId;
@property (nonatomic, strong) NSNumber* start;
@property (nonatomic, strong) NSNumber* end;
@property (nonatomic, strong) NSString* grade;
@property (nonatomic, strong) NSString* rank;
@property (nonatomic, strong) NSString* rankImage;
@property (nonatomic, strong) PBRewards* rewards;

@end
