//
//  demoViewController.h
//  demoApp
//
//  Created by Playbasis on 5/20/56 BE.
//  Copyright (c) 2556 Playbasis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Playbasis/Playbasis.h>

@interface demoViewController : UIViewController <PBRule_ResponseHandler>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextView *resultTextArea;

-(void)processResponseWithRule:(PBRule_Response *)response withURL:(NSURL *)url error:(NSError *)error;

- (IBAction)callAPI_player1:(id)sender;
- (IBAction)callAPI_player:(id)sender;
- (IBAction)callAPI_asyncPlayerBulk:(id)sender;
@end
