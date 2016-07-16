//
//  PBBuilderConfiguration.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import <Foundation/Foundation.h>

@interface PBBuilderConfiguration : NSObject

@property (nonatomic, strong) NSString* baseUrl;
@property (nonatomic, strong) NSString* baseAsyncUrl;
@property (nonatomic, strong) NSString* apiKey;
@property (nonatomic, strong) NSString* apiSecret;

@end
