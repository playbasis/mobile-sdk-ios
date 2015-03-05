//
//  PBMacros.h
//  pblib
//
//  Created by haxpor on 3/5/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#ifndef pblib_PBMacros_h
#define pblib_PBMacros_h

#define PB_IS_NSNull(obj)   ((obj == (id)[NSNull null]) ? YES : NO)

#define PB_IS_NIL_OR_NSNull(obj)    ((obj == nil) || (obj == (id)[NSNull null]) ? YES : NO)
#endif
