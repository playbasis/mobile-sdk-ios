//
//  PBPlayer.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import <Foundation/Foundation.h>
#import "PBGender.h"
#import "OCMapperConfigurable.h"

@interface PBPlayer : NSObject <OCMapperConfigurable>

@property (nonatomic, strong) NSString* image;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSNumber* exp;
@property (nonatomic, strong) NSNumber* level;
@property (nonatomic, strong) NSString* phoneNumber;
@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic) PBGender *gender;
@property (nonatomic, strong) NSDate* birthDate;
@property (nonatomic, strong) NSDate* registered;
@property (nonatomic, strong) NSDate* lastLogin;
@property (nonatomic, strong) NSDate* lastLogout;
@property (nonatomic, strong) NSString* clPlayerId;

+(void)configure:(InCodeMappingProvider *)mappingProvider;

@end
