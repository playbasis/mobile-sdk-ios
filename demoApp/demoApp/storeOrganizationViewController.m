//
//  storeOrganizationViewController.m
//  demoApp
//
//  Created by Patsita Kongkaew on 1/8/16.
//  Copyright © 2016 Maethee Chongchitnant. All rights reserved.
//

#import "storeOrganizationViewController.h"
#import "demoAppSettings.h"
@implementation storeOrganizationViewController

-(IBAction)listOrganize:(id)sender
{
    [[Playbasis sharedPB]storeOrganizeList:nil withBlock:^(PBStoreOrganize_Response *response, NSURL *url, NSError *error) {
        
        [_detailView setText:[NSString stringWithFormat:@"%@",[response parseLevelJsonResponse]]];
    }];
}
-(IBAction)listNode:(id)sender
{
    
}
@end
