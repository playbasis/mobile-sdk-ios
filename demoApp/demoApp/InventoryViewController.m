//
//  InventoryViewController.m
//  demoApp
//
//  Created by Patsita Kongkaew on 11/20/15.
//  Copyright © 2015 Maethee Chongchitnant. All rights reserved.
//

#import "InventoryViewController.h"
#import "demoAppSettings.h"
@interface InventoryViewController ()

@end

@implementation InventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)listGoods:(id)sender
{
    [[Playbasis sharedPB] goodsOwnedOfPlayer:USER withBlock:^(PBPlayerGoodsOwned_Response *goodsOwneds, NSURL *url, NSError *error) {
        //[_detailView setText:@"goods:[]"];
        NSLog(@"%@",goodsOwneds);
        [_detailView setText:[NSString stringWithFormat:@"%@",goodsOwneds]];
    }];
    
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
