//
//  rewardItemViewController.m
//  demoApp
//
//  Created by haxpor on 2/16/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "rewardItemViewController.h"
#import "demoAppSettings.h"

@interface rewardItemViewController ()

-(void)sendCodeByEmail_internal;
-(void)sendCodeBySMS_internal;

@end

@implementation rewardItemViewController

@synthesize goodsInfo = goodsInfo_;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // initially hide code, and send code buttons
        self.sendCodeBySMSButton.hidden = YES;
        self.sendCodeByEmailButton.hidden = YES;
        self.codeLabel.hidden = YES;
        
        // set page UI
        self.goodsNameLabel.text = goodsInfo_.goods.name;
        self.goodsDescriptionLabel.text = goodsInfo_.goods.description_;
        self.expireLabel.text = [goodsInfo_.goods.dateExpire description];
        self.codeLabel.text = goodsInfo_.goods.code;
        self.goodsImage.image = self.image;
    });
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

-(void)sendCodeByEmail_internal
{
    // form message
    NSString *message = [NSString stringWithFormat:@"Your reward code is: %@ Enjoy the privilege!", goodsInfo_.goods.code];
    
    // all is good then we send code via email
    [[Playbasis sharedPB] sendEmail:USER subject:@"Redeem Complete!" message:message withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"Sent email complete");
            NSLog(@"%@", jsonResponse);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.activityIndicator.hidden = YES;
            });
        }
        else
        {
            NSLog(@"Sent email failed");
            NSLog(@"%@", error);
        }
    }];
}
-(void)sendCodeBySMS_internal
{
    // form message
    NSString *message = [NSString stringWithFormat:@"Your reward code is: %@ Enjoy the privilege!", goodsInfo_.goods.code];
    
    // all is good then we send code via email
    [[Playbasis sharedPB] sms:USER message:message withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"Sent sms complete");
            NSLog(@"%@", jsonResponse);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.activityIndicator.hidden = YES;
            });
        }
        else
        {
            NSLog(@"Sent sms failed");
            NSLog(@"%@", error);
        }
    }];
}

- (IBAction)redeemGoods:(id)sender {
    
    // spin activity indicator
    dispatch_async(dispatch_get_main_queue(), ^{
        self.activityIndicator.hidden = NO;
    });
    
    // redeem this goods
    [[Playbasis sharedPB] redeemGoodsAsync:goodsInfo_.goods.goodsId player:USER amount:1 withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            // get 'response'
            NSDictionary *response = [jsonResponse objectForKey:@"response"];
            // get 'event'
            NSArray *events = [response objectForKey:@"events"];
            for(NSDictionary *eventJson in events)
            {
                // get 'event_type'
                NSString *eventType = [eventJson objectForKey:@"event_type"];
                
                // we got goods, then we show code, and send buttons
                if([eventType isEqualToString:@"GOODS_RECEIVED"])
                {
                    NSLog(@"Redeem complete");
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.activityIndicator.hidden = YES;
                        self.redeemButton.hidden = YES;
                        self.sendCodeBySMSButton.hidden = NO;
                        self.sendCodeByEmailButton.hidden = NO;
                        self.codeLabel.hidden = NO;
                    });
                }
                else
                {
                    NSLog(@"Redeem un-complete.");
                    // alert that's there not enough coin to redeem
                    UIAlertView *popup = [[UIAlertView alloc] initWithTitle:@"Redeem not complete!" message:@"There's not enough coin!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [popup show];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.activityIndicator.hidden = YES;
                    });
                }
            }
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // email
    if(alertView.tag == 1)
    {
        // get email
        NSString *email = [[alertView textFieldAtIndex:0] text];
        // create a param udpate for email
        NSString *paramEmailUpdate = [NSString stringWithFormat:@"email=%@", email];
        
        // udpate user's profile
        [[Playbasis sharedPB] updateUser:USER withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"Updated user's email.");
                NSLog(@"%@", jsonResponse);
                
                // send code by email
                [self sendCodeByEmail_internal];
            }
        } :paramEmailUpdate, nil];
    }
    // sms
    else if(alertView.tag == 2)
    {
        // get phonenumber
        NSString *phoneNumber = [[alertView textFieldAtIndex:0] text];
        // create a param udpate for phonenumber
        NSString *paramPhonenumberUdpate = [NSString stringWithFormat:@"phone_number=%@", phoneNumber];
        
        // udpate user's profile
        [[Playbasis sharedPB] updateUser:USER withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"Updated user's phonenumber.");
                NSLog(@"%@", jsonResponse);
                
                // send code by sms
                [self sendCodeBySMS_internal];
            }
        } :paramPhonenumberUdpate, nil];
    }
}

- (IBAction)sendCodeByEmail:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.activityIndicator.hidden = NO;
    });
    
    // get player information to check for e-mail if it's valid
    [[Playbasis sharedPB] playerAsync:USER withBlock:^(PBPlayer_Response *player, NSURL *url, NSError *error) {
        if(!error)
        {
            // basic check
            if([player.email isEqualToString:@""] ||
               [player.email isEqualToString:@"noreply@gmail.com"] ||
               [player.email isEqualToString:@"pb_app_auto_user@playbasis.com"])
            {
                // show the form for user to re-enter the e-mail
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Update your profile" message:@"Enter your e-mail" delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                alert.tag = 1;
                [alert show];
            }
            else
            {
                [self sendCodeByEmail_internal];
            }
        }
    }];
}

- (IBAction)sendCodeBySMS:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.activityIndicator.hidden = NO;
    });
    
    // get player information to check for e-mail if it's valid
    [[Playbasis sharedPB] playerAsync:USER withBlock:^(PBPlayer_Response *player, NSURL *url, NSError *error) {
        if(!error)
        {
            // basic check
            if([player.phoneNumber isEqualToString:@""])
            {
                // show the form for user to re-enter the phone number
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Update your profile" message:@"Enter your phone number" delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                alert.tag = 2;
                [alert show];
            }
            else
            {
                [self sendCodeBySMS_internal];
            }
        }
    }];
}
@end
