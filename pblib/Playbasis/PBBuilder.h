//
//  PBBuilder.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import <Foundation/Foundation.h>

@class Playbasis;

@interface PBBuilder : NSObject

-(PBBuilder*)setBaseUrl:(NSString *)url;
-(PBBuilder*)setBaseAsyncUrl:(NSString *)url;
-(PBBuilder*)setApiKey:(NSString *)apiKey;
-(PBBuilder*)setApiSecret:(NSString *)apiSecret;

-(Playbasis*)build;

@end
