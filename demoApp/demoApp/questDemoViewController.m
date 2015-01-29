//
//  questDemoViewController.m
//  demoApp
//
//  Created by haxpor on 1/29/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "questDemoViewController.h"
#import "playbasis.h"
#import "demoAppSettings.h"

@interface questDemoViewController ()

@end

@implementation questDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // will be got from the request
    __block NSString *questId = nil;
    
    // test quest api
    // - /Quest
    [[Playbasis sharedPB] questListWithBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            // print out the response
            NSLog(@"delegate triggered from URL: %@", [url path]);
            NSLog(@"%@", jsonResponse);
            
            // get 'response'
            NSDictionary *response = [jsonResponse objectForKey:@"response"];
            NSArray* quests = [response objectForKey:@"quests"];
            
            if([quests count] >= 1)
            {
                // get first quest json-data
                NSDictionary *firstQuestJson = [quests objectAtIndex:0];
                // get quest id
                questId = [firstQuestJson objectForKey:@"quest_id"];
                
                NSLog(@"Got questId = %@", questId);
            }
        }
    }];
    
    // - /Quest:id
    [[Playbasis sharedPB] quest:questId withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            // print out the response
            NSLog(@"delegate triggered from URL: %@", [url path]);
            NSLog(@"%@", jsonResponse);
        }
    }];
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
