//
//  questionScreenViewController.h
//  demoApp
//
//  Created by haxpor on 1/28/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbasis.h"

@interface questionScreenViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    PBQuestion_Response *question_response;
    PBQuestionAnswered_Response *questionAnsweredResult_response;
    
    // this will be set by prior view controller
    NSString *quizId;
    
#if PBSandBoxEnabled==1
    // for sample build only
    // as it's sandbox for some api, we need to specify last question id to retrieve a next question
    NSString *lastQuestionId;
#endif
}

@property (nonatomic, strong) NSString *quizId;
@property (weak, nonatomic) IBOutlet UIImageView *questionImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;

/**
 Load next question from given quiz-id.
 */
-(void)loadNextQuestionAsyncFrom:(NSString *)qId;

/**
 Transition to result screen if there's no more questions left to answer.
 */
-(void)transitionToResultScreen;
- (IBAction)answerQuestion:(id)sender;

@end
