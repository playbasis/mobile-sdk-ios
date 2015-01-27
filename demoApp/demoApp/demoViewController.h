//
//  demoViewController.h
//  demoApp
//
//  Created by Maethee Chongchitnant on 5/20/56 BE.
//  Copyright (c) 2556 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playbasis.h"

@interface demoViewController : UIViewController <PBResponseHandler>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void)processResponse:(NSDictionary*)jsonResponse withURL:(NSURL *)url error:(NSError*)error;

- (IBAction)callAPI_player1:(id)sender;
- (IBAction)callAPI_player:(id)sender;
- (IBAction)callAPI_asyncPlayerBulk:(id)sender;
@end
