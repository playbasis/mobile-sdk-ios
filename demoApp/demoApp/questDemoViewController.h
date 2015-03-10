//
//  questDemoViewController.h
//  demoApp
//
//  Created by Playbasis on 1/29/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface questDemoViewController : UIViewController

@property NSUInteger pageIndex;
@property NSString *questId;
@property NSString *questName;
@property UIImage *questImage;
@property NSString *questDescription;
@property NSString *questRewards;
@property NSString *questStatus;

@property (weak, nonatomic) IBOutlet UILabel *questNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *questImageView;
@property (weak, nonatomic) IBOutlet UILabel *questDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *questRewardsLabel;
@property (weak, nonatomic) IBOutlet UIButton *questAbleToJoinOrContinueButton;
@property (weak, nonatomic) IBOutlet UIButton *questContinueButton;
@end
