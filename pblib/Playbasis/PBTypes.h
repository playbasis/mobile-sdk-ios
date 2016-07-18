//
//  PBTypes.h
//  pblib
//
//  Created by Playbasis on 1/22/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "Reachability.h"

/**
 Network status changed protocol
 */
@protocol PBNetworkStatusChangedDelegate <NSObject>

/**
 This method will be called when network status has changed

 @param status status of network
 */
- (void)networkStatusChanged:(NetworkStatus)status;
@end
