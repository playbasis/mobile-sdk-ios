//
//  PBBadgeValue.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import <Foundation/Foundation.h>

/**
 Badge in rewards
 */
@interface PBBadgeValue : NSObject

@property (nonatomic, strong) NSString* badgeId;
@property (nonatomic, strong) NSNumber* badgeValue;

@end
