//
//  PBBadge.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/18/16.
//
//

#import <Foundation/Foundation.h>
#import "OCMapperConfigurable.h"

@interface PBBadge : NSObject <OCMapperConfigurable>

@property (nonatomic, strong) NSString* badgeId;
@property (nonatomic, strong) NSString* image;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* desc;   // use "desc" instead of "description" as the latter means description method of NSObject, thus we need to configure this model
@property (nonatomic, strong) NSNumber* amount;
@property (nonatomic, strong) NSString* hint;
@property (nonatomic, strong) NSMutableArray<NSString*>* tags;

+ (void)configure:(InCodeMappingProvider *)mappingProvider;

@end
