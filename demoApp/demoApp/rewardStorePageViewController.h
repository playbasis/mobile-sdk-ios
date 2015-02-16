//
//  rewardStorePageViewController.h
//  demoApp
//
//  Created by haxpor on 2/16/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbasis.h"

@interface rewardStorePageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
{
    PBGoodsListInfo_Response *_goodsList;
    NSArray *_goodsInfoList;
    NSMutableArray *_cachedImages;
}

@property (strong, nonatomic) PBGoodsListInfo_Response *goodsList;
@property (strong, nonatomic) NSArray *goodsInfoList;

-(void)cacheImageSequectiallyAtIndex:(NSUInteger)index;

@end
