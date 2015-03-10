//
//  PBCommon.h
//  pblib
//
//  Created by Playbasis on 3/5/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The max length of PBLog message.
 */
static const int kMaxLogLen = 16*1024;

/**
 Ouput debug message.
 */
void PBLog(NSString * pszFormat, ...);
