//
//  PBDetailedPlayer.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/18/16.
//
//

#import <Foundation/Foundation.h>
#import "PBPlayer.h"
#import "PBBadge.h"
#import "PBGoods.h"

@interface PBDetailedPlayer : PBPlayer

@property (nonatomic, strong) NSNumber* percentOfLevel;
@property (nonatomic, strong) NSString* levelTitle;
@property (nonatomic, strong) NSString* levelImage;
@property (nonatomic, strong) NSArray<PBBadge*>* badges;
@property (nonatomic, strong) NSArray<PBGoods*>* goods;

@end
