//
//  PBMacros.h
//  pblib
//
//  Created by haxpor on 3/5/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#ifndef pblib_PBMacros_h
#define pblib_PBMacros_h

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

#endif
