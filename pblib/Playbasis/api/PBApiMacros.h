//
//  PBApiMacros.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/18/16.
//
//

#import <Foundation/Foundation.h>

/**
    Check if Playbasis instance is valid, if not then raise exception.
 */
#define API_VALIDATE_PBOBJ(playbasis) if (![PBValidator isValid:playbasis]) \
    [NSException raise:@"playbasis instance is neeed" format:@"playabsis instance cannot be nil"];

/**
    Create a method string variable with variadic parameter. Always end with nil.
 */
#define API_CREATE_METHOD_VARS(apiKey, str, ...) NSString *method = [[PBUtils sharedInstance] createMethodWithApiKeyUrlFromMethod:[NSString stringWithFormat:str, __VA_ARGS__] andApiKey:apiKey];

/**
    Create a post data string with variadic parameter of value1, key1, value2, key2, and on. Always end with nil.
 */
#define API_CREATE_DATA_VARS(...)    NSString *data = [[PBUtils sharedInstance] createPostDataStringFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys: __VA_ARGS__]];



