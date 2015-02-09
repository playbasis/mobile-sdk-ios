//
//  PBResponses.m
//  pblib
//
//  Created by haxpor on 2/6/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "PBResponses.h"
#import "JSONKit.h"


///--------------------------------------
/// Auth
///--------------------------------------
@implementation PBAuth_Response

@synthesize token;
@synthesize dateExpire;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Auth : {\r   token : %@\r   date_expire : %@\r   }", self.token, self.dateExpire];
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

///--------------------------------------
/// PlayerPublic
///--------------------------------------
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
    NSString *descriptionString = [NSString stringWithFormat:@"Player's Public Information : {\r   image : %@\r   userName : %@\r   exp : %u\r   level : %u\r   first_name : %@\r   last_name : %@\r   gender : %u\r   registered : %@\r   last_login : %@\r   last_logout : %@\r   cl_player_id : %@\r   }", self.image, self.userName, (unsigned int)self.exp, (unsigned int)self.level, self.firstName, self.lastName, (unsigned int)self.gender, self.registered, self.lastLogin, self.lastLogout, self.clPlayerId];
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

///--------------------------------------
/// Player
///--------------------------------------
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
    NSString *descriptionString = [NSString stringWithFormat:@"Player Information : {\r   image : %@\r   email : %@\r   userName : %@\r   exp : %u\r   level : %u\r   phone_number : %@\r   first_name : %@\r   last_name : %@\r   gender : %u\r   registered : %@\r   last_login : %@\r   last_logout : %@\r   cl_player_id : %@\r   }", self.image, self.email, self.userName, (unsigned int)self.exp, (unsigned int)self.level, self.phoneNumber, self.firstName, self.lastName, (unsigned int)self.gender, self.registered, self.lastLogin, self.lastLogout, self.clPlayerId];
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

///--------------------------------------
/// PlayerList
///--------------------------------------
@implementation PBPlayerList_Response

@synthesize players;

-(NSString *)description
{
    // create string to hold all players line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"PlayerList : {\r   "];
    
    for(PBPlayer_Response *player in self.players)
    {
        // get description line from each player
        NSString *playerLine = [player description];
        // append \r
        NSString *playerLineWithCR = [NSString stringWithFormat:@"%@\r", playerLine];
        
        // append to result 'lines'
        [lines appendString:playerLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBPlayerList_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse
{
    if(jsonResponse == nil)
        return nil;
    
    // get 'response'
    NSDictionary *response = [jsonResponse objectForKey:@"response"];
    NSAssert(response != nil, @"response must not be nil");
    
    // get array of 'player'
    NSArray *players = [response objectForKey:@"player"];
    NSAssert(response != nil, @"player must not be nil");
    
    // create an empty array to add each player into it
    NSMutableArray *playerArray = [NSMutableArray array];
    
    // iterate through all the players, add add into result array
    for(NSDictionary *player in players)
    {
        // create a player object
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
        
        // add to temporary array
        [playerArray addObject:c];
    }
    
    // create a result playerList object
    PBPlayerList_Response *playerList = [[PBPlayerList_Response alloc] init];
    // add a player into an array
    playerList.players = [NSArray arrayWithArray:playerArray];
    
    return playerList;
}

@end

///--------------------------------------
/// PlayerDetailPublic
///--------------------------------------
@implementation PBPlayerDetailPublic_Response

@synthesize playerPublic;

-(NSString *)description
{
    
}

+(PBPlayerList_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse
{
    
}

@end

///--------------------------------------
/// Point - No Resposne
///--------------------------------------
@implementation PBPoint

@synthesize rewardId;
@synthesize rewardName;
@synthesize value;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Point : {\r   reward_id : %@\r   reward_name : %@\r   value : %u\r   }", self.rewardId, self.rewardName, (unsigned int)self.value];
    
    return descriptionString;
}

@end

///--------------------------------------
/// Point
///--------------------------------------
@implementation PBPoint_Response

@synthesize points;

-(NSString *)description
{
    // create string to hold all players line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Point : {\r   "];
    
    for(PBPoint *point in self.points)
    {
        // get description line from each point
        NSString *pointLine = [point description];
        // append \r
        NSString *pointLineWithCR = [NSString stringWithFormat:@"%@\r", pointLine];
        
        // append to result 'lines'
        [lines appendString:pointLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBPoint_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse
{
    if(jsonResponse == nil)
        return nil;
    
    // get 'response'
    NSDictionary *response = [jsonResponse objectForKey:@"response"];
    NSAssert(response != nil, @"response must not be nil");
    
    // crate a temporary array to hold all points
    NSMutableArray *tempPoints = [NSMutableArray array];
    
    // get 'points'
    NSArray *points = [response objectForKey:@"point"];
    for(NSDictionary *point in points)
    {
        // create a point object
        PBPoint *pObj = [[PBPoint alloc] init];
        pObj.rewardId = [point objectForKey:@"reward_id"];
        pObj.value = [[point objectForKey:@"value"] unsignedIntegerValue];
        pObj.rewardName = [point objectForKey:@"reward_name"];
        
        // add it into temp array
        [tempPoints addObject:pObj];
    }
    
    // create a result response
    PBPoint_Response *result = [[PBPoint_Response alloc] init];
    
    // set to NSArray
    result.points = [NSArray arrayWithArray:tempPoints];
    
    return result;
}

@end
