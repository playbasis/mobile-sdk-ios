//
//  PBGameItemStatusRoot.h
//  pblib
//
//  Created by Wasin Thonkaew on 10/10/16.
//
//

#import <Foundation/Foundation.h>
#import "OCMapperConfigurable.h"
#import "PBItemStatus.h"

@interface PBGameItemStatusRoot : NSObject <OCMapperConfigurable>

@property (nonatomic, strong) NSString* stageLevel;
@property (nonatomic, strong) NSString* stageName;
@property (nonatomic, strong) NSArray<PBItemStatus*>* itemsStatus;

@end
