//
//  badgeDemoViewController.m
//  demoApp
//
//  Created by Playbasis on 1/27/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "badgeDemoViewController.h"
#import <Playbasis/Playbasis.h>
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
    [[Playbasis sharedPB] ruleForPlayerAsync:USER action:@"like" withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"%@", response);
            
            BOOL isBadgeReward = NO;
            
            // check if we have a badge reward, then we will show it
            for(PBRuleEvent *event in response.events.list)
            {
                if([event.rewardType isEqualToString:@"badge"])
                {
                    // set badge reward
                    isBadgeReward = YES;
                    
                    // get image url
                    NSString *imageUrl = ((PBRuleEventBadgeRewardData*)event.rewardData).image;
                    
                    [UIImage startLoadingImageInTheBackgroundWithUrl:imageUrl response:^(UIImage *image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.badgeImage.image = image;
                            self.badgeImage.hidden = false;
                            self.activityIndicator.hidden = true;
                            
                            // update text to update
                            PBRuleEventBadgeRewardData *rewardData = event.rewardData;
                            NSString *text = [NSString stringWithFormat:@"You just got a badge '%@'", rewardData.name];
                            
                            // show status update
                            [[Playbasis sharedPB] showFeedbackStatusUpdateWithText:text];
                            
                            // show event popup update
                            [[Playbasis sharedPB] showFeedbackEventPopupWithImage:image title:@"Badge" description:text];
                        });
                    }];
                }
            }
            
            // if we didn't got a badge reward, then we stop spinning activity indicator
            if(!isBadgeReward)
            {
                // there's no badge to show, then we stop spinning activity indicator
                dispatch_queue_t uiQ = dispatch_get_main_queue();
                dispatch_async(uiQ, ^{
                    // hide activity indicator
                    self.activityIndicator.hidden = true;
                });
            }
        }
        else
        {
            NSLog(@"Error %@", error);
        }
    }, nil];
}
@end
