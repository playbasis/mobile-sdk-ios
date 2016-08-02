//
//  PBRewardData.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/2/16.
//
//

#import <Foundation/Foundation.h>
#import "OCMapperConfigurable.H"

@interface PBRewardData : NSObject <OCMapperConfigurable>

@property (nonatomic, strong) NSString* image;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* desc;

@end
