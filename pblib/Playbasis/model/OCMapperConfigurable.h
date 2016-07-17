//
//  OCMapperConfigurable.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/17/16.
//
//

#import <Foundation/Foundation.h>
#import <OCMapper/OCMapper.h>

/**
 Protocol to allow any model class used with OCMapper to have a chance to configure if needed.
 */
@protocol OCMapperConfigurable <NSObject>

/**
 Configure with mapping provider of OCMapper

 @param mappingProvider Mapping provider
 */
+ (void)configure:(InCodeMappingProvider*)mappingProvider;

@end
