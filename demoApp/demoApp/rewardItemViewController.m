//
//  rewardItemViewController.m
//  demoApp
//
//  Created by haxpor on 2/16/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "rewardItemViewController.h"

@interface rewardItemViewController ()

-(BOOL)revalidateSendCodeButtons;

@end

@implementation rewardItemViewController

@synthesize goodsInfo = goodsInfo_;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // set page UI
        self.goodsNameLabel.text = goodsInfo_.goods.name;
        self.goodsDescriptionLabel.text = goodsInfo_.goods.description_;
        self.expireLabel.text = [goodsInfo_.goods.dateExpire description];
        self.codeLabel.text = goodsInfo_.goods.code;
        self.goodsImage.image = self.image;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)revalidateSendCodeButtons
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
