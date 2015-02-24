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

@synthesize goods = goods_;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // initially hide code, and send code buttons
        self.sendCodeBySMSButton.hidden = YES;
        self.sendCodeByEmailButton.hidden = YES;
        self.codeLabel.hidden = YES;
        
        // set page UI
        self.goodsNameLabel.text = goods_.name;
        self.goodsDescriptionLabel.text = goods_.description_;
        self.expireLabel.text = [goods_.dateExpire description];
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
    [[Playbasis sharedPB] sendEmailForPlayer:USER subject:@"Redeem Complete!" message:message withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"Sent email complete");
            NSLog(@"%@", jsonResponse);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.activityIndicator.hidden = YES;
                
                // show status update
                [[Playbasis sharedPB] showFeedbackStatusUpdateFromView:self text:@"Send code via E-mail Complete!"];
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
    [[Playbasis sharedPB] sendSMSForPlayer:USER message:message withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"Sent sms complete");
            NSLog(@"%@", jsonResponse);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.activityIndicator.hidden = YES;
                
                // show status update
                [[Playbasis sharedPB] showFeedbackStatusUpdateFromView:self text:@"Send code SMS Complete!"];
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
    [[Playbasis sharedPB] redeemGoodsAsync:goods_.goodsId forPlayer:USER amount:1 withBlock:^(PBRedeemGoods_Response *response, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"%@", response);
            
            // get *code* information from goods-info
            [[Playbasis sharedPB] goods:goods_.goodsId withBlock:^(PBGoodsInfo_Response *goodsInfo, NSURL *url, NSError *error) {
                if(!error)
                {
                    // save goods-info
                    goodsInfo_ = goodsInfo;
                    
                    for(PBRedeemGoodsEvent *event in response.response.list)
                    {
                        // check if we got any goods
                        if([event.eventType isEqualToString:@"GOODS_RECEIVED"])
                        {
                            NSLog(@"Redeem complete");
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.activityIndicator.hidden = YES;
                                self.redeemButton.hidden = YES;
                                self.sendCodeBySMSButton.hidden = NO;
                                self.sendCodeByEmailButton.hidden = NO;
                                
                                // get the code
                                self.codeLabel.text = goodsInfo.goods.code;
                                self.codeLabel.hidden = NO;
                            });
                            
                            // show popup event
                            [[Playbasis sharedPB] showFeedbackEventPopupFromView:self image:self.goodsImage.image title:@"Goods recieved!" description:@""];
                            
                            // we just break it out now
                            break;
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
                else
                {
                    NSLog(@"%@", error);
                }
            }];
        }
        else
        {
            NSLog(@"%@", error);
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
        [[Playbasis sharedPB] updateUserForPlayerId:USER firstArg:paramEmailUpdate andBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"Updated users's email.");
                NSLog(@"%@", result);
                
                // send code by email
                [self sendCodeByEmail_internal];
            }
        }, nil];
    }
    // sms
    else if(alertView.tag == 2)
    {
        // get phonenumber
        NSString *phoneNumber = [[alertView textFieldAtIndex:0] text];
        // create a param udpate for phonenumber
        NSString *paramPhonenumberUdpate = [NSString stringWithFormat:@"phone_number=%@", phoneNumber];
        
        // udpate user's profile
        [[Playbasis sharedPB] updateUserForPlayerId:USER firstArg:paramPhonenumberUdpate andBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"Updated user's phonenumber.");
                NSLog(@"%@", result);
                
                // send code by sms
                [self sendCodeBySMS_internal];
            }
        },nil];
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
            if(player.email == (id)[NSNull null] ||
               [player.email isEqualToString:@""] ||
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
            if(player.phoneNumber == (id)[NSNull null] ||
               [player.phoneNumber isEqualToString:@""])
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
