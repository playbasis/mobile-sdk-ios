//
//  PBRewards.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/1/16.
//
//

#import <Foundation/Foundation.h>
#import "OCMapperConfigurable.h"
#import "PBExpValue.h"
#import "PBPointValue.h"
#import "PBBadgeValue.h"

/**
 Rewards
 Contains 3 elements as child: exp, point, or badge.
 */
@interface PBRewards : NSObject <OCMapperConfigurable>  // TODO: remove protocol here as it's working around solution to make it deserialize the field

@property (nonatomic, strong) PBExpValue* exp;
@property (nonatomic, strong) PBPointValue* point;
@property (nonatomic, strong) NSArray<PBBadgeValue*>* badge;

@end
