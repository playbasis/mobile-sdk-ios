//
//  pbUserRegistrationFormViewController.h
//  pblib
//
//  Created by Playbasis on 2/14/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbasis.h"

@interface pbUserRegistrationFormViewController : UIViewController <UITextFieldDelegate>
{
    PBResponseBlock _responseBlock;
    NSString *_intendedPlayerId;
}

@property (strong, nonatomic) PBResponseBlock responseBlock;
@property (strong, nonatomic) NSString *intendedPlayerId;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)onTouchedCancelButton:(id)sender;
- (IBAction)onTouchedSubmitButton:(id)sender;

@end
