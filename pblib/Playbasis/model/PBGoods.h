//
//  PBGoods.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/18/16.
//
//

#import <Foundation/Foundation.h>
#import "OCMapperConfigurable.h"

@interface PBGoods : NSObject <OCMapperConfigurable>

@property (nonatomic, strong) NSString* goodsId;
@property (nonatomic, strong) NSString* image;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) NSNumber* amount;

@end
