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
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
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
/// Player Info Basic
///--------------------------------------
@implementation PBPlayerBasic : PBBase_Response

@synthesize image;
@synthesize userName;
@synthesize exp;
@synthesize level;
@synthesize firstName;
@synthesize lastName;
@synthesize gender;
@synthesize clPlayerId;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Player's Basic Information : {\r\timage : %@\r\tuserName : %@\r\texp : %lu\r\tlevel : %lu\r\tfirst_name : %@\r\tlast_name : %@\r\tgender : %lu\r\tcl_player_id : %@\r\t}", self.image, self.userName, (unsigned long)self.exp, (unsigned long)self.level, self.firstName, self.lastName, (unsigned long)self.gender, self.clPlayerId];
    
    return descriptionString;
}

+(PBPlayerBasic*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBPlayerBasic *c = [[PBPlayerBasic alloc] init];
    
    // ignore start level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    c.userName = [c.parseLevelJsonResponse objectForKey:@"username"];
    c.exp = [[c.parseLevelJsonResponse objectForKey:@"exp"] unsignedIntegerValue];
    c.level = [[c.parseLevelJsonResponse objectForKey:@"level"] unsignedIntegerValue];
    c.firstName = [c.parseLevelJsonResponse objectForKey:@"first_name"];
    c.lastName = [c.parseLevelJsonResponse objectForKey:@"last_name"];
    c.gender = [[c.parseLevelJsonResponse objectForKey:@"gender"] unsignedIntegerValue];
    c.clPlayerId = [c.parseLevelJsonResponse objectForKey:@"cl_player_id"];
    
    return c;
}

@end

///--------------------------------------
/// PlayerPublic
///--------------------------------------
@implementation PBPlayerPublic_Response

@synthesize playerBasic;
@synthesize registered;
@synthesize lastLogin;
@synthesize lastLogout;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Player's Public Information : {\r\t%@\r\tregistered : %@\r\tlast_login : %@\r\tlast_logout : %@\r\t}", self.playerBasic, self.registered, self.lastLogin, self.lastLogout];
    return descriptionString;
}

+(PBPlayerPublic_Response*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
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
    
    // parse player's basic information
    c.playerBasic = [PBPlayerBasic parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.registered = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"registered"]];
    c.lastLogin = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"last_login"]];
    c.lastLogout = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"last_logout"]];
    
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
    NSString *descriptionString = [NSString stringWithFormat:@"Player : {\r\t%@\r\temail : %@\r\tphoneNumber : %@\r\t}", self.playerPublic, self.email, self.phoneNumber];
    
    return descriptionString;
}

+(PBPlayer_Response*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
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
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
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
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
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

@synthesize point;

-(NSString *)description
{
    // create string to hold all players line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Point : {"];
    
    for(PBPoint *p in self.point)
    {
        // get description line from each point
        NSString *pointLine = [p description];
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
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
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
        
        // get 'point'
        NSDictionary *point = [response objectForKey:@"point"];
        NSAssert(point != nil, @"point must not be nil");
        
        c.parseLevelJsonResponse = point;
    }
    
    // crate a temporary array to hold all points
    NSMutableArray *tempPoints = [NSMutableArray array];
    
    // convert 'point' json to array
    NSArray *points = (NSArray*)c.parseLevelJsonResponse;
    for(NSDictionary *point in points)
    {
        // create a point object
        PBPoint *pObj = [PBPoint parseFromDictionary:point startFromFinalLevel:YES];
        
        // add it into temp array
        [tempPoints addObject:pObj];
    }
    
    // set to NSArray
    c.point = [NSArray arrayWithArray:tempPoints];
    
    return c;
}

@end

///--------------------------------------
/// Points
///--------------------------------------
@implementation PBPoints_Response

@synthesize points;

-(NSString *)description
{
    // create string to hold all players line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Points : {"];
    
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

+(PBPoints_Response*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBPoints_Response *c = [[PBPoints_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'points'
        NSDictionary *points = [response objectForKey:@"points"];
        NSAssert(points != nil, @"points must not be nil");
        
        c.parseLevelJsonResponse = points;
    }
    
    // crate a temporary array to hold all points
    NSMutableArray *tempPoints = [NSMutableArray array];
    
    // convert 'points' to array
    NSArray *points = (NSArray*)c.parseLevelJsonResponse;
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
/// Badge
///--------------------------------------
@implementation PBBadge_Response

@synthesize badgeId;
@synthesize image;
@synthesize sortOrder;
@synthesize name;
@synthesize description_;
@synthesize hint;
@synthesize sponsor;
@synthesize claim;
@synthesize redeem;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Badge : {\r\tbadge_id : %@\r\timage : %@\r\tsort_order : %lu\r\tname : %@\r\tdescription : %@\r\thint : %@\r\tsponsor : %@\r\tclaim : %@\r\tredeem : %@\r\t}", self.badgeId, self.image, (unsigned long)self.sortOrder, self.name, self.description_, self.hint, self.sponsor ? @"YES" : @"NO", self.claim ? @"YES" : @"NO", self.redeem ? @"YES" : @"NO"];
    
    return descriptionString;
}

+(PBBadge_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBBadge_Response *c = [[PBBadge_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'badge'
        NSDictionary *badge = [response objectForKey:@"badge"];
        NSAssert(badge != nil, @"badge must not be nil");
        
        c.parseLevelJsonResponse = badge;
    }
    
    c.badgeId = [c.parseLevelJsonResponse objectForKey:@"badge_id"];
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    c.sortOrder = [[c.parseLevelJsonResponse objectForKey:@"sort_order"] unsignedIntegerValue];
    c.name = [c.parseLevelJsonResponse objectForKey:@"name"];
    c.description_ = [c.parseLevelJsonResponse objectForKey:@"description"];
    c.hint = [c.parseLevelJsonResponse objectForKey:@"hint"];
    c.sponsor = [[c.parseLevelJsonResponse objectForKey:@"sponsor"] boolValue];
    c.claim = [[c.parseLevelJsonResponse objectForKey:@"claim"] boolValue];
    c.redeem = [[c.parseLevelJsonResponse objectForKey:@"redeem"] boolValue];
    
    return c;
}

@end

///--------------------------------------
/// Badges
///--------------------------------------
@implementation PBBadges_Response

@synthesize badges;

-(NSString *)description
{
    // create string to hold all badges line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Badges : {"];
    
    for(PBBadge_Response *badge in self.badges)
    {
        // get description line from each player-badge
        NSString *badgeLine = [badge description];
        // append \r
        NSString *badgeLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", badgeLine];
        
        // append to result 'lines'
        [lines appendString:badgeLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBBadges_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result response
    PBBadges_Response *c = [[PBBadges_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'badges'
        NSDictionary *badges = [response objectForKey:@"badges"];
        NSAssert(badges != nil, @"badges must not be nil");
        
        c.parseLevelJsonResponse = badges;
    }
    
    // convert 'badges' into array
    NSArray *badgeArray = (NSArray*)c.parseLevelJsonResponse;
    
    // temporary array to hold badges
    NSMutableArray *tempBadges = [NSMutableArray array];
    
    for(NSDictionary *badge in badgeArray)
    {
        // get badge
        PBBadge_Response *b = [PBBadge_Response parseFromDictionary:badge startFromFinalLevel:YES];
        
        // add to temp array
        [tempBadges addObject:b];
    }
    
    // set back to itself
    c.badges = [NSArray arrayWithArray:tempBadges];
    
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
    NSString *descriptionString = [NSString stringWithFormat:@"Player Badge : {\r\tbadge_id : %@\r\tredeemed : %@\r\tclaimed : %@\r\timage : %@\r\tname : %@\r\tdescription : %@\r\tamount : %lu\r\thint : %@\r\t}", self.badgeId, self.redeemed ? @"YES" : @"NO", self.claimed ? @"YES" : @"NO", self.image, self.name, self.description_, (unsigned long)self.amount, self.hint];
    
    return descriptionString;
}

+(PBPlayerBadge *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
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
@implementation PBPlayerBadges_Response

@synthesize playerBadges;

-(NSString *)description
{
    // create string to hold all players line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Player Badges : {"];
    
    for(PBPlayerBadge *badge in self.playerBadges)
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

+(PBPlayerBadges_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result
    PBPlayerBadges_Response *c = [[PBPlayerBadges_Response alloc] init];
    
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
    
    // set back player-badges
    c.playerBadges = [NSArray arrayWithArray:tempBadges];
    
    return c;
}

@end

///--------------------------------------
/// PlayerDetailedPublic
///--------------------------------------
@implementation PBPlayerDetailedPublic_Response

@synthesize playerPublic;
@synthesize percentOfLevel;
@synthesize levelTitle;
@synthesize levelImage;
@synthesize badges;
@synthesize points;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Player Detailed Public : {\r\t%@\r\tpercent_of_level : %.2f\r\tlevel_title : %@\r\tlevel_image : %@\r\t%@\r\t%@\r\t}", self.playerPublic, self.percentOfLevel, self.levelTitle, self.levelImage, self.badges, self.points];
    
    return descriptionString;
}

+(PBPlayerDetailedPublic_Response*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result response
    PBPlayerDetailedPublic_Response *c = [[PBPlayerDetailedPublic_Response alloc] init];
    
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
        NSAssert(player != nil, @"player must not be nil");
        
        c.parseLevelJsonResponse = player;
    }
    
    // get player's public information
    c.playerPublic = [PBPlayerPublic_Response parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    // get other fields of data
    c.percentOfLevel = [[c.parseLevelJsonResponse objectForKey:@"percent_of_level"] floatValue];
    c.levelTitle = [c.parseLevelJsonResponse objectForKey:@"level_title"];
    c.levelImage = [c.parseLevelJsonResponse objectForKey:@"level_image"];
    
    // get 'badges'
    NSDictionary *badgesJson = [c.parseLevelJsonResponse objectForKey:@"badges"];
    // get badges
    c.badges = [PBPlayerBadges_Response parseFromDictionary:badgesJson startFromFinalLevel:YES];
    
    // get 'points'
    NSDictionary *pointsJson = [c.parseLevelJsonResponse objectForKey:@"points"];
    // get points
    c.points = [PBPoints_Response parseFromDictionary:pointsJson startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// PlayerDetailed
///--------------------------------------
@implementation PBPlayerDetailed_Response

@synthesize player;
@synthesize percentOfLevel;
@synthesize levelTitle;
@synthesize levelImage;
@synthesize badges;
@synthesize points;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Player Detailed : {\r\t%@\r\tpercent_of_level : %.2f\r\tlevel_title : %@\r\tlevel_image : %@\r\t%@\r\t%@\r\t}", self.player, self.percentOfLevel, self.levelTitle, self.levelImage, self.badges, self.points];
    
    return descriptionString;
}

+(PBPlayerDetailed_Response*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result response
    PBPlayerDetailed_Response *c = [[PBPlayerDetailed_Response alloc] init];
    
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
        NSAssert(player != nil, @"player must not be nil");
        
        c.parseLevelJsonResponse = player;
    }
    
    // get player's information
    c.player = [PBPlayer_Response parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    // get other fields of data
    c.percentOfLevel = [[c.parseLevelJsonResponse objectForKey:@"percent_of_level"] floatValue];
    c.levelTitle = [c.parseLevelJsonResponse objectForKey:@"level_title"];
    c.levelImage = [c.parseLevelJsonResponse objectForKey:@"level_image"];
    
    // get 'badges'
    NSDictionary *badgesJson = [c.parseLevelJsonResponse objectForKey:@"badges"];
    // get badges
    c.badges = [PBPlayerBadges_Response parseFromDictionary:badgesJson startFromFinalLevel:YES];
    
    // get 'points'
    NSDictionary *pointsJson = [c.parseLevelJsonResponse objectForKey:@"points"];
    // get points
    c.points = [PBPoints_Response parseFromDictionary:pointsJson startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// PointHistory - No Response
///--------------------------------------
@implementation PBPointHistory

@synthesize message;
@synthesize rewardId;
@synthesize rewardName;
@synthesize value;
@synthesize dateAdded;
@synthesize actionName;
@synthesize stringFilter;
@synthesize actionIcon;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"PointHistory (single) : {\r\tmessage : %@\r\treward_id : %@\r\treward_name : %@\r\tvalue : %lu\r\tdate_added : %@\r\taction_name : %@\r\tstring_filter : %@\r\taction_icon : %@\r\t}", self.message, self.rewardId, self.rewardName, (unsigned long)self.value, self.dateAdded, self.actionName, self.stringFilter, self.actionIcon];
    
    return descriptionString;
}

+(PBPointHistory *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result response
    PBPointHistory *c = [[PBPointHistory alloc] init];
    
    // ignore json level flag, because it doesn't appear anywhere singlely
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    c.message = [c.parseLevelJsonResponse objectForKey:@"message"];
    c.rewardId = [c.parseLevelJsonResponse objectForKey:@"reward_id"];
    c.rewardName = [c.parseLevelJsonResponse objectForKey:@"reward_name"];
    c.value = [[c.parseLevelJsonResponse objectForKey:@"value"] unsignedIntegerValue];
    
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.dateAdded = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"date_added"]];
    
    c.actionName = [c.parseLevelJsonResponse objectForKey:@"action_name"];
    c.stringFilter = [c.parseLevelJsonResponse objectForKey:@"string_filter"];
    c.actionIcon = [c.parseLevelJsonResponse objectForKey:@"action_icon"];
    
    return c;
}

@end

///--------------------------------------
/// PointHistory
///--------------------------------------
@implementation PBPointHistory_Response

@synthesize pointHistory;

-(NSString *)description
{
    // create string to hold all point-history line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Point History : {"];
    
    for(PBPointHistory *ph in self.pointHistory)
    {
        // get description line from each player-badge
        NSString *pointHistoryLine = [ph description];
        // append \r
        NSString *pointHistoryLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", pointHistoryLine];
        
        // append to result 'lines'
        [lines appendString:pointHistoryLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBPointHistory_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result response
    PBPointHistory_Response *c = [[PBPointHistory_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'points'
        NSDictionary *points = [response objectForKey:@"points"];
        NSAssert(points != nil, @"points must not be nil");
        
        c.parseLevelJsonResponse = points;
    }
    
    // convert points into array
    NSArray *phArray = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all of point history elements
    NSMutableArray *tempPhArray = [NSMutableArray array];
    
    for(NSDictionary *ph in phArray)
    {
        // get point history
        PBPointHistory *pointHistory = [PBPointHistory parseFromDictionary:ph startFromFinalLevel:YES];
        
        // add to temp array
        [tempPhArray addObject:pointHistory];
    }
    
    // set back to result response
    c.pointHistory = [NSArray arrayWithArray:tempPhArray];
    
    return c;
}

@end

///--------------------------------------
/// Action Last Performed Time
///--------------------------------------
@implementation PBActionLastPerformedTime

@synthesize actionId;
@synthesize actionName;
@synthesize time;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Action Last Performed Time : {\r\taction_id : %@\r\taction_name : %@\r\ttime : %@\r\t}", self.actionId, self.actionName, self.time];
    
    return descriptionString;
}

+(PBActionLastPerformedTime *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBActionLastPerformedTime *c = [[PBActionLastPerformedTime alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.actionId = [c.parseLevelJsonResponse objectForKey:@"action_id"];
    c.actionName = [c.parseLevelJsonResponse objectForKey:@"action_name"];
    
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.time = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"time"]];
    
    return c;
}

@end

///--------------------------------------
/// Action Last Performed Time - Response
///--------------------------------------
@implementation PBActionLastPerformedTime_Response

@synthesize response;

- (NSString *)description
{
    return [self.response description];
}

+(PBActionLastPerformedTime_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBActionLastPerformedTime_Response *c = [[PBActionLastPerformedTime_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'action'
        NSDictionary *action = [response objectForKey:@"action"];
        NSAssert(action != nil, @"action must not be nil");
        
        c.parseLevelJsonResponse = action;
    }
    
    // parse
    c.response = [PBActionLastPerformedTime parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// ActionTime
///--------------------------------------
@implementation PBActionTime_Response

@synthesize actionId;
@synthesize actionName;
@synthesize time;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"ActionTime : {\r\taction_id : %@\r\taction_name : %@\r\ttime : %@\r\t}", self.actionId, self.actionName, self.time];
    
    return descriptionString;
}

+(PBActionTime_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBActionTime_Response *c = [[PBActionTime_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'action'
        NSDictionary *action = [response objectForKey:@"action"];
        NSAssert(action != nil, @"action must not be nil");
        
        c.parseLevelJsonResponse = action;
    }
    
    // parse
    c.actionId = [c.parseLevelJsonResponse objectForKey:@"action_id"];
    c.actionName = [c.parseLevelJsonResponse objectForKey:@"action_name"];
    
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.time = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"time"]];
    
    return c;
}

@end

///--------------------------------------
/// LastAction
///--------------------------------------
@implementation PBLastAction_Response

@synthesize actionId;
@synthesize actionName;
@synthesize time;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Last Action : {\r\taction_id : %@\r\taction_name : %@\r\ttime : %@\r\t}", self.actionId, self.actionName, self.time];
    
    return descriptionString;
}

+(PBLastAction_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBLastAction_Response *c = [[PBLastAction_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'action'
        NSDictionary *action = [response objectForKey:@"action"];
        NSAssert(action != nil, @"action must not be nil");
        
        c.parseLevelJsonResponse = action;
    }
    
    // parse
    c.actionId = [c.parseLevelJsonResponse objectForKey:@"action_id"];
    c.actionName = [c.parseLevelJsonResponse objectForKey:@"action_name"];
    
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.time = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"time"]];
    
    return c;
}

@end

///--------------------------------------
/// ActionCount
///--------------------------------------
@implementation PBActionCount_Response

@synthesize actionId;
@synthesize actionName;
@synthesize count;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Action Count : {\r\taction_id : %@\r\taction_name : %@\r\tcount : %lu\r\t}", self.actionId, self.actionName, (unsigned long)self.count];
    
    return descriptionString;
}

+(PBActionCount_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBActionCount_Response *c = [[PBActionCount_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'action'
        NSDictionary *action = [response objectForKey:@"action"];
        NSAssert(action != nil, @"action must not be nil");
        
        c.parseLevelJsonResponse = action;
    }
    
    // parse
    c.actionId = [c.parseLevelJsonResponse objectForKey:@"action_id"];
    c.actionName = [c.parseLevelJsonResponse objectForKey:@"action_name"];
    c.count = [[c.parseLevelJsonResponse objectForKey:@"count"] unsignedIntegerValue];
    
    return c;
}

@end

///--------------------------------------
/// Level
///--------------------------------------
@implementation PBLevel_Response

@synthesize levelTitle;
@synthesize level;
@synthesize minExp;
@synthesize maxExp;
@synthesize levelImage;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Level : {\r\tlevel_title : %@\r\tlevel = %lu\r\tmin_exp : %lu\r\tmax_exp : %lu\r\tlevel_image : %@\r\t}", self.levelTitle, (unsigned long)self.level, (unsigned long)self.minExp, (unsigned long)self.maxExp, self.levelImage];
    
    return descriptionString;
}

+(PBLevel_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBLevel_Response *c = [[PBLevel_Response alloc] init];
    
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
    
    // parse
    c.levelTitle = [c.parseLevelJsonResponse objectForKey:@"level_title"];
    c.level = [[c.parseLevelJsonResponse objectForKey:@"level"] unsignedIntegerValue];
    c.minExp = [[c.parseLevelJsonResponse objectForKey:@"min_exp"] unsignedIntegerValue];
    id obj = [c.parseLevelJsonResponse objectForKey:@"max_exp"];
    
    if([obj respondsToSelector:@selector(unsignedIntegerValue)])
       c.maxExp = [obj unsignedIntegerValue];
    else
       // TODO: Fix this later, as 'null' value returned can happen
       c.maxExp = NSUIntegerMax;
    
    c.levelImage = [c.parseLevelJsonResponse objectForKey:@"level_image"];
    
    return c;
}

@end

///--------------------------------------
/// Levels
///--------------------------------------
@implementation PBLevels_Response

@synthesize levels;

-(NSString *)description
{
    // create string to hold all level line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Level (single) : {"];
    
    for(PBLevel_Response *level in self.levels)
    {
        // get description line from each player-badge
        NSString *levelLine = [level description];
        // append \r
        NSString *levelLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", levelLine];
        
        // append to result 'lines'
        [lines appendString:levelLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBLevels_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBLevels_Response *c = [[PBLevels_Response alloc] init];
    
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
    
    // convert parsing json into array
    NSArray *levelArray = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all level
    NSMutableArray *tempLevels = [NSMutableArray array];
    
    for(NSDictionary *levelJson in levelArray)
    {
        // get level
        PBLevel_Response *level = [PBLevel_Response parseFromDictionary:levelJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempLevels addObject:level];
    }
    
    // set back array to result response
    c.levels = [NSArray arrayWithArray:tempLevels];
    
    return c;
}

@end

///--------------------------------------
/// Rank - No Response
///--------------------------------------
@implementation PBRank

@synthesize pbPlayerId;
@synthesize playerId;
@synthesize pointType;
@synthesize pointValue;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Rank : {\r\tpb_player_id : %@\r\tplayer_id = %@\r\tpoint_type : %@\r\tpointValue : %lu\r\t}", self.pbPlayerId, self.playerId, self.pointType, (unsigned long)self.pointValue];
    
    return descriptionString;
}

+(PBRank *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBRank *c = [[PBRank alloc] init];
    
    // ignore parse level
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    // get 'pb_player_id'
    NSDictionary *pb_player_id = [c.parseLevelJsonResponse objectForKey:@"pb_player_id"];
    c.pbPlayerId = [pb_player_id objectForKey:@"$id"];
    
    c.playerId = [c.parseLevelJsonResponse objectForKey:@"player_id"];
    
    // get the key to determine point type
    NSArray *keys = [c.parseLevelJsonResponse allKeys];
    
    for(NSString *key in keys)
    {
        if(![key isEqualToString:@"pb_player_id"] &&
           ![key isEqualToString:@"player_id"])
        {
            // set point type
            c.pointType = key;
            
            break;
        }
    }
    
    // get pointValue from pointType we got above
    c.pointValue = [[c.parseLevelJsonResponse objectForKey:c.pointType] unsignedIntegerValue];
    
    return c;
}

@end

///--------------------------------------
/// Rank (only particular point type)
///--------------------------------------
@implementation PBRank_Response

@synthesize ranks;

-(NSString *)description
{
    // create string to hold all rank line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Rank (single) : {"];
    
    for(PBRank *rank in self.ranks)
    {
        // get description line from each player-badge
        NSString *rankLine = [rank description];
        // append \r
        NSString *rankLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", rankLine];
        
        // append to result 'lines'
        [lines appendString:rankLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBRank_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result response
    PBRank_Response *c = [[PBRank_Response alloc] init];
    
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
    
    // convert resposne into array
    NSArray *ranksJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all rank
    NSMutableArray *tempRanks = [NSMutableArray array];
    
    for(NSDictionary *rankJson in ranksJson)
    {
        // get rank object
        PBRank *rank = [PBRank parseFromDictionary:rankJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempRanks addObject:rank];
    }
    
    // set back to result response
    c.ranks = [NSArray arrayWithArray:tempRanks];
    
    return c;
}

@end

///--------------------------------------
/// Rank (for all point types)
///--------------------------------------
@implementation PBRanks_Response

@synthesize rankByKeys;
@synthesize ranks;

-(NSString *)description
{
    // create string to hold all rank line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Ranks by all point types : {"];
    
    for(NSString *rankByKey in self.rankByKeys)
    {
        // append lines with rank-by-key
        [lines appendString:[NSString stringWithFormat:@"\r\tRank by %@\r\t", rankByKey]];
        
        // get ranks array from rankBy key
        NSArray *rankBy = [ranks objectForKey:rankByKey];
        
        // iterate through the rankBy array for all ranks in that rankBy type
        for(PBRank_Response *rank in rankBy)
        {
            // get description line from each player-badge
            NSString *rankLine = [rank description];
            // append \r
            NSString *rankLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", rankLine];
            
            // append to result 'lines'
            [lines appendString:rankLineWithCR];
        }
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBRanks_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result response
    PBRanks_Response *c = [[PBRanks_Response alloc] init];
    
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

    // get all keys from json response
    NSArray *keys = [c.parseLevelJsonResponse allKeys];
    // set rank-by-keys to result response
    c.rankByKeys = keys;
    
    // create temp dictionary to hold for all array populated
    NSMutableDictionary *tempRanksDict = [NSMutableDictionary dictionary];
    
    // iterate through all keys, and parse them for each rankBy type
    for(NSString *rankByKey in keys)
    {
        // get array of that rank-by-key
        NSDictionary *ranksJson = [c.parseLevelJsonResponse objectForKey:rankByKey];
        
        // temp array to hold all ranks for this rank-by-key
        NSMutableArray *tempRanks = [NSMutableArray array];
        
        // get ranks object
        PBRank_Response *rank = [PBRank_Response parseFromDictionary:ranksJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempRanks addObject:rank];
        
        // set back to result response
        [tempRanksDict setValue:[NSArray arrayWithArray:tempRanks] forKey:rankByKey];
    }
    
    // set back dictionary ranks to result response
    c.ranks = [NSDictionary dictionaryWithDictionary:tempRanksDict];
    
    return c;
}

@end

///--------------------------------------
/// Custom - No Response
///--------------------------------------
@implementation PBCustom

@synthesize customId;
@synthesize customName;
@synthesize customValue;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Custom : {\r\tcustom_id : %@\r\tcustom_name : %@\r\tcustom_value : %lu\r\t}", self.customId, self.customName, (unsigned long)self.customValue];
    
    return descriptionString;
}

+(PBCustom *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result response
    PBCustom *c = [[PBCustom alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.customId = [c.parseLevelJsonResponse objectForKey:@"custom_id"];
    c.customName = [c.parseLevelJsonResponse objectForKey:@"custom_name"];
    c.customValue = [[c.parseLevelJsonResponse objectForKey:@"custom_value"] unsignedIntegerValue];
    
    return c;
}

@end

///--------------------------------------
/// Custom - Array
///--------------------------------------
@implementation PBCustoms

@synthesize customs;

-(NSString *)description
{
    // create string to hold all custom line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Customs : {"];
    
    for(PBCustom *custom in self.customs)
    {
        // get description line from each player-badge
        NSString *customLine = [custom description];
        // append \r
        NSString *customLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", customLine];
        
        // append to result 'lines'
        [lines appendString:customLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBCustoms *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBCustoms *c = [[PBCustoms alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert json data to array
    NSArray *customsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all customs
    NSMutableArray *tempCustoms = [NSMutableArray array];
    
    for(NSDictionary *customJson in customsJson)
    {
        // get custom
        PBCustom *custom = [PBCustom parseFromDictionary:customJson startFromFinalLevel:YES];
        
        // add to array
        [tempCustoms addObject:custom];
    }
    
    // set back to result response
    c.customs = [NSArray arrayWithArray:tempCustoms];
    
    // parse
    return c;
}

@end

///--------------------------------------
/// Redeem
///--------------------------------------
@implementation PBRedeem

@synthesize pointValue;
@synthesize customs;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Redeem : {\r\tpoint_value = %lu\r\t%@\r\t}", (unsigned long)self.pointValue, self.customs];
    
    return descriptionString;
}

+(PBRedeem *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBRedeem *c = [[PBRedeem alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    // get 'point'
    NSDictionary *pointJson = [c.parseLevelJsonResponse objectForKey:@"point"];
    c.pointValue = [[pointJson objectForKey:@"point_value"] unsignedIntegerValue];
    c.customs = [PBCustoms parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"custom"] startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// Goods
///--------------------------------------
@implementation PBGoods

@synthesize goodsId;
@synthesize quantity;
@synthesize image;
@synthesize sortOrder;
@synthesize name;
@synthesize description_;
@synthesize redeem;
@synthesize code;
@synthesize sponsor;
@synthesize dateStart;
@synthesize dateExpire;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Goods : {\r\tgoods_id : %@\r\tquantity : %lu\r\timage : %@\r\tsort_order : %lu\r\tname : %@\r\tdescription : %@\r\tredeem : %@\r\tcode : %@\r\tsponsor : %@\r\tdate_start : %@\r\tdate_expire : %@\r\t}", self.goodsId, (unsigned long)self.quantity, self.image, (unsigned long)self.sortOrder, self.name, self.description_, self.redeem, self.code, self.sponsor ? @"YES" : @"NO", self.dateStart, self.dateExpire];
    
    return descriptionString;
}

+(PBGoods *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBGoods *c = [[PBGoods alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.goodsId = [c.parseLevelJsonResponse objectForKey:@"goods_id"];
    id q = [c.parseLevelJsonResponse objectForKey:@"quantity"];
    if([q respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.quantity = [q unsignedIntegerValue];
    }
    
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    c.sortOrder = [[c.parseLevelJsonResponse objectForKey:@"sort_order"] unsignedIntegerValue];
    c.name = [c.parseLevelJsonResponse objectForKey:@"name"];
    c.description_ = [c.parseLevelJsonResponse objectForKey:@"description"];
    
    // populate redeem object
    c.redeem = [PBRedeem parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"redeem"] startFromFinalLevel:YES];
    
    c.code = [c.parseLevelJsonResponse objectForKey:@"code"];
    c.sponsor = [[c.parseLevelJsonResponse objectForKey:@"sponsor"] boolValue];
    
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.dateStart = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"date_start"]];
    c.dateExpire = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"date_expire"]];
    
    return c;
}

@end

///--------------------------------------
/// Goods Info
///--------------------------------------
@implementation PBGoodsInfo_Response

@synthesize goods;
@synthesize perUser;
@synthesize isGroup;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Goods Info : {\r\t%@\r\t per_user : %lu\r\tis_group : %@\r\t}", self.goods, (unsigned long)self.perUser, self.isGroup ? @"YES" : @"NO"];
    
    return descriptionString;
}

+(PBGoodsInfo_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBGoodsInfo_Response *c = [[PBGoodsInfo_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'goods'
        NSDictionary *goods = [response objectForKey:@"goods"];
        NSAssert(goods != nil, @"goods must not be nil");
        
        c.parseLevelJsonResponse = goods;
    }
    
    // parse
    c.goods = [PBGoods parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    id perUser = [c.parseLevelJsonResponse objectForKey:@"per_user"];
    if([perUser respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.perUser = [perUser unsignedIntegerValue];
    }
    c.isGroup = [[c.parseLevelJsonResponse objectForKey:@"is_group"] boolValue];
    
    return c;
}

@end

///--------------------------------------
/// Goods List Info
///--------------------------------------
@implementation PBGoodsListInfo_Response

@synthesize goodsList;

-(NSString *)description
{
    // create string to hold all goods line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Goods List : {"];
    
    for(PBGoods *goods in self.goodsList)
    {
        // get description line from each player-badge
        NSString *goodsLine = [goods description];
        // append \r
        NSString *goodsLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", goodsLine];
        
        // append to result 'lines'
        [lines appendString:goodsLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBGoodsListInfo_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBGoodsListInfo_Response *c = [[PBGoodsListInfo_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'goods_list'
        NSDictionary *goods_list = [response objectForKey:@"goods_list"];
        NSAssert(goods_list != nil, @"goods_list must not be nil");
        
        c.parseLevelJsonResponse = goods_list;
    }
    
    // convert from goods_list into array
    NSArray *goodsListJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all goods
    NSMutableArray *tempGoodsList = [NSMutableArray array];
    
    for(NSDictionary *goodsJson in goodsListJson)
    {
        // get goods
        PBGoods *goods = [PBGoods parseFromDictionary:goodsJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempGoodsList addObject:goods];
    }
    
    // set back to response
    c.goodsList = [NSArray arrayWithArray:tempGoodsList];
    
    return c;
}

@end

///--------------------------------------
/// Goods Group Available
///--------------------------------------
@implementation PBGoodsGroupAvailable_Response

@synthesize available;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Goods Group Available : %lu", (unsigned long)self.available];
    
    return descriptionString;
}

+(PBGoodsGroupAvailable_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBGoodsGroupAvailable_Response *c = [[PBGoodsGroupAvailable_Response alloc] init];
    
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
    
    // convert from json into unsigned integer
    NSUInteger goodsGroupAvailable = [((id)c.parseLevelJsonResponse) unsignedIntegerValue];
    
    c.available = goodsGroupAvailable;
    
    return c;
}

@end

///--------------------------------------
/// Player Goods Owned - No Response
///--------------------------------------
@implementation PBPlayerGoodsOwned

@synthesize goodsId;
@synthesize image;
@synthesize name;
@synthesize description_;
@synthesize amount;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Player Goods Owned : {\r\tgoods_id : %@\r\timage : %@\r\tname : %@\r\tdescription : %@\r\tamount : %lu\r\t}", self.goodsId, self.image, self.name, self.description_, (unsigned long)self.amount];
    
    return descriptionString;
}

+(PBPlayerGoodsOwned *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBPlayerGoodsOwned *c = [[PBPlayerGoodsOwned alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.goodsId = [c.parseLevelJsonResponse objectForKey:@"goods_id"];
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    c.name = [c.parseLevelJsonResponse objectForKey:@"name"];
    c.description_ = [c.parseLevelJsonResponse objectForKey:@"description"];
    
    id amount = [c.parseLevelJsonResponse objectForKey:@"amount"];
    if([amount respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.amount = [amount unsignedIntegerValue];
    }
    
    return c;
}

@end

///--------------------------------------
/// Player Goods Owned
///--------------------------------------
@implementation PBPlayerGoodsOwned_Response

@synthesize goodsOwneds;

-(NSString *)description
{
    // create string to hold all goods line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Player Goods Owneds : {"];
    
    for(PBPlayerGoodsOwned *goodsOwned in self.goodsOwneds)
    {
        // get description line from each player-badge
        NSString *goodsOwnedLine = [goodsOwned description];
        // append \r
        NSString *goodsOwnedLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", goodsOwnedLine];
        
        // append to result 'lines'
        [lines appendString:goodsOwnedLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBPlayerGoodsOwned_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBPlayerGoodsOwned_Response *c = [[PBPlayerGoodsOwned_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'goods'
        NSDictionary *goods = [response objectForKey:@"goods"];
        NSAssert(goods != nil, @"goods must not be nil");
        
        c.parseLevelJsonResponse = goods;
    }
    
    // convert parse json into array
    NSArray *goodsOwnedsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all goods-owned
    NSMutableArray *tempGoodsOwneds = [NSMutableArray array];
    
    for(NSDictionary *goodsOwnedJson in goodsOwnedsJson)
    {
        // get goods-owned
        PBPlayerGoodsOwned *goodsOwned = [PBPlayerGoodsOwned parseFromDictionary:goodsOwnedJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempGoodsOwneds addObject:goodsOwned];
    }
    
    // set back to response
    c.goodsOwneds = [NSArray arrayWithArray:tempGoodsOwneds];
    
    return c;
}

@end

///--------------------------------------
/// Reward
///--------------------------------------
@implementation PBReward

@synthesize rewardValue;
@synthesize rewardType;
@synthesize rewardId;
@synthesize rewardName;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Reward : {\r\treward_value : %@\r\treward_type : %@\r\treward_id : %@\r\treward_data.name : %@\r\t}", self.rewardValue, self.rewardType, self.rewardId, self.rewardName];
    
    return descriptionString;
}

+(PBReward *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBReward *c = [[PBReward alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.rewardValue = [c.parseLevelJsonResponse objectForKey:@"reward_value"];
    c.rewardType = [c.parseLevelJsonResponse objectForKey:@"reward_type"];
    c.rewardId = [c.parseLevelJsonResponse objectForKey:@"reward_id"];
    
    NSDictionary *rewardData = [c.parseLevelJsonResponse objectForKey:@"reward_data"];
    c.rewardName = [rewardData objectForKey:@"name"];
    
    return c;
}

@end

///--------------------------------------
/// QuestReward
///--------------------------------------
@implementation PBQuestReward

@synthesize questId;
@synthesize missionId;
@synthesize rewardValue;
@synthesize rewardType;
@synthesize rewardId;
@synthesize rewardName;
@synthesize dateAdded;
@synthesize dateModified;
@synthesize questName;
@synthesize type;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Quest Reward : {\r\tquest_id : %@\r\tmission_id : %@\r\treward_value : %@\r\treward_type : %@\r\treward_id : %@\r\treward_name : %@\r\tdate_added : %@\r\tdate_modified : %@\r\tquest_name : %@\r\ttype : %@\r\t}", self.questId, self.missionId, self.rewardValue, self.rewardType, self.rewardId, self.rewardName, self.dateAdded, self.dateModified, self.questName, self.type];
    
    return descriptionString;
}

+(PBQuestReward *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuestReward *c = [[PBQuestReward alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.questId = [c.parseLevelJsonResponse objectForKey:@"quest_id"];
    c.missionId = [c.parseLevelJsonResponse objectForKey:@"mission_id"];
    c.rewardValue = [c.parseLevelJsonResponse objectForKey:@"reward_value"];
    c.rewardType = [c.parseLevelJsonResponse objectForKey:@"reward_type"];
    c.rewardId = [c.parseLevelJsonResponse objectForKey:@"reward_id"];
    c.rewardName = [c.parseLevelJsonResponse objectForKey:@"reward_name"];
    
    // parse date field
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.dateAdded = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"date_added"]];
    c.dateModified = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"date_modified"]];
    
    c.questName = [c.parseLevelJsonResponse objectForKey:@"quest_name"];
    c.type = [c.parseLevelJsonResponse objectForKey:@"type"];
    
    return c;
}

@end

///--------------------------------------
/// QuestRewardArray
///--------------------------------------
@implementation PBQuestRewardArray

@synthesize questRewards;

-(NSString *)description
{
    // create string to hold all quest-reward line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Quest Reward : {"];
    
    for(PBQuestReward *item in self.questRewards)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBQuestRewardArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result object
    PBQuestRewardArray *c = [[PBQuestRewardArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert json to array
    NSArray *questRewardsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // create a temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *questRewardJson in questRewardsJson)
    {
        // get quest reward object
        PBQuestReward *questReward = [PBQuestReward parseFromDictionary:questRewardJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:questReward];
    }
    
    // set back to response object
    c.questRewards = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// QuestRewardHistoryOfPlayer
///--------------------------------------
@implementation PBQuestRewardHistoryOfPlayer_Response

@synthesize list;

-(NSString *)description
{
    return [self.list description];
}

+(PBQuestRewardHistoryOfPlayer_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a response
    PBQuestRewardHistoryOfPlayer_Response *c = [[PBQuestRewardHistoryOfPlayer_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'rewards'
        NSDictionary *rewards = [response objectForKey:@"rewards"];
        NSAssert(rewards != nil, @"rewards must not be nil");
        
        c.parseLevelJsonResponse = rewards;
    }
    
    // parse
    c.list = [PBQuestRewardArray parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// Reward Array
///--------------------------------------
@implementation PBRewardArray

@synthesize rewards;

-(NSString *)description
{
    // create string to hold all goods line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Rewards : {"];
    
    for(PBReward *reward in self.rewards)
    {
        // get description line from each player-badge
        NSString *rewardLine = [reward description];
        // append \r
        NSString *rewardLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", rewardLine];
        
        // append to result 'lines'
        [lines appendString:rewardLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBRewardArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result object
    PBRewardArray *c = [[PBRewardArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert input json into array
    NSArray *rewardsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // create a temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *rewardJson in rewardsJson)
    {
        // get reward object
        PBReward *reward = [PBReward parseFromDictionary:rewardJson startFromFinalLevel:YES];
        
        [tempArray addObject:reward];
    }
    
    // set back to result object
    c.rewards = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// Incomplete
///--------------------------------------
@implementation PBIncomplete

@synthesize incompletionId;
@synthesize incompletionType;
@synthesize incompletionValue;
@synthesize incompletionElementId;
@synthesize incompletionFilter;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Incomplete : {\r\tincompletion_id : %@\r\tincompletion_type : %@\r\tincompletion_value : %lu\r\tincompletion_element_id : %@\r\tincompletion_filter : %@\r\t", self.incompletionId, self.incompletionType, (unsigned long)self.incompletionValue, self.incompletionElementId, self.incompletionFilter];
    
    return descriptionString;
}

+(PBIncomplete *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBIncomplete *c = [[PBIncomplete alloc] init];
    
    // ignore parse level
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.incompletionId = [c.parseLevelJsonResponse objectForKey:@"incompletion_id"];
    c.incompletionType = [c.parseLevelJsonResponse objectForKey:@"incompletion_type"];
    
    id incompletionValue = [c.parseLevelJsonResponse objectForKey:@"incompletion_value"];
    if([incompletionValue respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.incompletionValue = [incompletionValue unsignedIntegerValue];
    }
    
    c.incompletionElementId = [c.parseLevelJsonResponse objectForKey:@"incompletion_element_id"];
    c.incompletionFilter = [c.parseLevelJsonResponse objectForKey:@"incompletion_filter"];
    
    return c;
}

@end

///--------------------------------------
/// IncompleteArray
///--------------------------------------
@implementation PBIncompleteArray

@synthesize incompletions;

-(NSString *)description
{
    // create string to hold all incompletion line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Incompletions : {"];
    
    for(PBIncomplete *item in self.incompletions)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBIncompleteArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result object
    PBIncompleteArray *c = [[PBIncompleteArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert input json into array
    NSArray *incompletionsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // create a temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *incompleteJson in incompletionsJson)
    {
        // get incomplete object
        PBIncomplete *incomplete = [PBIncomplete parseFromDictionary:incompleteJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:incomplete];
    }
    
    // set back to result object
    c.incompletions = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// CompletionData
///--------------------------------------
@implementation PBCompletionData

@synthesize actionId;
@synthesize name;
@synthesize description_;
@synthesize icon;
@synthesize color;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Completion Data : {\r\taction_id : %@\r\tname : %@\r\tdescription : %@\r\ticon : %@\r\tcolor : %@\r\t}", self.actionId, self.name, self.description_, self.icon, self.color];
    
    return descriptionString;
}

+(PBCompletionData *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result object
    PBCompletionData *c = [[PBCompletionData alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    c.actionId = [c.parseLevelJsonResponse objectForKey:@"action_id"];
    c.name = [c.parseLevelJsonResponse objectForKey:@"name"];
    c.description_ = [c.parseLevelJsonResponse objectForKey:@"description"];
    c.icon = [c.parseLevelJsonResponse objectForKey:@"icon"];
    c.color = [c.parseLevelJsonResponse objectForKey:@"color"];
    
    return c;
}

@end

///--------------------------------------
/// Completion
///--------------------------------------
@implementation PBCompletion

@synthesize completionFilter;
@synthesize completionValue;
@synthesize completionId;
@synthesize completionType;
@synthesize completionElementId;
@synthesize completionTitle;
@synthesize completionData;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Completion : {\r\tcompletion_filter : %@\r\tcompletion_value : %@\r\tcompletion_id : %@\r\tcompletion_type : %@\r\tcompletion_element_id : %@\r\tcompletion_title : %@\r\t%@\r\t}", self.completionFilter, self.completionValue, self.completionId, self.completionType, self.completionElementId, self.completionTitle, self.completionData];
    
    return descriptionString;
}

+(PBCompletion *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBCompletion *c = [[PBCompletion alloc] init];
    
    // ignore the parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.completionFilter = [c.parseLevelJsonResponse objectForKey:@"completion_filter"];
    c.completionValue = [c.parseLevelJsonResponse objectForKey:@"completion_value"];
    c.completionId = [c.parseLevelJsonResponse objectForKey:@"completion_id"];
    c.completionType = [c.parseLevelJsonResponse objectForKey:@"completion_type"];
    c.completionElementId = [c.parseLevelJsonResponse objectForKey:@"completion_element_id"];
    c.completionTitle = [c.parseLevelJsonResponse objectForKey:@"completion_title"];
    
    c.completionData = [PBCompletionData parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"completion_data"] startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// CompletionArray
///--------------------------------------
@implementation PBCompletionArray

@synthesize completions;

-(NSString *)description
{
    // create string to hold all completion line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Completions : {"];
    
    for(PBCompletion *item in self.completions)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBCompletionArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBCompletionArray *c = [[PBCompletionArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert input json into array
    NSArray *completionsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // create a temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *completionJson in completionsJson)
    {
        // get completion object
        PBCompletion *completion = [PBCompletion parseFromDictionary:completionJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:completion];
    }
    
    // set back to result object
    c.completions = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// Pending
///--------------------------------------
@implementation PBPending

@synthesize eventType;
@synthesize message;
@synthesize incomplete;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Pending : {\r\teventType : %@\r\tmessage : %@\r\t%@\r\t}", self.eventType, self.message, self.incomplete];
    
    return descriptionString;
}

+(PBPending *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBPending *c = [[PBPending alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.eventType = [c.parseLevelJsonResponse objectForKey:@"event_type"];
    c.message = [c.parseLevelJsonResponse objectForKey:@"message"];
    
    c.incomplete = [PBIncomplete parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"incomplete"] startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// PendingArray
///--------------------------------------
@implementation PBPendingArray

@synthesize pendings;

-(NSString *)description
{
    // create string to hold all pending line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Pendings : {"];
    
    for(PBPending *item in self.pendings)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBPendingArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result object
    PBPendingArray *c = [[PBPendingArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert input json into array
    NSArray *pendingsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // create a temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *pendingJson in pendingsJson)
    {
        // get pending object
        PBPending *pending = [PBPending parseFromDictionary:pendingJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:pending];
    }
    
    // set back to result object
    c.pendings = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// MissionBasic
///--------------------------------------
@implementation PBMissionBasic

@synthesize missionName;
@synthesize missionNumber;
@synthesize description_;
@synthesize hint;
@synthesize image;
@synthesize completions;
@synthesize rewards;
@synthesize missionId;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Mission Basic : {\r\tmission_name : %@\r\tmission_number : %lu\r\tdescription : %@\r\thint : %@\r\timage : %@\r\t%@\r\t%@\r\tmission_id : %@\r\t}", self.missionName, (unsigned long)self.missionNumber, self.description_, self.hint, self.image, self.completions, self.rewards, self.missionId];
    
    return descriptionString;
}

+(PBMissionBasic *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBMissionBasic *c = [[PBMissionBasic alloc] init];
    
    // ignore parse level.
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.missionName = [c.parseLevelJsonResponse objectForKey:@"mission_name"];
    c.missionNumber = [c.parseLevelJsonResponse objectForKey:@"mission_number"];
    c.description_ = [c.parseLevelJsonResponse objectForKey:@"description"];
    c.hint = [c.parseLevelJsonResponse objectForKey:@"hint"];
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    c.completions = [PBCompletionArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"completion"] startFromFinalLevel:YES];
    c.rewards = [PBRewardArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"rewards"] startFromFinalLevel:YES];
    c.missionId = [c.parseLevelJsonResponse objectForKey:@"mission_id"];
    
    return c;
}

@end

///--------------------------------------
/// MissionBasicArray
///--------------------------------------
@implementation PBMissionBasicArray

@synthesize missionBasics;

-(NSString *)description
{
    // create string to hold all mission-basic line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"MissionBasics : {"];
    
    for(PBMissionBasic *item in self.missionBasics)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBMissionBasicArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result object
    PBMissionBasicArray *c = [[PBMissionBasicArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert input json into array
    NSArray *missionsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // create a temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *missionJson in missionsJson)
    {
        // get mission
        PBMissionBasic *mission = [PBMissionBasic parseFromDictionary:missionJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:mission];
    }
    
    // set back to result object
    c.missionBasics = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// Mission
///--------------------------------------
@implementation PBMission

@synthesize missionBasic;
@synthesize dateModified;
@synthesize status;
@synthesize pendings;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Mission : {\r\t%@\r\tdate_modified : %@\r\tstatus : %@\r\t%@\r\t}", self.missionBasic, self.dateModified, self.status, self.pendings];
    
    return descriptionString;
}

+(PBMission *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBMission *c = [[PBMission alloc] init];
    
    // ignore parse level.
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse mission basic
    c.missionBasic = [PBMissionBasic parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    // parse date field
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.dateModified = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"date_modified"]];
    
    // parse normal fields
    c.status = [c.parseLevelJsonResponse objectForKey:@"status"];
    
    c.pendings = [PBPendingArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"pending"] startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// MissionArray
///--------------------------------------
@implementation PBMissionArray

@synthesize missions;

-(NSString *)description
{
    // create string to hold all mission line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Missions : {"];
    
    for(PBMission *item in self.missions)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBMissionArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result object
    PBMissionArray *c = [[PBMissionArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert input json into array
    NSArray *missionsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // create a temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *missionJson in missionsJson)
    {
        // get mission
        PBMission *mission = [PBMission parseFromDictionary:missionJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:mission];
    }
    
    // set back to result object
    c.missions = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// ConditionData
///--------------------------------------
@implementation PBConditionData

@synthesize questName;
@synthesize description_;
@synthesize hint;
@synthesize image;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"ConditionData : {\r\tquest_name : %@\r\tdescription : %@\r\thint : %@\r\timage : %@\r\t}", self.questName, self.description_, self.hint, self.image];
    
    return descriptionString;
}

+(PBConditionData *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result object
    PBConditionData *c = [[PBConditionData alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.questName = [c.parseLevelJsonResponse objectForKey:@"quest_name"];
    c.description_ = [c.parseLevelJsonResponse objectForKey:@"description"];
    c.hint = [c.parseLevelJsonResponse objectForKey:@"hint"];
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    
    return c;
}

@end

///--------------------------------------
/// Condition
///--------------------------------------
@implementation PBCondition

@synthesize conditionId;
@synthesize conditionType;
@synthesize conditionValue;
@synthesize conditionData;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Condition : {\r\tcondition_id : %@\r\tcondition_type : %@\r\tcondition_value : %@\r\t%@\r\t}", self.conditionId, self.conditionType, self.conditionValue, self.conditionData];
    
    return descriptionString;
}

+(PBCondition *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBCondition *c = [[PBCondition alloc] init];
    
    // ignore parse level
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.conditionId = [c.parseLevelJsonResponse objectForKey:@"condition_id"];
    c.conditionType = [c.parseLevelJsonResponse objectForKey:@"condition_type"];
    c.conditionValue = [c.parseLevelJsonResponse objectForKey:@"condition_value"];
    c.conditionData = [PBConditionData parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"condition_data"] startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// ConditionArray
///--------------------------------------
@implementation PBConditionArray

@synthesize conditions;

-(NSString *)description
{
    // create string to hold all condition line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Conditions : {"];
    
    for(PBCondition *item in self.conditions)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBConditionArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result object
    PBConditionArray *c = [[PBConditionArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert json into array
    NSArray *conditionsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // create a temp array to hold items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *conditionJson in conditionsJson)
    {
        // get condition object
        PBCondition *condition = [PBCondition parseFromDictionary:conditionJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:condition];
    }
    
    // set back to result object
    c.conditions = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// QuestBasic
///--------------------------------------
@implementation PBQuestBasic

@synthesize questName;
@synthesize description_;
@synthesize hint;
@synthesize image;
@synthesize missionOrder;
@synthesize status;
@synthesize sortOrder;
@synthesize rewards;
@synthesize missionBasics;
@synthesize dateAdded;
@synthesize clientId;
@synthesize siteId;
@synthesize dateModified;
@synthesize questId;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Quest : {\r\tquest_name : %@\r\tdescription : %@\r\thint : %@\r\timage : %@\r\tmission_order : %@\r\tstatus : %@\r\tsort_order : %lu\r\t%@\r\t%@\r\tdate_added : %@\r\tclient_id : %@\r\tsite_id : %@\r\tdate_modified : %@\r\tquest_id : %@\r\t}", self.questName, self.description_, self.hint, self.image, self.missionOrder ? @"YES" : @"NO", self.status ? @"YES" : @"NO", (unsigned long)self.sortOrder, self.rewards, self.missionBasics, self.dateAdded, self.clientId, self.siteId, self.dateModified, self.questId];
    
    return descriptionString;
}

+(PBQuestBasic *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuestBasic *c = [[PBQuestBasic alloc] init];
    
    // ignroe parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    c.questName = [c.parseLevelJsonResponse objectForKey:@"quest_name"];
    c.description_ = [c.parseLevelJsonResponse objectForKey:@"description"];
    c.hint = [c.parseLevelJsonResponse objectForKey:@"hint"];
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    c.missionOrder = [[c.parseLevelJsonResponse objectForKey:@"mission_order"] boolValue];
    
    c.status = [[c.parseLevelJsonResponse objectForKey:@"status"] boolValue];
    id sortOrder = [c.parseLevelJsonResponse objectForKey:@"sort_order"];
    if([sortOrder respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.sortOrder = [sortOrder unsignedIntegerValue];
    }
    
    c.rewards = [PBRewardArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"rewards"] startFromFinalLevel:YES];
    c.missionBasics = [PBMissionBasicArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"missions"] startFromFinalLevel:YES];
    
    // parse date field
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.dateAdded = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"date_added"]];
    c.dateModified = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"date_modified"]];
    c.clientId = [c.parseLevelJsonResponse objectForKey:@"client_id"];
    c.siteId = [c.parseLevelJsonResponse objectForKey:@"site_id"];
    c.questId = [c.parseLevelJsonResponse objectForKey:@"quest_id"];
    
    return c;
}

@end

///--------------------------------------
/// Quest Info
///--------------------------------------
@implementation PBQuestInfo_Response

@synthesize questBasic;
@synthesize conditions;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Quest Info : {\r\t%@\r\t%@\r\t}", self.questBasic, self.conditions];
    
    return descriptionString;
}

+(PBQuestInfo_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a response
    PBQuestInfo_Response *c = [[PBQuestInfo_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'quest'
        NSDictionary *quest = [response objectForKey:@"quest"];
        NSAssert(quest != nil, @"quest must not be nil");
        
        c.parseLevelJsonResponse = quest;
    }
    
    // parse
    c.questBasic = [PBQuestBasic parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    c.conditions = [PBConditionArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"condition"] startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// Quest
///--------------------------------------
@implementation PBQuest

@synthesize questName;
@synthesize description_;
@synthesize hint;
@synthesize image;
@synthesize missionOrder;
@synthesize status;
@synthesize sortOrder;
@synthesize rewards;
@synthesize missions;
@synthesize dateAdded;
@synthesize clientId;
@synthesize siteId;
@synthesize dateModified;
@synthesize questId;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Quest : {\r\tquest_name : %@\r\tdescription : %@\r\thint : %@\r\timage : %@\r\tmission_order : %@\r\tstatus : %@\r\tsort_order : %lu\r\t%@\r\t%@\r\tdate_added : %@\r\tclient_id : %@\r\tsite_id : %@\r\tdate_modified : %@\r\tquest_id : %@\r\t}", self.questName, self.description_, self.hint, self.image, self.missionOrder ? @"YES" : @"NO", self.status, (unsigned long)self.sortOrder, self.rewards, self.missions, self.dateAdded, self.clientId, self.siteId, self.dateModified, self.questId];
    
    return descriptionString;
}

+(PBQuest *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuest *c = [[PBQuest alloc] init];
    
    // ignroe parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    c.questName = [c.parseLevelJsonResponse objectForKey:@"quest_name"];
    c.description_ = [c.parseLevelJsonResponse objectForKey:@"description"];
    c.hint = [c.parseLevelJsonResponse objectForKey:@"hint"];
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    c.missionOrder = [[c.parseLevelJsonResponse objectForKey:@"mission_order"] boolValue];
    
    c.status = [c.parseLevelJsonResponse objectForKey:@"status"];
    id sortOrder = [c.parseLevelJsonResponse objectForKey:@"sort_order"];
    if([sortOrder respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.sortOrder = [sortOrder unsignedIntegerValue];
    }
    
    c.rewards = [PBRewardArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"rewards"] startFromFinalLevel:YES];
    c.missions = [PBMissionArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"missions"] startFromFinalLevel:YES];
    
    // parse date field
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.dateAdded = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"date_added"]];
    c.dateModified = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"date_modified"]];
    c.clientId = [c.parseLevelJsonResponse objectForKey:@"client_id"];
    c.siteId = [c.parseLevelJsonResponse objectForKey:@"site_id"];
    c.questId = [c.parseLevelJsonResponse objectForKey:@"quest_id"];
    
    return c;
}

@end

///--------------------------------------
/// QuestBasicArray
///--------------------------------------
@implementation PBQuestBasicArray

@synthesize questBasics;

-(NSString *)description
{
    // create string to hold all quest-basic line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Quests : {"];
    
    for(PBQuestBasic *item in self.questBasics)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBQuestBasicArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result object
    PBQuestBasicArray *c = [[PBQuestBasicArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert input json into array
    NSArray *questsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // create a temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *questJson in questsJson)
    {
        // get quest object
        PBQuestBasic *quest = [PBQuestBasic parseFromDictionary:questJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:quest];
    }
    
    // set back to result object
    c.questBasics = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// QuestArray
///--------------------------------------
@implementation PBQuestArray

@synthesize quests;

-(NSString *)description
{
    // create string to hold all quest line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Quests : {"];
    
    for(PBQuest *item in self.quests)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBQuestArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result object
    PBQuestArray *c = [[PBQuestArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert input json into array
    NSArray *questsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // create a temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *questJson in questsJson)
    {
        // get quest object
        PBQuest *quest = [PBQuest parseFromDictionary:questJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:quest];
    }
    
    // set back to result object
    c.quests = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// QuestOfPlayer
///--------------------------------------
@implementation PBQuestOfPlayer_Response

@synthesize quest;

-(NSString *)description
{
    return [self.quest description];
}

+(PBQuestOfPlayer_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a response
    PBQuestOfPlayer_Response *c = [[PBQuestOfPlayer_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'quest'
        NSDictionary *quest = [response objectForKey:@"quest"];
        NSAssert(quest != nil, @"quest must not be nil");
        
        c.parseLevelJsonResponse = quest;
    }
    
    // parse data
    c.quest = [PBQuest parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// QuestListOfPlayer
///--------------------------------------
@implementation PBQuestListOfPlayer_Response

@synthesize questList;

-(NSString *)description
{
    return [self.questList description];
}

+(PBQuestListOfPlayer_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuestListOfPlayer_Response *c = [[PBQuestListOfPlayer_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'quests'
        NSDictionary *quests = [response objectForKey:@"quests"];
        NSAssert(quests != nil, @"quests must not be nil");
        
        c.parseLevelJsonResponse = quests;
    }
    
    // parse data
    c.questList = [PBQuestArray parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// QuestListOfPlayer
///--------------------------------------
@implementation PBQuestList_Response

@synthesize list;

-(NSString *)description
{
    return [self.list description];
}

+(PBQuestList_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuestList_Response *c = [[PBQuestList_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'quests'
        NSDictionary *quests = [response objectForKey:@"quests"];
        NSAssert(quests != nil, @"quests must not be nil");
        
        c.parseLevelJsonResponse = quests;
    }
    
    // parse data
    c.list = [PBQuestBasicArray parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// Config
///--------------------------------------
@implementation PBConfig

@synthesize url;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Config : {\r\turl : %@\r\t}", self.url];
    
    return descriptionString;
}

+(PBConfig *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBConfig *c = [[PBConfig alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.url = [c.parseLevelJsonResponse objectForKey:@"url"];
    
    return c;
}

@end

///--------------------------------------
/// ConfigArray
///--------------------------------------
@implementation PBConfigArray

@synthesize configs;

-(NSString *)description
{
    // create string to hold all config line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Configs : {"];
    
    for(PBConfig *item in self.configs)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBConfigArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBConfigArray *c = [[PBConfigArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert json input into array
    NSArray *configsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *configJson in configsJson)
    {
        // get config object
        PBConfig *config = [PBConfig parseFromDictionary:configJson startFromFinalLevel:YES];
        
        // add into temp array
        [tempArray addObject:config];
    }
    
    // set back to result
    c.configs = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// ActionConfig
///--------------------------------------
@implementation PBActionConfig

@synthesize name;
@synthesize configs;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"ActionConfig : {\r\tname : %@\r\t%@\r\t}", self.name, self.configs];
    
    return descriptionString;
}

+(PBActionConfig *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBActionConfig *c = [[PBActionConfig alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.name = [c.parseLevelJsonResponse objectForKey:@"name"];
    c.configs = [PBConfigArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"config"] startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// RuleEventBadgeRewardData
///--------------------------------------
@implementation PBRuleEventBadgeRewardData

@synthesize badgeId;
@synthesize image;
@synthesize name;
@synthesize description_;
@synthesize hint;
@synthesize claim;
@synthesize redeem;

- (NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Badge's rule event data : {\r\tbadge_id : %@\r\timage : %@\r\tname : %@\r\tdescription : %@\r\thint : %@\r\tclaim : %@\r\tredeem : %@\r\t", self.badgeId, self.image, self.name, self.description_, self.hint, self.claim ? @"YES" : @"NO", self.redeem ? @"YES" : @"NO"];
    
    return descriptionString;
}

+(PBRuleEventBadgeRewardData *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBRuleEventBadgeRewardData *c = [[PBRuleEventBadgeRewardData alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.badgeId = [c.parseLevelJsonResponse objectForKey:@"badge_id"];
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    c.name = [c.parseLevelJsonResponse objectForKey:@"name"];
    c.description_ = [c.parseLevelJsonResponse objectForKey:@"description"];
    c.hint = [c.parseLevelJsonResponse objectForKey:@"hint"];
    c.claim = [[c.parseLevelJsonResponse objectForKey:@"claim"] boolValue];
    c.redeem = [[c.parseLevelJsonResponse objectForKey:@"redeem"] boolValue];
    
    return c;
}

@end

///--------------------------------------
/// RuleEvent
///--------------------------------------
@implementation PBRuleEvent

@synthesize eventType;
@synthesize rewardType;
@synthesize value;
@synthesize rewardData;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Rule's event : {\r\tevent_type : %@\r\treward_type : %@\r\tvalue : %@\r\treward_data : %@\r\t}", self.eventType, self.rewardType, self.value, self.rewardData];
    
    return descriptionString;
}

+(PBRuleEvent *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBRuleEvent *c = [[PBRuleEvent alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.eventType = [c.parseLevelJsonResponse objectForKey:@"event_type"];
    c.rewardType = [c.parseLevelJsonResponse objectForKey:@"reward_type"];
    c.value = [c.parseLevelJsonResponse objectForKey:@"value"];
    
    // check to parse reward_data if reward_type matches ones that have
    if([c.rewardType isEqualToString:@"badge"])
    {
        // get reward_data json
        NSDictionary *bRewardDataJson = [c.parseLevelJsonResponse objectForKey:@"reward_data"];
        
        // populate badge's reward data
        PBRuleEventBadgeRewardData *bRewardData = [PBRuleEventBadgeRewardData parseFromDictionary:bRewardDataJson startFromFinalLevel:YES];
        
        // set back to result object
        c.rewardData = bRewardData;
    }
    
    return c;
}

@end

///--------------------------------------
/// RuleEvents
///--------------------------------------
@implementation PBRuleEvents

@synthesize list;

-(NSString *)description
{
    // create string to hold all rule-event line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Rule events : {"];
    
    for(PBRuleEvent *item in self.list)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBRuleEvents *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBRuleEvents *c = [[PBRuleEvents alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert input json into array
    NSArray *eventsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *eventJson in eventsJson)
    {
        // populate PBRuleEvent object
        PBRuleEvent *ruleEvent = [PBRuleEvent parseFromDictionary:eventJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:ruleEvent];
    }
    
    // set back array to result object
    c.list = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// RuleEventsMission
///--------------------------------------
@implementation PBRuleEventsMission

@synthesize events;
@synthesize missionNumber;
@synthesize missionName;
@synthesize description_;
@synthesize hint;
@synthesize image;
@synthesize questId;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Rule's events-missions : {\r\t%@\r\tmission_number : %@\r\tmission_name : %@\r\tdescription : %@\r\thint : %@\r\timage : %@\r\tquest_id : %@\r\t}", self.events, self.missionNumber, self.missionName, self.description_, self.hint, self.image, self.questId];
    
    return descriptionString;
}

+(PBRuleEventsMission *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBRuleEventsMission *c = [[PBRuleEventsMission alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    // parse 'events'
    c.events = [PBRuleEvents parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"events"] startFromFinalLevel:YES];
    c.missionId = [c.parseLevelJsonResponse objectForKey:@"mission_id"];
    c.missionNumber = [c.parseLevelJsonResponse objectForKey:@"mission_number"];
    c.missionName = [c.parseLevelJsonResponse objectForKey:@"mission_name"];
    c.description_ = [c.parseLevelJsonResponse objectForKey:@"description"];
    c.hint = [c.parseLevelJsonResponse objectForKey:@"hint"];
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    c.questId = [c.parseLevelJsonResponse objectForKey:@"quest_id"];
    
    return c;
}

@end

///--------------------------------------
/// RuleEventsMissions
///--------------------------------------
@implementation PBRuleEventsMissions

@synthesize list;

-(NSString *)description
{
    // create string to hold all action-config line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Rule's Events-Missions : {"];
    
    for(PBRuleEventsMission *item in self.list)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBRuleEventsMissions *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBRuleEventsMissions *c = [[PBRuleEventsMissions alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert input json into array
    NSArray *ruleEventsMissionsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *ruleEventsMissionJson in ruleEventsMissionsJson)
    {
        // populate a single object
        PBRuleEventsMission *ruleEventMission = [PBRuleEventsMission parseFromDictionary:ruleEventsMissionJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:ruleEventMission];
    }
    
    // set back to result object
    c.list = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// RuleEventQuest
///--------------------------------------
@implementation PBRuleEventsQuest

@synthesize events;
@synthesize questId;
@synthesize questName;
@synthesize description_;
@synthesize hint;
@synthesize image;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Rule's events-quest : {\r\t%@\r\tquest_id : %@\r\tquest_name : %@\r\tdescription : %@\r\thint : %@\r\timage : %@\r\t}", self.events, self.questId, self.questName, self.description_, self.hint, self.image];
    
    return descriptionString;
}

+(PBRuleEventsQuest *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBRuleEventsQuest *c = [[PBRuleEventsQuest alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.events = [PBRuleEvents parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"events"] startFromFinalLevel:YES];
    c.questId = [c.parseLevelJsonResponse objectForKey:@"quest_id"];
    c.questName = [c.parseLevelJsonResponse objectForKey:@"quest_name"];
    c.description_ = [c.parseLevelJsonResponse objectForKey:@"description"];
    c.hint = [c.parseLevelJsonResponse objectForKey:@"hint"];
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    
    return c;
}

@end

///--------------------------------------
/// RuleEventQuests
///--------------------------------------
@implementation PBRuleEventsQuests

@synthesize list;

-(NSString *)description
{
    // create string to hold all action-config line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Rule's events-quests : {"];
    
    for(PBRuleEventsQuest *item in self.list)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBRuleEventsQuests *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBRuleEventsQuests *c = [[PBRuleEventsQuests alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert input json into array
    NSArray *ruleEventsQuestsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *ruleEventsQuestJson in ruleEventsQuestsJson)
    {
        // popuplate an item
        PBRuleEventsQuest *item = [PBRuleEventsQuest parseFromDictionary:ruleEventsQuestJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:item];
    }
    
    // set back list
    c.list = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// Rule - Response
///--------------------------------------
@implementation PBRule_Response

@synthesize events;

-(NSString *)description
{
    NSString *d = [self.events description];
    NSLog(@"d = %@", d);
    
    NSString *descriptionString = [NSString stringWithFormat:@"Rule Response: {\r\t%@\r\t}", [self.events description]];
    
    return descriptionString;
}

+(PBRule_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBRule_Response *c = [[PBRule_Response alloc] init];
    
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
    
    // parse 'events'
    c.events = [PBRuleEvents parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"events"] startFromFinalLevel:YES];
    
    // TODO: Add parse 'events_missions', 'events_quests' ...
    
    return c;
}

@end

///--------------------------------------
/// ActionConfigArray
///--------------------------------------
@implementation PBActionConfigArray

@synthesize actionConfigs;

-(NSString *)description
{
    // create string to hold all action-config line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"ActionConfigs : {"];
    
    for(PBActionConfig *item in self.actionConfigs)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBActionConfigArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBActionConfigArray *c = [[PBActionConfigArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // get all keys
    // due to unique format structure of json-response
    NSArray *keys = [c.parseLevelJsonResponse allKeys];
    
    // temp array
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSString *key in keys)
    {
        // get json for this key
        NSDictionary *actionConfigJson = [c.parseLevelJsonResponse objectForKey:key];
        
        // get action config object
        PBActionConfig *actionConfig = [PBActionConfig parseFromDictionary:actionConfigJson startFromFinalLevel:YES];
        
        // add into temp array
        [tempArray addObject:actionConfig];
    }
    
    // set back to result object
    c.actionConfigs = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// ActionConfig - Response
///--------------------------------------
@implementation PBActionConfig_Response

@synthesize list;

-(NSString *)description
{
    return [self.list description];
}

+(PBActionConfig_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBActionConfig_Response *c = [[PBActionConfig_Response alloc] init];
    
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
    
    c.list = [PBActionConfigArray parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// Recent Point
///--------------------------------------
@implementation PBRecentPoint

@synthesize message;
@synthesize rewardId;
@synthesize rewardName;
@synthesize value;
@synthesize dateAdded;
@synthesize playerBasic;
@synthesize actionName;
@synthesize stringFilter;
@synthesize actionIcon;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Recent point : {\r\tmessage : %@\r\treward_id : %@\r\treward_name : %@\r\tvalue = %lu\r\tdate_added : %@\r\t%@\r\taction_name : %@\r\tstring_filter : %@\r\taction_icon : %@\r\t}", self.message, self.rewardId, self.rewardName, (unsigned long)self.value, self.dateAdded, self.playerBasic, self.actionName, self.stringFilter, self.actionIcon];
    
    return descriptionString;
}

+(PBRecentPoint *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result object
    PBRecentPoint *c = [[PBRecentPoint alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    c.message = [c.parseLevelJsonResponse objectForKey:@"message"];
    c.rewardId = [c.parseLevelJsonResponse objectForKey:@"reward_id"];
    c.rewardName = [c.parseLevelJsonResponse objectForKey:@"reward_name"];
    id value = [c.parseLevelJsonResponse objectForKey:@"value"];
    if([value respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.value = [value unsignedIntegerValue];
    }
    
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    c.dateAdded = [dateFormatter dateFromString:[c.parseLevelJsonResponse objectForKey:@"date_added"]];
    
    // parse playerbasic
    c.playerBasic = [PBPlayerBasic parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"player"] startFromFinalLevel:YES];
    
    c.actionName = [c.parseLevelJsonResponse objectForKey:@"action_name"];
    c.stringFilter = [c.parseLevelJsonResponse objectForKey:@"string_filter"];
    c.actionIcon = [c.parseLevelJsonResponse objectForKey:@"action_icon"];
    
    return c;
}

@end

///--------------------------------------
/// Recent Point Array
///--------------------------------------
@implementation PBRecentPointArray_Response

@synthesize list;

-(NSString *)description
{
    // create string to hold all action-config line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Recent Points : {"];
    
    for(PBRecentPoint *item in self.list)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBRecentPointArray_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBRecentPointArray_Response *c = [[PBRecentPointArray_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'points'
        NSDictionary *points = [response objectForKey:@"points"];
        NSAssert(points != nil, @"points must not be nil");
        
        c.parseLevelJsonResponse = points;
    }
    
    // convert json into array
    NSArray *pointsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *pointJson in pointsJson)
    {
        // get point
        PBRecentPoint *point = [PBRecentPoint parseFromDictionary:pointJson startFromFinalLevel:YES];
        
        // add into temp array
        [tempArray addObject:point];
    }
    
    // set back to response
    c.list = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// MissionInfo
///--------------------------------------
@implementation PBMissionInfo_Response

@synthesize missionBasic;
@synthesize questId;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Mission Info : {\r\t%@\r\tquest_id : %@\r\t}", self.missionBasic, self.questId];
    
    return descriptionString;
}

+(PBMissionInfo_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel

{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a response
    PBMissionInfo_Response *c = [[PBMissionInfo_Response alloc] init];
    
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
    
    c.missionBasic = [PBMissionBasic parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    c.questId = [c.parseLevelJsonResponse objectForKey:@"quest_id"];
    
    return c;
}

@end

///--------------------------------------
/// QuestListAvailableForPlayer
///--------------------------------------
@implementation PBQuestListAvailableForPlayer_Response

@synthesize list;

-(NSString *)description
{
    return [self.list description];
}

+(PBQuestListAvailableForPlayer_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a response
    PBQuestListAvailableForPlayer_Response *c = [[PBQuestListAvailableForPlayer_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'quests'
        NSDictionary *quests = [response objectForKey:@"quests"];
        NSAssert(quests != nil, @"quests must not be nil");
        
        c.parseLevelJsonResponse = quests;
    }
    
    // parse
    c.list = [PBQuestBasicArray parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// QuestAvailableForPlayer - Response
///--------------------------------------
@implementation PBQuestAvailableForPlayer_Response

@synthesize eventType;
@synthesize eventMessage;
@synthesize eventStatus;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Quest available to player : {\r\tevent_type : %@\r\tevent_message : %@\r\tevent_status : %@\r\t}", self.eventType, self.eventMessage, self.eventStatus ? @"YES" : @"NO"];
    
    return descriptionString;
}

+(PBQuestAvailableForPlayer_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a response
    PBQuestAvailableForPlayer_Response *c = [[PBQuestAvailableForPlayer_Response alloc] init];
    
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
    
    // parse
    c.eventType = [c.parseLevelJsonResponse objectForKey:@"event_type"];
    c.eventMessage = [c.parseLevelJsonResponse objectForKey:@"event_message"];
    c.eventStatus = [[c.parseLevelJsonResponse objectForKey:@"event_status"] boolValue];
    
    return c;
}

@end

///--------------------------------------
/// Join Quest
///--------------------------------------
@implementation PBJoinQuest

@synthesize eventType;
@synthesize questId;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Join Quest : {\r\tevent_type : %@\r\tquest_id : %@\r\t}", self.eventType, self.questId];
    
    return descriptionString;
}

+(PBJoinQuest *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBJoinQuest *c = [[PBJoinQuest alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.eventType = [c.parseLevelJsonResponse objectForKey:@"event_type"];
    c.questId = [c.parseLevelJsonResponse objectForKey:@"quest_id"];
    
    return c;
}

@end

///--------------------------------------
/// Join Quest - Response
///--------------------------------------
@implementation PBJoinQuest_Response

@synthesize response;

-(NSString *)description
{
    return [self.response description];
}

+(PBJoinQuest_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBJoinQuest_Response *c = [[PBJoinQuest_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'events'
        NSDictionary *events = [response objectForKey:@"events"];
        NSAssert(events != nil, @"events must not be nil");
        
        c.parseLevelJsonResponse = events;
    }
    
    // parse
    c.response = [PBJoinQuest parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// GradeRewardCustom
///--------------------------------------
@implementation PBGradeRewardCustom

@synthesize customId;
@synthesize customValue;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Grade Reward Custom : {\r\tcustom_id : %@\r\tcustom_value : %@\r\t}", self.customId, self.customValue];
    
    return descriptionString;
}

+(PBGradeRewardCustom *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBGradeRewardCustom *c = [[PBGradeRewardCustom alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.customId = [c.parseLevelJsonResponse objectForKey:@"custom_id"];
    c.customValue = [c.parseLevelJsonResponse objectForKey:@"custom_value"];
    
    return c;
}

@end

///--------------------------------------
/// GradeRewardCustomArray
///--------------------------------------
@implementation PBGradeRewardCustomArray

@synthesize gradeRewardCustoms;

-(NSString *)description
{
    // create string to hold all grade-reward-custom line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Grade Reward Custom Array : {"];
    
    for(PBGradeRewardCustom *item in self.gradeRewardCustoms)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBGradeRewardCustomArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBGradeRewardCustomArray *c = [[PBGradeRewardCustomArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert json into array
    NSArray *grcsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *grcJson in grcsJson)
    {
        // get grade reward custom object
        PBGradeRewardCustom *grc = [PBGradeRewardCustom parseFromDictionary:grcJson startFromFinalLevel:YES];
        
        // add into temp array
        [tempArray addObject:grc];
    }
    
    // set back array to result object
    c.gradeRewardCustoms = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// GradeRewards
///--------------------------------------
@implementation PBGradeRewards

@synthesize expValue;
@synthesize pointValue;
@synthesize customList;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Grade Rewards : {\r\texp_value : %@\r\tpoint_value : %@\r\t%@\r\t}", self.expValue, self.pointValue, self.customList];
    
    return descriptionString;
}

+(PBGradeRewards *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBGradeRewards *c = [[PBGradeRewards alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.expValue = [[c.parseLevelJsonResponse objectForKey:@"exp"] objectForKey:@"exp_value"];
    c.pointValue = [[c.parseLevelJsonResponse objectForKey:@"point"] objectForKey:@"point_value"];
    c.customList = [PBGradeRewardCustomArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"custom"] startFromFinalLevel:YES
                    ];
    return c;
}

@end

///--------------------------------------
/// Grade
///--------------------------------------
@implementation PBGrade

@synthesize gradeId;
@synthesize start;
@synthesize end;
@synthesize grade;
@synthesize rank;
@synthesize rankImage;
@synthesize rewards;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Grade : {\r\tgrade_id : %@\r\tstart : %@\r\tend : %@\r\tgrade : %@\r\trank : %@\r\trank_image : %@\r\t%@\r\t}", self.gradeId, self.start, self.end, self.grade, self.rank, self.rankImage, self.rewards];
    
    return descriptionString;
}

+(PBGrade *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBGrade *c = [[PBGrade alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.gradeId = [c.parseLevelJsonResponse objectForKey:@"grade_id"];
    c.start = [c.parseLevelJsonResponse objectForKey:@"start"];
    c.end = [c.parseLevelJsonResponse objectForKey:@"end"];
    c.grade = [c.parseLevelJsonResponse objectForKey:@"grade"];
    c.rank = [c.parseLevelJsonResponse objectForKey:@"rank"];
    c.rankImage = [c.parseLevelJsonResponse objectForKey:@"rank_image"];
    c.rewards = [PBGradeRewards parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"rewards"] startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// GradeDoneReward
///--------------------------------------
@implementation PBGradeDoneReward

@synthesize eventType;
@synthesize rewardType;
@synthesize rewardId;
@synthesize value;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Grade Done : {\r\tevent_type : %@\r\treward_type : %@\r\treward_id : %@\r\tvalue : %@\r\t}", self.eventType, self.rewardType, self.rewardId, self.value];
    
    return descriptionString;
}

+(PBGradeDoneReward *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBGradeDoneReward *c = [[PBGradeDoneReward alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.eventType = [c.parseLevelJsonResponse objectForKey:@"event_type"];
    c.rewardType = [c.parseLevelJsonResponse objectForKey:@"reward_type"];
    c.rewardId = [c.parseLevelJsonResponse objectForKey:@"reward_id"];
    c.value = [c.parseLevelJsonResponse objectForKey:@"value"];
    
    return c;
}

@end

///--------------------------------------
/// GradeDoneRewardArray
///--------------------------------------
@implementation PBGradeDoneRewardArray

@synthesize gradeDoneRewards;

-(NSString *)description
{
    // create string to hold all gradedone-reward line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"GradeDone Reward : {"];
    
    for(PBGradeDoneReward *item in self.gradeDoneRewards)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBGradeDoneRewardArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBGradeDoneRewardArray *c = [[PBGradeDoneRewardArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert json into array
    NSArray *gradeDonesJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *gradeDoneJson in gradeDonesJson)
    {
        // get gradedone-reward object
        PBGradeDoneReward *gdr = [PBGradeDoneReward parseFromDictionary:gradeDoneJson startFromFinalLevel:YES];
        
        // add into temp array
        [tempArray addObject:gdr];
    }
    
    // set back to result object
    c.gradeDoneRewards = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// GradeDone
///--------------------------------------
@implementation PBGradeDone

@synthesize gradeId;
@synthesize start;
@synthesize end;
@synthesize grade;
@synthesize rank;
@synthesize rankImage;
@synthesize rewards;
@synthesize score;
@synthesize maxScore;
@synthesize totalScore;
@synthesize totalMaxScore;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"GradeDone : {\r\tgrade_id : %@\r\tstart : %@\r\tend : %@\r\tgrade : %@\r\trank : %@\r\trank_image : %@\r\t%@\r\tscore : %lu\r\tmax_score : %@\r\ttotal_score : %lu\r\ttotal_max_score : %lu\r\t}", self.gradeId, self.start, self.end, self.grade, self.rank, self.rankImage, self.rewards, (unsigned long)self.score, self.maxScore, (unsigned long)self.totalScore, (unsigned long)self.totalMaxScore];
    
    return descriptionString;
}

+(PBGradeDone *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBGradeDone *c = [[PBGradeDone alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.gradeId = [c.parseLevelJsonResponse objectForKey:@"grade_id"];
    c.start = [c.parseLevelJsonResponse objectForKey:@"start"];
    c.end = [c.parseLevelJsonResponse objectForKey:@"end"];
    c.grade = [c.parseLevelJsonResponse objectForKey:@"grade"];
    c.rank = [c.parseLevelJsonResponse objectForKey:@"rank"];
    c.rankImage = [c.parseLevelJsonResponse objectForKey:@"rewards"];
    c.rewards = [c.parseLevelJsonResponse objectForKey:@"rewards"];
    id score = [c.parseLevelJsonResponse objectForKey:@"score"];
    if([score respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.score = [score unsignedIntegerValue];
    }
    c.maxScore = [c.parseLevelJsonResponse objectForKey:@"max_score"];
    
    id totalScore = [c.parseLevelJsonResponse objectForKey:@"total_score"];
    if([totalScore respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.totalScore = [totalScore unsignedIntegerValue];
    }
    
    id totalMaxScore = [c.parseLevelJsonResponse objectForKey:@"total_max_score"];
    if([totalMaxScore respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.totalMaxScore = [totalMaxScore unsignedIntegerValue];
    }
    
    return c;
}

@end

///--------------------------------------
/// QuizDone
///--------------------------------------
@implementation PBQuizDone

@synthesize value;
@synthesize grade;
@synthesize totalCompletedQuestion;
@synthesize quizId;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"QuizDone : {\r\tvalue : %lu\r\t%@total_completed_questions : %lu\r\tquiz_id : %@\r\t}", (unsigned long)self.value, self.grade, (unsigned long)self.totalCompletedQuestion, self.quizId];
    
    return descriptionString;
}

+(PBQuizDone *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuizDone *c = [[PBQuizDone alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    id value = [c.parseLevelJsonResponse objectForKey:@"value"];
    if([value respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.value = [value unsignedIntegerValue];
    }
    
    c.grade = [PBGradeDone parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"grade"] startFromFinalLevel:YES];
    
    id totalCompletedQuestion = [c.parseLevelJsonResponse objectForKey:@"value"];
    if([totalCompletedQuestion respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.totalCompletedQuestion = [totalCompletedQuestion unsignedIntegerValue];
    }
    
    c.quizId = [c.parseLevelJsonResponse objectForKey:@"quiz_id"];
    
    return c;
}

@end

///--------------------------------------
/// QuizDoneArray
///--------------------------------------
@implementation PBQuizDoneArray

@synthesize quizDones;

-(NSString *)description
{
    // create string to hold all quizdone line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Quiz done : {"];
    
    for(PBQuizDone *item in self.quizDones)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBQuizDoneArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuizDoneArray *c = [[PBQuizDoneArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert json into array
    NSArray *quizDonesJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *quizDoneJson in quizDonesJson)
    {
        // get quizdone json
        PBQuizDone *quizDone = [PBQuizDone parseFromDictionary:quizDoneJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:quizDone];
    }
    
    // set back to result object
    c.quizDones = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// QuizDoneList - Response
///--------------------------------------
@implementation PBQuizDoneList_Response

@synthesize list;

-(NSString *)description
{
    return [self.list description];
}

+(PBQuizDoneList_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a response
    PBQuizDoneList_Response *c = [[PBQuizDoneList_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'result'
        NSDictionary *result = [response objectForKey:@"result"];
        NSAssert(result != nil, @"result must not be nil");
        
        c.parseLevelJsonResponse = result;
    }
    
    // parse
    c.list = [PBQuizDoneArray parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// GradeArray
///--------------------------------------
@implementation PBGradeArray

@synthesize grades;

-(NSString *)description
{
    // create string to hold all grade line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Grade Array : {"];
    
    for(PBGrade *item in self.grades)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}
+(PBGradeArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBGradeArray *c = [[PBGradeArray alloc] init];
    
    // ignroe parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert json into array
    NSArray *gradesJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *gradeJson in gradesJson)
    {
        // get grade object
        PBGrade *grade = [PBGrade parseFromDictionary:gradeJson startFromFinalLevel:YES];
        
        // add into temp array
        [tempArray addObject:grade];
    }
    
    // set back to result object
    c.grades = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// QuizBasic
///--------------------------------------
@implementation PBQuizBasic

@synthesize name;
@synthesize image;
@synthesize weight;
@synthesize description_;
@synthesize descriptionImage;
@synthesize quizId;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Quiz Basic : {\r\tname : %@\r\timage : %@\r\tweight : %@\r\tdescription : %@\r\tdescription_image : %@\r\tquiz_id : %@\r\t}", self.name, self.image, self.weight, self.description_, self.descriptionImage, self.quizId];
    
    return descriptionString;
}

+(PBQuizBasic *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuizBasic *c = [[PBQuizBasic alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.name = [c.parseLevelJsonResponse objectForKey:@"name"];
    c.image = [c.parseLevelJsonResponse objectForKey:@"image"];
    c.weight = [c.parseLevelJsonResponse objectForKey:@"weight"];
    c.description_ = [c.parseLevelJsonResponse objectForKey:@"description"];
    c.descriptionImage = [c.parseLevelJsonResponse objectForKey:@"description_image"];
    c.quizId = [c.parseLevelJsonResponse objectForKey:@"quiz_id"];
    
    return c;
}

@end

///--------------------------------------
/// Quiz
///--------------------------------------
@implementation PBQuiz

@synthesize basic;
@synthesize dateStart;
@synthesize dateExpire;
@synthesize status;
@synthesize grades;
@synthesize deleted;
@synthesize totalMaxScore;
@synthesize totalQuestions;

- (NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Quiz : {\r\t%@\r\tdate_start : %@\r\tdate_expire : %@\r\tstatus : %@\r\tgrades : %@\r\tdeleted : %@\r\ttotal_max_score : %lu\r\ttotal_questions : %lu\r\t}", self.basic, self.dateStart, self.dateExpire, self.status ? @"YES" : @"NO", self.grades, self.deleted ? @"YES" : @"NO", (unsigned long)self.totalMaxScore,  (unsigned long)self.totalQuestions];
    
    return descriptionString;
}

+(PBQuiz *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuiz *c = [[PBQuiz alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.basic = [PBQuizBasic parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    // create a date formatter to parse date-timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    id dateStart = [c.parseLevelJsonResponse objectForKey:@"date_start"];
    if(dateStart != [NSNull null])
        c.dateStart = [dateFormatter dateFromString:dateStart];
    
    id dateExpire = [c.parseLevelJsonResponse objectForKey:@"date_expire"];
    if(dateExpire != [NSNull null])
        c.dateExpire = [dateFormatter dateFromString:dateExpire];
    
    c.status = [[c.parseLevelJsonResponse objectForKey:@"status"] boolValue];
    
    c.grades = [PBGradeArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"grades"] startFromFinalLevel:YES];
    
    c.deleted = [[c.parseLevelJsonResponse objectForKey:@"deleted"] boolValue];
    id totalMaxScore = [c.parseLevelJsonResponse objectForKey:@"total_max_score"];
    if([totalMaxScore respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.totalMaxScore = [totalMaxScore unsignedIntegerValue];
    }
    
    id totalQuestions = [c.parseLevelJsonResponse objectForKey:@"total_questions"];
    if([totalQuestions respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.totalQuestions = [totalQuestions unsignedIntegerValue];
    }
    
    return c;
}

@end

///--------------------------------------
/// QuizBasicArray
///--------------------------------------
@implementation PBQuizBasicArray

@synthesize quizBasics;

-(NSString *)description
{
    // create string to hold all quiz-basic line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Quiz Basic Array : {"];
    
    for(PBQuizBasic *item in self.quizBasics)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBQuizBasicArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create result object
    PBQuizBasicArray *c = [[PBQuizBasicArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert json into array
    NSArray *quizBasicsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *quizBasicJson in quizBasicsJson)
    {
        // get quiz basic object
        PBQuizBasic *quizBasic = [PBQuizBasic parseFromDictionary:quizBasicJson startFromFinalLevel:YES];
        
        // add into temp array
        [tempArray addObject:quizBasic];
    }
    
    // set back to result object
    c.quizBasics = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// ActiveQuizList
///--------------------------------------
@implementation PBActiveQuizList_Response

@synthesize list;

-(NSString *)description
{
    return [self.list description];
}

+(PBActiveQuizList_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a response
    PBActiveQuizList_Response *c = [[PBActiveQuizList_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'result'
        NSDictionary *result = [response objectForKey:@"result"];
        NSAssert(result != nil, @"result must not be nil");
        
        c.parseLevelJsonResponse = result;
    }
    
    // parse
    c.list = [PBQuizBasicArray parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// QuizDetail - Response
///--------------------------------------
@implementation PBQuizDetail_Response

@synthesize quiz;

-(NSString *)description
{
    return [self.quiz description];
}

+(PBQuizDetail_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBQuizDetail_Response *c = [[PBQuizDetail_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'result'
        NSDictionary *result = [response objectForKey:@"result"];
        NSAssert(result != nil, @"result must not be nil");
        
        c.parseLevelJsonResponse = result;
    }
    
    // parse
    c.quiz = [PBQuiz parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// QuizRandom - Response
///--------------------------------------
@implementation PBQuizRandom_Response

@synthesize randomQuiz;

-(NSString *)description
{
    return [self.randomQuiz description];
}

+(PBQuizRandom_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a response
    PBQuizRandom_Response *c = [[PBQuizRandom_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'result'
        NSDictionary *result = [response objectForKey:@"result"];
        NSAssert(result != nil, @"result must not be nil");
        
        c.parseLevelJsonResponse = result;
    }
    
    // parse
    c.randomQuiz = [PBQuizBasic parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// QuestionOption
///--------------------------------------
@implementation PBQuestionOption

@synthesize option;
@synthesize optionImage;
@synthesize optionId;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Qustion Option : {\r\toption : %@\r\toption_image : %@\r\toption_id : %@\r\t}", self.option, self.optionImage, self.optionId];
    
    return descriptionString;
}

+(PBQuestionOption *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuestionOption *c = [[PBQuestionOption alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.option = [c.parseLevelJsonResponse objectForKey:@"option"];
    c.optionImage = [c.parseLevelJsonResponse objectForKey:@"option_image"];
    c.optionId = [c.parseLevelJsonResponse objectForKey:@"option_id"];
    
    return c;
}

@end

///--------------------------------------
/// QuestionOptionArray
///--------------------------------------
@implementation PBQuestionOptionArray

@synthesize options;

-(NSString *)description
{
    // create string to hold all quiz-basic line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Question Option Array : {"];
    
    for(PBQuestionOption *item in self.options)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBQuestionOptionArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result option
    PBQuestionOptionArray *c = [[PBQuestionOptionArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert json into array
    NSArray *optionsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *optionJson in optionsJson)
    {
        // get option object
        PBQuestionOption *option = [PBQuestionOption parseFromDictionary:optionJson startFromFinalLevel:YES];
        
        [tempArray addObject:option];
    }
    
    // set back to result object
    c.options = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// Question
///--------------------------------------
@implementation PBQuestion

@synthesize question;
@synthesize questionImage;
@synthesize options;
@synthesize index;
@synthesize total;
@synthesize questionId;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Question : {\r\tquestion : %@\r\tquestion_image : %@\r\t%@\r\tindex : %lu\r\ttotal : %lu\r\tquestion_id : %@\r\t}", self.question, self.questionImage, self.options, (unsigned long)self.index, (unsigned long)self.total, self.questionId];
    
    return descriptionString;
}

+(PBQuestion *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuestion *c = [[PBQuestion alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.question = [c.parseLevelJsonResponse objectForKey:@"question"];
    c.questionImage = [c.parseLevelJsonResponse objectForKey:@"question_image"];
    c.options = [PBQuestionOptionArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"options"] startFromFinalLevel:YES];
    id index = [c.parseLevelJsonResponse objectForKey:@"index"];
    if([index respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.index = [index unsignedIntegerValue];
    }
    
    id total = [c.parseLevelJsonResponse objectForKey:@"total"];
    if([total respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.total = [total unsignedIntegerValue];
    }
    
    c.questionId = [c.parseLevelJsonResponse objectForKey:@"question_id"];
    
    return c;
}

@end

///--------------------------------------
/// Question - Response
///--------------------------------------
@implementation PBQuestion_Response

@synthesize question;

-(NSString *)description
{
    return [self.question description];
}

+(PBQuestion_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create response
    PBQuestion_Response *c = [[PBQuestion_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'result'
        NSDictionary *result = [response objectForKey:@"result"];
        NSAssert(result != nil, @"result must not be nil");
        
        c.parseLevelJsonResponse = result;
    }
    
    // parse
    c.question = [PBQuestion parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// QuestionAnsweredOption
///--------------------------------------
@implementation PBQuestionAnsweredOption

@synthesize option;
@synthesize score;
@synthesize explanation;
@synthesize optionImage;
@synthesize optionId;

-(NSString *)description
{
    NSString *descriptionString  = [NSString stringWithFormat:@"Answered Option : {\r\toption : %@\r\tscore : %@\r\texplanation : %@\r\toption_image : %@\r\toption_id : %@\r\t", self.option, self.score, self.explanation, self.optionImage, self.optionId];
    
    return descriptionString;
}

+(PBQuestionAnsweredOption *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuestionAnsweredOption *c = [[PBQuestionAnsweredOption alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.option = [c.parseLevelJsonResponse objectForKey:@"option"];
    c.score = [c.parseLevelJsonResponse objectForKey:@"score"];
    c.explanation = [c.parseLevelJsonResponse objectForKey:@"explanantion"];
    c.optionImage = [c.parseLevelJsonResponse objectForKey:@"option_image"];
    c.optionId = [c.parseLevelJsonResponse objectForKey:@"option_id"];
    
    return c;
}

@end

///--------------------------------------
/// QuestionAnsweredOptionArray
///--------------------------------------
@implementation PBQuestionAnsweredOptionArray

@synthesize answeredOptions;

-(NSString *)description
{
    // create string to hold all answered-option-array line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Answered Option Array : {"];
    
    for(PBQuestionAnsweredOption *item in self.answeredOptions)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBQuestionAnsweredOptionArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuestionAnsweredOptionArray *c = [[PBQuestionAnsweredOptionArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert json into array
    NSArray *answeredOptionsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *answeredOptionJson in answeredOptionsJson)
    {
        // get answered option object
        PBQuestionAnsweredOption *answeredOption = [PBQuestionAnsweredOption parseFromDictionary:answeredOptionJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:answeredOption];
    }
    
    // set back to result object
    c.answeredOptions = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// QuestionAnsweredGradeDone
///--------------------------------------
@implementation PBQuestionAnsweredGradeDone

@synthesize gradeId;
@synthesize start;
@synthesize end;
@synthesize grade;
@synthesize rank;
@synthesize rankImage;
@synthesize score;
@synthesize maxScore;
@synthesize totalScore;
@synthesize totalMaxScore;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Answerd Option Grade Done : {\r\tgrade_id : %@\r\tstart : %@\r\tend : %@\r\tgrade : %@\r\trank : %@\r\trank_image : %@\r\tscore : %lu\r\tmax_score : %@\r\ttotal_score : %lu\r\ttotal_max_score : %lu\r\t}", self.gradeId, self.start, self.end, self.grade, self.rank, self.rankImage, (unsigned long)self.score, self.maxScore, (unsigned long)self.totalScore, (unsigned long)self.totalMaxScore];
    
    return descriptionString;
}

+(PBQuestionAnsweredGradeDone*)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuestionAnsweredGradeDone *c = [[PBQuestionAnsweredGradeDone alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.gradeId = [c.parseLevelJsonResponse objectForKey:@"grade_id"];
    c.start = [c.parseLevelJsonResponse objectForKey:@"start"];
    c.end = [c.parseLevelJsonResponse objectForKey:@"end"];
    c.grade = [c.parseLevelJsonResponse objectForKey:@"grade"];
    c.rank = [c.parseLevelJsonResponse objectForKey:@"rank"];
    c.rankImage = [c.parseLevelJsonResponse objectForKey:@"rank_image"];
    id score = [c.parseLevelJsonResponse objectForKey:@"score"];
    if([score respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.score = [score unsignedIntegerValue];
    }
    
    c.maxScore = [c.parseLevelJsonResponse objectForKey:@"max_score"];
    
    id totalScore = [c.parseLevelJsonResponse objectForKey:@"total_score"];
    if([totalScore respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.totalScore = [totalScore unsignedIntegerValue];
    }
    
    id totalMaxScore = [c.parseLevelJsonResponse objectForKey:@"total_max_score"];
    if([totalMaxScore respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.totalMaxScore = [totalMaxScore unsignedIntegerValue];
    }
    
    return c;
}

@end

///--------------------------------------
/// QuestionAnswered
///--------------------------------------
@implementation PBQuestionAnswered

@synthesize options;
@synthesize score;
@synthesize maxScore;
@synthesize explanation;
@synthesize totalScore;
@synthesize totalMaxScore;
@synthesize grade;
@synthesize rewards;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Qusetion Answered : {%@\r\t\r\tscore : %lu\r\tmax_score : %@\r\texplanation : %@\r\ttotal_score : %lu\r\ttotal_max_score : %lu\r\t%@\r\t%@\r\t}", self.options, (unsigned long)self.score, self.maxScore, self.explanation, (unsigned long)self.totalScore, (unsigned long)self.totalMaxScore, self.grade, self.rewards];
    
    return descriptionString;
}

+(PBQuestionAnswered *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBQuestionAnswered *c = [[PBQuestionAnswered alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.options = [PBQuestionAnsweredOptionArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"options"] startFromFinalLevel:YES];
    id score = [c.parseLevelJsonResponse objectForKey:@"score"];
    if([score respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.score = [score unsignedIntegerValue];
    }
    c.maxScore = [c.parseLevelJsonResponse objectForKey:@"max_score"];
    c.explanation = [c.parseLevelJsonResponse objectForKey:@"explanation"];
    
    id totalScore = [c.parseLevelJsonResponse objectForKey:@"total_score"];
    if([totalScore respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.totalScore = [totalScore unsignedIntegerValue];
    }
    
    id totalMaxScore = [c.parseLevelJsonResponse objectForKey:@"total_max_score"];
    if([totalMaxScore respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.totalMaxScore = [totalMaxScore unsignedIntegerValue];
    }
    
    c.grade = [PBQuestionAnsweredGradeDone parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"grade"] startFromFinalLevel:YES];
    c.rewards = [PBGradeDoneRewardArray parseFromDictionary:[c.parseLevelJsonResponse objectForKey:@"rewards"] startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// QuestionAnswered - Response
///--------------------------------------
@implementation PBQuestionAnswered_Response

@synthesize result;

-(NSString *)description
{
    return [self.result description];
}

+(PBQuestionAnswered_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result response
    PBQuestionAnswered_Response *c = [[PBQuestionAnswered_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'result'
        NSDictionary *result = [response objectForKey:@"result"];
        NSAssert(result != nil, @"result must not be nil");
        
        c.parseLevelJsonResponse = result;
    }
    
    // parse
    c.result = [PBQuestionAnswered parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// PlayerQuizRank
///--------------------------------------
@implementation PBPlayerQuizRank

@synthesize pbPlayerId;
@synthesize playerId;
@synthesize score;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Player's Quiz Rank : {\r\tpb_player_id : %@\r\tplayer_id : %@\r\tscore : %lu\r\t}", self.pbPlayerId, self.playerId, (unsigned long)self.score];
    
    return descriptionString;
}

+(PBPlayerQuizRank *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result object
    PBPlayerQuizRank *c = [[PBPlayerQuizRank alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.pbPlayerId = [c.parseLevelJsonResponse objectForKey:@"pb_player_id"];
    c.playerId = [c.parseLevelJsonResponse objectForKey:@"player_id"];
    id score = [c.parseLevelJsonResponse objectForKey:@"score"];
    if([score respondsToSelector:@selector(unsignedIntegerValue)])
    {
        c.score = [score unsignedIntegerValue];
    }
    
    return c;
}

@end

///--------------------------------------
/// PlayerQuizRankArray
///--------------------------------------
@implementation PBPlayerQuizRankArray

@synthesize list;

-(NSString *)description
{
    // create string to hold all player-quiz-rank line-by-line
    NSMutableString *lines = [NSMutableString stringWithString:@"Player's Quiz Rank Array : {"];
    
    for(PBPlayerQuizRank *item in self.list)
    {
        // get description line from each player-badge
        NSString *itemLine = [item description];
        // append \r
        NSString *itemLineWithCR = [NSString stringWithFormat:@"\r\t%@\r", itemLine];
        
        // append to result 'lines'
        [lines appendString:itemLineWithCR];
    }
    
    // end with brace
    [lines appendString:@"}"];
    
    return [NSString stringWithString:lines];
}

+(PBPlayerQuizRankArray *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create a result objct
    PBPlayerQuizRankArray *c = [[PBPlayerQuizRankArray alloc] init];
    
    // ignore parse level flag
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // convert json into array
    NSArray *pqrsJson = (NSArray*)c.parseLevelJsonResponse;
    
    // temp array to hold all items
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for(NSDictionary *pqrJson in pqrsJson)
    {
        // get player-quiz-rank object
        PBPlayerQuizRank *pqr = [PBPlayerQuizRank parseFromDictionary:pqrJson startFromFinalLevel:YES];
        
        // add to temp array
        [tempArray addObject:pqr];
    }
    
    // set back to result object
    c.list = [NSArray arrayWithArray:tempArray];
    
    return c;
}

@end

///--------------------------------------
/// PlayersQuizRank - Response
///--------------------------------------
@implementation PBPlayersQuizRank_Response

@synthesize playersQuizRank;

-(NSString *)description
{
    return [self.playersQuizRank description];
}

+(PBPlayersQuizRank_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create response
    PBPlayersQuizRank_Response *c = [[PBPlayersQuizRank_Response alloc] init];
    
    if(startFromFinalLevel)
    {
        c.parseLevelJsonResponse = [jsonResponse copy];
    }
    else
    {
        // get 'response'
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSAssert(response != nil, @"response must not be nil");
        
        // get 'result'
        NSDictionary *result = [response objectForKey:@"result"];
        NSAssert(result != nil, @"result must not be nil");
        
        c.parseLevelJsonResponse = result;
    }
    
    // parse
    c.playersQuizRank = [PBPlayerQuizRankArray parseFromDictionary:c.parseLevelJsonResponse startFromFinalLevel:YES];
    
    return c;
}

@end

///--------------------------------------
/// ManualSetResultStatus - Response
///--------------------------------------
@implementation PBManualSetResultStatus_Response

@synthesize success;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Manual Set Result Status Response : {\r\tstatus = %@\r\t}", self.success ? @"YES" : @"NO"];
    
    return descriptionString;
}

+(PBManualSetResultStatus_Response *)resultStatusWithSuccess
{
    // create result status object with success
    PBManualSetResultStatus_Response *c = [[PBManualSetResultStatus_Response alloc] init];
    c.success = YES;
    
    return c;
}

+(PBManualSetResultStatus_Response *)resultStatusWithFailure
{
    // create result status object with success
    PBManualSetResultStatus_Response *c = [[PBManualSetResultStatus_Response alloc] init];
    c.success = NO;
    
    return c;
}

@end

///--------------------------------------
/// ResultStatus - Response
///--------------------------------------
@implementation PBResultStatus_Response

@synthesize success;

-(NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Result Status Response : {\r\tstatus = %@\r\t}", self.success ? @"YES" : @"NO"];
    
    return descriptionString;
}

+(PBResultStatus_Response *)parseFromDictionary:(const NSDictionary *)jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel
{
    if(jsonResponse == nil || (id)jsonResponse == (id)[NSNull null])
        return nil;
    
    // create response
    PBResultStatus_Response *c = [[PBResultStatus_Response alloc] init];
    
    // ignore parse level
    c.parseLevelJsonResponse = [jsonResponse copy];
    
    // parse
    c.success = [[c.parseLevelJsonResponse objectForKey:@"success"] boolValue];
    
    return c;
}

@end

