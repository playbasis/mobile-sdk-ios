//
//  quizResultScreenViewController.h
//  demoApp
//
//  Created by haxpor on 1/28/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playbasis.h"

@interface quizResultScreenViewController : UIViewController

@property (atomic, strong) PBQuestionAnswered_Response* questionAnswered_response;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreOutOfLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *expRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinRewardLabel;
- (IBAction)goBackToMainMenu:(id)sender;

@end
