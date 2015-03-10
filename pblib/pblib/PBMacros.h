//
//  PBMacros.h
//  pblib
//
//  Created by Playbasis on 3/5/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#ifndef pblib_PBMacros_h
#define pblib_PBMacros_h

#import "PBSettings.h"
#import "PBCommon.h"

/**
 Check against NSNull.
 If input obj is NSNull then return YES, otherwise return NO.
 */
#define PB_IS_NSNull(obj)   ((obj == (id)[NSNull null]) ? YES : NO)

/**
 Check against nil or NSNull.
 If input obj is nil, or NSNull then return YES, otherwise return NO.
 */
#define PB_IS_NIL_OR_NSNull(obj)    ((obj == nil) || (obj == (id)[NSNull null]) ? YES : NO)

/**
 PBLOG, console logging
 */
#if PBDebugMode == 1
#define PBLOG(text, ...)    PBLog(text, ##__VA_ARGS__)
#else
#define PBLOG(text, ...)    do {} while(0)
#endif

#endif
