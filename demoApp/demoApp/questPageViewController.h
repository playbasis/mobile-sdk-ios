//
//  questPageViewController.h
//  demoApp
//
//  Created by haxpor on 2/6/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbasis.h"

@interface questPageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate,
    UIAlertViewDelegate>
{
    NSUInteger currentPageIndex;
    PBQuestListAvailableForPlayer_Response *questListAvailable_;
    PBQuestListOfPlayer_Response *questList_;
}

@property (strong, nonatomic) NSMutableDictionary *loadedImagesForAllQuests;
@property (strong, nonatomic) NSMutableArray *allRewardsLinesForAllQuests;

@end
