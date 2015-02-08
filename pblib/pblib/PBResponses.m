//
//  PBResponses.m
//  pblib
//
//  Created by haxpor on 2/6/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "PBResponses.h"
#import "JSONKit.h"

/**
 Auth
 */
@implementation PBAuth_Response

@synthesize token;
@synthesize dateExpire;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Auth : {\r   token : %@\r   date_expire : %@\r}", self.token, self.dateExpire];
    return descriptionString;
}

+(PBAuth_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse
{
    if(jsonResponse == nil)
        return nil;
    
    // get 'response'
    NSDictionary *response = [jsonResponse objectForKey:@"response"];
    NSAssert(response != nil, @"response must not be nil");
    
    PBAuth_Response *c = [[PBAuth_Response alloc] init];
    c.token = [response objectForKey:@"token"];
    
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.dateExpire = [dateFormatter dateFromString:[response objectForKey:@"date_expire"]];
    
    return c;
}

@end

/**
 PlayerPublic
 */
@implementation PBPlayerPublic_Response

@synthesize image;
@synthesize userName;
@synthesize exp;
@synthesize level;
@synthesize firstName;
@synthesize lastName;
@synthesize gender;
@synthesize registered;
@synthesize lastLogin;
@synthesize lastLogout;
@synthesize clPlayerId;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Player's Public Information : {\r   image : %@\r   userName : %@\r   exp : %u\r   level : %u\r   first_name : %@\r   last_name : %@\r   gender : %u\r   registered : %@\r   last_login : %@\r   last_logout : %@\r   cl_player_id : %@\r}", self.image, self.userName, self.exp, self.level, self.firstName, self.lastName, self.gender, self.registered, self.lastLogin, self.lastLogout, self.clPlayerId];
    return descriptionString;
}

+(PBPlayerPublic_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse
{
    if(jsonResponse == nil)
        return nil;
    
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
    
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.registered = [dateFormatter dateFromString:[player objectForKey:@"registered"]];
    c.lastLogin = [dateFormatter dateFromString:[player objectForKey:@"last_login"]];
    c.lastLogout = [dateFormatter dateFromString:[player objectForKey:@"last_logout"]];
    
    c.clPlayerId = [player objectForKey:@"cl_player_id"];
    
    return c;
}

@end

/**
 Player
 */
@implementation PBPlayer_Response

@synthesize image;
@synthesize email;
@synthesize userName;
@synthesize exp;
@synthesize level;
@synthesize phoneNumber;
@synthesize firstName;
@synthesize lastName;
@synthesize gender;
@synthesize registered;
@synthesize lastLogin;
@synthesize lastLogout;
@synthesize clPlayerId;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Player Information : {\r   image : %@\r   email : %@\r   userName : %@\r   exp : %u\r   level : %u\r   phone_number : %@\r   first_name : %@\r   last_name : %@\r   gender : %u\r   registered : %@\r   last_login : %@\r   last_logout : %@\r   cl_player_id : %@\r}", self.image, self.email, self.userName, self.exp, self.level, self.phoneNumber, self.firstName, self.lastName, self.gender, self.registered, self.lastLogin, self.lastLogout, self.clPlayerId];
    return descriptionString;
}

+(PBPlayer_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse
{
    if(jsonResponse == nil)
        return nil;
    
    // get 'response'
    NSDictionary *response = [jsonResponse objectForKey:@"response"];
    NSAssert(response != nil, @"response must not be nil");
    
    // get 'player'
    NSDictionary *player = [response objectForKey:@"player"];
    NSAssert(response != nil, @"player must not be nil");
    
    PBPlayer_Response *c = [[PBPlayer_Response alloc] init];
    c.image = [player objectForKey:@"image"];
    c.email = [player objectForKey:@"email"];
    c.userName = [player objectForKey:@"username"];
    c.exp = [[player objectForKey:@"exp"] unsignedIntegerValue];
    c.level = [[player objectForKey:@"level"] unsignedIntegerValue];
    c.phoneNumber = [player objectForKey:@"phone_number"];
    c.firstName = [player objectForKey:@"first_name"];
    c.lastName = [player objectForKey:@"last_name"];
    c.gender = [[player objectForKey:@"gender"] unsignedIntegerValue];
    
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.registered = [dateFormatter dateFromString:[player objectForKey:@"registered"]];
    c.lastLogin = [dateFormatter dateFromString:[player objectForKey:@"last_login"]];
    c.lastLogout = [dateFormatter dateFromString:[player objectForKey:@"last_logout"]];
    
    c.clPlayerId = [player objectForKey:@"cl_player_id"];
    
    return c;
}

@end