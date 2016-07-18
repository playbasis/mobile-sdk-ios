//
//  PBSuccessStatus.h
//  pblib
//
//  Created by Wasin Thonkaew on 7/18/16.
//
//

#import <Foundation/Foundation.h>

@interface PBSuccessStatus : NSObject

@property (nonatomic) BOOL success;

-(instancetype)initWithBool:(BOOL)success;

@end
