//
//  mainmenuViewController.h
//  demoApp
//
//  Created by haxpor on 1/27/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbasis.h"

@interface mainmenuViewController : UIViewController
{
    // cache the result from goodsList
    PBGoodsListInfo_Response *goodsListInfo_;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// caching
// - quest
@property (strong, nonatomic) PBQuestListAvailableForPlayer_Response* cachedQuestListAvailable_response;
@property (strong, nonatomic) NSMutableDictionary *cachedQuestImages;
@property (strong, nonatomic) PBQuestListOfPlayer_Response* cachedQuestListOfPlayer_response;

// - reward store
@property (strong, nonatomic) PBGoodsListInfo_Response* cachedGoodsListInfo;
@property (strong, nonatomic) NSMutableArray *cachedGoodsListInfoImages;

@end
