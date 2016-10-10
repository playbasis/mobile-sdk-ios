//
//  PBItemConfig.h
//  pblib
//
//  Created by Wasin Thonkaew on 10/10/16.
//
//

#import <Foundation/Foundation.h>

@interface PBItemConfig : NSObject

@property (nonatomic, strong) NSNumber* row;
@property (nonatomic, strong) NSNumber* column;
@property (nonatomic, strong) NSNumber* daysToDeduct;
@property (nonatomic, strong) NSNumber* amountToHarvest;

@end
