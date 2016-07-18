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
 PBLOG, console logging
 */
#if DEBUG
#define PBLOG(text, ...)    PBLog(text, ##__VA_ARGS__)
#else
#define PBLOG(text, ...)    /* */
#endif

#endif
