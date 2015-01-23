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
{
    BOOL authed;
}
-(void)processResponse:(NSDictionary *)jsonResponse withURL:(NSURL *)url;

- (IBAction)callAPI_player1:(id)sender;
- (IBAction)callAPI_player:(id)sender;
- (IBAction)queueSerializeAndSaveToFile:(id)sender;
- (IBAction)QueueLoadFromFile:(id)sender;
@end
