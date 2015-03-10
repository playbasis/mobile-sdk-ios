//
//  UIImage+AutoLoader.h
//  pblib
//
//  Created by Playbasis on 2/24/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AutoLoader)

/**
 Start loading image in the background with given url, then return it via a given block.
 This method will return immediately.
 */
+(void) startLoadingImageInTheBackgroundWithUrl:(NSString *)imageUrl response:(void (^)(UIImage* image))response;

/**
 Start loading image with given url, then return it via a given block.
 This method is blocking call until loading finishes.
 */
+(void) startLoadingImageWithUrl:(NSString *)imageUrl response:(void (^)(UIImage* image))response;

@end
