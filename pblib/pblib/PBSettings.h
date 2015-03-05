//
//  PBSettings.h
//  pblib
//
//  Created by haxpor on 2/23/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#ifndef pblib_PBSettings_h
#define pblib_PBSettings_h

/**
 Shared key used to decrypt protected resource during the time of Playbasis's startup.
 TODO:
 - Change this for your application.
 - Update a run script in pblib project as well.
 */
static NSString* const pbProtectedResourcesSharedKey = @"abcdefghijklmnopqrstuvwxyz123456";

/**
 Number of retry of PBRequestUnit to do before giving up.
 */
static const NSUInteger pbRequestRetryCount = 1;

/**
 Amount of delay in millisecond to initiate a next retry.
 */
static const float pbDelayAmountBeforeNextRequestRetry = 10000;

/**
 Debug mode enabled.
 */
#define PBDebugMode 1

#endif
