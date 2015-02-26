//
//  mainmenuViewController.m
//  demoApp
//
//  Created by haxpor on 1/27/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "mainmenuViewController.h"
#import "rewardStorePageViewController.h"
#import "questPageViewController.h"
#import "Playbasis.h"
#import "demoAppSettings.h"

@interface mainmenuViewController ()

@end

@implementation mainmenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.activityIndicator.hidden = YES;
    
    // listen to network status changed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged:) name:pbNetworkStatusChangedNotification object:nil];
    
    // do caching for quest
    dispatch_async(dispatch_get_main_queue(), ^{
        // load all quests available to player
        [[Playbasis sharedPB] questListAvailableForPlayer:USER withBlock:^(PBQuestListAvailableForPlayer_Response *list, NSURL *url, NSError *error) {
            if(!error)
            {
                // save the response
                _cachedQuestListAvailable_response = list;
                
                if(_cachedQuestListAvailable_response.list != nil &&
                   [_cachedQuestListAvailable_response.list.questBasics count] > 0)
                {
                    // create dictionary
                    _cachedQuestImages = [NSMutableDictionary dictionary];
                    
                    // async load all image from the quest-list
                    for(PBQuestBasic *q in _cachedQuestListAvailable_response.list.questBasics)
                    {
                        // load image in non-blocking call
                        [UIImage startLoadingImageInTheBackgroundWithUrl:q.image response:^(UIImage *image) {
                             [_cachedQuestImages setValue:image forKey:q.questId];
                            NSLog(@"Complete caching quest image %@", q.questId);
                        }];
                    }
                }
            }
            else
            {
                NSLog(@"Cannot cache questListAvailableForPlayer data at ths time.");
            }
        }];
        
        // load quest that player has joined to get its status
        [[Playbasis sharedPB] questListOfPlayer:USER withBlock:^(PBQuestListOfPlayer_Response *questList, NSURL *url, NSError *error) {
            if(!error)
            {
                // save the result
                _cachedQuestListOfPlayer_response = questList;
                
                NSLog(@"Complete caching all quests information.");
            }
            else
            {
                NSLog(@"Cannot cache questListOfPlayer data at ths time.");
            }
        }];
    });
    
    // do caching for reward store
    dispatch_async(dispatch_get_main_queue(), ^{
        // load goods-list in non-blocking way
        [[Playbasis sharedPB] goodsListWithBlock:^(PBGoodsListInfo_Response *goodsListInfo, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"%@", goodsListInfo);
                
                // save response
                _cachedGoodsListInfo = goodsListInfo;
                
                // it's there any to load
                if(goodsListInfo.goodsList != nil &&
                   [goodsListInfo.goodsList count] > 0)
                {
                    // create array
                    _cachedGoodsListInfoImages = [NSMutableArray array];
                    
                    // cache all images
                    for(PBGoods *goods in goodsListInfo.goodsList)
                    {
                        [UIImage startLoadingImageWithUrl:goods.image response:^(UIImage *image) {
                            // add image sequentially
                            [_cachedGoodsListInfoImages addObject:image];
                            NSLog(@"Complete caching image for %@", goods.image);
                        }];
                    }
                    
                    NSLog(@"Complete caching all information about goods-list");
                }
                else
                {
                    NSLog(@"There's no goods list available.");
                }
            }
            else
            {
                NSLog(@"Cannot cache goodsList data at ths time.");
            }
        }];
    });
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // remove listener from notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:pbNetworkStatusChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onNetworkStatusChanged:(NSNotification *)notif
{
    // get NetworkStatus from notif
    NSDictionary *data = notif.userInfo;
    NSNumber *networkStatusNumber = [data objectForKey:@"data"];
    
    NetworkStatus networkStatus = [networkStatusNumber intValue];
    
    switch(networkStatus)
    {
        case NotReachable:
            NSLog(@"User: Network is not reachable");
            break;
        case ReachableViaWiFi:
            NSLog(@"User: Network is reachable via WiFi");
            break;
        case ReachableViaWWAN:
            NSLog(@"User: Network is reachable via WWAN");
            break;
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // if network cannot be reachable then set the cache data
    if(![Playbasis sharedPB].isNetworkReachable)
    {
        if([[segue identifier] isEqualToString:@"showQuestPageViewController"] &&
           _cachedQuestListAvailable_response != nil &&
           _cachedQuestImages != nil &&
           _cachedQuestListOfPlayer_response != nil)
        {
            // get quest page view
            questPageViewController *questPage = [segue destinationViewController];
            
            // set cached data
            questPage.questListAvailable = _cachedQuestListAvailable_response;
            questPage.questList = _cachedQuestListOfPlayer_response;
            questPage.cachedQuestImages = _cachedQuestImages;
            
            NSLog(@"Set all cached data to quest page view.");
        }
        else if([[segue identifier] isEqualToString:@"showRewardStorePageViewController"] &&
            _cachedGoodsListInfo != nil &&
            _cachedGoodsListInfoImages != nil)
        {
            // get reward-store
            rewardStorePageViewController *rewardStore = [segue destinationViewController];
            
            // set result of goodslist back to reward-store
            rewardStore.goodsListInfo = _cachedGoodsListInfo;
            rewardStore.goodsListInfoCachedImages = _cachedGoodsListInfoImages;
            
            // stop spinning activity indicator
            dispatch_async(dispatch_get_main_queue(), ^{
                self.activityIndicator.hidden = YES;
            });
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    // make sure navigation bar is always showing
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

@end
