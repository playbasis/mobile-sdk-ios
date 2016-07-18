//
//  PBCommon.h
//  pblib
//
//  Created by Playbasis on 3/5/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Max buffer length in bytes
 */
static const int kMaxLogLen = 16*1024;

/**
 Log message to console only if preprocessor "DEBUG" is set.

 @param pszFormat format string
 @param ...       variadic parameters
 */
void PBLog(NSString * pszFormat, ...);
