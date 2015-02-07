//
//  PBResponses.h
//  pblib
//
//  Created by haxpor on 2/6/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#ifndef pblib_PBResponses_h
#define pblib_PBResponses_h

#import <Foundation/Foundation.h>

///--------------------------------------
/// Type of Response
///--------------------------------------
typedef enum
{
    responseType_normal,
    responseType_playerPublic
}pbResponseType;

///--------------------------------------
/// JSON Response - Refactored Classes
///--------------------------------------

///--------------------------------------
/// JSON Response - Refactored Classes
///--------------------------------------
@interface PBPlayerPublic_Response : NSObject

@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *userName;
@property (nonatomic) NSUInteger exp;
@property (nonatomic) NSUInteger level;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (nonatomic) NSUInteger gender;

/**
 Parse json-response data into NSDictionary.
 */
+(PBPlayerPublic_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse;

@end

#endif
