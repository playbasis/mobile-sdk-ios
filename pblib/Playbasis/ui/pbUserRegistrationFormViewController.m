//
//  pbUserRegistrationFormViewController.m
//  pblib
//
//  Created by Playbasis on 2/14/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "pbUserRegistrationFormViewController.h"

@interface pbUserRegistrationFormViewController ()

-(void)revalidateSubmitButton;

@end

@implementation pbUserRegistrationFormViewController

@synthesize responseBlock = _responseBlock;
@synthesize intendedPlayerId = _intendedPlayerId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set delegate of all textfields to this class
    // we need to dismiss keyboard when user hits return button
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.usernameTextField.delegate = self;
    self.submitButton.enabled = NO;
    
    // if intented player-id is not nil, then set it to username field as well
    if(self.intendedPlayerId != nil)
    {
        self.usernameTextField.text = _intendedPlayerId;
        [self revalidateSubmitButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTouchedCancelButton:(id)sender {
    PBLOG(@"Cancel button touched.");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTouchedSubmitButton:(id)sender {
    PBLOG(@"Submit the information to register user.");
    
    PBLOG(@"First name : %@", self.firstNameTextField.text);
    PBLOG(@"Last name : %@", self.lastNameTextField.text);
    PBLOG(@"Email : %@", self.emailTextField.text);
    PBLOG(@"Username : %@", self.usernameTextField.text);
    
    // register according to the information entered
    // if all fields are entered, then we enable submit button
    if(![self.firstNameTextField.text isEqualToString:@""] &&
       ![self.lastNameTextField.text isEqualToString:@""] &&
       ![self.emailTextField.text isEqualToString:@""] &&
       ![self.usernameTextField.text isEqualToString:@""])
    {
        [[Playbasis sharedPB] registerUserWithPlayerId:self.usernameTextField.text username:self.usernameTextField.text email:self.emailTextField.text imageUrl:@"https://www.pbapp.net/images/default_profile.jpg" andBlock:^(id jsonResponse, NSURL *url, NSError *error) {
            _responseBlock(jsonResponse, url, error);
            
            // dismiss this form and get back to normal flow
            [self dismissViewControllerAnimated:YES completion:nil];
        }, [NSString stringWithFormat:@"first_name=%@", self.firstNameTextField.text], [NSString stringWithFormat:@"last_name=%@", self.lastNameTextField.text], nil];
    }
}

-(void)revalidateSubmitButton
{
    // re-enable submit button
    if(![self.firstNameTextField.text isEqualToString:@""] &&
       ![self.lastNameTextField.text isEqualToString:@""] &&
       ![self.emailTextField.text isEqualToString:@""] &&
       ![self.usernameTextField.text isEqualToString:@""])
    {
        self.submitButton.enabled = YES;
    }
    else
    {
        self.submitButton.enabled = NO;
    }
}

// dismiss the keyboard when hit return button
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    // revalidate submit button
    [self revalidateSubmitButton];
    
    return NO;
}
@end
