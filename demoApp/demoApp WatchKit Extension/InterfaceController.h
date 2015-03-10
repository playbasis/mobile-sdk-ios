//
//  InterfaceController.h
//  demoApp WatchKit Extension
//
//  Created by Playbasis on 3/10/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *textLabel;
- (IBAction)requestToGetPlayerFirstName;


@end
