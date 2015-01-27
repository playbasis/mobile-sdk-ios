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

@interface quizDemoViewController ()

@end

@implementation quizDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __block NSString *quizId = nil;
    
    // TEST API Calls
    // get available list of quiz
    [[Playbasis sharedPB] quizList:USER withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"response from url %@", [url path]);
            NSLog(@"response data = %@", [jsonResponse description]);
            
            // get response
            NSDictionary *response = [jsonResponse objectForKey:@"response"];
            if(response != nil)
            {
                // get array of quizzes
                NSArray *quizzes = (NSArray*)[response objectForKey:@"result"];
                
                // check if there's at least 1 quiz for us to get
                if([quizzes count] >= 1)
                {
                    // get first quiz
                    NSDictionary *quiz = (NSDictionary*)quizzes[0];
                    
                    // get quizId
                    quizId = (NSString*)[quiz objectForKey:@"quiz_id"];
                    
                    NSLog(@"Got quizId = %@", quizId);
                }
            }
        }
    }];
    
    // get detail of a quiz (without player-id)
    if(quizId != nil)
    {
        [[Playbasis sharedPB] quizDetail:quizId withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"response from url %@", [url path]);
                NSLog(@"response data = %@", [jsonResponse description]);
            }
        }];
    }
    
    // get detail of a quiz
    if(quizId != nil)
    {
        [[Playbasis sharedPB] quizDetail:quizId forPlayer:USER withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"response from url %@", [url path]);
                NSLog(@"response data = %@", [jsonResponse description]);
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

@end
