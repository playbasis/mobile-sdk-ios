//
//  questPageViewController.h
//  demoApp
//
//  Created by haxpor on 2/6/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playbasis.h"

@interface questPageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
{
    NSUInteger currentPageIndex;
    PBQuestListOfPlayer_Response *questList_;
}

@property (strong, nonatomic) NSMutableArray *pageAllQuestIds;
@property (strong, nonatomic) NSMutableArray *pageAllQuestNames;
@property (strong, atomic) NSMutableArray *pageAllImages;
@property (strong, nonatomic) NSMutableArray *pageAllQuestDescriptions;
@property (strong, nonatomic) NSMutableArray *pageAllQuestRewards;

@end
