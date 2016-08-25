//
//  PBGoodsRewardData.m
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import "PBGoodsRewardData.h"

@implementation PBGoodsRewardData

+(void)configure:(id)mappingProvider
{
    // call super to set up for derived class
    // BUG: resolve issue of crash for "description" is not key-value pair of class, but others won't affected
    [super configure:mappingProvider forClass:[PBGoodsRewardData class]];
}

@end
