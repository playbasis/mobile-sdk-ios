//
//  authAndLoginViewController.h
//  demoApp
//
//  Created by haxpor on 1/27/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playbasis.h"

@interface authAndLoginViewController : UIViewController<PBResponseHandler, PBPlayerPublic_ResponseHandler>
{
    BOOL authed;
}

@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

-(void)processResponse:(id)jsonResponse withURL:(NSURL *)url error:(NSError*)error;
-(void)processResponseWithPlayerPublic:(PBPlayerPublic_Response *)playerResponse withURL:(NSURL *)url error:(NSError *)error;

@end
