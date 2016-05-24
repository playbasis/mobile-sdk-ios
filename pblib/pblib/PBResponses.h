//
//  PBResponses.h
//  pblib
//
//  Created by Playbasis on 2/6/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#ifndef pblib_PBResponses_h
#define pblib_PBResponses_h

#import <Foundation/Foundation.h>
#import "UIImage+AutoLoader.h"

///--------------------------------------
/// Type of Response
///--------------------------------------
typedef enum
{
    responseType_normal,
    responseType_auth,
    responseType_renew,
    responseType_playerPublic,
    responseType_player,
    responseType_playerList,
    responseType_playerGoodsOwned,
    responseType_playerSetCustomFields,
    responseType_playerGetCustomFields,
    responseType_registerUser,
    responseType_updateUser,
    responseType_deleteUser,
    responseType_loginUser,
    responseType_logoutUser,
    responseType_point,
    responseType_points,
    responseType_badge,
    responseType_badges,
    responseType_playerBadges,
    responseType_playerDetailedPublic,
    responseType_playerDetailed,
    responseType_pointHistory,
    responseType_actionLastPerformedTime,
    responseType_actionTime,
    responseType_lastAction,
    responseType_actionCount,
    responseType_level,
    responseType_levels,
    responseType_claimBadge,
    responseType_redeemBadge,
    responseType_rank,
    responseType_ranks,
    responseType_deductReward,
    responseType_goodsInfo,
    responseType_goodsListInfo,
    responseType_goodsGroupAvailable,
    responseType_questOfPlayer,
    responseType_questListOfPlayer,
    responseType_questRewardHistoryOfPlayer,
    responseType_questList,
    responseType_questInfo,
    responseType_actionConfig,
    responseType_rule,
    responseType_recentPoint,
    responseType_missionInfo,
    responseType_questListAvailableForPlayer,
    responseType_questAvailableForPlayer,
    responseType_joinQuest,
    responseType_joinAllQuests,
    responseType_cancelQuest,
    responseType_activeQuizList,
    responseType_quizDetail,
    responseType_quizRandom,
    responseType_quizDoneListByPlayer,
    responseType_quizPendingsByPlayer,
    responseType_redeemGoods,
    responseType_sendEmail,
    responseType_sendEmailCoupon,
    responseType_sendSMS,
    responseType_sendSMSCoupon,
    responseType_questionFromQuiz,
    responseType_questionAnswered,
    responseType_playersQuizRank,
    responseType_resetPoint,
    responseType_uniqueCode,
    responseType_ruleDetail
}pbResponseType;

///--------------------------------------
/// Base - Response
/// Do not use this class directly.
/// All response classes subclasses this class.
///--------------------------------------
@interface PBBase_Response : NSObject

/** 
 Raw JSON-format response.
 If you want to manipulate json-format response yourself, this is the property you will be working with.
 */
@property (strong, nonatomic, readonly) NSDictionary* parseLevelJsonResponse;

@end

///--------------------------------------
/// Auth
///--------------------------------------
@interface PBAuth_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSString *token;
@property (strong, nonatomic, readonly) NSDate *dateExpire;

+(PBAuth_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Player Info Basic
///--------------------------------------
@interface PBPlayerBasic : PBBase_Response

@property (strong, nonatomic, readonly) NSString *image;
@property (strong, nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSUInteger exp;
@property (nonatomic, readonly) NSUInteger level;
@property (strong, nonatomic, readonly) NSString *firstName;
@property (strong, nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSUInteger gender;
@property (strong, nonatomic, readonly) NSString* clPlayerId;

+(PBPlayerBasic*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Player Info - Public Data Only
///--------------------------------------
@interface PBPlayerPublic_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBPlayerBasic *playerBasic;
@property (strong, nonatomic, readonly) NSDate *registered;
@property (strong, nonatomic, readonly) NSDate *lastLogin;
@property (strong, nonatomic, readonly) NSDate *lastLogout;

+(PBPlayerPublic_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Player Info - Included Private Data
///--------------------------------------
@interface PBPlayer_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBPlayerPublic_Response *playerPublic;
@property (strong, nonatomic, readonly) NSString *email;
@property (strong, nonatomic, readonly) NSString *phoneNumber;

+(PBPlayer_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerList
///--------------------------------------
@interface PBPlayerList_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *players;

+(PBPlayerList_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Point - No Response
///--------------------------------------
@interface PBPoint : PBBase_Response

@property (strong, nonatomic, readonly) NSString *rewardId;
@property (strong, nonatomic, readonly) NSString *rewardName;
@property (nonatomic, readonly) NSUInteger value;

+(PBPoint*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Point
///--------------------------------------
@interface PBPoint_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSArray* point;

+(PBPoint_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Points
///--------------------------------------
@interface PBPoints_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSArray* points;

+(PBPoints_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Badge
///--------------------------------------
@interface PBBadge_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSString* badgeId;
@property (strong, nonatomic, readonly) NSString* image;
@property (nonatomic, readonly) NSUInteger sortOrder;
@property (strong, nonatomic, readonly) NSString* name;
@property (strong, nonatomic, readonly) NSString* description_;
@property (strong, nonatomic, readonly) NSString* hint;
@property (nonatomic, readonly) BOOL sponsor;
@property (nonatomic, readonly) BOOL claim;
@property (nonatomic, readonly) BOOL redeem;

+(PBBadge_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Badges
///--------------------------------------
@interface PBBadges_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSArray* badges;

+(PBBadges_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerBadge - No Response
///--------------------------------------
@interface PBPlayerBadge : PBBase_Response

@property (strong, nonatomic, readonly) NSString *badgeId;
@property (nonatomic, readonly) BOOL redeemed;
@property (nonatomic, readonly) BOOL claimed;
@property (strong, nonatomic, readonly) NSString *image;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *description_;
@property (nonatomic, readonly) NSUInteger amount;
@property (strong, nonatomic, readonly) NSString *hint;

+(PBPlayerBadge*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerBadge
///--------------------------------------
@interface PBPlayerBadges_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *playerBadges;

+(PBPlayerBadges_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerDetailedPublic
///--------------------------------------
@interface PBPlayerDetailedPublic_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBPlayerPublic_Response *playerPublic;
@property (nonatomic) float percentOfLevel;
@property (strong, nonatomic, readonly) NSString *levelTitle;
@property (strong, nonatomic, readonly) NSString *levelImage;
@property (strong, nonatomic, readonly) PBPlayerBadges_Response *badges;
@property (strong, nonatomic, readonly) PBPoints_Response *points;

+(PBPlayerDetailedPublic_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerDetailed
///--------------------------------------
@interface PBPlayerDetailed_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBPlayer_Response *player;
@property (nonatomic, readonly) float percentOfLevel;
@property (strong, nonatomic, readonly) NSString *levelTitle;
@property (strong, nonatomic, readonly) NSString *levelImage;
@property (strong, nonatomic, readonly) PBPlayerBadges_Response *badges;
@property (strong, nonatomic, readonly) PBPoints_Response *points;

+(PBPlayerDetailed_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PointHistory - No Response
///--------------------------------------
@interface PBPointHistory : PBBase_Response

@property (strong, nonatomic, readonly) NSString *message;
@property (strong, nonatomic, readonly) NSString *rewardId;
@property (strong, nonatomic, readonly) NSString *rewardName;
@property (nonatomic, readonly) NSUInteger value;
@property (strong, nonatomic, readonly) NSDate *dateAdded;
@property (strong, nonatomic, readonly) NSString *actionName;
@property (strong, nonatomic, readonly) NSString *stringFilter;
@property (strong, nonatomic, readonly) NSString *actionIcon;

+(PBPointHistory*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PointHistory
///--------------------------------------
@interface PBPointHistory_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *pointHistory;

+(PBPointHistory_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Action Last Performed Time
///--------------------------------------
@interface PBActionLastPerformedTime : PBBase_Response

@property (strong, nonatomic, readonly) NSString *actionId;
@property (strong, nonatomic, readonly) NSString *actionName;
@property (strong, nonatomic, readonly) NSDate *time;

+(PBActionLastPerformedTime*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Action Last Performed Time - Response
///--------------------------------------
@interface PBActionLastPerformedTime_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBActionLastPerformedTime *response;

+(PBActionLastPerformedTime_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end


///--------------------------------------
/// ActionTime
///--------------------------------------
@interface PBActionTime_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSString *actionId;
@property (strong, nonatomic, readonly) NSString *actionName;
@property (strong, nonatomic, readonly) NSDate *time;

+(PBActionTime_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// LastAction
///--------------------------------------
@interface PBLastAction_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSString *actionId;
@property (strong, nonatomic, readonly) NSString *actionName;
@property (strong, nonatomic, readonly) NSDate *time;

+(PBLastAction_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ActionCount
///--------------------------------------
@interface PBActionCount_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSString *actionId;
@property (strong, nonatomic, readonly) NSString *actionName;
@property (nonatomic, readonly) NSUInteger count;

+(PBActionCount_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Level
///--------------------------------------
@interface PBLevel_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSString *levelTitle;
@property (nonatomic, readonly) NSUInteger level;
@property (nonatomic, readonly) NSUInteger minExp;
@property (nonatomic, readonly) NSUInteger maxExp;
@property (strong, nonatomic, readonly) NSString *levelImage;

+(PBLevel_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Levels
///--------------------------------------
@interface PBLevels_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *levels;

+(PBLevels_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Rank
///--------------------------------------
@interface PBRank : PBBase_Response

@property (strong, nonatomic, readonly) NSString *pbPlayerId;
@property (strong, nonatomic, readonly) NSString *playerId;
@property (strong, nonatomic, readonly) NSString *pointType;
@property (nonatomic, readonly) NSUInteger pointValue;

+(PBRank*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Rank (only particular point type)
///--------------------------------------
@interface PBRank_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *ranks;

+(PBRank_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Rank (for all point types)
///--------------------------------------
@interface PBRanks_Response : PBBase_Response

/**
 Use this key to access ranks according to each point type.
 */
@property (strong, nonatomic, readonly) NSArray *rankByKeys;

/**
 Array contains ranks by each point type.
 Use rankByKeys to access array according to each point type.
 */
@property (strong, nonatomic) NSDictionary *ranks;

+(PBRanks_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Deduct Reward
///--------------------------------------
@interface PBDeductReward_Response : PBBase_Response

@property (nonatomic, readonly) NSInteger newValue;
@property (nonatomic, readonly) NSInteger oldValue;
@property (nonatomic, readonly) NSInteger valueDeducted;

+(PBDeductReward_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Unique Code
///--------------------------------------
@interface PBUniqueCode_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSString *uniqueCode;
@property (strong, nonatomic, readonly) NSString *referralURL;

+(PBUniqueCode_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Custom
///--------------------------------------
@interface PBCustom : PBBase_Response

@property (strong, nonatomic, readonly) NSString *customId;
@property (strong, nonatomic, readonly) NSString *customName;
@property (nonatomic, readonly) NSUInteger customValue;

+(PBCustom*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Custom - Array
///--------------------------------------
@interface PBCustoms : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *customs;

+(PBCustoms*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RedeemBadge
///--------------------------------------
@interface PBRedeemBadge : PBBase_Response

@property (strong, nonatomic, readonly) NSString *badgeId;
@property (nonatomic, readonly) NSUInteger badgeValue;

+(PBRedeemBadge*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RedeemBadges
///--------------------------------------
@interface PBRedeemBadges : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *list;

+(PBRedeemBadges*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Redeem
///--------------------------------------
@interface PBRedeem : PBBase_Response

@property (nonatomic, readonly) NSUInteger pointValue;
@property (strong, nonatomic, readonly) PBCustoms *customs;
@property (strong, nonatomic, readonly) PBRedeemBadges *redeemBadges;

+(PBRedeem*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Goods
///--------------------------------------
@interface PBGoods : PBBase_Response

@property (strong, nonatomic, readonly) NSString *goodsId;
@property (nonatomic, readonly) NSUInteger quantity;
@property (strong, nonatomic, readonly) NSString *image;
@property (nonatomic, readonly) NSUInteger sortOrder;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *description_;
@property (strong, nonatomic, readonly) PBRedeem *redeem;
@property (strong, nonatomic, readonly) NSString *code;
@property (nonatomic, readonly) BOOL sponsor;
@property (strong, nonatomic, readonly) NSDate *dateStart;
@property (strong, nonatomic, readonly) NSDate *dateExpire;

+(PBGoods*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Goods Info
///--------------------------------------
@interface PBGoodsInfo_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBGoods *goods;
@property (nonatomic, readonly) NSUInteger perUser;
@property (nonatomic, readonly) BOOL isGroup;

+(PBGoodsInfo_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Goods List Info
///--------------------------------------
@interface PBGoodsListInfo_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *goodsList;

+(PBGoodsListInfo_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Goods Group Available
///--------------------------------------
@interface PBGoodsGroupAvailable_Response : PBBase_Response

@property (nonatomic, readonly) NSUInteger available;

+(PBGoodsGroupAvailable_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Player Goods Owned - No Response
///--------------------------------------
@interface PBPlayerGoodsOwned : PBBase_Response

@property (strong, nonatomic, readonly) NSString *goodsId;
@property (strong, nonatomic, readonly) NSString *image;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *code;
@property (strong, nonatomic, readonly) NSString *description_;
@property (nonatomic, readonly) NSUInteger amount;

+(PBPlayerGoodsOwned*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Player Goods Owned
///--------------------------------------
@interface PBPlayerGoodsOwned_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSArray<PBPlayerGoodsOwned*> *goodsOwneds;

+(PBPlayerGoodsOwned_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Player Custom Fields
///--------------------------------------
@interface PBPlayerCustomFields_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSDictionary *customFields;

+(PBPlayerCustomFields_Response*)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Reward
///--------------------------------------
@interface PBReward : PBBase_Response

@property (strong, nonatomic, readonly) NSString *rewardValue;
@property (strong, nonatomic, readonly) NSString *rewardType;
@property (strong, nonatomic, readonly) NSString *rewardId;
@property (strong, nonatomic, readonly) NSString *rewardName;

+(PBReward *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestReward
///--------------------------------------
@interface PBQuestReward : PBBase_Response

@property (strong, nonatomic, readonly) NSString *questId;
@property (strong, nonatomic, readonly) NSString *missionId;
@property (strong, nonatomic, readonly) NSString *rewardValue;
@property (strong, nonatomic, readonly) NSString *rewardType;
@property (strong, nonatomic, readonly) NSString *rewardId;
@property (strong, nonatomic, readonly) NSString *rewardName;
@property (strong, nonatomic, readonly) NSDate *dateAdded;
@property (strong, nonatomic, readonly) NSDate *dateModified;
@property (strong, nonatomic, readonly) NSString *questName;
@property (strong, nonatomic, readonly) NSString *type;

+(PBQuestReward *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestRewardArray
///--------------------------------------
@interface PBQuestRewardArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *questRewards;

+(PBQuestRewardArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestRewardHistoryOfPlayer
///--------------------------------------
@interface PBQuestRewardHistoryOfPlayer_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBQuestRewardArray *list;

+(PBQuestRewardHistoryOfPlayer_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RewardArray
///--------------------------------------
@interface PBRewardArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *rewards;

+(PBRewardArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Incomplete
///--------------------------------------
@interface PBIncomplete : PBBase_Response

@property (strong, nonatomic, readonly) NSString *incompletionId;
@property (strong, nonatomic, readonly) NSString *incompletionType;
@property (nonatomic, readonly) NSUInteger incompletionValue;
@property (strong, nonatomic, readonly) NSString *incompletionElementId;
@property (strong, nonatomic, readonly) NSString *incompletionFilter;

+(PBIncomplete *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// IncompleteArray
///--------------------------------------
@interface PBIncompleteArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *incompletions;

+(PBIncompleteArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// CompletionData
///--------------------------------------
@interface PBCompletionData : PBBase_Response

@property (strong, nonatomic, readonly) NSString *actionId;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *description_;
@property (strong, nonatomic, readonly) NSString *icon;
@property (strong, nonatomic, readonly) NSString *color;

+(PBCompletionData *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Completion
///--------------------------------------
@interface PBCompletion : PBBase_Response

@property (strong, nonatomic, readonly) NSString *completionFilter;
@property (strong, nonatomic, readonly) NSString *completionValue;
@property (strong, nonatomic, readonly) NSString *completionId;
@property (strong, nonatomic, readonly) NSString *completionType;
@property (strong, nonatomic, readonly) NSString *completionElementId;
@property (strong, nonatomic, readonly) NSString *completionTitle;
@property (strong, nonatomic, readonly) PBCompletionData *completionData;

+(PBCompletion *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// CompletionArray
///--------------------------------------
@interface PBCompletionArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *completions;

+(PBCompletionArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Pending
///--------------------------------------
@interface PBPending : PBBase_Response

@property (strong, nonatomic, readonly) NSString *eventType;
@property (strong, nonatomic, readonly) NSString *message;
@property (strong, nonatomic, readonly) PBIncomplete *incomplete;

+(PBPending *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PendingArray
///--------------------------------------
@interface PBPendingArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *pendings;

+(PBPendingArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// MissionBasic
///--------------------------------------
@interface PBMissionBasic : PBBase_Response

@property (strong, nonatomic, readonly) NSString *missionName;
@property (strong, nonatomic, readonly) NSString *missionNumber;
@property (strong, nonatomic, readonly) NSString *description_;
@property (strong, nonatomic, readonly) NSString *hint;
@property (strong, nonatomic, readonly) NSString *image;
@property (strong, nonatomic, readonly) PBCompletionArray *completions;
@property (strong, nonatomic, readonly) PBRewardArray *rewards;
@property (strong, nonatomic, readonly) NSString *missionId;

+(PBMissionBasic *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// MissionBasicArray
///--------------------------------------
@interface PBMissionBasicArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *missionBasics;

+(PBMissionBasicArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Mission
///--------------------------------------
@interface PBMission : PBBase_Response

@property (strong, nonatomic, readonly) PBMissionBasic *missionBasic;
@property (strong, nonatomic, readonly) NSDate *dateModified;
@property (strong, nonatomic, readonly) NSString *status;
@property (strong, nonatomic, readonly) PBPendingArray *pendings;

+(PBMission *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// MissionArray
///--------------------------------------
@interface PBMissionArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *missions;

+(PBMissionArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ConditionData
///--------------------------------------
@interface PBConditionData : PBBase_Response

@property (strong, nonatomic, readonly) NSString *questName;
@property (strong, nonatomic, readonly) NSString *description_;
@property (strong, nonatomic, readonly) NSString *hint;
@property (strong, nonatomic, readonly) NSString *image;

+(PBConditionData *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Condition
///--------------------------------------
@interface PBCondition : PBBase_Response

@property (strong, nonatomic, readonly) NSString *conditionId;
@property (strong, nonatomic, readonly) NSString *conditionType;
@property (strong, nonatomic, readonly) NSString *conditionValue;
@property (strong, nonatomic, readonly) PBConditionData *conditionData;

+(PBCondition *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ConditionArray
///--------------------------------------
@interface PBConditionArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *conditions;

+(PBConditionArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestBasic
///--------------------------------------
@interface PBQuestBasic : PBBase_Response

@property (strong, nonatomic, readonly) NSString *questName;
@property (strong, nonatomic, readonly) NSString *description_;
@property (strong, nonatomic, readonly) NSString *hint;
@property (strong, nonatomic, readonly) NSString *image;
@property (nonatomic, readonly) BOOL missionOrder;
@property (nonatomic, readonly) BOOL status;
@property (nonatomic, readonly) NSUInteger sortOrder;
@property (strong, nonatomic, readonly) PBRewardArray *rewards;
@property (strong, nonatomic, readonly) PBMissionBasicArray *missionBasics;
@property (strong, nonatomic, readonly) NSDate *dateAdded;
@property (strong, nonatomic, readonly) NSString *clientId;
@property (strong, nonatomic, readonly) NSString *siteId;
@property (strong, nonatomic, readonly) NSDate *dateModified;
@property (strong, nonatomic, readonly) NSString *questId;

+(PBQuestBasic *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Quest Info - Response
///--------------------------------------
@interface PBQuestInfo_Response : PBQuestBasic

@property (strong, nonatomic, readonly) PBQuestBasic *questBasic;
@property (strong, nonatomic, readonly) PBConditionArray *conditions;

+(PBQuestInfo_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Quest
///--------------------------------------
@interface PBQuest : PBBase_Response

@property (strong, nonatomic, readonly) NSString *questName;
@property (strong, nonatomic, readonly) NSString *description_;
@property (strong, nonatomic, readonly) NSString *hint;
@property (strong, nonatomic, readonly) NSString *image;
@property (nonatomic, readonly) BOOL missionOrder;
@property (strong, nonatomic, readonly) NSString *status;
@property (nonatomic, readonly) NSUInteger sortOrder;
@property (strong, nonatomic, readonly) PBRewardArray *rewards;
@property (strong, nonatomic, readonly) PBMissionArray *missions;
@property (strong, nonatomic, readonly) NSDate *dateAdded;
@property (strong, nonatomic, readonly) NSString *clientId;
@property (strong, nonatomic, readonly) NSString *siteId;
@property (strong, nonatomic, readonly) NSDate *dateModified;
@property (strong, nonatomic, readonly) NSString *questId;

+(PBQuest *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestBasicArray
///--------------------------------------
@interface PBQuestBasicArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *questBasics;

+(PBQuestBasicArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestArray
///--------------------------------------
@interface PBQuestArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *quests;

+(PBQuestArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestOfPlayer - Response
///--------------------------------------
@interface PBQuestOfPlayer_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBQuest *quest;

+(PBQuestOfPlayer_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestListOfPlayer - Response
///--------------------------------------
@interface PBQuestListOfPlayer_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBQuestArray *questList;

+(PBQuestListOfPlayer_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestListOfPlayer - Response
///--------------------------------------
@interface PBQuestList_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBQuestBasicArray *list;

+(PBQuestList_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Config
///--------------------------------------
@interface PBConfig : PBBase_Response

@property (strong, nonatomic, readonly) NSString *url;

+(PBConfig *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ConfigArray
///--------------------------------------
@interface PBConfigArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *configs;

+(PBConfigArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ActionConfig
///--------------------------------------
@interface PBActionConfig : PBBase_Response

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) PBConfigArray *configs;

+(PBActionConfig *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RuleEventGoodsRewardData
///--------------------------------------
@interface PBRuleEventGoodsRewardData : PBBase_Response

@property (strong, nonatomic, readonly) NSString *goodsId;
@property (strong, nonatomic, readonly) NSString *image;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *description_;
@property (strong, nonatomic, readonly) NSString *perUser;
@property (strong, nonatomic, readonly) NSString *quantity;

+(PBRuleEventGoodsRewardData *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RuleEventBadgeRewardData
///--------------------------------------
@interface PBRuleEventBadgeRewardData : PBBase_Response

@property (strong, nonatomic, readonly) NSString *badgeId;
@property (strong, nonatomic, readonly) NSString *image;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *description_;
@property (strong, nonatomic, readonly) NSString *hint;
@property (nonatomic, readonly) BOOL claim;
@property (nonatomic, readonly) BOOL redeem;

+(PBRuleEventBadgeRewardData *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RuleEvent
///--------------------------------------
@interface PBRuleEvent : PBBase_Response

@property (strong, nonatomic, readonly) NSString *eventType;
@property (strong, nonatomic, readonly) NSString *rewardType;
@property (strong, nonatomic, readonly) NSString *value;
// arbitrary data, it can be anything thus we use id as a data type here
// certain reward type doesn't have any reward-data, but some has
@property (strong, nonatomic, readonly) id rewardData;
@property (nonatomic, readonly) NSNumber* index;

+(PBRuleEvent *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RuleEvents
///--------------------------------------
@interface PBRuleEvents : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *list;

+(PBRuleEvents *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RuleEventsMission
///--------------------------------------
@interface PBRuleEventsMission : PBBase_Response

@property (strong, nonatomic, readonly) PBRuleEvents *events;

@property (strong, nonatomic, readonly) NSString *missionId;
@property (strong, nonatomic, readonly) NSString *missionNumber;
@property (strong, nonatomic, readonly) NSString *missionName;
@property (strong, nonatomic, readonly) NSString *description_;
@property (strong, nonatomic, readonly) NSString *hint;
@property (strong, nonatomic, readonly) NSString *image;
@property (strong, nonatomic, readonly) NSString *questId;

+(PBRuleEventsMission *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RuleEventsMissions
///--------------------------------------
@interface PBRuleEventsMissions : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *list;

+(PBRuleEventsMissions *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RuleEventQuest
///--------------------------------------
@interface PBRuleEventsQuest : PBBase_Response

@property (strong, nonatomic, readonly) PBRuleEvents *events;

@property (strong, nonatomic, readonly) NSString *questId;
@property (strong, nonatomic, readonly) NSString *questName;
@property (strong, nonatomic, readonly) NSString *description_;
@property (strong, nonatomic, readonly) NSString *hint;
@property (strong, nonatomic, readonly, readonly) NSString *image;

+(PBRuleEventsQuest *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RuleEventQuests
///--------------------------------------
@interface PBRuleEventsQuests : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *list;

+(PBRuleEventsQuests *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Rule Engine Reward
///--------------------------------------
@interface PBReward_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSString* rewardName;
@property (strong, nonatomic, readonly) NSString* itemID;
@property (strong, nonatomic, readonly) NSString* rewardID;
@property (strong, nonatomic, readonly) PBBadge_Response* badgeData;
@property (strong, nonatomic, readonly) PBGoods* goodsData;
@property (nonatomic, readonly) NSInteger quantity;

+(PBReward_Response *) parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Rule Engine Rewards (Group)
///--------------------------------------
@interface PBRuleRewards_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSMutableArray* list;

+(PBRuleRewards_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Rule Detail - Response
/// Query rule's details from rule ID
///--------------------------------------
@interface PBRuleDetail_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBRuleRewards_Response *ruleReward;

+(PBRuleDetail_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Rule - Response
///--------------------------------------
@interface PBRule_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBRuleEvents *events;
@property (strong, nonatomic, readonly) PBRuleEventsMissions *missions;
@property (strong, nonatomic, readonly) PBRuleEventsQuests *quests;

+(PBRule_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ActionConfigArray
///--------------------------------------
@interface PBActionConfigArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *actionConfigs;

+(PBActionConfigArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ActionConfig - Response
///--------------------------------------
@interface PBActionConfig_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBActionConfigArray *list;

+(PBActionConfig_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Recent Point
///--------------------------------------
@interface PBRecentPoint : PBBase_Response

@property (strong, nonatomic, readonly) NSString *message;
@property (strong, nonatomic, readonly) NSString *rewardId;
@property (strong, nonatomic, readonly) NSString *rewardName;
@property (nonatomic, readonly) NSUInteger value;
@property (strong, nonatomic, readonly) NSDate *dateAdded;
@property (strong, nonatomic, readonly) PBPlayerBasic *playerBasic;
@property (strong, nonatomic, readonly) NSString *actionName;
@property (strong, nonatomic, readonly) NSString *stringFilter;
@property (strong, nonatomic, readonly) NSString *actionIcon;

+(PBRecentPoint *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Recent Point Array - Response
///--------------------------------------
@interface PBRecentPointArray_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *list;

+(PBRecentPointArray_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// MissionInfo - Response
///--------------------------------------
@interface PBMissionInfo_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBMissionBasic *missionBasic;
@property (strong, nonatomic, readonly) NSString *questId;

+(PBMissionInfo_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestListAvailableForPlayer - Response
///--------------------------------------
@interface PBQuestListAvailableForPlayer_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBQuestBasicArray *list;

+(PBQuestListAvailableForPlayer_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestAvailableForPlayer - Response
///--------------------------------------
@interface PBQuestAvailableForPlayer_Response : PBBase_Response

@property (strong, nonatomic, readonly) NSString *eventType;
@property (strong, nonatomic, readonly) NSString *eventMessage;
@property (nonatomic, readonly) BOOL eventStatus;

+(PBQuestAvailableForPlayer_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Join Quest
///--------------------------------------
@interface PBJoinQuest : PBBase_Response

@property (strong, nonatomic, readonly) NSString *eventType;
@property (strong, nonatomic, readonly) NSString *questId;

+(PBJoinQuest *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Join Quest - Response
///--------------------------------------
@interface PBJoinQuest_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBJoinQuest *response;

+(PBJoinQuest_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Join All Quests
///--------------------------------------
@interface PBJoinAllQuests : PBBase_Response

@property (strong, nonatomic, readonly) NSString *joinAll;

+(PBJoinAllQuests *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Join All Quests - Response
///--------------------------------------
@interface PBJoinAllQuests_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBJoinAllQuests *response;

+(PBJoinAllQuests_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Cancel Quest
///--------------------------------------
@interface PBCancelQuest : PBBase_Response

@property (strong, nonatomic, readonly) NSString *eventType;
@property (strong, nonatomic, readonly) NSString *questId;

+(PBCancelQuest *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Cancel Quest - Response
///--------------------------------------
@interface PBCancelQuest_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBCancelQuest *response;

+(PBCancelQuest_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// GradeRewardCustom
///--------------------------------------
@interface PBGradeRewardCustom : PBBase_Response

@property (strong, nonatomic, readonly) NSString *customId;
@property (strong, nonatomic, readonly) NSString *customValue;

+(PBGradeRewardCustom *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// GradeRewardCustomArray
///--------------------------------------
@interface PBGradeRewardCustomArray : PBBase_Response

@property (strong, nonatomic) NSArray *gradeRewardCustoms;

+(PBGradeRewardCustomArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// GradeRewards
///--------------------------------------
@interface PBGradeRewards : PBBase_Response

@property (strong, nonatomic, readonly) NSString *expValue;
@property (strong, nonatomic, readonly) NSString *pointValue;
@property (strong, nonatomic, readonly) PBGradeRewardCustomArray *customList;

+(PBGradeRewards *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Grade
///--------------------------------------
@interface PBGrade : PBBase_Response

@property (strong, nonatomic, readonly) NSString *gradeId;
@property (strong, nonatomic, readonly) NSString *start;
@property (strong, nonatomic, readonly) NSString *end;
@property (strong, nonatomic, readonly) NSString *grade;
@property (strong, nonatomic, readonly) NSString *rank;
@property (strong, nonatomic, readonly) NSString *rankImage;
@property (strong, nonatomic, readonly) PBGradeRewards *rewards;

+(PBGrade *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// GradeDoneReward
///--------------------------------------
@interface PBGradeDoneReward : PBBase_Response

@property (strong, nonatomic, readonly) NSString *eventType;
@property (strong, nonatomic, readonly) NSString *rewardType;
@property (strong, nonatomic, readonly) NSString *rewardId;
@property (strong, nonatomic, readonly) NSString *value;

+(PBGradeDoneReward *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// GradeDoneRewardArray
///--------------------------------------
@interface PBGradeDoneRewardArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *gradeDoneRewards;

+(PBGradeDoneRewardArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// GradeDone
///--------------------------------------
@interface PBGradeDone : PBBase_Response

@property (strong, nonatomic, readonly) NSString *gradeId;
@property (strong, nonatomic, readonly) NSString *start;
@property (strong, nonatomic, readonly) NSString *end;
@property (strong, nonatomic, readonly) NSString *grade;
@property (strong, nonatomic, readonly) NSString *rank;
@property (strong, nonatomic, readonly) NSString *rankImage;
@property (strong, nonatomic, readonly) PBGradeDoneRewardArray *rewards;
@property (nonatomic, readonly) NSUInteger score;
@property (strong, nonatomic, readonly) NSString *maxScore;
@property (nonatomic, readonly) NSUInteger totalScore;
@property (nonatomic, readonly) NSUInteger totalMaxScore;

+(PBGradeDone *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuizDone
///--------------------------------------
@interface PBQuizDone : PBBase_Response

@property (nonatomic, readonly) NSUInteger value;
@property (strong, nonatomic, readonly) PBGradeDone *grade;
@property (nonatomic, readonly) NSUInteger totalCompletedQuestion;
@property (strong, nonatomic, readonly) NSString *quizId;

+(PBQuizDone *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuizDoneArray
///--------------------------------------
@interface PBQuizDoneArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *quizDones;

+(PBQuizDoneArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuizDoneList - Response
///--------------------------------------
@interface PBQuizDoneList_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBQuizDoneArray *list;

+(PBQuizDoneList_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RedeemGoods
///--------------------------------------
@interface PBRedeemGoodsEvent : PBBase_Response

@property (strong, nonatomic, readonly) NSString *eventType;
@property (strong, nonatomic, readonly) PBGoods *goodsData;
@property (nonatomic, readonly) NSUInteger value;

+(PBRedeemGoodsEvent *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RedeemGoodsEvents
///--------------------------------------
@interface PBRedeemGoodsEvents : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *list;

+(PBRedeemGoodsEvents *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// RedeemGoods - Response
///--------------------------------------
@interface PBRedeemGoods_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBRedeemGoodsEvents *events;
@property (strong, nonatomic, readonly) NSString *logId;

+(PBRedeemGoods_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// GradeArray
///--------------------------------------
@interface PBGradeArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *grades;

+(PBGradeArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuizBasic
///--------------------------------------
@interface PBQuizBasic : PBBase_Response

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *image;
@property (nonatomic, readonly) int weight;
@property (strong, nonatomic, readonly) NSString *description_;
@property (strong, nonatomic, readonly) NSString *descriptionImage;
@property (strong, nonatomic, readonly) NSString *quizId;

+(PBQuizBasic *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Quiz
///--------------------------------------
@interface PBQuiz : PBBase_Response

@property (strong, nonatomic, readonly) PBQuizBasic *basic;
@property (strong, nonatomic, readonly) NSDate *dateStart;
@property (strong, nonatomic, readonly) NSDate *dateExpire;
@property (nonatomic, readonly) BOOL status;
@property (strong, nonatomic, readonly) PBGradeArray *grades;
@property (nonatomic, readonly) BOOL deleted;
@property (nonatomic, readonly) NSUInteger totalMaxScore;
@property (nonatomic, readonly) NSUInteger totalQuestions;

+(PBQuiz *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuizBasicArray
///--------------------------------------
@interface PBQuizBasicArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *quizBasics;

+(PBQuizBasicArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ActiveQuizList - Response
///--------------------------------------
@interface PBActiveQuizList_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBQuizBasicArray *list;

+(PBActiveQuizList_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuizDetail - Response
///--------------------------------------
@interface PBQuizDetail_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBQuiz *quiz;

+(PBQuizDetail_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuizRandom - Response
///--------------------------------------
@interface PBQuizRandom_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBQuizBasic *randomQuiz;

+(PBQuizRandom_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestionOption
///--------------------------------------
@interface PBQuestionOption : PBBase_Response

@property (strong, nonatomic, readonly) NSString *option;
@property (strong, nonatomic, readonly) NSString *optionImage;
@property (strong, nonatomic, readonly) NSString *optionId;

+(PBQuestionOption *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestionOptionArray
///--------------------------------------
@interface PBQuestionOptionArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *options;

+(PBQuestionOptionArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Question
///--------------------------------------
@interface PBQuestion : PBBase_Response

@property (strong, nonatomic, readonly) NSString *question;
@property (strong, nonatomic, readonly) NSString *questionImage;
@property (strong, nonatomic, readonly) PBQuestionOptionArray *options;
@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) NSUInteger total;
@property (strong, nonatomic, readonly) NSString *questionId;

+(PBQuestion *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// Question - Response
///--------------------------------------
@interface PBQuestion_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBQuestion *question;

+(PBQuestion_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestionAnsweredOption
///--------------------------------------
@interface PBQuestionAnsweredOption : PBBase_Response

@property (strong, nonatomic, readonly) NSString *option;
@property (strong, nonatomic, readonly) NSString *score;
@property (strong, nonatomic, readonly) NSString *explanation;
@property (strong, nonatomic, readonly) NSString *optionImage;
@property (strong, nonatomic, readonly) NSString *optionId;

+(PBQuestionAnsweredOption *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestionAnsweredOptionArray
///--------------------------------------
@interface PBQuestionAnsweredOptionArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *answeredOptions;

+(PBQuestionAnsweredOptionArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestionAnsweredGradeDone
///--------------------------------------
@interface PBQuestionAnsweredGradeDone : PBBase_Response

@property (strong, nonatomic, readonly) NSString *gradeId;
@property (strong, nonatomic, readonly) NSString *start;
@property (strong, nonatomic, readonly) NSString *end;
@property (strong, nonatomic, readonly) NSString *grade;
@property (strong, nonatomic, readonly) NSString *rank;
@property (strong, nonatomic, readonly) NSString *rankImage;
@property (nonatomic, readonly) NSUInteger score;
@property (strong, nonatomic, readonly) NSString *maxScore;
@property (nonatomic, readonly) NSUInteger totalScore;
@property (nonatomic, readonly) NSUInteger totalMaxScore;

+(PBQuestionAnsweredGradeDone *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestionAnswered
///--------------------------------------
@interface PBQuestionAnswered : PBBase_Response

@property (strong, nonatomic, readonly) PBQuestionAnsweredOptionArray *options;
@property (nonatomic, readonly) NSUInteger score;
@property (strong, nonatomic, readonly) NSString *maxScore;
@property (strong, nonatomic, readonly) NSString *explanation;
@property (nonatomic, readonly) NSUInteger totalScore;
@property (nonatomic, readonly) NSUInteger totalMaxScore;
@property (strong, nonatomic, readonly) PBQuestionAnsweredGradeDone *grade;
@property (strong, nonatomic, readonly) PBGradeDoneRewardArray *rewards;

+(PBQuestionAnswered *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// QuestionAnswered - Response
///--------------------------------------
@interface PBQuestionAnswered_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBQuestionAnswered *result;

+(PBQuestionAnswered_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerQuizRank
///--------------------------------------
@interface PBPlayerQuizRank : PBBase_Response

@property (strong, nonatomic, readonly) NSString *pbPlayerId;
@property (strong, nonatomic, readonly) NSString *playerId;
@property (nonatomic, readonly) NSUInteger score;

+(PBPlayerQuizRank *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayerQuizRankArray
///--------------------------------------
@interface PBPlayerQuizRankArray : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *list;

+(PBPlayerQuizRankArray *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PlayersQuizRank - Response
///--------------------------------------
@interface PBPlayersQuizRank_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBPlayerQuizRankArray *playersQuizRank;

+(PBPlayersQuizRank_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PBSendSMS
///--------------------------------------
@interface PBSendSMS : PBBase_Response

@property (strong, nonatomic, readonly) NSString *to;
@property (strong, nonatomic, readonly) NSString *from;
@property (strong, nonatomic, readonly) NSString *message;

+(PBSendSMS *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PBSendSMS - Response
///--------------------------------------
@interface PBSendSMS_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBSendSMS *response;

+(PBSendSMS_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PBQuizPendingGradeReward
///--------------------------------------
@interface PBQuizPendingGradeReward : PBBase_Response

@property (strong, nonatomic, readonly) NSString *eventType;
@property (strong, nonatomic, readonly) NSString *rewardType;
@property (strong, nonatomic, readonly) NSString *rewardId;
@property (strong, nonatomic, readonly) NSString *value;

// arbitrary data, it can be anything thus we use id as a data type here
// certain reward type doesn't have any reward-data, but some has
@property (strong, nonatomic, readonly) id rewardData;

+(PBQuizPendingGradeReward *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PBQuizPendingGradeRewards
///--------------------------------------
@interface PBQuizPendingGradeRewards : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *list;

+(PBQuizPendingGradeRewards *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PBQuizPendingGrade
///--------------------------------------
@interface PBQuizPendingGrade : PBBase_Response

@property (nonatomic, readonly) NSUInteger score;
@property (strong, nonatomic, readonly) PBQuizPendingGradeRewards *rewards;
@property (strong, nonatomic, readonly) NSString *maxScore;
@property (nonatomic, readonly) NSUInteger totalScore;
@property (nonatomic, readonly) NSUInteger totalMaxScore;

+(PBQuizPendingGrade *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PBQuizPending
///--------------------------------------
@interface PBQuizPending : PBBase_Response

@property (nonatomic, readonly) NSUInteger value;
@property (strong, nonatomic, readonly) PBQuizPendingGrade *grade;
@property (nonatomic, readonly) NSUInteger totalCompletedQuestions;
@property (nonatomic, readonly) NSUInteger totalPendingQuestions;
@property (strong, nonatomic, readonly) NSString *quizId;

+(PBQuizPending *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PBQuizPendings
///--------------------------------------
@interface PBQuizPendings : PBBase_Response

@property (strong, nonatomic, readonly) NSArray *list;

+(PBQuizPendings *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PBQuizPendings - Response
///--------------------------------------
@interface PBQuizPendings_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBQuizPendings *quizPendings;

+(PBQuizPendings_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PBResetPoint
///--------------------------------------
@interface PBResetPoint : PBBase_Response

@property (nonatomic, readonly) BOOL reset;

+(PBResetPoint *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// PBResetPoint - Response
///--------------------------------------
@interface PBResetPoint_Response : PBBase_Response

@property (strong, nonatomic, readonly) PBResetPoint *response;

+(PBResetPoint_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

///--------------------------------------
/// ManualSetResultStatus - Response
/// Note: This response is usually used by async url request
/// as its response is not in json type, but just pure text.
/// Thus it's manual to set the result upon reading those text.
///--------------------------------------
@interface PBManualSetResultStatus_Response : PBBase_Response

@property (nonatomic, readonly) BOOL success;

// either use one or another of the following static method to create
// the proper result content for the response class
+(PBManualSetResultStatus_Response *)resultStatusWithSuccess;
+(PBManualSetResultStatus_Response *)resultStatusWithFailure;

@end

///--------------------------------------
/// ResultStatus - Response
/// Note: Differnt from ManualSetResultStatus as this will be
/// automatically parsed by internal system and set its result status.
///--------------------------------------
@interface PBResultStatus_Response : PBBase_Response

@property (nonatomic, readonly) BOOL success;

+(PBResultStatus_Response *)parseFromDictionary:(const NSDictionary*) jsonResponse startFromFinalLevel:(BOOL)startFromFinalLevel;

@end

#endif
