//
//  rewardItemViewController.h
//  demoApp
//
//  Created by haxpor on 2/16/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbasis.h"

@interface rewardItemViewController : UIViewController
{
    PBGoodsInfo_Response *goodsInfo_;
}

// meta
@property NSUInteger pageIndex;
@property (strong, nonatomic) PBGoodsInfo_Response *goodsInfo;

// image
@property (strong, nonatomic) UIImage *image;

// information showed on UI
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
