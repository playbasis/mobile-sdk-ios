//
//  rewardItemViewController.h
//  demoApp
//
//  Created by Playbasis on 2/16/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbasis.h"

@interface rewardItemViewController : UIViewController<UIAlertViewDelegate>
{
    PBGoods *goods_;
    PBGoodsInfo_Response *goodsInfo_;
}

// meta
@property NSUInteger pageIndex;
@property (strong, nonatomic) PBGoods *goods;

// image
@property (strong, nonatomic) UIImage *image;

// information showed on UI
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *redeemButton;
- (IBAction)redeemGoods:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBySMSButton;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeByEmailButton;
- (IBAction)sendCodeByEmail:(id)sender;
- (IBAction)sendCodeBySMS:(id)sender;


@end
