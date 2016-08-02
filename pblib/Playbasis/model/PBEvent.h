//
//  PBEvent.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import <Foundation/Foundation.h>
#import "PBRewardData.h"

@interface PBEvent : NSObject

@property (nonatomic, strong) NSString* eventType;
@property (nonatomic, strong) NSString* rewardType;
@property (nonatomic, strong) PBRewardData* rewardData;
@property (nonatomic, strong) NSString* value;

@end
