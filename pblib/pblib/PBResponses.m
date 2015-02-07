//
//  PBResponses.m
//  pblib
//
//  Created by haxpor on 2/6/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "PBResponses.h"
#import "JSONKit.h"

@implementation PBPlayerPublic_Response

@synthesize image;
@synthesize userName;
@synthesize exp;
@synthesize level;
@synthesize firstName;
@synthesize lastName;
@synthesize gender;

+(PBPlayerPublic_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse
{
    // get 'response'
    NSDictionary *response = [jsonResponse objectForKey:@"response"];
    NSAssert(response != nil, @"response must not be nil");
    
    // get 'player'
    NSDictionary *player = [response objectForKey:@"player"];
    NSAssert(response != nil, @"player must not be nil");
    
    PBPlayerPublic_Response *c = [[PBPlayerPublic_Response alloc] init];
    c.image = [player objectForKey:@"image"];
    c.userName = [player objectForKey:@"username"];
    c.exp = [[player objectForKey:@"exp"] unsignedIntegerValue];
    c.level = [[player objectForKey:@"level"] unsignedIntegerValue];
    c.firstName = [player objectForKey:@"first_name"];
    c.lastName = [player objectForKey:@"last_name"];
    c.gender = [[player objectForKey:@"gender"] unsignedIntegerValue];
    
    return c;
}

@end