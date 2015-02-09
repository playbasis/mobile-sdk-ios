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
/// Base - Response
/// Additional interface for private methods
///--------------------------------------
@interface PBBase_Response ()

/**
 Do not use this property.
 It's used internally for convenience in parsing json-response.
 */
@property (strong, nonatomic) NSDictionary *parseLevelJsonResponse;

@end

@implementation PBBase_Response

@synthesize parseLevelJsonResponse;

@end

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

+(PBAuth_Response*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil)
        return nil;
    
    // create a result response
    PBAuth_Response *c = [[PBAuth_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        c.parseLevelJsonResponse = response;
    }

    // set token
    c.token = [c.parseLevelJsonResponse objectForKey:@"token"];
    
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.dateExpire = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"date_expire"]];
    
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

+(PBPlayerPublic_Response*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil)
        return nil;
    
    // create a result response
    PBPlayerPublic_Response *c = [[PBPlayerPublic_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'player'
        NSDictionary *player = [response objectForKey:@"player"];
        NSAssert(response != nil, @"player must not be nil");
        
        c.parseLevelJsonResponse = player;
    }
    
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    c.userName = [c.parseLevelJsonResponse objectForKey:@"username"];
    c.exp = [[c.parseLevelJsonResponse objectForKey:@"exp"] unsignedIntegerValue];
    c.level = [[c.parseLevelJsonResponse objectForKey:@"level"] unsignedIntegerValue];
    c.firstName = [c.parseLevelJsonResponse objectForKey:@"first_name"];
    c.lastName = [c.parseLevelJsonResponse objectForKey:@"last_name"];
    c.gender = [[c.parseLevelJsonResponse objectForKey:@"gender"] unsignedIntegerValue];
    
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.registered = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"registered"]];
    c.lastLogin = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"last_login"]];
    c.lastLogout = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"last_logout"]];
    
    c.clPlayerId = [c.parseLevelJsonResponse objectForKey:@"cl_player_id"];
    
    return c;
}

@end

///--------------------------------------
/// Player
///--------------------------------------
@implementation PBPlayer_Response

@synthesize playerPublic;
@synthesize email;
@synthesize phoneNumber;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Player Information : {\r   image : %@\r   email : %@\r   userName : %@\r   exp : %u\r   level : %u\r   phone_number : %@\r   first_name : %@\r   last_name : %@\r   gender : %u\r   registered : %@\r   last_login : %@\r   last_logout : %@\r   cl_player_id : %@\r   }", self.playerPublic.image, self.email, self.playerPublic.userName, (unsigned int)self.playerPublic.exp, (unsigned int)self.playerPublic.level, self.phoneNumber, self.playerPublic.firstName, self.playerPublic.lastName, (unsigned int)self.playerPublic.gender, self.playerPublic.registered, self.playerPublic.lastLogin, self.playerPublic.lastLogout, self.playerPublic.clPlayerId];
    return descriptionString;
}

+(PBPlayer_Response*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil)
        return nil;
    
    // create a result response
    PBPlayer_Response *c = [[PBPlayer_Response alloc] init];
    
    // if it starts from the final level, then copy the json-response right away
    if(startFromFinalLevel)
    {
        // set the parsing level
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'player'
        NSDictionary *player = [response objectForKey:@"player"];
        NSAssert(response != nil, @"player must not be nil");
        
        // set the parsing level
        c.parseLevelJsonResponse = player;
    }
    
    c.email = [c.parseLevelJsonResponse objectForKey:@"email"];
    c.phoneNumber = [c.parseLevelJsonResponse objectForKey:@"phone_number"];
    
    // parse player's public info
    PBPlayerPublic_Response *playerPublic = [PBPlayerPublic_Response parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    // set player's public info to this response
    c.playerPublic = playerPublic;
    
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

+(PBPlayerList_Response*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil)
        return nil;
    
    // create a result playerList object
    PBPlayerList_Response *playerList = [[PBPlayerList_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        playerList.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get array of 'player'
        NSDictionary *players = [response objectForKey:@"player"];
        NSAssert(response != nil, @"player must not be nil");
        
        playerList.parseLevelJsonResponse = players;
    }
    
    // convert the final level into array
    NSArray *players = (NSArray*)playerList.parseLevelJsonResponse;
    
    // create an empty array to add each player into it
    NSMutableArray *playerArray = [NSMutableArray array];
    
    // iterate through all the players, add add into result array
    for(NSDictionary *player in players)
    {
        // create a player object
        PBPlayer_Response *c = [PBPlayer_Response parseFromDictionary:player startFromFinalLevel:YES];
        
        // add to temporary array
        [playerArray addObject:c];
    }

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

+(PBPlayerDetailPublic_Response*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
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

+(PBPoint*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil)
        return nil;
    
    // create a result object
    PBPoint *c = [[PBPoint alloc] init];
    
    // ignore the 'startFromFinalLevel' flag
    // its appearance won't appear anywhere as a single entity to parse
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    c.rewardId = [c.parseLevelJsonResponse objectForKey:@"reward_id"];
    c.value = [[c.parseLevelJsonResponse objectForKey:@"value"] unsignedIntegerValue];
    c.rewardName = [c.parseLevelJsonResponse objectForKey:@"reward_name"];
    
    return c;
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

+(PBPoint_Response*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil)
        return nil;
    
    // create a result response
    PBPoint_Response *c = [[PBPoint_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        c.parseLevelJsonResponse = response;
    }
    
    // crate a temporary array to hold all points
    NSMutableArray *tempPoints = [NSMutableArray array];
    
    // get 'points'
    NSArray *points = [c.parseLevelJsonResponse objectForKey:@"point"];
    for(NSDictionary *point in points)
    {
        // create a point object
        PBPoint *pObj = [PBPoint parseFromDictionary:point startFromFinalLevel:YES];
        
        // add it into temp array
        [tempPoints addObject:pObj];
    }
    
    // set to NSArray
    c.points = [NSArray arrayWithArray:tempPoints];
    
    return c;
}

@end
