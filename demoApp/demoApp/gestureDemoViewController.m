//
//  gestureDemoViewController.m
//  demoApp
//
//  Created by haxpor on 2/28/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "gestureDemoViewController.h"
#import "Playbasis.h"
#import "demoAppSettings.h"

@interface gestureDemoViewController ()

@end

@implementation gestureDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)swipeRight:(id)sender {
    NSLog(@"Swipe right");
    
    // show popup indicating that user has swiped right
    [[Playbasis sharedPB] showFeedbackStatusUpdateWithText:@"Swiped right" duration:0.2];
    
    // send phone event to Playbasis server
    [[Playbasis sharedPB] ruleForPlayerAsync:USER action:@"swiperight" withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"Sent phone event 'swiperight' to Playbasis");
            NSLog(@"%@", response);
        }
        else
        {
            NSLog(@"Failed to send phone event 'swiperight' to Playbasis");
            NSLog(@"%@", error);
        }
    }, nil];
}

- (IBAction)swipeLeft:(id)sender {
    NSLog(@"Swipe left");
    
    // show popup indicating that user has swiped left
    [[Playbasis sharedPB] showFeedbackStatusUpdateWithText:@"Swiped left" duration:0.2];
    
    // send phone event to Playbasis server
    [[Playbasis sharedPB] ruleForPlayerAsync:USER action:@"swipeleft" withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"Sent phone event 'swipeleft' to Playbasis");
            NSLog(@"%@", response);
        }
        else
        {
            NSLog(@"Failed to send phone event 'swipeleft' to Playbasis");
            NSLog(@"%@", error);
        }
    }, nil];
}

- (IBAction)swipeUp:(id)sender {
    NSLog(@"Swipe up");
    
    // show popup indicating that user has swiped left
    [[Playbasis sharedPB] showFeedbackStatusUpdateWithText:@"Swiped up" duration:0.2];
    
    // send phone event to Playbasis server
    [[Playbasis sharedPB] ruleForPlayerAsync:USER action:@"swipeup" withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"Sent phone event 'swipeup' to Playbasis");
            NSLog(@"%@", response);
        }
        else
        {
            NSLog(@"Failed to send phone event 'swipeup' to Playbasis");
            NSLog(@"%@", error);
        }
    }, nil];
}

- (IBAction)swipeDown:(id)sender {
    NSLog(@"Swipe down");
    
    // show popup indicating that user has swiped left
    [[Playbasis sharedPB] showFeedbackStatusUpdateWithText:@"Swiped down" duration:0.2];
    
    // send phone event to Playbasis server
    [[Playbasis sharedPB] ruleForPlayerAsync:USER action:@"swipedown" withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"Sent phone event 'swipedown' to Playbasis");
            NSLog(@"%@", response);
        }
        else
        {
            NSLog(@"Failed to send phone event 'swipedown' to Playbasis");
            NSLog(@"%@", error);
        }
    }, nil];
}

- (IBAction)buttonClick:(id)sender {
    NSLog(@"Clicked button");
    
    // show popup indicating that user has swiped left
    [[Playbasis sharedPB] showFeedbackStatusUpdateWithText:@"Clicked button" duration:0.2];
    
    // send phone event to Playbasis server
    [[Playbasis sharedPB] ruleForPlayerAsync:USER action:@"buttonclick" withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"Sent phone event 'buttonclick' to Playbasis");
            NSLog(@"%@", response);
        }
        else
        {
            NSLog(@"Failed to send phone event 'buttonclick' to Playbasis");
            NSLog(@"%@", error);
        }
    }, nil];
}

- (IBAction)buttonClickAttachedWithUrl:(id)sender {
    NSLog(@"Clicked button");
    
    // show popup indicating that user has swiped left
    [[Playbasis sharedPB] showFeedbackStatusUpdateWithText:@"Clicked button w/ url" duration:0.2];
    
    // send phone event to Playbasis server
    [[Playbasis sharedPB] ruleForPlayerAsync:USER action:@"buttonclick" withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"Sent phone event 'buttonclick' to Playbasis");
            NSLog(@"%@", response);
        }
        else
        {
            NSLog(@"Failed to send phone event 'buttonclick' to Playbasis");
            NSLog(@"%@", error);
        }
    }, @"url=buttonclick_url", nil];
}
@end
