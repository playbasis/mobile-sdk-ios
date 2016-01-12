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
    NSMutableDictionary *options = [[NSMutableDictionary alloc]init];
    [options setObject:@"567bfc8f5e232a204f8b45c3" forKey:@"organize_id"];
    [[Playbasis sharedPB]storeNodeList:options withBlock:^(PBNodeOrganize_Response *response, NSURL *url, NSError *error) {
        
        [_detailView setText:[NSString stringWithFormat:@"%@",[response parseLevelJsonResponse]]];
    }];
    
}
-(IBAction)childNode:(id)sender
{
    [[Playbasis sharedPB]childNodeList:@"567c05705e232a214f8b563e" layer:nil withBlock:^(PBNodeOrganize_Response *response, NSURL *url, NSError *error) {
        
        [_detailView setText:[NSString stringWithFormat:@"%@",[response parseLevelJsonResponse]]];
    }];
 
    
}
-(IBAction)associatedNode:(id)sender
{
    [[Playbasis sharedPB]getAssociatedNode:@"sm1" withBlock:^(PBAssociatedNode_Response *response, NSURL *url, NSError *error) {
        
        [_detailView setText:[NSString stringWithFormat:@"%@",[response parseLevelJsonResponse]]];
    }];
    
}
-(IBAction)saleHistory:(id)sender
{
    [[Playbasis sharedPB]saleHistory:@"567c05705e232a214f8b563e" count:@"6" options:nil withBlock:^(PBSaleHistory_Response *response, NSURL *url, NSError *error) {
        [_detailView setText:[NSString stringWithFormat:@"%@",[response parseLevelJsonResponse]]];
        
    }];
    
}
-(IBAction)saleBoard:(id)sender
{
    [[Playbasis sharedPB]saleBoard:@"567c05705e232a214f8b563e" layer:@"0" options:nil withBlock:^(PBSaleBoard_Response *response, NSURL *url, NSError *error) {
        [_detailView setText:[NSString stringWithFormat:@"%@",[response parseLevelJsonResponse]]];
        
    }];
    
}

@end
