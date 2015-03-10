//
//  quizScreenViewController.m
//  demoApp
//
//  Created by Playbasis on 1/28/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "quizScreenViewController.h"
#import "questionScreenViewController.h"

@interface quizScreenViewController ()

@end

@implementation quizScreenViewController

@synthesize quizId;
@synthesize quizName;
@synthesize quizImage;
@synthesize quizDescription;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set up label's setting
    self.quizDescriptionLabel.numberOfLines = 0;
    self.quizDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // set text-data, and image to ui
    // those data was set by previous quizDemoViewController
    self.quizNameLabel.text = quizName;
    self.quizImageView.image = quizImage;
    self.quizDescriptionLabel.text = quizDescription;
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
    if([[segue identifier] isEqualToString:@"showQuestionScreen"])
    {
        // get destination view controller (question screen)
        questionScreenViewController *destView = [segue destinationViewController];
        
        // set quizId
        destView.quizId = self.quizId;
    }
}

@end
