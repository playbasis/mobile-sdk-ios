//
//  PBItemStatus.h
//  pblib
//
//  Created by Wasin Thonkaew on 10/10/16.
//
//

#import <Foundation/Foundation.h>
#import "PBItemConfig.h"

@interface PBItemStatus : NSObject

@property (nonatomic, strong) NSString* itemId;
@property (nonatomic, strong) NSString* itemName;
@property (nonatomic, strong) PBItemConfig* itemConfig;
@property (nonatomic, strong) NSString* itemStatus;
@property (nonatomic, strong) NSString* itemImage;

@end
