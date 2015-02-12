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

@synthesize questionAnswered_response;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // initially didn't show anything for these two rewards
    self.expRewardLabel.hidden = true;
    self.pointRewardLabel.hidden = true;
    
    PBQuestionAnswered *result = questionAnswered_response.result;
    
    NSString *rExpReward, *rPointReward;
    
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
    }
    
    // immediately do async loading of rank image
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // load and cache image from above url
        NSURL *url = [NSURL URLWithString:result.grade.rankImage];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        // update ui
        dispatch_async(dispatch_get_main_queue(), ^{
            self.rankImageView.image = [[UIImage alloc] initWithData:imageData];
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

- (IBAction)goBackToMainMenu:(id)sender {
    
    // for this section, check your ui design and follow any necessary steps to go back to
    // specific ui view controller
    
    /// get parent modal view
    UIViewController *questionScreen = self.presentingViewController;
    // get quiz screen
    UIViewController *quizScreen = questionScreen.presentingViewController;
    // get quiz demo main screen
    UIViewController *quizMainScreen = quizScreen.presentingViewController;
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissed quiz result screen - modal");
        
        // dismiss a parent (it's a modal view)
        [questionScreen dismissViewControllerAnimated:YES completion:^{
            NSLog(@"dismissed question screen - modal");
            
            // popup quiz screen
            [quizScreen dismissViewControllerAnimated:YES completion:^{
                NSLog(@"dismissed quiz screen - pushed");
                
                // dismiss quiz-main screen and finally got back to mainmenu screen
                [quizMainScreen dismissViewControllerAnimated:YES completion:^{
                    NSLog(@"dismissed quiz-main screen - pushed");
                    NSLog(@"all done");
                }];
            }];
            
        }];
    }];
}
@end
