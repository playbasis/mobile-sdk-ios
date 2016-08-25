//
//  PBRule.h
//  pblib
//
//  Created by Wasin Thonkaew on 8/25/16.
//
//

#import <Foundation/Foundation.h>
#import "OCMapperConfigurable.h"
#import "PBEvent.h"

@interface PBRule : NSObject <OCMapperConfigurable>

@property (nonatomic, strong) NSArray<PBEvent*>* events;
// TODO: Add "events_missions", and "events_quests" fields later

@end
