//
//  globalCaching.h
//  demoApp
//
//  Created by haxpor on 2/27/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Playbasis.h"

@interface globalCaching : NSObject

+ (globalCaching*)sharedInstance;

/**
 Flush all cache, thus invalidate all cache data.
 */
- (void)flushAll;

/**
 Start to make requests to relevant data and cache them.
 */
- (void)startCachingDataInBackgroundForUser:(NSString *)user complete:(void (^)(BOOL success))completion;

/**
 Get whether quest relevant data is all cached and ready to use.
 */
- (BOOL)questDataReadyToUse;

/**
 Get whether goods-list relevant data all is cached and ready to use.
 */
- (BOOL)goodsListDataReadyToUse;

/**
 Caching properties
 */
/**
 For Quest.
 */
@property (strong, nonatomic) PBQuestListAvailableForPlayer_Response* cachedQuestListAvailable_response;
@property (strong, nonatomic) NSMutableDictionary *cachedQuestImages;
@property (strong, nonatomic) PBQuestListOfPlayer_Response* cachedQuestListOfPlayer_response;

/**
 For Reward store
 */
@property (strong, nonatomic) PBGoodsListInfo_Response* cachedGoodsListInfo;
@property (strong, nonatomic) NSMutableArray *cachedGoodsListInfoImages;

@end
