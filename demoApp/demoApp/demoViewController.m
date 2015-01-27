//
//  demoViewController.m
//  demoApp
//
//  Created by Maethee Chongchitnant on 5/20/56 BE.
//  Copyright (c) 2556 Maethee Chongchitnant. All rights reserved.
//

#import "demoViewController.h"
#import "playbasis.h"

@interface demoViewController ()

@end

@implementation demoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // firstly hide the activity indicator
    self.activityIndicator.hidden = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processResponse:(NSDictionary*)jsonResponse withURL:(NSURL *)url error:(NSError*)error
{
    // now the returning part is in user's thread, not ui thread.
    // thus updating any ui related elements, we need to get UI queue via dispatch_get_main_queue().
    
    if(error)
    {
        // get url path
        NSString* urlPath = [url path];
        
        // print out the response
        NSLog(@"delegate triggered from URL: %@", urlPath);
        NSLog(@"%@", jsonResponse);
        NSLog(@"Error = %@", [error localizedDescription]);
        
        return;
    }
    else
    {
        // get url path
        NSString* urlPath = [url path];
        
        // print out the response
        NSLog(@"delegate triggered from URL: %@", urlPath);
        NSLog(@"%@", jsonResponse);
    }
    
    // show activity indicator
    // note: make sure we do it in ui thread
    dispatch_queue_t uiThread = dispatch_get_main_queue();
    dispatch_async(uiThread, ^{
        self.activityIndicator.hidden = true;
    });
}

- (IBAction)callAPI_player1:(id)sender {
    // execute this only if authenticate app successfully
    if([[Playbasis sharedPB] token] != nil)
    {
        NSLog(@"Touched to callAPI_player1");

        // show activity indicator
        self.activityIndicator.hidden = false;
        
        // execute 'like' action
        // note: this will let activity indicator to be updated in UI thread
        dispatch_queue_t gQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(gQueue, ^{
            [[Playbasis sharedPB] rule:@"1" forAction:@"like" withDelegate:self, nil];
        });
    }
}

- (IBAction)callAPI_player:(id)sender {
    // execute this only if authenticate app successfully
    if([[Playbasis sharedPB] token] != nil)
    {
        NSLog(@"Touched to get player's info");
        
        NSString *user = @"1";
        
        // test calling via non-blocking call
        NSLog(@"Non-blocking player() call 1");
        [[Playbasis sharedPB] playerAsync:user withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"failed player(), error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"[Blocking call via block 1] block triggered from URL: %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }];
        NSLog(@"Non-blocking player() call 2");
        [[Playbasis sharedPB] playerAsync:user withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"failed player(), error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"[Blocking call via block 2] block triggered from URL: %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }];
        NSLog(@"Non-blocking player() call 3");
        [[Playbasis sharedPB] playerAsync:user withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"failed player(), error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"[Blocking call via block 3] block triggered from URL: %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }];
        NSLog(@"Non-blocking player() call 4");
        [[Playbasis sharedPB] playerAsync:user withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"failed player(), error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"[Blocking call via block 4] block triggered from URL: %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }];
    }
}

- (IBAction)callAPI_asyncPlayerBulk:(id)sender {
    // execute this only if authenticate app successfully
    if([[Playbasis sharedPB] token] != nil)
    {
        NSLog(@"Touched to send rule: for 'like' 4 requests");
        
        NSString *user = @"1";
        NSString *action = @"like";
        
        // test calling via non-blocking call
        NSLog(@"Non-blocking rule():like call 1");
        [[Playbasis sharedPB] ruleAsync:user forAction:action withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"Failed rule():like - 1, error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"response req 1 from url = %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }, nil];
        
        NSLog(@"Non-blocking rule():like call 2");
        [[Playbasis sharedPB] ruleAsync:user forAction:action withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"Failed rule():like - 2, error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"response req 2 from url = %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }, nil];
        
        NSLog(@"Non-blocking rule():like call 3");
        [[Playbasis sharedPB] ruleAsync:user forAction:action withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"Failed rule():like - 3, error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"response req 3 from url = %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }, nil];
        
        NSLog(@"Non-blocking rule():like call 4");
        [[Playbasis sharedPB] ruleAsync:user forAction:action withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
            if(error)
            {
                NSLog(@"Failed rule():like - 4, error = %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"response req 4 from url = %@", [url path]);
                NSLog(@"%@", [jsonResponse description]);
            }
        }, nil];
    }
}

@end
