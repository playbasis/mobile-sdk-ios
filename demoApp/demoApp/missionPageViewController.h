//
//  missionPageViewController.h
//  demoApp
//
//  Created by haxpor on 2/16/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbasis.h"

@interface missionPageViewController : UIPageViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIAlertViewDelegate>
{
    PBQuestOfPlayer_Response *quest_;
}

@property (strong, nonatomic) NSString* questId;

@end
