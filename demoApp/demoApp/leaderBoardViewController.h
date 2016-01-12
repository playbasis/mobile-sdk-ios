//
//  leaderBoardViewController.h
//  demoApp
//
//  Created by Patsita Kongkaew on 1/12/16.
//  Copyright © 2016 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbasis.h"
@interface leaderBoardViewController : UIViewController
@property (strong,nonatomic) IBOutlet UIButton *leaderBoard;
@property (strong,nonatomic) IBOutlet UIButton *leaderBoardByAction;
@property (strong,nonatomic) IBOutlet UITextView *detailView;
@end
