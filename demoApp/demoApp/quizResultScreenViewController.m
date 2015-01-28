//
//  quizResultScreenViewController.m
//  demoApp
//
//  Created by haxpor on 1/28/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "quizResultScreenViewController.h"
#import "playbasis.h"

@interface quizResultScreenViewController ()

@end

@implementation quizResultScreenViewController

@synthesize jsonResponse;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // initially didn't show anything for these two rewards
    self.expRewardLabel.hidden = true;
    self.pointRewardLabel.hidden = true;
    
    // get all the required information
    // note: retrieve information from 'jsonResponse'
    NSDictionary *response = [jsonResponse objectForKey:@"response"];
    NSDictionary *result = [response objectForKey:@"result"];
    NSDictionary *gradeJsonResponse = [result objectForKey:@"grade"];
    
    rRankImageUrl = [gradeJsonResponse objectForKey:@"rank_image"];
    rRankName = [gradeJsonResponse objectForKey:@"rank"];
    rTotalScore = [(NSString*)[gradeJsonResponse objectForKey:@"total_score"] integerValue];
    rTotalMaxScore = [(NSString*)[gradeJsonResponse objectForKey:@"total_max_score"] integerValue];
    
    // get rewards
    NSArray *rewards = [result objectForKey:@"rewards"];
    for(NSDictionary *json in rewards)
    {
        // check type
        NSString *rewardType = [json objectForKey:@"reward_type"];
        if([rewardType isEqualToString:@"exp"])
        {
            rExpReward = [(NSString*)[json objectForKey:@"value"] integerValue];
        }
        else if([rewardType isEqualToString:@"point"])
        {
            rPointReward = [(NSString*)[json objectForKey:@"value"] integerValue];
        }
    }
    
    // immediately do async loading of rank image
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // load and cache image from above url
        NSURL *url = [NSURL URLWithString:rRankImageUrl];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        // update ui
        dispatch_async(dispatch_get_main_queue(), ^{
            self.rankImageView.image = [[UIImage alloc] initWithData:imageData];
            self.rankNameLabel.text = rRankName;
            self.scoreOutOfLabel.text = [NSString stringWithFormat:@"Got %d out of %d", rTotalScore, rTotalMaxScore];
            
            if(rExpReward != 0)
            {
                self.expRewardLabel.text = [NSString stringWithFormat:@"Got %d exp", rExpReward];
                self.expRewardLabel.hidden = false;
            }
            if(rPointReward != 0)
            {
                self.pointRewardLabel.text = [NSString stringWithFormat:@"Got %d point", rPointReward];
                self.pointRewardLabel.hidden = false;
            }
        });
    });
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

@end
