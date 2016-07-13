//
//  storeOrganizationViewController.h
//  demoApp
//
//  Created by Patsita Kongkaew on 1/8/16.
//  Copyright © 2016 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Playbasis/Playbasis.h>
@interface storeOrganizationViewController : UIViewController
@property (strong,nonatomic) IBOutlet UITextView *detailView;
@property (strong,nonatomic) IBOutlet UIButton *listOrganize;
@property (strong,nonatomic) IBOutlet UIButton *listNode;
@property (strong,nonatomic) IBOutlet UIButton *child;
@property (strong,nonatomic) IBOutlet UIButton *associated;
@property (strong,nonatomic) IBOutlet UIButton *saleHistory;
@property (strong,nonatomic) IBOutlet UIButton *saleBoard;
@end
