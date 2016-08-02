//
//  PBBadgeRewardData.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import <Foundation/Foundation.h>
#import "PBRewardData.h"

@interface PBBadgeRewardData : PBRewardData

@property (nonatomic, strong) NSString* hint;
@property (nonatomic, strong) NSString* badgeId;
@property (nonatomic, strong) NSArray<NSString*>* tags;

@end
