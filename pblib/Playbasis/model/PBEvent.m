//
//  PBEvent.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import "PBEvent.h"
#import "PBBadgeRewardData.h"
#import "PBGoodsRewardData.h"

@implementation PBEvent

+(void)configure:(InCodeMappingProvider *)mappingProvider
{
    // map reward data according to which type of reward
    // it can be badge or goods
    [mappingProvider mapFromDictionaryKey:@"reward_data" toPropertyKey:@"reward_data" forClass:[PBEvent class] withTransformer:^id(id currentNode, id parentNode) {
        NSString *rewardType = [parentNode objectForKey:@"reward_type"];
        PBRewardData *reward;
        
        if ([rewardType isEqualToString:@"badge"])
        {
            reward = [PBBadgeRewardData objectFromDictionary:currentNode];
        }
        else if ([rewardType isEqualToString:@"goods"])
        {
            reward = [PBGoodsRewardData objectFromDictionary:currentNode];
        }
        
        return reward;
    }];
}

@end
