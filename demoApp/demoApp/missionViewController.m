//
//  missionViewController.m
//  demoApp
//
//  Created by haxpor on 2/6/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "missionViewController.h"
#import "Playbasis.h"
#import "demoAppSettings.h"

@interface missionViewController ()

@end

@implementation missionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // if we need to join the quest first
    if(_viaMethod == QUEST_JOIN)
    {
        [[Playbasis sharedPB] joinQuest:_questId player:USER withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"Joined the quest = %@", [jsonResponse description]);
            }
        }];
    }
    
    // load the set questId from previous view controller
    [[Playbasis sharedPB] questOfPlayer:USER questId:_questId andBlock:^(PBQuestOfPlayer_Response *quest, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"%@", quest);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
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
