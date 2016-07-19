//
//  PBLevel.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/19/16.
//
//

#import <Foundation/Foundation.h>

@interface PBLevel : NSObject

@property (nonatomic, strong) NSString* levelTitle;
@property (nonatomic, strong) NSNumber* level;
@property (nonatomic, strong) NSNumber* minExp;
@property (nonatomic, strong) NSNumber* maxExp;
@property (nonatomic, strong) NSString* levelImage;

@end
