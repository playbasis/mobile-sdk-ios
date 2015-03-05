//
//  PBUtils.h
//  pblib
//
//  Created by haxpor on 3/5/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBUtils : NSObject

@property (strong, atomic, readonly) NSDateFormatter *dateFormatter;

/**
 Get shared instance of this PBUtils.
 */
+(PBUtils*) sharedInstance;

/**
 Initialize.
 */
-(id)init;

@end
