//
//  contentViewController.h
//  demoApp
//
//  Created by Patsita Kongkaew on 1/12/16.
//  Copyright © 2016 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Playbasis/Playbasis.h>
@interface contentViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong,nonatomic) IBOutlet UIButton *getContent;
@property (strong,nonatomic) IBOutlet UIButton *playerAuth;
@property (strong,nonatomic) IBOutlet UIButton *listPlayer;
@property (strong,nonatomic) IBOutlet UITextView *detailView;
@property (strong,nonatomic) IBOutlet UIImageView *photo;
@end
