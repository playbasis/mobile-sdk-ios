#import "Populator.h"
#import "Util.h"

#define RETURNIFNULL(x) if (x == nil) return;
#define BEGIN_NOTNULL(x) if (x != nil) {
#define END_NOTNULL(x) }
/*#define CREATE_PTRARRAY(varName, type, count, indexName)\
    ##type* ##varName = new ##type[count];\
    int ##indexName = 0;*/
/*#define SETPTRARRAY(ptrArray, count, to)\
    to->data = ptrArray;\
    to->count = count;*/

@implementation Populator

+ (void) populatePlayerBasic:(playerBasic*)outData from:(PBPlayerBasic*)pbData
{
	RETURNIFNULL(pbData)

    COPYSTRING(pbData.image, outData->image)
    COPYSTRING(pbData.userName, outData->userName)
    
    outData->exp = pbData.exp;
    outData->level = pbData.level;

    COPYSTRING(pbData.firstName, outData->firstName)
    COPYSTRING(pbData.lastName, outData->lastName)
    
    outData->gender = pbData.gender;

    COPYSTRING(pbData.clPlayerId, outData->clPlayerId)
}

+ (void) populatePlayerPublic:(playerPublic*)outData from:(PBPlayerPublic_Response*)pbData
{
    RETURNIFNULL(pbData)

    // playerBasic
    [Populator populatePlayerBasic:&outData->basic from:pbData.playerBasic];
    outData->registered = [pbData.registered timeIntervalSince1970];
    outData->lastLogin = [pbData.lastLogin timeIntervalSince1970];
    outData->lastLogout = [pbData.lastLogout timeIntervalSince1970];
}

+ (void) populatePlayer:(player*)outData from:(PBPlayer_Response*)pbData
{
    RETURNIFNULL(pbData)

    // playerPublic
    [Populator populatePlayerPublic:&outData->playerPublic from:pbData.playerPublic];
    COPYSTRING(pbData.email, outData->email)
    COPYSTRING(pbData.phoneNumber, outData->phoneNumber)
}

+ (void) populatePointArray:(_array<point>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    //CREATE_PTRARRAY(items, point, [pbArray count], i)
    point *items = new point[[pbArray count]];
    int i=0;

    for (PBPoint *p in pbArray)
    {
        COPYSTRING(p.rewardId, items[i].rewardId)
        COPYSTRING(p.rewardName, items[i].rewardName)
        items[i].value = p.value;
        i++;
    }
    //SETPTRARRAY(items, [pbArray count], &outData)
    outData->data = items;
    outData->count = i;
}

+ (void) populateQuizArray:(_array<quizBasic>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    quizBasic *items = new quizBasic[[pbArray count]];
    int i=0;

    for (PBQuizBasic *qb in pbArray)
    {
        COPYSTRING(qb.name, items[i].name)
        COPYSTRING(qb.image, items[i].image)
        items[i].weight = qb.weight;
        COPYSTRING(qb.description_, items[i].description_)
        COPYSTRING(qb.descriptionImage, items[i].descriptionImage)
        COPYSTRING(qb.quizId, items[i].quizId)
        i++;
    }
    outData->data = items;
    outData->count = i;
}

+ (void) populateQuizBasic:(quizBasic*)outData from:(PBQuizBasic*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.name, outData->name)
    COPYSTRING(pbData.image, outData->image)
    outData->weight = pbData.weight;
    COPYSTRING(pbData.description_, outData->description_)
    COPYSTRING(pbData.descriptionImage, outData->descriptionImage)
    COPYSTRING(pbData.quizId, outData->quizId)
}

+ (void) populateQuiz:(quiz*)outData from:(PBQuiz*)pbData
{
    RETURNIFNULL(pbData)

    // quizBasic
    [Populator populateQuizBasic:&outData->basic from:pbData.basic];

    outData->dateStart = [pbData.dateStart timeIntervalSince1970];
    outData->dateExpire = [pbData.dateExpire timeIntervalSince1970];
    outData->status = pbData.status;

    // array of grade
    [Populator populateGradeArray:&outData->gradeArray from:pbData.grades.grades];

    outData->deleted = pbData.deleted;
    outData->totalMaxScore = pbData.totalMaxScore;
    outData->totalQuestions = pbData.totalQuestions;
}

+ (void) populateGrade:(grade*)outData from:(PBGrade*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.gradeId, outData->gradeId)
    COPYSTRING(pbData.start, outData->start)
    COPYSTRING(pbData.end, outData->end)
    COPYSTRING(pbData.grade, outData->grade)
    COPYSTRING(pbData.rank, outData->rank)
    COPYSTRING(pbData.rankImage, outData->rankImage)

    // gradeRewards
    [Populator populateGradeRewards:&outData->rewards from:pbData.rewards];
}

+ (void) populateGradeArray:(_array<grade>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    grade* items = new grade[[pbArray count]];
    int i=0;

    for (PBGrade *c in pbArray)
    {
        // grade
        [Populator populateGrade:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateGradeRewards:(gradeRewards*)outData from:(PBGradeRewards*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.expValue, outData->expValue)
    COPYSTRING(pbData.pointValue, outData->pointValue)

    // array of gradeRewardCustom
    [Populator populateGradeRewardCustomArray:&outData->gradeRewardCustomArray from:pbData.customList.gradeRewardCustoms];
}

+ (void) populateGradeRewardCustom:(gradeRewardCustom*)outData from:(PBGradeRewardCustom*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.customId, outData->customId)
    COPYSTRING(pbData.customValue, outData->customValue)
}

+ (void) populateGradeRewardCustomArray:(_array<gradeRewardCustom>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    gradeRewardCustom* items = new gradeRewardCustom[[pbArray count]];
    int i=0;

    for (PBGradeRewardCustom *c in pbArray)
    {
        // gradeRewardCustom
        [Populator populateGradeRewardCustom:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateQuizDone:(quizDone*)outData from:(PBQuizDone*)pbData
{
    RETURNIFNULL(pbData)

    outData->value = pbData.value;

    // gradeDone
    [Populator populateGradeDone:&outData->gradeDone from:pbData.grade];

    outData->totalCompletedQuestion = pbData.totalCompletedQuestion;
    COPYSTRING(pbData.quizId, outData->quizId)
}

+ (void) populateQuizDoneArray:(_array<quizDone>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    quizDone* items = new quizDone[[pbArray count]];
    int i=0;

    for (PBQuizDone *c in pbArray)
    {
        // quizDone
        [Populator populateQuizDone:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateGradeDone:(gradeDone*)outData from:(PBGradeDone*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.gradeId, outData->gradeId)
    COPYSTRING(pbData.start, outData->start)
    COPYSTRING(pbData.end, outData->end)
    COPYSTRING(pbData.grade, outData->grade)
    COPYSTRING(pbData.rank, outData->rank)
    COPYSTRING(pbData.rankImage, outData->rankImage)

    // gradeDoneReward
    [Populator populateGradeDoneRewardArray:&outData->rewardArray from:pbData.rewards.gradeDoneRewards];

    outData->score = pbData.score;
    COPYSTRING(pbData.maxScore, outData->maxScore)
    outData->totalScore = pbData.totalScore;
    outData->totalMaxScore = pbData.totalMaxScore;
}

+ (void) populateGradeDoneReward:(gradeDoneReward*)outData from:(PBGradeDoneReward*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.eventType, outData->eventType)
    COPYSTRING(pbData.rewardType, outData->rewardType)
    COPYSTRING(pbData.rewardId, outData->rewardId)
    COPYSTRING(pbData.value, outData->value)
}

+ (void) populateGradeDoneRewardArray:(_array<gradeDoneReward>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    gradeDoneReward* items = new gradeDoneReward[[pbArray count]];
    int i=0;

    for (PBGradeDoneReward *c in pbArray)
    {
        // gradeDoneReward
        [Populator populateGradeDoneReward:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateQuizPending:(quizPending*)outData from:(PBQuizPending*)pbData
{
    RETURNIFNULL(pbData)

    outData->value = pbData.value;

    // quizPendingGrade
    [Populator populateQuizPendingGrade:&outData->grade from:pbData.grade];

    outData->totalCompletedQuestions = pbData.totalCompletedQuestions;
    outData->totalPendingQuestions = pbData.totalPendingQuestions;
    COPYSTRING(pbData.quizId, outData->quizId);
}

+ (void) populateQuizPendingArray:(_array<quizPending>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    quizPending *items = new quizPending[[pbArray count]];
    int i=0;

    for (PBQuizPending *c in pbArray)
    {
        // quizPending
        [Populator populateQuizPending:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateQuizPendingGrade:(quizPendingGrade*)outData from:(PBQuizPendingGrade*)pbData
{
    RETURNIFNULL(pbData)

    outData->score = pbData.score;

    // quizPendingGradeRewards
    [Populator populateQuizPendingGradeRewardArray:&outData->quizPendingGradeRewardArray from:pbData.rewards.list];

    COPYSTRING(pbData.maxScore, outData->maxScore)
    outData->totalScore = pbData.totalScore;
    outData->totalMaxScore = pbData.totalMaxScore;
}

+ (void) populateQuizPendingGradeReward:(quizPendingGradeReward*)outData from:(PBQuizPendingGradeReward*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.eventType, outData->eventType)
    COPYSTRING(pbData.rewardType, outData->rewardType)
    COPYSTRING(pbData.rewardId, outData->rewardId)
    COPYSTRING(pbData.value, outData->value)
}

+ (void) populateQuizPendingGradeRewardArray:(_array<quizPendingGradeReward>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    quizPendingGradeReward *items = new quizPendingGradeReward[[pbArray count]];
    int i=0;

    for (PBQuizPendingGradeReward *c in pbArray)
    {
        // quizPendingGradeReward
        [Populator populateQuizPendingGradeReward:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateQuestion:(question*)outData from:(PBQuestion*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.question, outData->question)
    COPYSTRING(pbData.questionImage, outData->questionImage)

    // array of questionOption
    [Populator populateQuestionOptionArray:&outData->optionArray from:pbData.options.options];

    outData->index = pbData.index;
    outData->total = pbData.total;
    COPYSTRING(pbData.questionId, outData->questionId)
}

+ (void) populateQuestionOption:(questionOption*)outData from:(PBQuestionOption*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.option, outData->option)
    COPYSTRING(pbData.optionImage, outData->optionImage)
    COPYSTRING(pbData.optionId, outData->optionId)
}

+ (void) populateQuestionOptionArray:(_array<questionOption>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    questionOption* items = new questionOption[[pbArray count]];
    int i=0;

    for (PBQuestionOption *c in pbArray)
    {
        // questionOption
        [Populator populateQuestionOption:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateQuestionAnswered:(questionAnswered*)outData from:(PBQuestionAnswered*)pbData
{
    RETURNIFNULL(pbData)

    // array of questionAnsweredOption
    [Populator populateQuestionAnsweredOptionArray:&outData->optionArray from:pbData.options.answeredOptions];

    outData->score = pbData.score;
    COPYSTRING(pbData.maxScore, outData->maxScore)
    COPYSTRING(pbData.explanation, outData->explanation)
    outData->totalScore = pbData.totalScore;
    outData->totalMaxScore = pbData.totalMaxScore;

    // questionAnsweredGradeDone
    [Populator populateQuestionAnsweredGradeDone:&outData->gradeDone from:pbData.grade];

    // array of gradeDoneReward
    [Populator populateGradeDoneRewardArray:&outData->gradeDoneRewardArray from:pbData.rewards.gradeDoneRewards];
}

+ (void) populateQuestionAnsweredOption:(questionAnsweredOption*)outData from:(PBQuestionAnsweredOption*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.option, outData->option)
    COPYSTRING(pbData.score, outData->score)
    COPYSTRING(pbData.explanation, outData->explanation)
    COPYSTRING(pbData.optionImage, outData->optionImage)
    COPYSTRING(pbData.optionId, outData->optionId)
}

+ (void) populateQuestionAnsweredOptionArray:(_array<questionAnsweredOption>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    questionAnsweredOption *items = new questionAnsweredOption[[pbArray count]];
    int i=0;

    for (PBQuestionAnsweredOption* c in pbArray)
    {
        // populateQuestionAnsweredOption
        [Populator populateQuestionAnsweredOption:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateQuestionAnsweredGradeDone:(questionAnsweredGradeDone*)outData from:(PBQuestionAnsweredGradeDone*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.gradeId, outData->gradeId)
    COPYSTRING(pbData.start, outData->start)
    COPYSTRING(pbData.end, outData->end)
    COPYSTRING(pbData.grade, outData->grade)
    COPYSTRING(pbData.rank, outData->rank)
    COPYSTRING(pbData.rankImage, outData->rankImage)
    outData->score = pbData.score;
    COPYSTRING(pbData.maxScore, outData->maxScore)
    outData->totalScore = outData->totalScore;
    outData->totalMaxScore = outData->totalMaxScore;
}

+ (void) populateRuleEvent:(ruleEvent*)outData from:(PBRuleEvent*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.eventType, outData->eventType)
    COPYSTRING(pbData.rewardType, outData->rewardType)
    COPYSTRING(pbData.value, outData->value)
    // get specific data according to type of reward
    if ([pbData.rewardType isEqualToString:@"badge"])
    {
        PBRuleEventBadgeRewardData *badge = (PBRuleEventBadgeRewardData*)pbData.rewardData;
        [Populator populateRuleEventBadgeRewardData:&outData->badgeData from:badge];
    }
    else if ([pbData.rewardType isEqualToString:@"goods"])
    {
        PBRuleEventGoodsRewardData *goods = (PBRuleEventGoodsRewardData*)pbData.rewardData;
        [Populator populateRuleEventGoodsRewardData:&outData->goodsData from:goods];
    }
    outData->index = [pbData.index intValue];
}

+ (void) populateRuleEventArray:(_array<ruleEvent>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    ruleEvent *items = new ruleEvent[[pbArray count]];
    int i=0;

    for (PBRuleEvent* c in pbArray)
    {
        // populateRuleEvent
        [Populator populateRuleEvent:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateRuleEventMission:(ruleEventMission*)outData from:(PBRuleEventsMission*)pbData
{
    RETURNIFNULL(pbData)

    [Populator populateRuleEventArray:&outData->eventArray from:pbData.events.list];
    COPYSTRING(pbData.missionId, outData->missionId)
    COPYSTRING(pbData.missionNumber, outData->missionNumber)
    COPYSTRING(pbData.missionName, outData->missionName)
    COPYSTRING(pbData.description_, outData->description_)
    COPYSTRING(pbData.hint, outData->hint)
    COPYSTRING(pbData.image, outData->image)
    COPYSTRING(pbData.questId, outData->questId)
}

+ (void) populateRuleEventMissionArray:(_array<ruleEventMission>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    ruleEventMission *items = new ruleEventMission[[pbArray count]];
    int i=0;

    for (PBRuleEventsMission* c in pbArray)
    {
        // populateRuleEventMission
        [Populator populateRuleEventMission:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateRuleEventQuest:(ruleEventQuest*)outData from:(PBRuleEventsQuest*)pbData
{
    RETURNIFNULL(pbData)

    [Populator populateRuleEventArray:&outData->eventArray from:pbData.events.list];
    COPYSTRING(pbData.questId, outData->questId)
    COPYSTRING(pbData.questName, outData->questName)
    COPYSTRING(pbData.description_, outData->description_)
    COPYSTRING(pbData.hint, outData->hint)
    COPYSTRING(pbData.image, outData->image)
}

+ (void) populateRuleEventQuestArray:(_array<ruleEventQuest>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    ruleEventQuest *items = new ruleEventQuest[[pbArray count]];
    int i=0;

    for (PBRuleEventsQuest* c in pbArray)
    {
        // populateRuleEventQuest
        [Populator populateRuleEventQuest:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateRuleEventBadgeRewardData:(ruleEventBadgeRewardData*)outData from:(PBRuleEventBadgeRewardData*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.badgeId, outData->badgeId)
    COPYSTRING(pbData.image, outData->image)
    COPYSTRING(pbData.name, outData->name)
    COPYSTRING(pbData.description_, outData->description_)
    COPYSTRING(pbData.hint, outData->hint)
    outData->claim = pbData.claim;
    outData->redeem = pbData.redeem;
}

+ (void) populateRuleEventGoodsRewardData:(ruleEventGoodsRewardData*)outData from:(PBRuleEventGoodsRewardData*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.goodsId, outData->goodsId)
    COPYSTRING(pbData.image, outData->image)
    COPYSTRING(pbData.name, outData->name)
    COPYSTRING(pbData.description_, outData->description_)
    COPYSTRING(pbData.perUser, outData->perUser)
    COPYSTRING(pbData.quantity, outData->quantity)
}

+ (void) populateRule:(rule*)outData from:(PBRule_Response*)pbData
{
    RETURNIFNULL(pbData)

    [Populator populateRuleEventArray:&outData->ruleEventArray from:pbData.events.list];
    [Populator populateRuleEventMissionArray:&outData->ruleEventMissionArray from:pbData.missions.list];
    [Populator populateRuleEventQuestArray:&outData->ruleEventQuestArray from:pbData.quests.list];
}

+ (void) populateBadge:(badge*)outData from:(PBBadge_Response*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.badgeId, outData->badgeId)
    COPYSTRING(pbData.image, outData->image)
    outData->sortOrder = pbData.sortOrder;
    COPYSTRING(pbData.name, outData->name)
    COPYSTRING(pbData.description_, outData->description_)
    COPYSTRING(pbData.hint, outData->hint)
    outData->sponsor = pbData.sponsor;
    outData->claim = pbData.claim;
    outData->redeem = pbData.redeem;
}

+ (void) populateBadgeArray:(_array<badge>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    badge *items = new badge[[pbArray count]];
    int i=0;

    for (PBBadge_Response* c in pbArray)
    {
        [Populator populateBadge:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateRedeem:(redeem*)outData from:(PBRedeem*)pbData
{
    RETURNIFNULL(pbData)

    outData->pointValue = pbData.pointValue;
    [Populator populateCustomArray:&outData->customArray from:pbData.customs.customs];
    [Populator populateRedeemBadgeArray:&outData->redeemBadgeArray from:pbData.redeemBadges.list];
}

+ (void) populateRedeemBadge:(redeemBadge*)outData from:(PBRedeemBadge*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.badgeId, outData->badgeId)
    outData->badgeValue = pbData.badgeValue;
}

+ (void) populateRedeemBadgeArray:(_array<redeemBadge>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    redeemBadge *items = new redeemBadge[[pbArray count]];
    int i=0;

    for (PBRedeemBadge* c in pbArray)
    {
        [Populator populateRedeemBadge:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateGoods:(goods*)outData from:(PBGoods*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.goodsId, outData->goodsId)
    outData->quantity = pbData.quantity;
    COPYSTRING(pbData.image, outData->image)
    outData->sortOrder = pbData.sortOrder;
    COPYSTRING(pbData.name, outData->name)
    COPYSTRING(pbData.description_, outData->description_)
    [Populator populateRedeem:&outData->redeem from:pbData.redeem];
    COPYSTRING(pbData.code, outData->code)
    outData->sponsor = pbData.sponsor;
    outData->dateStart = [pbData.dateStart timeIntervalSince1970];
    outData->dateExpire = [pbData.dateExpire timeIntervalSince1970];
}

+ (void) populateGoodsInfo:(goodsInfo*)outData from:(PBGoodsInfo_Response*)pbData
{
    RETURNIFNULL(pbData)

    [Populator populateGoods:&outData->goods from:pbData.goods];
    outData->perUser = pbData.perUser;
    outData->isGroup = pbData.isGroup;
}

+ (void) populateGoodsInfoArray:(_array<goodsInfo>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    goodsInfo *items = new goodsInfo[[pbArray count]];
    int i=0;

    for (PBGoodsInfo_Response* c in pbArray)
    {
        [Populator populateGoodsInfo:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

+ (void) populateCustom:(custom*)outData from:(PBCustom*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.customId, outData->customId)
    COPYSTRING(pbData.customName, outData->customName)
    outData->customValue = pbData.customValue;
}

+ (void) populateCustomArray:(_array<custom>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    custom *items = new custom[[pbArray count]];
    int i=0;

    for (PBCustom* c in pbArray)
    {
        [Populator populateCustom:&items[i] from:c];
        i++;
    }

    outData->data = items;
    outData->count = i;
}

@end