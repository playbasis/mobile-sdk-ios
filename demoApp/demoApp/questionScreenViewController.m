//
//  questionScreenViewController.m
//  demoApp
//
//  Created by haxpor on 1/28/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "questionScreenViewController.h"
#import "demoAppSettings.h"
#import "quizResultScreenViewController.h"

@interface questionScreenViewController ()

@end

@implementation questionScreenViewController

@synthesize quizId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set up label's setting
    self.questionTextLabel.numberOfLines = 0;
    self.questionTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.questionTextLabel.hidden = true;
    
    [self loadNextQuestionAsyncFrom:self.quizId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNextQuestionAsyncFrom:(NSString *)qId
{
    // reset set content in ui
    self.questionImage.image = nil;
    self.questionTextLabel.text = @"";
    
    // reload tableview (for better ux)
    [self.tableView reloadData];
    
    // begin requesting to load a next question
    [[Playbasis sharedPB] quizQuestionAsync:qId forPlayer:USER withBlock:^(PBQuestion_Response *question, NSURL *url, NSError *error) {
        if(!error)
        {
            // save response
            question_response = question;
            
            // update ui question text
            dispatch_async(dispatch_get_main_queue(), ^{
                self.questionTextLabel.text = question.question.question;
                self.questionTextLabel.hidden = false;
            });
            
            // async loading image
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // load and cache image from above url
                NSURL *url = [NSURL URLWithString:question.question.questionImage];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                
                // update ui question image
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.questionImage.image = [[UIImage alloc] initWithData:imageData];
                });
            });
            
            // after all loaded, then reload it
            dispatch_async(dispatch_get_main_queue(), ^{
                // reload table data
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)transitionToResultScreen
{
    NSLog(@"Begin transition into result screen");
    
    [self performSegueWithIdentifier:@"showQuizResultScreen" sender:self];
}

- (IBAction)answerQuestion:(id)sender {
    
    // get the selected index from table view
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"selected index row: %d", [selectedIndexPath row]);
    
    // get question-option id from selection
    PBQuestionOption *option = [question_response.question.options.options objectAtIndex: [selectedIndexPath row]];
    
    // answer with the selected index row fetching option-id from 'optionsIds'
    [[Playbasis sharedPB] quizAnswer:self.quizId optionId:option.optionId forPlayer:USER ofQuestionId:question_response.question.questionId withBlock:^(PBQuestionAnswered_Response *questionAnswered, NSURL *url, NSError *error) {
        if(!error)
        {
            if(questionAnswered.result.rewards != nil)
            {
                if([questionAnswered.result.rewards.gradeDoneRewards count] > 0)
                {
                    NSLog(@"No more question.");
                    
                    // save this response
                    questionAnsweredResult_response = questionAnswered;
                    
                    // finish the quiz now, then transition into result screen
                    [self transitionToResultScreen];
                }
                // otherwise reload this screen again for a next question
                else
                {
                    // load next question
                    [self loadNextQuestionAsyncFrom:self.quizId];
                }
            }
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(question_response != nil)
        return [question_response.question.options.options count];
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // get option
    PBQuestionOption *option = [question_response.question.options.options objectAtIndex:indexPath.row];
    
    // set answer text
    cell.textLabel.text = option.option;
    cell.textLabel.adjustsFontSizeToFitWidth = true;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"showQuizResultScreen"])
    {
        quizResultScreenViewController *quizResult = [segue destinationViewController];
        quizResult.questionAnswered_response = questionAnsweredResult_response;
    }
}


@end
