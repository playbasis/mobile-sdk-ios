//
//  PBGameItemStatusRoot.m
//  pblib
//
//  Created by Wasin Thonkaew on 10/10/16.
//
//

#import "PBGameItemStatusRoot.h"
#import "PBItemStatus.h"

@implementation PBGameItemStatusRoot

+ (void)configure:(id)mappingProvider
{
    [mappingProvider mapFromDictionaryKey:@"items_status" toPropertyKey:@"items_status" withObjectType:[PBItemStatus class] forClass:[PBGameItemStatusRoot class]];
}

@end
