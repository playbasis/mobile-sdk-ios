//
//  InterfaceController.m
//  demoApp WatchKit Extension
//
//  Created by haxpor on 3/10/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "InterfaceController.h"

@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)requestToGetPlayerFirstName {
    NSLog(@"Sending message to iPhone app");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // reset text label every time we make a request
        self.textLabel.text = @"";
    });
    
    // send a request data (can be anything) to let iPhone app to make a request to
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"playerPublic-firstName" forKey:@"message"];
    [WKInterfaceController openParentApplication:dict reply:^(NSDictionary *replyInfo, NSError *error) {
        
        if(error == nil)
        {
            // get response text
            NSString *response = [replyInfo objectForKey:@"response"];
            
            if(response != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // update to label
                    self.textLabel.text = response;
                    
                    NSLog(@"Set back result to text label.");
                });
            }
        }
        else
        {
            NSLog(@"error occurs : %@", error);
        }
    }];
}
@end



