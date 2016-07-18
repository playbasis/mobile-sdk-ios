//
//  PBSettings.h
//  pblib
//
//  Created by Playbasis on 2/23/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#ifndef pblib_PBSettings_h
#define pblib_PBSettings_h

/**
 Number of retry of PBRequestUnit to do before giving up.
 */
static const NSUInteger pbRequestRetryCount = 1;

/**
 Amount of delay in millisecond to initiate a next retry.
 */
static const float pbDelayAmountBeforeNextRequestRetry = 10000;

static NSString * const BASE_URL = @"https://api.pbapp.net/";
// only apply to some of api call ie. rule()
static NSString * const BASE_ASYNC_URL = @"https://api.pbapp.net/async/call";

#endif
