//
//  demoViewController.m
//  demoApp
//
//  Created by Maethee Chongchitnant on 5/20/56 BE.
//  Copyright (c) 2556 Maethee Chongchitnant. All rights reserved.
//

#import "demoViewController.h"
#import "Playbasis.h"
#import "demoAppSettings.h"

@interface demoViewController ()

@end

@implementation demoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.activityIndicator.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processResponseWithRule:(PBRule_Response *)response withURL:(NSURL *)url error:(NSError *)error
{
    // now the returning part is in user's thread, not ui thread.
    // thus updating any ui related elements, we need to get UI queue via dispatch_get_main_queue().
    
    if(error)
    {
        // get url path
        NSString* urlPath = [url path];
        
        // print out the response
        NSLog(@"delegate triggered from URL: %@", urlPath);
        NSLog(@"%@", response);
        NSLog(@"Error = %@", [error localizedDescription]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // hide hud
            [[Playbasis sharedPB] hideHUDFromView:self.view];
        });
    }
    else
    {
        // get url path
        NSString* urlPath = [url path];
        
        // print out the response
        NSLog(@"delegate triggered from URL: %@", urlPath);
        NSLog(@"%@", response);
        
        // set result to text area
        dispatch_async(dispatch_get_main_queue(), ^{
            // set text
            self.resultTextArea.text = [response description];
            // hide hud
            [[Playbasis sharedPB] hideHUDFromView:self.view];
        });
    }
}

- (IBAction)callAPI_player1:(id)sender {
    // execute this only if authenticate app successfully
    if([[Playbasis sharedPB] token] != nil)
    {
        NSLog(@"Touched to callAPI_player1");

        // show hud
        [[Playbasis sharedPB] showHUDFromView:self.view withText:@"Loading"];
        
        // execute 'like' action
        // do like this to allow time for hud to be updated
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[Playbasis sharedPB] ruleForPlayer:USER action:@"like" withDelegate:self, nil];
        });
    }
}

- (IBAction)callAPI_player:(id)sender {
    // execute this only if authenticate app successfully
    if([[Playbasis sharedPB] token] != nil)
    {
        NSLog(@"Touched to get player's info");
        
        // show hud
        [[Playbasis sharedPB] showHUDFromView:self.view withText:@"Loading"];
        
        // test calling via non-blocking call
        NSLog(@"Non-blocking player() call 1");
        [[Playbasis sharedPB] playerAsync:USER withBlock:^(PBPlayer_Response *player, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"failed player(), error = %@", [error localizedDescription]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // hide hud
                    [[Playbasis sharedPB] hideHUDFromView:self.view];
                });
            }
            else
            {
                NSLog(@"[Blocking call via block 1] block triggered from URL: %@", [url path]);
                NSLog(@"%@", player);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // set result to text area
                    self.resultTextArea.text = [player description];
                    // hide hud
                    [[Playbasis sharedPB] hideHUDFromView:self.view];
                });
            }
        }];
    }
}

- (IBAction)callAPI_asyncPlayerBulk:(id)sender {
    // execute this only if authenticate app successfully
    if([[Playbasis sharedPB] token] != nil)
    {
        NSLog(@"Touched to send rule: for 'like'");
        
        // show hud
        [[Playbasis sharedPB] showHUDFromView:self.view withText:@"Loading"];
        
        NSString *action = @"like";
        
        // test calling via non-blocking call
        NSLog(@"Non-blocking rule():like call 1");
        
        [[Playbasis sharedPB] ruleForPlayerAsync:USER action:action withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"response req 1 from url = %@", [url path]);
                NSLog(@"%@", [response description]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // set result to text area
                    self.resultTextArea.text = [response description];
                    // hide hud
                    [[Playbasis sharedPB] hideHUDFromView:self.view];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // hide hud
                    [[Playbasis sharedPB] hideHUDFromView:self.view];
                });
            }
        }, nil];
    }
}

@end
