//
//  questPageViewController.h
//  demoApp
//
//  Created by Playbasis on 2/6/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbasis.h"

@interface questPageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate,
    UIAlertViewDelegate>
{
    NSUInteger currentPageIndex;
    NSMutableArray *_allRewardsLinesForAllQuests;
}

@property (strong, nonatomic) PBQuestListAvailableForPlayer_Response *questListAvailable;
@property (strong, nonatomic) PBQuestListOfPlayer_Response *questList;
@property (strong, nonatomic) NSMutableDictionary *questImages;

@end
