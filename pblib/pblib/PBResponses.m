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
    NSString *descriptionString = [NSString stringWithFormat:@"Auth : {\r\ttoken : %@\r\tdate_expire : %@\r\t}", self.token, self.dateExpire];
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
    NSString *descriptionString = [NSString stringWithFormat:@"Player's Public Information : {\r\timage : %@\r\tuserName : %@\r\texp : %lu\r\tlevel : %lu\r\tfirst_name : %@\r\tlast_name : %@\r\tgender : %lu\r\tregistered : %@\r\tlast_login : %@\r\tlast_logout : %@\r\tcl_player_id : %@\r\t}", self.image, self.userName, (unsigned long)self.exp, (unsigned long)self.level, self.firstName, self.lastName, (unsigned long)self.gender, self.registered, self.lastLogin, self.lastLogout, self.clPlayerId];
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
    NSString *descriptionString = [NSString stringWithFormat:@"Player Information : {\r\timage : %@\r\temail : %@\r\tuserName : %@\r\texp : %u\r\tlevel : %u\r\tphone_number : %@\r\tfirst_name : %@\r\tlast_name : %@\r\tgender : %u\r\tregistered : %@\r\tlast_login : %@\r\tlast_logout : %@\r\tcl_player_id : %@\r\t}", self.playerPublic.image, self.email, self.playerPublic.userName, (unsigned int)self.playerPublic.exp, (unsigned int)self.playerPublic.level, self.phoneNumber, self.playerPublic.firstName, self.playerPublic.lastName, (unsigned int)self.playerPublic.gender, self.playerPublic.registered, self.playerPublic.lastLogin, self.playerPublic.lastLogout, self.playerPublic.clPlayerId];
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
    NSMutableString *lines = [NSMutableString stringWithString:@"PlayerList : {"];
    
    for(PBPlayer_Response *player in self.players)
    {
        // get description line from each player
        NSString *playerLine = [player description];
        // append \r
        NSString *playerLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", playerLine];
        
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
    NSString *descriptionString = [NSString stringWithFormat:@"Point : {\r\treward_id : %@\r\treward_name : %@\r\tvalue : %lu\r\t}", self.rewardId, self.rewardName, (unsigned long)self.value];
    
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
    NSMutableString *lines = [NSMutableString stringWithString:@"Point : {"];
    
    for(PBPoint *point in self.points)
    {
        // get description line from each point
        NSString *pointLine = [point description];
        // append \r
        NSString *pointLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", pointLine];
        
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

///--------------------------------------
/// PBPlayerBadge - No Response
///--------------------------------------
@implementation PBPlayerBadge

@synthesize badgeId;
@synthesize redeemed;
@synthesize claimed;
@synthesize image;
@synthesize name;
@synthesize description;
@synthesize amount;
@synthesize hint;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Badge : {\r\tbadge_id : %@\r\tredeemed : %@\r\tclaimed : %@\r\timage : %@\r\tname : %@\r\tdescription : %@\r\tamount : %lu\r\thint : %@\r\t}", self.badgeId, self.redeemed ? @"YES" : @"NO", self.claimed ? @"YES" : @"NO", self.image, self.name, self.description_, (unsigned long)self.amount, self.hint];
    
    return descriptionString;
}

+(PBPlayerBadge *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil)
        return nil;
    
    // create a result object
    PBPlayerBadge *c = [[PBPlayerBadge alloc] init];
    
    // ignore parsing level flag as it won't be appeared anywhere singlely
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    c.badgeId = [c.parseLevelJsonResponse objectForKey:@"badge_id"];
    c.redeemed = [[c.parseLevelJsonResponse objectForKey:@"redeemed"] boolValue];
    c.claimed = [[c.parseLevelJsonResponse objectForKey:@"claimed"] boolValue];
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    c.name = [c.parseLevelJsonResponse objectForKey:@"name"];
    c.description_ = [c.parseLevelJsonResponse objectForKey:@"description"];
    c.amount = [[c.parseLevelJsonResponse objectForKey:@"amount"] unsignedIntegerValue];
    c.hint = [c.parseLevelJsonResponse objectForKey:@"hint"];
    
    return c;
}

@end

///--------------------------------------
/// PlayerBadge
///--------------------------------------
@implementation PBPlayerBadge_Response

@synthesize badges;

-(NSString *)description
{
    // create string to hold all players line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Badges : {"];
    
    for(PBPlayerBadge *badge in self.badges)
    {
        // get description line from each player-badge
        NSString *pbadgeLine = [badge description];
        // append \r
        NSString *pbadgeLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", pbadgeLine];
        
        // append to result 'lines'
        [lines appendString:pbadgeLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBPlayerBadge_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil)
        return nil;
    
    // create a result
    PBPlayerBadge_Response *c = [[PBPlayerBadge_Response alloc] init];
    
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
    
    // convert response to NSArray*
    NSArray *badges = (NSArray*)c.parseLevelJsonResponse;
    // create a temp array to hold all badges
    NSMutableArray *tempBadges = [NSMutableArray array];
    
    for(NSDictionary *badge in badges)
    {
        // get badge
        PBPlayerBadge *pb = [PBPlayerBadge parseFromDictionary:badge startFromFinalLevel:YES];
        
        // add into temp array
        [tempBadges addObject:pb];
    }
    
    // set back badges
    c.badges = [NSArray arrayWithArray:tempBadges];
    
    return c;
}

@end
