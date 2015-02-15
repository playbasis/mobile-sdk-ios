//
//  quizDemoViewController.h
//  demoApp
//
//  Created by haxpor on 1/27/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbasis.h"

@interface quizDemoViewController : UIViewController
{
    PBQuizRandom_Response *quizResponse;
    UIImage *cachedQuizImage;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *loadingStatusLabel;
- (IBAction)goBack:(id)sender;
- (IBAction)refreshAvailableQuiz:(id)sender;

/**
 Testcases included here in this method.
 */
-(void)testcases;

/**
 Load a quiz.
 */
-(void)loadQuizAsync;

@end
