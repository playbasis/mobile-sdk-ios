//
//  quizDemoViewController.m
//  demoApp
//
//  Created by haxpor on 1/27/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "quizDemoViewController.h"
#import "playbasis.h"
#import "demoAppSettings.h"
#import "quizScreenViewController.h"

@interface quizDemoViewController ()

@end

@implementation quizDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Begin loading a quiz.");
    
    self.activityIndicator.hidden = false;
    
    // begin loading quiz information
    [self loadQuizAsync];
}

-(void)loadQuizAsync
{
    // load information in async as we need UI to still be in updating
    [[Playbasis sharedPB] quizRandomAsync:USER withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"response from url %@", [url path]);
            NSLog(@"response data = %@", [jsonResponse description]);
            
            // get json-response, and save it internally for use later when
            // we trainsition into another UIViewController
            NSDictionary *rootResponse = [jsonResponse objectForKey:@"response"];
            quizJsonResponse = [rootResponse objectForKey:@"result"];
            
            NSLog(@"quizJsonResponse = %@", [quizJsonResponse description]);
            
            // only if 'quizJsonResponse' is NSDictionary type
            if(quizJsonResponse != nil && [quizJsonResponse isKindOfClass:[NSDictionary class]])
            {
                // get quiz's image url
                NSString *quizImageUrl = [quizJsonResponse objectForKey:@"image"];
                // load and cache image from above url
                NSURL *url = [NSURL URLWithString:quizImageUrl];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                cachedQuizImage = [[UIImage alloc] initWithData:imageData];
                
                // transition into another UIViewController
                [self performSegueWithIdentifier:@"showQuizScreen" sender:self];
            }
            else
            {
                NSLog(@"No more questions available.");
                
                // update ui
                // to let user knows that there's no more questions available
                dispatch_async(dispatch_get_main_queue(), ^{
                    // hide activity indicator
                    self.activityIndicator.hidden = true;
                    
                    // update loading status
                    self.loadingStatusLabel.text = @"No more quiz available";
                });
            }
        }
    }];
}

-(void)testcases
{
    __block NSString *quizId = nil;
    
    // TEST API Calls
    // get available list of quiz
    [[Playbasis sharedPB] quizList:USER withBlock:^(PBActiveQuizList_Response *activeQuizList, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"%@", activeQuizList);
            
            if([activeQuizList.list.quizBasics count] > 0)
            {
                // get the first quiz-id
                PBQuizBasic *firstQuiz = [activeQuizList.list.quizBasics objectAtIndex:0];
                
                // set quiz-id
                quizId = firstQuiz.quizId;
            }
            
        }
    }];
    
    // get detail of a quiz (without player-id)
    if(quizId != nil)
    {
        [[Playbasis sharedPB] quizDetail:quizId withBlock:^(PBQuizDetail_Response *quizDetail, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"%@", quizDetail);
            }
        }];
    }
    
    // get detail of a quiz
    if(quizId != nil)
    {
        [[Playbasis sharedPB] quizDetail:quizId forPlayer:USER withBlock:^(PBQuizDetail_Response *quizDetail, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"%@", quizDetail);
            }
        }];
    }
    
    // get random quiz from available list of quiz
    [[Playbasis sharedPB] quizRandom:USER withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"response from url %@", [url path]);
            NSLog(@"response data = %@", [jsonResponse description]);
        }
    }];
    
    // get recent quiz done by the player
    [[Playbasis sharedPB] quizDone:USER limit:5 withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"response from url %@", [url path]);
            NSLog(@"response data = %@", [jsonResponse description]);
        }
    }];
    
    // get pending quiz by player
    [[Playbasis sharedPB] quizPending:USER limit:5 withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"response from url %@", [url path]);
            NSLog(@"response data = %@", [jsonResponse description]);
        }
    }];
    
    // get a question from quiz for player
    if(quizId != nil)
    {
        [[Playbasis sharedPB] quizQuestion:quizId forPlayer:USER withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"response from url %@", [url path]);
                NSLog(@"response data = %@", [jsonResponse description]);
            }
        }];
    }
    
    // answer a question
    if(quizId != nil && false)
    {
        [[Playbasis sharedPB] quizAnswer:quizId optionId:@"812410f259f23cf5ca2f138b" forPlayer:USER ofQuestionId:@"70067216bb3119080f5063ac" withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"response from url %@", [url path]);
                NSLog(@"response data = %@", [jsonResponse description]);
            }
        }];
    }
    
    // rank players by their quiz's score for a given quiz
    if(quizId != nil)
    {
        [[Playbasis sharedPB] quizScoreRank:quizId limit:5 withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"response from url %@", [url path]);
                NSLog(@"response data = %@", [jsonResponse description]);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showQuizScreen"])
    {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        quizScreenViewController *quizScreen = [segue destinationViewController];
        
        // set all loaded information to target screen
        quizScreen.quizId = [quizJsonResponse objectForKey:@"quiz_id"];
        quizScreen.quizName = [quizJsonResponse objectForKey:@"name"];
        quizScreen.quizImage = cachedQuizImage;
        quizScreen.quizDescription = [quizJsonResponse objectForKey:@"description"];
    }
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissed and went back to mainmenu screen");
    }];
}

- (IBAction)refreshAvailableQuiz:(id)sender {
    NSLog(@"Begin loading a quiz.");
    
    self.activityIndicator.hidden = false;
    
    // begin loading quiz information
    [self loadQuizAsync];
}
@end
