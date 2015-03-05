//
//  PBUtils.m
//  pblib
//
//  Created by haxpor on 3/5/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "PBUtils.h"

@implementation PBUtils

@synthesize dateFormatter = _dateFormatter;

+(PBUtils*)sharedInstance
{
    static PBUtils *sharedInstance = nil;
    
    // use dispatch_once_t to initialize singleton just once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(id)init
{
    if(!(self = [super init]))
        return nil;
    
    // create a date formatter
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    return self;
}

@end
