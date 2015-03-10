//
//  quizResultScreenViewController.m
//  demoApp
//
//  Created by Playbasis on 1/28/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "quizResultScreenViewController.h"
#import "Playbasis.h"

@interface quizResultScreenViewController ()

@end

@implementation quizResultScreenViewController

@synthesize questionAnswered_response;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // initially didn't show anything for these two rewards
    self.expRewardLabel.hidden = true;
    self.pointRewardLabel.hidden = true;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    PBQuestionAnswered *result = questionAnswered_response.result;
    
    NSString *rExpReward, *rPointReward, *rCoinReward;
    
    // get rewards
    for(PBGradeDoneReward *reward in result.rewards.gradeDoneRewards)
    {
        // check type
        if([reward.rewardType isEqualToString:@"exp"])
        {
            rExpReward = reward.value;
        }
        else if([reward.rewardType isEqualToString:@"point"])
        {
            rPointReward = reward.value;
        }
        else if([reward.rewardType isEqualToString:@"coin"])
        {
            rCoinReward = reward.value;
        }
    }
    
    NSMutableString *statusUpdate = [NSMutableString stringWithString:@"Finished quiz."];
    if(rExpReward != nil)
    {
        [statusUpdate appendFormat:@"\nGot %@ exp. ", rExpReward];
    }
    if(rPointReward != nil)
    {
        [statusUpdate appendFormat:@"\nGot %@ point.", rPointReward];
    }
    if(rCoinReward != nil)
    {
        [statusUpdate appendFormat:@"\nGot %@ coin.", rCoinReward];
    }
    
    // load image, then after finish do further stuff
    [UIImage startLoadingImageInTheBackgroundWithUrl:result.grade.rankImage response:^(UIImage *image) {
        // update ui
        dispatch_async(dispatch_get_main_queue(), ^{
            self.rankImageView.image = image;
            self.rankNameLabel.text = result.grade.rank;
            self.scoreOutOfLabel.text = [NSString stringWithFormat:@"Got %lu out of %lu", (unsigned long)result.totalScore, (unsigned long)result.totalMaxScore];
            
            if(rExpReward != nil)
            {
                self.expRewardLabel.text = [NSString stringWithFormat:@"Got %@ exp", rExpReward];
                self.expRewardLabel.hidden = false;
            }
            if(rPointReward != nil)
            {
                self.pointRewardLabel.text = [NSString stringWithFormat:@"Got %@ point", rPointReward];
                self.pointRewardLabel.hidden = false;
            }
        });
        
        // show update on status
        [[Playbasis sharedPB] showFeedbackStatusUpdateWithText:statusUpdate];
    }];
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

- (IBAction)goBackToMainMenu:(id)sender {
    
    // go back to root navigation controller (mainmenu)
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
