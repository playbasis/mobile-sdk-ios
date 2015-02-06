//
//  missionViewController.h
//  demoApp
//
//  Created by haxpor on 2/6/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    QUEST_JOIN,
    QUEST_CONTINUE
}questLoadViaMethod;

@interface missionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString* questId;
@property (nonatomic) questLoadViaMethod viaMethod;

@end
