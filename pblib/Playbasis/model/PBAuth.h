//
//  PBAuth.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/15/16.
//
//

#import <Foundation/Foundation.h>

@interface PBAuth : NSObject

@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSDate* dateExpire;

@end
