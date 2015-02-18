//
//  badgeDemoViewController.m
//  demoApp
//
//  Created by haxpor on 1/27/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "badgeDemoViewController.h"
#import "Playbasis.h"
#import "demoAppSettings.h"

@interface badgeDemoViewController ()

@end

@implementation badgeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // initially hide activity indicator
    self.activityIndicator.hidden = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doLikeAction:(id)sender {
    // show activity indicator
    self.activityIndicator.hidden = false;
    self.badgeImage.hidden = true;
    
    // execute 'like' action
    // note: this will let activity indicator to be updated in UI thread
    dispatch_queue_t gQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(gQueue, ^{
        [[Playbasis sharedPB] ruleForPlayer:USER action:@"like" withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            
            // if thing goes okay
            if(!error)
            {
                // print out response data
                NSLog(@"response data = %@", [jsonResponse description]);
                
                // check if we got 'badge' reward just yet
                if([jsonResponse objectForKey:@"response"] != nil)
                {
                    // get 'events' data
                    NSDictionary *response = [jsonResponse objectForKey:@"response"];
                    NSArray *events = (NSArray*)[response objectForKey:@"events"];
                    
                    if(events != nil)
                    {
                        // loop through all the events and find 'reward_type' of 'badge'
                        for (NSDictionary *event in events)
                        {
                            // find 'reward_type' of 'badge'
                            NSString *rewardType = [event objectForKey:@"reward_type"];
                            if([rewardType isEqualToString:@"badge"])
                            {
                                // get reward data
                                NSDictionary *rewardData = [event objectForKey:@"reward_data"];
                                
                                if(rewardData != nil)
                                {
                                    // get image url path
                                    NSString* imageUrl = [rewardData objectForKey:@"image"];
                                    
                                    if(imageUrl != nil)
                                    {
                                        // load badge image from url
                                        NSURL *url = [NSURL URLWithString:imageUrl];
                                        NSData *data = [NSData dataWithContentsOfURL:url];
                                        UIImage *img = [[UIImage alloc] initWithData:data];
                                        
                                        // update ui stuff
                                        dispatch_queue_t uiQ = dispatch_get_main_queue();
                                        dispatch_async(uiQ, ^{
                                            // set image to UIImageView
                                            self.badgeImage.image = img;
                                            
                                            // show UIImageView
                                            self.badgeImage.hidden = false;
                                            
                                            // hide activity indicator
                                            self.activityIndicator.hidden = true;
                                        });
                                    }
                                }
                            }
                        }
                    }
                    
                    // update ui stuff
                    dispatch_queue_t uiQ = dispatch_get_main_queue();
                    dispatch_async(uiQ, ^{
                        // hide activity indicator
                        self.activityIndicator.hidden = true;
                    });
                }
            }
        }, nil];
    });
}
@end
