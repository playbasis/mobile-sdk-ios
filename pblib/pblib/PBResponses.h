//
//  PBResponses.h
//  pblib
//
//  Created by haxpor on 2/6/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#ifndef pblib_PBResponses_h
#define pblib_PBResponses_h

#import <Foundation/Foundation.h>

///--------------------------------------
/// Type of Response
///--------------------------------------
typedef enum
{
    responseType_normal,
    responseType_auth,
    responseType_playerPublic,
    responseType_player,
    responseType_playerList,
    responseType_playerGoodsOwned,
    responseType_point,
    responseType_points,
    responseType_badge,
    responseType_badges,
    responseType_playerBadges,
    responseType_playerDetailedPublic,
    responseType_playerDetailed,
    responseType_pointHistory,
    responseType_actionTime,
    responseType_lastAction,
    responseType_actionCount,
    responseType_level,
    responseType_levels,
    responseType_rank,
    responseType_ranks,
    responseType_goodsInfo,
    responseType_goodsListInfo,
    responseType_goodsGroupAvailable,
    responseType_questOfPlayer,
    responseType_questListOfPlayer,
    responseType_questRewardHistoryOfPlayer,
    responseType_questList,
    responseType_questInfo,
    responseType_actionConfig,
}pbResponseType;

///--------------------------------------
/// Base - Response
/// Do not use this class directly.
/// All response classes subclasses this class.
///--------------------------------------
@interface PBBase_Response : NSObject

@end

///--------------------------------------
/// Auth
///--------------------------------------
@interface PBAuth_Response : PBBase_Response

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSDate *dateExpire;

+(PBAuth_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end
///--------------------------------------
/// Player Info - Public Data Only
///--------------------------------------
@interface PBPlayerPublic_Response : PBBase_Response

@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *userName;
@property (nonatomic) NSUInteger exp;
@property (nonatomic) NSUInteger level;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (nonatomic) NSUInteger gender;
@property (strong, nonatomic) NSDate *registered;
@property (strong, nonatomic) NSDate *lastLogin;
@property (strong, nonatomic) NSDate *lastLogout;
@property (strong, nonatomic) NSString* clPlayerId;

+(PBPlayerPublic_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Player Info - Included Private Data
///--------------------------------------
@interface PBPlayer_Response : PBBase_Response

@property (strong, nonatomic) PBPlayerPublic_Response *playerPublic;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;

+(PBPlayer_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerList
///--------------------------------------
@interface PBPlayerList_Response : PBBase_Response

@property (strong, nonatomic) NSArray *players;

+(PBPlayerList_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Point - No Response
///--------------------------------------
@interface PBPoint : PBBase_Response

@property (strong, nonatomic) NSString *rewardId;
@property (strong, nonatomic) NSString *rewardName;
@property (nonatomic) NSUInteger value;

+(PBPoint*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Point
///--------------------------------------
@interface PBPoint_Response : PBBase_Response

@property (strong, nonatomic) NSArray* point;

+(PBPoint_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Points
///--------------------------------------
@interface PBPoints_Response : PBBase_Response

@property (strong, nonatomic) NSArray* points;

+(PBPoints_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Badge
///--------------------------------------
@interface PBBadge_Response : PBBase_Response

@property (strong, nonatomic) NSString* badgeId;
@property (strong, nonatomic) NSString* image;
@property (nonatomic) NSUInteger sortOrder;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* description_;
@property (strong, nonatomic) NSString* hint;
@property (nonatomic) BOOL sponsor;
@property (nonatomic) BOOL claim;
@property (nonatomic) BOOL redeem;

+(PBBadge_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Badges
///--------------------------------------
@interface PBBadges_Response : PBBase_Response

@property (strong, nonatomic) NSArray* badges;

+(PBBadges_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerBadge - No Response
///--------------------------------------
@interface PBPlayerBadge : PBBase_Response

@property (strong, nonatomic) NSString *badgeId;
@property (nonatomic) BOOL redeemed;
@property (nonatomic) BOOL claimed;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description_;
@property (nonatomic) NSUInteger amount;
@property (strong, nonatomic) NSString *hint;

+(PBPlayerBadge*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerBadge
///--------------------------------------
@interface PBPlayerBadges_Response : PBBase_Response

@property (strong, nonatomic) NSArray *playerBadges;

+(PBPlayerBadges_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerDetailedPublic
///--------------------------------------
@interface PBPlayerDetailedPublic_Response : PBBase_Response

@property (strong, nonatomic) PBPlayerPublic_Response *playerPublic;
@property (nonatomic) float percentOfLevel;
@property (strong, nonatomic) NSString *levelTitle;
@property (strong, nonatomic) NSString *levelImage;
@property (strong, nonatomic) PBPlayerBadges_Response *badges;
@property (strong, nonatomic) PBPoints_Response *points;

+(PBPlayerDetailedPublic_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerDetailed
///--------------------------------------
@interface PBPlayerDetailed_Response : PBBase_Response

@property (strong, nonatomic) PBPlayer_Response *player;
@property (nonatomic) float percentOfLevel;
@property (strong, nonatomic) NSString *levelTitle;
@property (strong, nonatomic) NSString *levelImage;
@property (strong, nonatomic) PBPlayerBadges_Response *badges;
@property (strong, nonatomic) PBPoints_Response *points;

+(PBPlayerDetailed_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PointHistory - No Response
///--------------------------------------
@interface PBPointHistory : PBBase_Response

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *rewardId;
@property (strong, nonatomic) NSString *rewardName;
@property (nonatomic) NSUInteger value;
@property (strong, nonatomic) NSDate *dateAdded;
@property (strong, nonatomic) NSString *actionName;
@property (strong, nonatomic) NSString *stringFilter;
@property (strong, nonatomic) NSString *actionIcon;

+(PBPointHistory*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PointHistory
///--------------------------------------
@interface PBPointHistory_Response : PBBase_Response

@property (strong, nonatomic) NSArray *pointHistory;

+(PBPointHistory_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ActionTime
///--------------------------------------
@interface PBActionTime_Response : PBBase_Response

@property (strong, nonatomic) NSString *actionId;
@property (strong, nonatomic) NSString *actionName;
@property (strong, nonatomic) NSDate *time;

+(PBActionTime_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// LastAction
///--------------------------------------
@interface PBLastAction_Response : PBBase_Response

@property (strong, nonatomic) NSString *actionId;
@property (strong, nonatomic) NSString *actionName;
@property (strong, nonatomic) NSDate *time;

+(PBLastAction_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ActionCount
///--------------------------------------
@interface PBActionCount_Response : PBBase_Response

@property (strong, nonatomic) NSString *actionId;
@property (strong, nonatomic) NSString *actionName;
@property (nonatomic) NSUInteger count;

+(PBActionCount_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Level
///--------------------------------------
@interface PBLevel_Response : PBBase_Response

@property (strong, nonatomic) NSString *levelTitle;
@property (nonatomic) NSUInteger level;
@property (nonatomic) NSUInteger minExp;
@property (nonatomic) NSUInteger maxExp;
@property (strong, nonatomic) NSString *levelImage;

+(PBLevel_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Levels
///--------------------------------------
@interface PBLevels_Response : PBBase_Response

@property (strong, nonatomic) NSArray *levels;

+(PBLevels_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Rank - No Response
///--------------------------------------
@interface PBRank : PBBase_Response

@property (strong, nonatomic) NSString *pbPlayerId;
@property (strong, nonatomic) NSString *playerId;
@property (strong, nonatomic) NSString *pointType;
@property (nonatomic) NSUInteger pointValue;

+(PBRank*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Rank (only particular point type)
///--------------------------------------
@interface PBRank_Response : PBBase_Response

@property (strong, nonatomic) NSArray *ranks;

+(PBRank_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Rank (for all point types)
///--------------------------------------
@interface PBRanks_Response : PBBase_Response

/**
 Use this key to access ranks according to each point type.
 */
@property (strong, nonatomic) NSArray *rankByKeys;

/**
 Array contains ranks by each point type.
 Use rankByKeys to access array according to each point type.
 */
@property (strong, nonatomic) NSDictionary *ranks;

+(PBRanks_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Custom - No Response
///--------------------------------------
@interface PBCustom : PBBase_Response

@property (strong, nonatomic) NSString *customId;
@property (strong, nonatomic) NSString *customName;
@property (nonatomic) NSUInteger customValue;

+(PBCustom*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Custom - Array
///--------------------------------------
@interface PBCustoms : PBBase_Response

@property (strong, nonatomic) NSArray *customs;

+(PBCustoms*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Redeem
///--------------------------------------
@interface PBRedeem : PBBase_Response

@property (nonatomic) NSUInteger pointValue;
@property (strong, nonatomic) PBCustoms *customs;

+(PBRedeem*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Goods
///--------------------------------------
@interface PBGoods : PBBase_Response

@property (strong, nonatomic) NSString *goodsId;
@property (nonatomic) NSUInteger quantity;
@property (strong, nonatomic) NSString *image;
@property (nonatomic) NSUInteger sortOrder;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description_;
@property (strong, nonatomic) PBRedeem *redeem;
@property (strong, nonatomic) NSString *code;
@property (nonatomic) BOOL sponsor;
@property (strong, nonatomic) NSDate *dateStart;
@property (strong, nonatomic) NSDate *dateExpire;

+(PBGoods*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Goods Info
///--------------------------------------
@interface PBGoodsInfo_Response : PBBase_Response

@property (strong, nonatomic) PBGoods *goods;
@property (nonatomic) NSUInteger perUser;
@property (nonatomic) BOOL isGroup;

+(PBGoodsInfo_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Goods List Info
///--------------------------------------
@interface PBGoodsListInfo_Response : PBBase_Response

@property (strong, nonatomic) NSArray *goodsList;

+(PBGoodsListInfo_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Goods Group Available
///--------------------------------------
@interface PBGoodsGroupAvailable_Response : PBBase_Response

@property (nonatomic) NSUInteger available;

+(PBGoodsGroupAvailable_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Player Goods Owned - No Response
///--------------------------------------
@interface PBPlayerGoodsOwned : PBBase_Response

@property (strong, nonatomic) NSString *goodsId;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description_;
@property (nonatomic) NSUInteger amount;

+(PBPlayerGoodsOwned*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Player Goods Owned
///--------------------------------------
@interface PBPlayerGoodsOwned_Response : PBBase_Response

@property (strong, nonatomic) NSArray *goodsOwneds;

+(PBPlayerGoodsOwned_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Reward
///--------------------------------------
@interface PBReward : PBBase_Response

@property (strong, nonatomic) NSString *rewardValue;
@property (strong, nonatomic) NSString *rewardType;
@property (strong, nonatomic) NSString *rewardId;
@property (strong, nonatomic) NSString *rewardName;

+(PBReward *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestReward
///--------------------------------------
@interface PBQuestReward : PBBase_Response

@property (strong, nonatomic) NSString *questId;
@property (strong, nonatomic) NSString *missionId;
@property (strong, nonatomic) NSString *rewardValue;
@property (strong, nonatomic) NSString *rewardType;
@property (strong, nonatomic) NSString *rewardId;
@property (strong, nonatomic) NSString *rewardName;
@property (strong, nonatomic) NSDate *dateAdded;
@property (strong, nonatomic) NSDate *dateModified;
@property (strong, nonatomic) NSString *questName;
@property (strong, nonatomic) NSString *type;

+(PBQuestReward *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestRewardArray
///--------------------------------------
@interface PBQuestRewardArray : PBBase_Response

@property (strong, nonatomic) NSArray *questRewards;

+(PBQuestRewardArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestRewardHistoryOfPlayer
///--------------------------------------
@interface PBQuestRewardHistoryOfPlayer_Response : PBBase_Response

@property (strong, nonatomic) PBQuestRewardArray *list;

+(PBQuestRewardHistoryOfPlayer_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RewardArray
///--------------------------------------
@interface PBRewardArray : PBBase_Response

@property (strong, nonatomic) NSArray *rewards;

+(PBRewardArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Incomplete
///--------------------------------------
@interface PBIncomplete : PBBase_Response

@property (strong, nonatomic) NSString *incompletionId;
@property (strong, nonatomic) NSString *incompletionType;
@property (nonatomic) NSUInteger incompletionValue;
@property (strong, nonatomic) NSString *incompletionElementId;
@property (strong, nonatomic) NSString *incompletionFilter;

+(PBIncomplete *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// IncompleteArray
///--------------------------------------
@interface PBIncompleteArray : PBBase_Response

@property (strong, nonatomic) NSArray *incompletions;

+(PBIncompleteArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// CompletionData
///--------------------------------------
@interface PBCompletionData : PBBase_Response

@property (strong, nonatomic) NSString *actionId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description_;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *color;

+(PBCompletionData *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Completion
///--------------------------------------
@interface PBCompletion : PBBase_Response

@property (strong, nonatomic) NSString *completionFilter;
@property (strong, nonatomic) NSString *completionValue;
@property (strong, nonatomic) NSString *completionId;
@property (strong, nonatomic) NSString *completionType;
@property (strong, nonatomic) NSString *completionElementId;
@property (strong, nonatomic) NSString *completionTitle;
@property (strong, nonatomic) PBCompletionData *completionData;

+(PBCompletion *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// CompletionArray
///--------------------------------------
@interface PBCompletionArray : PBBase_Response

@property (strong, nonatomic) NSArray *completions;

+(PBCompletionArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Pending
///--------------------------------------
@interface PBPending : PBBase_Response

@property (strong, nonatomic) NSString *eventType;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) PBIncomplete *incomplete;

+(PBPending *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PendingArray
///--------------------------------------
@interface PBPendingArray : PBBase_Response

@property (strong, nonatomic) NSArray *pendings;

+(PBPendingArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// MissionBasic
///--------------------------------------
@interface PBMissionBasic : PBBase_Response

@property (strong, nonatomic) NSString *missionName;
@property (strong, nonatomic) NSString *missionNumber;
@property (strong, nonatomic) NSString *description_;
@property (strong, nonatomic) NSString *hint;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) PBCompletionArray *completions;
@property (strong, nonatomic) PBRewardArray *rewards;
@property (strong, nonatomic) NSString *missionId;

+(PBMissionBasic *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// MissionBasicArray
///--------------------------------------
@interface PBMissionBasicArray : PBBase_Response

@property (strong, nonatomic) NSArray *missionBasics;

+(PBMissionBasicArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Mission
///--------------------------------------
@interface PBMission : PBBase_Response

@property (strong, nonatomic) PBMissionBasic *missionBasic;
@property (strong, nonatomic) NSDate *dateModified;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) PBPendingArray *pendings;

+(PBMission *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// MissionArray
///--------------------------------------
@interface PBMissionArray : PBBase_Response

@property (strong, nonatomic) NSArray *missions;

+(PBMissionArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ConditionData
///--------------------------------------
@interface PBConditionData : PBBase_Response

@property (strong, nonatomic) NSString *questName;
@property (strong, nonatomic) NSString *description_;
@property (strong, nonatomic) NSString *hint;
@property (strong, nonatomic) NSString *image;

+(PBConditionData *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Condition
///--------------------------------------
@interface PBCondition : PBBase_Response

@property (strong, nonatomic) NSString *conditionId;
@property (strong, nonatomic) NSString *conditionType;
@property (strong, nonatomic) NSString *conditionValue;
@property (strong, nonatomic) PBConditionData *conditionData;

+(PBCondition *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ConditionArray
///--------------------------------------
@interface PBConditionArray : PBBase_Response

@property (strong, nonatomic) NSArray *conditions;

+(PBConditionArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestBasic
///--------------------------------------
@interface PBQuestBasic : PBBase_Response

@property (strong, nonatomic) NSString *questName;
@property (strong, nonatomic) NSString *description_;
@property (strong, nonatomic) NSString *hint;
@property (strong, nonatomic) NSString *image;
@property (nonatomic) BOOL missionOrder;
@property (nonatomic) BOOL status;
@property (nonatomic) NSUInteger sortOrder;
@property (strong, nonatomic) PBRewardArray *rewards;
@property (strong, nonatomic) PBMissionBasicArray *missionBasics;
@property (strong, nonatomic) NSDate *dateAdded;
@property (strong, nonatomic) NSString *clientId;
@property (strong, nonatomic) NSString *siteId;
@property (strong, nonatomic) NSDate *dateModified;
@property (strong, nonatomic) NSString *questId;

+(PBQuestBasic *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Quest Info
///--------------------------------------
@interface PBQuestInfo_Response : PBQuestBasic

@property (strong, nonatomic) PBQuestBasic *questBasic;
@property (strong, nonatomic) PBConditionArray *conditions;

+(PBQuestInfo_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Quest
///--------------------------------------
@interface PBQuest : PBBase_Response

@property (strong, nonatomic) NSString *questName;
@property (strong, nonatomic) NSString *description_;
@property (strong, nonatomic) NSString *hint;
@property (strong, nonatomic) NSString *image;
@property (nonatomic) BOOL missionOrder;
@property (strong, nonatomic) NSString *status;
@property (nonatomic) NSUInteger sortOrder;
@property (strong, nonatomic) PBRewardArray *rewards;
@property (strong, nonatomic) PBMissionArray *missions;
@property (strong, nonatomic) NSDate *dateAdded;
@property (strong, nonatomic) NSString *clientId;
@property (strong, nonatomic) NSString *siteId;
@property (strong, nonatomic) NSDate *dateModified;
@property (strong, nonatomic) NSString *questId;

+(PBQuest *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestBasicArray
///--------------------------------------
@interface PBQuestBasicArray : PBBase_Response

@property (strong, nonatomic) NSArray *questBasics;

+(PBQuestBasicArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestArray
///--------------------------------------
@interface PBQuestArray : PBBase_Response

@property (strong, nonatomic) NSArray *quests;

+(PBQuestArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestOfPlayer
///--------------------------------------
@interface PBQuestOfPlayer_Response : PBBase_Response

@property (strong, nonatomic) PBQuest *quest;

+(PBQuestOfPlayer_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestListOfPlayer
///--------------------------------------
@interface PBQuestListOfPlayer_Response : PBBase_Response

@property (strong, nonatomic) PBQuestArray *questList;

+(PBQuestListOfPlayer_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestListOfPlayer
///--------------------------------------
@interface PBQuestList_Response : PBBase_Response

@property (strong, nonatomic) PBQuestBasicArray *list;

+(PBQuestList_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Config
///--------------------------------------
@interface PBConfig : PBBase_Response

@property (strong, nonatomic) NSString *url;

+(PBConfig *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ConfigArray
///--------------------------------------
@interface PBConfigArray : PBBase_Response

@property (strong, nonatomic) NSArray *configs;

+(PBConfigArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ActionConfig
///--------------------------------------
@interface PBActionConfig : PBBase_Response

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) PBConfigArray *configs;

+(PBActionConfig *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ActionConfigArray
///--------------------------------------
@interface PBActionConfigArray : PBBase_Response

@property (strong, nonatomic) NSArray *actionConfigs;

+(PBActionConfigArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ActionConfig - Response
///--------------------------------------
@interface PBActionConfig_Response : PBBase_Response

@property (strong, nonatomic) PBActionConfigArray *list;

+(PBActionConfig_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

#endif
