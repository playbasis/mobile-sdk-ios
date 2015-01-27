//
//  authAndLoginViewController.h
//  demoApp
//
//  Created by haxpor on 1/27/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playbasis.h"

@interface authAndLoginViewController : UIViewController<PBResponseHandler>
{
    BOOL authed;
}

@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

-(void)processResponse:(NSDictionary*)jsonResponse withURL:(NSURL *)url error:(NSError*)error;

@end
