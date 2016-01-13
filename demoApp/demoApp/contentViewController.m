//
//  contentViewController.m
//  demoApp
//
//  Created by Patsita Kongkaew on 1/12/16.
//  Copyright © 2016 Maethee Chongchitnant. All rights reserved.
//

#import "contentViewController.h"
#import "demoAppSettings.h"
@implementation contentViewController
-(IBAction)getContent:(id)sender
{
    
        [[Playbasis sharedPB]getContent:nil withBlock:^(PBContent_Response *response, NSURL *url, NSError *error) {
            
            [_detailView setText:[NSString stringWithFormat:@"%@",[response parseLevelJsonResponse]]];
        }];
}
-(IBAction)playerAuth:(id)sender
{
    NSMutableDictionary *options = [[NSMutableDictionary alloc]init];
    [options setObject:@"sm1" forKey:@"username"];
    [[Playbasis sharedPB]playerAuthForPlayerId:@"12345678" options:options withBlock:^(PBPlayer_Response *player, NSURL *url, NSError *error) {
        [_detailView setText:[NSString stringWithFormat:@"%@",[player parseLevelJsonResponse]]];
    }];
}
@end
