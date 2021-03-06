//
//  quizDemoViewController.m
//  demoApp
//
//  Created by Playbasis on 1/27/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "quizDemoViewController.h"
#import "demoAppSettings.h"
#import "quizScreenViewController.h"

@interface quizDemoViewController ()

@end

@implementation quizDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // begin loading quiz information
    [self refreshAvailableQuiz:self];
}

-(void)loadQuizAsync
{
    [[Playbasis sharedPB] quizRandomForPlayerAsync:USER withBlock:^(PBQuizRandom_Response *quizRandom, NSURL *url, NSError *error) {
        if(!error)
        {
            // if there's quiz to be taken
            if(quizRandom.randomQuiz != nil)
            {
                // save response
                quizResponse = quizRandom;
                
                // loading (blocking call)
                [UIImage startLoadingImageWithUrl:quizRandom.randomQuiz.image response:^(UIImage *image) {
                    cachedQuizImage = image;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // hide activity indicator
                        self.activityIndicator.hidden = true;
                        // change label to complete
                        self.loadingStatusLabel.text = @"Completed loading";
                    });
                }];
                
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
        else
        {
            NSLog(@"Error occurs loading quizRandomForPlayer %@", error);
        }
    }];
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
        quizScreen.quizId = quizResponse.randomQuiz.quizId;
        quizScreen.quizName = quizResponse.randomQuiz.name;
        quizScreen.quizImage = cachedQuizImage;
        quizScreen.quizDescription = quizResponse.randomQuiz.description_;
    }
}

- (IBAction)refreshAvailableQuiz:(id)sender {
    NSLog(@"Begin loading a quiz.");
    
    self.activityIndicator.hidden = false;
    self.loadingStatusLabel.text = @"Loading Question ...";
    
    // begin loading quiz information
    [self loadQuizAsync];
}
@end
