//
//  PBCommon.m
//  pblib
//
//  Created by Playbasis on 3/5/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "PBCommon.h"

void PBLog(NSString * pszFormat, ...)
{
    NSString *str = [NSString stringWithFormat:@"[Playbasis] : %@", pszFormat];
    
    va_list ap;
    va_start(ap, pszFormat);
    NSLogv(str, ap);
    va_end(ap);
}
