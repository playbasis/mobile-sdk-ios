//
//  leaderBoardViewController.m
//  demoApp
//
//  Created by Patsita Kongkaew on 1/12/16.
//  Copyright © 2016 Maethee Chongchitnant. All rights reserved.
//

#import "leaderBoardViewController.h"
#import "demoAppSettings.h"
@implementation leaderBoardViewController
-(IBAction)leaderBoard:(id)sender{
    NSMutableDictionary *options = [[NSMutableDictionary alloc]init];
    [options setObject:@"20" forKey:@"limit"];
    [[Playbasis sharedPB]leaderBoard:@"567c05705e232a214f8b563e" rank:@"point" options:options withBlock:^(PBLeaderBoard_Response *response, NSURL *url, NSError *error) {
        
       [_detailView setText:[NSString stringWithFormat:@"%@",[response parseLevelJsonResponse]]];
    }];
}
-(IBAction)leaderBoardByAction:(id)sender{
    NSMutableDictionary *options = [[NSMutableDictionary alloc]init];
    [options setObject:@"20" forKey:@"limit"];
    [[Playbasis sharedPB]leaderBoardByAction:@"567c05705e232a214f8b563e" action:@"sell" parameter:@"amount" options:options withBlock:^(PBLeaderBoard_Response *response, NSURL *url, NSError *error) {
        NSMutableArray<PBLeaderBoardByAction*> *temp = [response list];
        NSString *prints = @"";
        for (PBLeaderBoardByAction *item in temp) {
            prints = [prints stringByAppendingString:[NSString stringWithFormat:@"%@",item.rank]];
        }
        [_detailView setText:prints];
    }];
}
@end
