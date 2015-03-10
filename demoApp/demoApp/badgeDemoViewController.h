//
//  badgeDemoViewController.h
//  demoApp
//
//  Created by Playbasis on 1/27/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface badgeDemoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)doLikeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImage;
@end
