#import "PlaybasisResponsesWrapper.h"
#import "PBResponses.h"

@interface Populator : NSObject

+ (void) populatePlayerBasic:(playerBasic*)outData from:(PBPlayerBasic*)pbData;
+ (void) populatePlayerPublic:(playerPublic*)outData from:(PBPlayerPublic_Response*)pbData;
+ (void) populatePlayer:(player*)outData from:(PBPlayer_Response*)pbData;
+ (void) populatePointArray:(_array<point>*)outData from:(NSArray*)pbArray;
+ (void) populateQuizArray:(_array<quizBasic>*)outData from:(NSArray*)pbArray;
+ (void) populateQuizBasic:(quizBasic*)outData from:(PBQuizBasic*)pbData;
+ (void) populateQuiz:(quiz*)outData from:(PBQuiz*)pbData;
+ (void) populateGrade:(grade*)outData from:(PBGrade*)pbData;
+ (void) populateGradeArray:(_array<grade>*)outData from:(NSArray*)pbArray;
+ (void) populateGradeRewards:(gradeRewards*)outData from:(PBGradeRewards*)pbData;
+ (void) populateGradeRewardCustom:(gradeRewardCustom*)outData from:(PBGradeRewardCustom*)pbData;
+ (void) populateGradeRewardCustomArray:(_array<gradeRewardCustom>*)outData from:(NSArray*)pbArray;
+ (void) populateQuizDone:(quizDone*)outData from:(PBQuizDone*)pbData;
+ (void) populateQuizDoneArray:(_array<quizDone>*)outData from:(NSArray*)pbArray;
+ (void) populateGradeDone:(gradeDone*)outData from:(PBGradeDone*)pbData;
+ (void) populateGradeDoneReward:(gradeDoneReward*)outData from:(PBGradeDoneReward*)pbData;
+ (void) populateGradeDoneRewardArray:(_array<gradeDoneReward>*)outData from:(NSArray*)pbArray;
+ (void) populateQuizPending:(quizPending*)outData from:(PBQuizPending*)pbData;
+ (void) populateQuizPendingArray:(_array<quizPending>*)outData from:(NSArray*)pbArray;
+ (void) populateQuizPendingGrade:(quizPendingGrade*)outData from:(PBQuizPendingGrade*)pbData;
+ (void) populateQuizPendingGradeReward:(quizPendingGradeReward*)outData from:(PBQuizPendingGradeReward*)pbData;
+ (void) populateQuizPendingGradeRewardArray:(_array<quizPendingGradeReward>*)outData from:(NSArray*)pbArray;
+ (void) populateQuestion:(question*)outData from:(PBQuestion*)pbData;
+ (void) populateQuestionOption:(questionOption*)outData from:(PBQuestionOption*)pbData;
+ (void) populateQuestionOptionArray:(_array<questionOption>*)outData from:(NSArray*)pbArray;
+ (void) populateQuestionAnswered:(questionAnswered*)outData from:(PBQuestionAnswered*)pbData;
+ (void) populateQuestionAnsweredOption:(questionAnsweredOption*)outData from:(PBQuestionAnsweredOption*)pbData;
+ (void) populateQuestionAnsweredOptionArray:(_array<questionAnsweredOption>*)outData from:(NSArray*)pbArray;
+ (void) populateQuestionAnsweredGradeDone:(questionAnsweredGradeDone*)outData from:(PBQuestionAnsweredGradeDone*)pbData;
+ (void) populateRuleEvent:(ruleEvent*)outData from:(PBRuleEvent*)pbData;
+ (void) populateRuleEventArray:(_array<ruleEvent>*)outData from:(NSArray*)pbArray;
+ (void) populateRuleEventMission:(ruleEventMission*)outData from:(PBRuleEventsMission*)pbData;
+ (void) populateRuleEventMissionArray:(_array<ruleEventMission>*)outData from:(NSArray*)pbArray;
+ (void) populateRuleEventQuest:(ruleEventQuest*)outData from:(PBRuleEventsQuest*)pbData;
+ (void) populateRuleEventQuestArray:(_array<ruleEventQuest>*)outData from:(NSArray*)pbArray;
+ (void) populateRuleEventBadgeRewardData:(ruleEventBadgeRewardData*)outData from:(PBRuleEventBadgeRewardData*)pbData;
+ (void) populateRuleEventGoodsRewardData:(ruleEventGoodsRewardData*)outData from:(PBRuleEventGoodsRewardData*)pbData;
+ (void) populateRule:(rule*)outData from:(PBRule_Response*)pbData;
+ (void) populateRedeem:(redeem*)outData from:(PBRedeem*)pbData;
+ (void) populateRedeemBadge:(redeemBadge*)outData from:(PBRedeemBadge*)pbData;
+ (void) populateRedeemBadgeArray:(_array<redeemBadge>*)outData from:(NSArray*)pbArray;
+ (void) populateGoods:(goods*)outData from:(PBGoods*)pbData;
+ (void) populateGoodsInfo:(goodsInfo*)outData from:(PBGoodsInfo_Response*)pbData;
+ (void) populateGoodsInfoArray:(_array<goodsInfo>*)outData from:(NSArray*)pbArray;
+ (void) populateCustom:(custom*)outData from:(PBCustom*)pbData;
+ (void) populateCustomArray:(_array<custom>*)outData from:(NSArray*)pbArray;
+ (void) populateBadge:(badge*)outData from:(PBBadge_Response*)pbData;
+ (void) populateBadgeArray:(_array<badge>*)outData from:(NSArray*)pbArray;
+ (void) populateReward:(reward*)outData from:(PBReward*)pbData;
+ (void) populateRewardArray:(_array<reward>*)outData from:(NSArray*)pbArray;
+ (void) populateMissionBasic:(missionBasic*)outData from:(PBMissionBasic*)pbData;
+ (void) populateMissionBasicArray:(_array<missionBasic>*)outData from:(NSArray*)pbArray;
+ (void) populateMission:(mission*)outData from:(PBMission*)pbData;
+ (void) populateMissionArray:(_array<mission>*)outData from:(NSArray*)pbArray;
+ (void) populateMissionInfo:(missionInfo*)outData from:(PBMissionInfo_Response*)pbData;
+ (void) populateCondition:(condition*)outData from:(PBCondition*)pbData;
+ (void) populateConditionArray:(_array<condition>*)outData from:(NSArray*)pbArray;
+ (void) populateConditionData:(conditionData*)outData from:(PBConditionData*)pbData;
+ (void) populateCompletion:(completion*)outData from:(PBCompletion*)pbData;
+ (void) populateCompletionArray:(_array<completion>*)outData from:(NSArray*)pbArray;
+ (void) populateCompletionData:(completionData*)outData from:(PBCompletionData*)pbData;
+ (void) populateFilteredParam:(filteredParam*)outData from:(PBFilteredParam*)pbData;
+ (void) populateUrl:(url*)outData from:(PBUrl*)pbData;
+ (void) populateQuestBasic:(questBasic*)outData from:(PBQuestBasic*)pbData;
+ (void) populateQuestBasicArray:(_array<questBasic>*)outData from:(NSArray*)pbArray;
+ (void) populateQuestInfo:(questInfo*)outData from:(PBQuestInfo_Response*)pbData;
+ (void) populateQuestAvailableForPlayer:(questAvailableForPlayer*)outData from:(PBQuestAvailableForPlayer_Response*)pbData;
@end