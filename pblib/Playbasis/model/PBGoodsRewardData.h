//
//  PBGoodsRewardData.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import <Foundation/Foundation.h>
#import "PBRewardData.h"

@interface PBGoodsRewardData : PBRewardData

@property (nonatomic, strong) NSString* goodsId;
@property (nonatomic, strong) NSNumber* perUser;
@property (nonatomic, strong) NSString* code;

@end
