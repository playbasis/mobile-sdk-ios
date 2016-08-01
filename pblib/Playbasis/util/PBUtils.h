//
//  PBUtils.h
//  pblib
//
//  Created by Playbasis on 3/5/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
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

/**
 Get platform string.
 */
-(NSString *)platformString;


/**
 Create method url from specified method, and api key

 @param method method url
 @param apiKey api key

 @return combined method url with apikey ready to use
 */
-(NSString *)createMethodWithApiKeyUrlFromMethod:(NSString *)method andApiKey:(NSString *)apiKey;


/**
 Create a post data as string

 @param keyValues key-value pair in dictioanry

 @return post data string
 */
-(NSString *)createPostDataStringFromDictionary:(NSDictionary<NSString*, NSString*> *)keyValues;

@end
