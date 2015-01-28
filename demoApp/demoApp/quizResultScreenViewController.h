//
//  quizResultScreenViewController.h
//  demoApp
//
//  Created by haxpor on 1/28/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface quizResultScreenViewController : UIViewController
{
    // jsonResponse from the prior ui view controller
    // use this to set corresponding information to UI
    NSDictionary *jsonResponse;
    
    // internal info that will be refered to later internally to update ui
    NSString *rRankImageUrl;
    NSString *rRankName;
    NSInteger rTotalScore;
    NSInteger rTotalMaxScore;
    NSInteger rExpReward;
    NSInteger rPointReward;
}

@property (atomic, strong) NSDictionary* jsonResponse;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreOutOfLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *expRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinRewardLabel;

@end
