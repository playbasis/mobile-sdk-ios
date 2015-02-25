//
//  rewardStoreLoadingPageViewController.h
//  demoApp
//
//  Created by haxpor on 2/25/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbasis.h"

@interface rewardStoreLoadingPageViewController : UIViewController
{
    PBGoodsListInfo_Response *_goodsListInfo;
    NSMutableArray *_goodsListInfoCachedImages;
}
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsInfoListNotAvailableLabel;

- (IBAction)checkForGoodsInfoList:(id)sender;

@end
