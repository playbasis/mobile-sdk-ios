//
//  questionScreenViewController.m
//  demoApp
//
//  Created by haxpor on 1/28/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "questionScreenViewController.h"
#import "demoAppSettings.h"
#import "playbasis.h"

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
    
    // create an empty text
    // this will be loaded later
    optionsTexts = [NSMutableArray array];
    optionsIds = [NSMutableArray array];
    
    // create an empty uiimage
    optionsUIImages = [NSMutableArray array];
    
    [self loadNextQuestionAsyncFrom:self.quizId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNextQuestionAsyncFrom:(NSString *)qId
{
    // clear all loaded variables first
    questionId = nil;
    [optionsTexts removeAllObjects];
    [optionsIds removeAllObjects];
    [optionsUIImages removeAllObjects];
    
    // reset set content in ui
    self.questionImage.image = nil;
    self.questionTextLabel.text = @"";
    
    // reload tableview (for better ux)
    [self.tableView reloadData];
    
    // begin requesting to load a next question
    [[Playbasis sharedPB] quizQuestionAsync:qId forPlayer:USER withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"response from url %@", [url path]);
            NSLog(@"response data = %@", [jsonResponse description]);
            
            // get 'response'
            NSDictionary *response = [jsonResponse objectForKey:@"response"];
            // get 'result'
            NSDictionary *result = [response objectForKey:@"result"];
            
            // get question id
            questionId = [result objectForKey:@"question_id"];
            // get question text
            NSString *questionText = [result objectForKey:@"question"];
            
            // update ui question text
            dispatch_async(dispatch_get_main_queue(), ^{
                self.questionTextLabel.text = questionText;
                self.questionTextLabel.hidden = false;
            });
            
            // get question's image url
            NSString *questionImageUrl = [result objectForKey:@"question_image"];
            
            // async loading image
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // load and cache image from above url
                NSURL *url = [NSURL URLWithString:questionImageUrl];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                
                // update ui question image
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.questionImage.image = [[UIImage alloc] initWithData:imageData];
                });
            });
            
            // set number of answers
            NSArray *options = [result objectForKey:@"options"];
            
            // load all answers' text
            for(NSDictionary *json in options)
            {
                // get option text
                NSString *optionText = [json objectForKey:@"option"];
                [optionsTexts addObject:optionText];
                
                // get option id
                NSString *optionId = [json objectForKey:@"option_id"];
                [optionsIds addObject:optionId];
            }
            
            // (optional) load all answers' image
            
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
    
}

- (IBAction)answerQuestion:(id)sender {
    
    // get the selected index from table view
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"selected index row: %d", [selectedIndexPath row]);
    
    // answer with the selected index row fetching option-id from 'optionsIds'
    [[Playbasis sharedPB] quizAnswer:self.quizId optionId:[optionsIds objectAtIndex:[selectedIndexPath row]] forPlayer:USER ofQuestionId:questionId withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"response from url %@", [url path]);
            NSLog(@"response data = %@", [jsonResponse description]);
            
            // get 'response'
            NSDictionary *response = [jsonResponse objectForKey:@"response"];
            // get 'result'
            NSDictionary *result = [response objectForKey:@"result"];
            // get 'rewards'
            NSArray *rewards = [result objectForKey:@"rewards"];
            
            // check for rewards, if any then it means user finishes the quiz
            if([rewards count] > 0)
            {
                NSLog(@"No more questions.");
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
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [optionsTexts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // set answer text
    cell.textLabel.text = [optionsTexts objectAtIndex:indexPath.row];
    cell.textLabel.adjustsFontSizeToFitWidth = true;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
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
