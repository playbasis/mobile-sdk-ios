//
//  quizScreenViewController.h
//  demoApp
//
//  Created by haxpor on 1/28/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface quizScreenViewController : UIViewController
{
    NSString *quizId;
    NSString *quizName;
    UIImage *quizImage;
    NSString *quizDescription;
}

@property (nonatomic, strong) NSString *quizId;
@property (nonatomic, strong) NSString *quizName;
@property (nonatomic, strong) UIImage *quizImage;
@property (nonatomic, strong) NSString *quizDescription;

@property (weak, nonatomic) IBOutlet UILabel *quizNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *quizImageView;
@property (weak, nonatomic) IBOutlet UILabel *quizDescriptionLabel;

@end
