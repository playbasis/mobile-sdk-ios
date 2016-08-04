//
//  UIImage+AutoLoader.m
//  pblib
//
//  Created by Playbasis on 2/24/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "UIImage+AutoLoader.h"

@implementation UIImage (AutoLoader)

+(void)startLoadingImageInTheBackgroundWithUrl:(NSString *)imageUrl complete:(void (^)(UIImage *image))onComplete andError:(void (^)(NSError *error))onError
{
    // start loading image in the background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // create a url
        NSURL *url = [NSURL URLWithString:imageUrl];
        // start loading
        NSError *error = nil;
        NSData *imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:&error];
        
        if (error != nil)
        {
            NSLog(@"error loading image: %@", [error localizedDescription]);
        }
        
        // return via response block if error is nil
        if (error == nil)
        {
            onComplete([[UIImage alloc] initWithData:imageData]);
        }
        else
        {
            onError(error);
        }
    });
}

+(void)startLoadingImageWithUrl:(NSString *)imageUrl complete:(void (^)(UIImage *))onComplete andError:(void (^)(NSError *error))onError
{
    // create a url
    NSURL *url = [NSURL URLWithString:imageUrl];
    // start loading
    NSError *error = nil;
    NSData *imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:&error];
    
    // return via response block if error is nil
    if (error == nil)
    {
        onComplete([[UIImage alloc] initWithData:imageData]);
    }
    else
    {
        onError(error);
    }
}

@end
