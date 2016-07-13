//
//  rewardStorePageViewController.h
//  demoApp
//
//  Created by Playbasis on 2/16/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Playbasis/Playbasis.h>

@interface rewardStorePageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) PBGoodsListInfo_Response *goodsListInfo;
@property (strong, nonatomic) NSMutableArray *goodsListInfoImages;
@end
