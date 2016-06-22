#import <string>
#import <cstdlib>

#define FREESTR(str) if(str) free(str); 

using std::string;

template <typename T>
struct _array {
	T* data=NULL;
	int count=0;

	~_array()
	{
		if (data)
			delete[] data;
	}
};

#ifdef __cplusplus
extern "C" {
#endif

typedef struct _playerBasic {
	char* image=NULL;
	char* userName=NULL;
	unsigned int exp=0;
	unsigned int level=0;
	char* firstName=NULL;
	char* lastName=NULL;
	unsigned int gender=0;
	char* clPlayerId=NULL;

	~_playerBasic()
	{
		FREESTR(image)
		FREESTR(userName)
		FREESTR(firstName)
		FREESTR(lastName)
		FREESTR(clPlayerId)
	}
} playerBasic;

typedef struct _playerPublic {
	playerBasic basic;
	time_t registered=0;
	time_t lastLogin=0;
	time_t lastLogout=0;
} playerPublic;

typedef struct _player {
	playerPublic playerPublic;
	char* email=NULL;
	char* phoneNumber=NULL;

	~_player()
	{
		FREESTR(email)
		FREESTR(phoneNumber)
	}
} player;

typedef struct _point {
	char* rewardId=NULL;
	char* rewardName=NULL;
	unsigned int value=0;

	~_point()
	{
		FREESTR(rewardId)
		FREESTR(rewardName)
	}
} point;

typedef struct _pointR {
	_array<point> pointArray;
} pointR;

typedef struct _gradeRewardCustom {
	char* customId=0;
	char* customValue=0;

	~_gradeRewardCustom()
	{
		FREESTR(customId)
		FREESTR(customValue)
	}
} gradeRewardCustom;

typedef struct _gradeRewards {
	char* expValue=NULL;
	char* pointValue=NULL;
	_array<gradeRewardCustom> gradeRewardCustomArray;

	~_gradeRewards()
	{
		FREESTR(expValue)
		FREESTR(pointValue)
	}
} gradeRewards;

typedef struct _grade {
	char* gradeId=NULL;
	char* start=NULL;
	char* end=NULL;
	char* grade=NULL;
	char* rank=NULL;
	char* rankImage=NULL;
	gradeRewards rewards;

	~_grade()
	{
		FREESTR(gradeId)
		FREESTR(start)
		FREESTR(end)
		FREESTR(grade)
		FREESTR(rank)
		FREESTR(rankImage)
	}
} grade;

typedef struct _quizBasic {
	char* name=NULL;
	char* image=NULL;
	int weight=NULL;
	char* description_=NULL;
	char* descriptionImage=NULL;
	char* quizId=NULL;

	~_quizBasic()
	{
		FREESTR(name)
		FREESTR(image)
		FREESTR(description_)
		FREESTR(descriptionImage)
		FREESTR(quizId)
	}
} quizBasic;

typedef struct _quiz {
	quizBasic basic;
	time_t dateStart=0;
	time_t dateExpire=0;
	bool status=false;
	_array<grade> gradeArray;
	bool deleted=false;
	unsigned int totalMaxScore=0;
	unsigned int totalQuestions=0;
} quiz;

typedef struct _gradeDoneReward {
	char* eventType=NULL;
	char* rewardType=NULL;
	char* rewardId=NULL;
	char* value=NULL;

	~_gradeDoneReward()
	{
		FREESTR(eventType)
		FREESTR(rewardType)
		FREESTR(rewardId)
		FREESTR(value)
	}
} gradeDoneReward;

typedef struct _gradeDone {
	char* gradeId=NULL;
	char* start=NULL;
	char* end=NULL;
	char* grade=NULL;
	char* rank=NULL;
	char* rankImage=NULL;
	_array<gradeDoneReward> rewardArray;
	unsigned int score=0;
	char* maxScore=NULL;
	unsigned int totalScore=0;
	unsigned int totalMaxScore=0;

	~_gradeDone()
	{
		FREESTR(gradeId)
		FREESTR(start)
		FREESTR(end)
		FREESTR(grade)
		FREESTR(rank)
		FREESTR(rankImage)
		FREESTR(maxScore)
	}
} gradeDone;

typedef struct _quizDone {
	unsigned int value=0;
	gradeDone gradeDone;
	unsigned int totalCompletedQuestion=0;
	char* quizId=NULL;

	~_quizDone()
	{
		FREESTR(quizId)
	}
} quizDone;

typedef struct _quizPendingGradeReward {
	char* eventType=NULL;
	char* rewardType=NULL;
	char* rewardId=NULL;
	char* value=NULL;

	~_quizPendingGradeReward()
	{
		FREESTR(eventType)
		FREESTR(rewardType)
		FREESTR(rewardId)
		FREESTR(value)
	}
} quizPendingGradeReward;

typedef struct _quizPendingGrade {
	unsigned int score=0;
	_array<quizPendingGradeReward> quizPendingGradeRewardArray;
	char* maxScore=NULL;
	unsigned int totalScore=0;
	unsigned int totalMaxScore=0;

	~_quizPendingGrade()
	{
		FREESTR(maxScore)
	}
} quizPendingGrade;

typedef struct _quizPending {
	unsigned int value=0;
	quizPendingGrade grade;
	unsigned int totalCompletedQuestions=0;
	unsigned int totalPendingQuestions=0;
	char* quizId=NULL;

	~_quizPending()
	{
		FREESTR(quizId)
	}
} quizPending;

typedef struct _quizDoneList {
	_array<quizDone> quizDoneArray;
} quizDoneList;

typedef struct _quizList {
	_array<quizBasic> quizBasicArray;
} quizList;

typedef struct _quizPendingList {
	_array<quizPending> quizPendingArray;
} quizPendingList;

typedef struct _questionOption {
	char* option=NULL;
	char* optionImage=NULL;
	char* optionId=NULL;

	~_questionOption()
	{
		FREESTR(option)
		FREESTR(optionImage)
		FREESTR(optionId)
	}
} questionOption;

typedef struct _question {
	char* question=NULL;
	char* questionImage=NULL;
	_array<questionOption> optionArray;
	unsigned int index=0;
	unsigned int total=0;
	char* questionId=NULL;

	~_question()
	{
		FREESTR(question)
		FREESTR(questionImage)
		FREESTR(questionId)
	}
} question;

typedef struct _questionAnsweredGradedone {
	char* gradeId=NULL;
	char* start=NULL;
	char* end=NULL;
	char* grade=NULL;
	char* rank=NULL;
	char* rankImage=NULL;
	unsigned int score=0;
	char* maxScore=NULL;
	unsigned int totalScore=NULL;
	unsigned int totalMaxScore=NULL;

	~_questionAnsweredGradedone()
	{
		FREESTR(gradeId)
		FREESTR(start)
		FREESTR(end)
		FREESTR(grade)
		FREESTR(rank)
		FREESTR(rankImage)
		FREESTR(maxScore)
	}
} questionAnsweredGradeDone;

typedef struct _questionAnsweredOption {
	char* option=NULL;
	char* score=NULL;
	char* explanation=NULL;
	char* optionImage=NULL;
	char* optionId=NULL;

	~_questionAnsweredOption()
	{
		FREESTR(option)
		FREESTR(score)
		FREESTR(explanation)
		FREESTR(optionImage)
		FREESTR(optionId)
	}
} questionAnsweredOption;

typedef struct _questionAnswered {
	_array<questionAnsweredOption> optionArray;
	unsigned int score=0;
	char* maxScore=NULL;
	char* explanation=NULL;
	unsigned int totalScore=0;
	unsigned int totalMaxScore=0;
	questionAnsweredGradeDone gradeDone;
	_array<gradeDoneReward> gradeDoneRewardArray;

	~_questionAnswered()
	{
		FREESTR(maxScore)
		FREESTR(explanation)
	}
} questionAnswered;

typedef struct _custom {
	char* customId=NULL;
	char* customName=NULL;
	unsigned int customValue=0;

	~_custom()
	{
		FREESTR(customId)
		FREESTR(customName)
	}
} custom;

typedef struct _redeemBadge {
	char* badgeId=NULL;
	unsigned int badgeValue=0;

	~_redeemBadge()
	{
		FREESTR(badgeId)
	}
} redeemBadge;

typedef struct _redeem {
	unsigned int pointValue=0;
	_array<custom> customArray;
	_array<redeemBadge> redeemBadgeArray;
} redeem;

typedef struct _goods {
	char* goodsId=NULL;
	unsigned int quantity=0;
	char* image=NULL;
	unsigned int sortOrder=0;
	char* name=NULL;
	char* description_=NULL;
	redeem redeem;
	char* code=NULL;
	bool sponsor=false;
	long dateStart=0;
	long dateExpire=0;

	~_goods()
	{
		FREESTR(goodsId)
		FREESTR(image)
		FREESTR(name)
		FREESTR(description_)
		FREESTR(code)
	}
} goods;

typedef struct _goodsInfo {
	goods goods;
	unsigned int amount=0;
	unsigned int perUser=0;
	bool isGroup=false;
} goodsInfo;

typedef struct _goodsInfoList {
	_array<goodsInfo> goodsInfoArray;
} goodsInfoList;

typedef struct _badge {
	char* badgeId=NULL;
	char* image=NULL;
	unsigned int sortOrder=0;
	char* name=NULL;
	char* description_=NULL;
	char* hint=NULL;
	bool sponsor=false;
 
	~_badge()
	{
		FREESTR(badgeId)
		FREESTR(image)
		FREESTR(name)
		FREESTR(description_)
		FREESTR(hint)
	}
} badge;

typedef struct _badges {
	_array<badge> badgeArray;
} badges;
    
typedef struct _ruleEventBadgeRewardData
{
    char* badgeId=NULL;
    char* image=NULL;
    char* name=NULL;
    char* description_=NULL;
    char* hint=NULL;

    ~_ruleEventBadgeRewardData()
    {
    	FREESTR(badgeId)
    	FREESTR(image)
    	FREESTR(name)
    	FREESTR(description_)
    	FREESTR(hint)
    }
} ruleEventBadgeRewardData;

typedef struct _ruleEventGoodsRewardData
{
    char* goodsId=NULL;
    char* image=NULL;
    char* name=NULL;
    char* description_=NULL;
    char* perUser=NULL;
    char* code=NULL;

    ~_ruleEventGoodsRewardData()
    {
    	FREESTR(goodsId)
    	FREESTR(image)
    	FREESTR(name)
    	FREESTR(description_)
    	FREESTR(perUser)
    	FREESTR(code)
    }
} ruleEventGoodsRewardData;

typedef struct _ruleEvent {
	char* eventType=NULL;
	char* rewardType=NULL;
	char* value=NULL;
	ruleEventBadgeRewardData badgeData;
	ruleEventGoodsRewardData goodsData;

	~_ruleEvent()
	{
		FREESTR(eventType)
		FREESTR(rewardType)
		FREESTR(value)
	}
} ruleEvent;

typedef struct _ruleEventMission {
	_array<ruleEvent> eventArray;
	char* missionId=NULL;
	char* missionNumber=NULL;
	char* missionName=NULL;
	char* description_=NULL;
	char* hint=NULL;
	char* image=NULL;
	char* questId=NULL;

	~_ruleEventMission()
	{
		FREESTR(missionId)
		FREESTR(missionNumber)
		FREESTR(missionName)
		FREESTR(description_)
		FREESTR(hint)
		FREESTR(image)
		FREESTR(questId)
	}
} ruleEventMission;

typedef struct _ruleEventQuest {
	_array<ruleEvent> eventArray;
	char* questId=NULL;
	char* questName=NULL;
	char* description_=NULL;
	char* hint=NULL;
	char* image=NULL;

	~_ruleEventQuest()
	{
		FREESTR(questId)
		FREESTR(questName)
		FREESTR(description_)
		FREESTR(hint)
		FREESTR(image)
	}
} ruleEventQuest;

typedef struct _rule {
	_array<ruleEvent> ruleEventArray;
	_array<ruleEventMission> ruleEventMissionArray;
	_array<ruleEventQuest> ruleEventQuestArray;
} rule;

typedef struct _url {
	char* operation=NULL;
	char* completionString=NULL;
	
	~_url()
	{
		FREESTR(operation)
		FREESTR(completionString)
	}
} url;

typedef struct _filteredParam {
	url url;
} filteredParam;

typedef struct _completionData {
    char* actionId=NULL;
	char* name=NULL;
	char* description_=NULL;
	char* icon=NULL;
	char* color=NULL;
	
	~_completionData() {
		FREESTR(actionId)
		FREESTR(name)
		FREESTR(description_)
		FREESTR(icon)
		FREESTR(color)
	}
} completionData;

typedef struct _completion {
	char* completionOp=NULL;
	char* completionFilter=NULL;
	char* completionValue=NULL;
	char* completionId=NULL;
	char* completionType=NULL;
	char* completionElementId=NULL;
	char* completionTitle=NULL;
	filteredParam filteredParam;
	completionData completionData;
	
	~_completion()
	{
		FREESTR(completionOp)
		FREESTR(completionFilter)
		FREESTR(completionValue)
		FREESTR(completionId)
		FREESTR(completionType)
		FREESTR(completionElementId)
		FREESTR(completionTitle)
	}
} completion;

typedef struct _reward {
	char* rewardValue=NULL;
	char* rewardType=NULL;
	char* rewardId=NULL;
	char* rewardName=NULL;

	~_reward()
	{
		FREESTR(rewardValue)
		FREESTR(rewardType)
		FREESTR(rewardId)
		FREESTR(rewardName)
	}
} reward;

typedef struct _missionBasic {
	char* missionName=NULL;
	char* missionNumber=NULL;
	char* description_=NULL;
	char* hint=NULL;
	char* image=NULL;
	_array<completion> completionArray;
	_array<reward> rewardArray;
	char* missionId;
	
	~_missionBasic()
	{
		FREESTR(missionName)
		FREESTR(missionNumber)
		FREESTR(description_)
		FREESTR(hint)
		FREESTR(image)
		FREESTR(missionId)
	}
} missionBasic;

typedef struct _mission {
	missionBasic missionBasic;
} mission;

typedef struct _missionInfo {
	missionBasic missionBasic;
	char* questId=NULL;
	
	~_missionInfo() {
		FREESTR(questId)
	}
} missionInfo;
    
typedef struct _conditionData {
    char* questName=NULL;
    char* description_=NULL;
    char* hint=NULL;
    char* image=NULL;
    
    ~_conditionData() {
        FREESTR(questName)
        FREESTR(description_)
        FREESTR(hint)
        FREESTR(image)
    }
} conditionData;

typedef struct _condition {
	char* conditionId=NULL;
	char* conditionType=NULL;
	char* conditionValue=NULL;
	conditionData conditionData;
	
	~_condition() {
		FREESTR(conditionId)
		FREESTR(conditionType)
		FREESTR(conditionValue)
	}
} condition;
    
typedef struct _questBasic {
	char* questName=NULL;
	char* description_=NULL;
	char* hint=NULL;
	char* image=NULL;
	bool missionOrder=false;
	bool status=false;
	unsigned int sortOrder=0;
	_array<reward> rewardArray;
	_array<missionBasic> missionBasicArray;
	time_t dateAdded=0;
	char* clientId=NULL;
	char* siteId=NULL;
	_array<condition> conditionArray;
	time_t dateModified=NULL;
	char* questId=NULL;

	~_questBasic()
	{
		FREESTR(questName)
		FREESTR(description_)
		FREESTR(hint)
		FREESTR(image)
		FREESTR(clientId)
		FREESTR(siteId)
		FREESTR(questId)
	}

} questBasic;
    
typedef struct _questInfo {
	questBasic questBasic;
} questInfo;

typedef struct _questInfoList {
	_array<questBasic> questBasicArray;
} questInfoList;

#ifdef __cplusplus
}
#endif