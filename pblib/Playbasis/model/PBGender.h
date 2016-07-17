//
//  PBGender.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import <Foundation/Foundation.h>

/**
 Enumberated gender value

 - MALE:   Male
 - FEMALE: Female
 */
typedef NS_ENUM(NSInteger, pbGender) {
    pbGenderMale=1,
    pbGenderFemale
};

/**
 Gender
 */
@interface PBGender : NSObject

/**
 Get enumerated gender value
 */
@property (nonatomic) pbGender gender;

/**
 Initialize with value.

 @param number integer number to initialize

 @return PBGender
 */
-(instancetype)initWithValue:(NSNumber*)number;

@end
