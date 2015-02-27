//
//  globalCaching.m
//  demoApp
//
//  Created by haxpor on 2/27/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "globalCaching.h"

@implementation globalCaching

+(globalCaching*)sharedInstance
{
    static globalCaching *sharedInstance = nil;
    
    // use dispatch_once_t to initialize singleton just once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)flushAll
{
    _cachedQuestListAvailable_response = nil;
    _cachedQuestImages = nil;
    _cachedQuestListOfPlayer_response = nil;
    
    _cachedGoodsListInfo = nil;
    _cachedGoodsListInfoImages = nil;
}

-(BOOL)questDataReadyToUse
{
    if(_cachedQuestListAvailable_response != nil &&
       _cachedQuestImages != nil && [_cachedQuestImages count] == [_cachedQuestListAvailable_response.list.questBasics count] &&
       _cachedQuestListOfPlayer_response != nil)
        return YES;
    else
        return NO;
}

-(BOOL)goodsListDataReadyToUse
{
    if(_cachedGoodsListInfo != nil &&
       _cachedGoodsListInfoImages != nil && [_cachedGoodsListInfoImages count] == [_cachedGoodsListInfo.goodsList count])
        return YES;
    else
        return NO;
}

-(void)startCachingDataInBackgroundForUser:(NSString *)user complete:(void (^)(BOOL success))completion
{
    static const int kTargetCompletion = 3;
    __block int completionCount = 0;
    
    // do caching for quest
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // load all quests available to player
        [[Playbasis sharedPB] questListAvailableForPlayer:user withBlock:^(PBQuestListAvailableForPlayer_Response *list, NSURL *url, NSError *error) {
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
                            if(image != nil)
                            {
                                [_cachedQuestImages setValue:image forKey:q.questId];
                                NSLog(@"Complete caching quest image %@", q.questId);
                            }
                            else
                            {
                                NSLog(@"Failed caching image %@", q.image);
                            }
                        }];
                    }
                }
                
                completionCount++;
            }
            else
            {
                NSLog(@"Cannot cache questListAvailableForPlayer data at ths time.");
                
                completion(false);
            }
        }];
        
        // load quest that player has joined to get its status
        [[Playbasis sharedPB] questListOfPlayer:user withBlock:^(PBQuestListOfPlayer_Response *questList, NSURL *url, NSError *error) {
            if(!error)
            {
                // save the result
                _cachedQuestListOfPlayer_response = questList;
                
                NSLog(@"Complete caching all quests information.");
                
                completionCount++;
                if(completionCount >= kTargetCompletion)
                {
                    completion(YES);
                    NSLog(@"Sent to completion block : YES");
                }
            }
            else
            {
                NSLog(@"Cannot cache questListOfPlayer data at ths time.");
                
                completion(NO);
            }
        }];
    });
    
    // do caching for reward store
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
                            if(image != nil)
                            {
                                // add image sequentially
                                [_cachedGoodsListInfoImages addObject:image];
                                NSLog(@"Complete caching image for %@", goods.image);
                            }
                            else
                            {
                                NSLog(@"Failed caching image %@", goods.image);
                            }
                        }];
                    }
                    
                    NSLog(@"Complete caching all information about goods-list");
                }
                else
                {
                    NSLog(@"There's no goods list available.");
                }
                
                completionCount++;
                if(completionCount >= kTargetCompletion)
                {
                    completion(YES);
                    NSLog(@"Sent to completion block : YES");
                }
            }
            else
            {
                NSLog(@"Cannot cache goodsList data at ths time.");
                
                completion(NO);
            }
        }];
    });
}

@end
