//
//  PBTypes.h
//  pblib
//
//  Created by haxpor on 1/22/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#ifndef pblib_PBTypes_h
#define pblib_PBTypes_h

@protocol PBResponseHandler <NSObject>
-(void)processResponse:(NSDictionary*)jsonResponse withURL:(NSURL *)url;
@end

#endif
