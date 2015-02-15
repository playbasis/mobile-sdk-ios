//
//  questDemoViewController.m
//  demoApp
//
//  Created by haxpor on 1/29/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "questDemoViewController.h"
#import "missionViewController.h"
#import "Playbasis.h"
#import "demoAppSettings.h"

@interface questDemoViewController ()

@end

@implementation questDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.questNameLabel.text = self.questName;
    self.questImageView.image = self.questImage;
    self.questDescriptionLabel.text = self.questDescription;
    self.questRewardsLabel.text = self.questRewards;
    
    if([self.questStatus isEqualToString:@"finish"])
    {
        self.questAbleToJoinOrContinueButton.hidden = YES;
        self.questContinueButton.hidden = YES;
    }
    else if([self.questStatus isEqualToString:@"join"])
    {
        self.questAbleToJoinOrContinueButton.hidden = YES;
        self.questContinueButton.hidden = NO;
    }
    else
    {
        self.questAbleToJoinOrContinueButton.hidden = NO;
        self.questContinueButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"showMissionInfoScreenViaJoin"])
    {
        missionViewController *missionView = [segue destinationViewController];
        missionView.questId = _questId;
        missionView.viaMethod = QUEST_JOIN;
    }
    else if([[segue identifier] isEqualToString:@"showMissionInfoScreenViaContinue"])
    {
        missionViewController *missionView = [segue destinationViewController];
        missionView.questId = _questId;
        missionView.viaMethod = QUEST_CONTINUE;
    }
}

@end
