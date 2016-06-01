//
//  ProfileViewController.m
//  demoApp
//
//  Created by Patsita Kongkaew on 11/24/15.
//  Copyright © 2015 Maethee Chongchitnant. All rights reserved.
//

#import "ProfileViewController.h"
#import "demoAppSettings.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)getProfileInfo:(id)sender
{
    [[Playbasis sharedPB] player:USER withBlock:^(PBPlayer_Response *player, NSURL *url, NSError *error) {
        NSLog(@"%@",player);
        [_detailView setText:[NSString stringWithFormat:@"%@",player]];
    }];
}
-(IBAction)getGoodsInfo:(id)sender
{
    [[Playbasis sharedPB] goodsOwnedOfPlayer:USER withBlock:^(PBPlayerGoodsOwned_Response *goodsOwneds, NSURL *url, NSError *error) {
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
