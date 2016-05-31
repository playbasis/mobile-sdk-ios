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

@end