//
//  InventoryViewController.h
//  demoApp
//
//  Created by Patsita Kongkaew on 11/20/15.
//  Copyright © 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Playbasis/Playbasis.h>
@interface InventoryViewController : UIViewController
@property (strong, nonatomic) PBPlayerGoodsOwned_Response *goodsListInfo;
@property (strong, nonatomic) IBOutlet UITextView *detailView;
@property (strong, nonatomic) IBOutlet UIButton *listGoods;
@end
