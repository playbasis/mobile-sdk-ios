//
//  missionViewController.h
//  demoApp
//
//  Created by Playbasis on 2/6/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbasis.h"

typedef enum : NSInteger {
    ACTION_COMPLETE,
    ACTION_NOTCOMPLETE
} tCellActionCompleted;

@interface missionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    PBMission *_mission;
}

// meta
@property (nonatomic) NSUInteger pageIndex;
@property (strong, nonatomic) NSString *questId;
@property (strong, nonatomic) PBMission *mission;

// container ui
@property (weak, nonatomic) IBOutlet UILabel *missionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *missionDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *missionImage;
@property (weak, nonatomic) IBOutlet UILabel *missionRewardsLabel;
@property (weak, nonatomic) IBOutlet UIButton *doSelectedActionButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)doSelectedAction:(id)sender;

@end
