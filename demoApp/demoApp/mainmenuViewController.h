//
//  mainmenuViewController.h
//  demoApp
//
//  Created by Playbasis on 1/27/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Playbasis/Playbasis.h>

@interface mainmenuViewController : UIViewController<PBNetworkStatusChangedDelegate, PBLocationUpdatedDelegate>
{
    // cache the result from goodsList
    PBGoodsListInfo_Response *goodsListInfo_;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
