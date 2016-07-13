//
//  UIImage+AutoLoader.m
//  pblib
//
//  Created by Playbasis on 2/24/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#if TARGET_OS_IOS
#import "UIImage+AutoLoader.h"

@implementation UIImage (AutoLoader)

+(void)startLoadingImageInTheBackgroundWithUrl:(NSString *)imageUrl response:(void (^)(UIImage *image))response
{
    // start loading image in the background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // create a url
        NSURL *url = [NSURL URLWithString:imageUrl];
        // start loading
        NSError *error;
        NSData *imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:&error];
        
        if (error != nil)
        {
            NSLog(@"error loading image: %@", [error localizedDescription]);
        }
        
        // return via response block
        response([[UIImage alloc] initWithData:imageData]);
    });
}

+(void)startLoadingImageWithUrl:(NSString *)imageUrl response:(void (^)(UIImage *))response
{
    // create a url
    NSURL *url = [NSURL URLWithString:imageUrl];
    // start loading
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    // return via response block
    response([[UIImage alloc] initWithData:imageData]);
}

@end
#endif
