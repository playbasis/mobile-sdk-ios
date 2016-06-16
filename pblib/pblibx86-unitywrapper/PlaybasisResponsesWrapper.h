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
	unsigned int exp;
	unsigned int level;
	char* firstName=NULL;
	char* lastName=NULL;
	unsigned int gender;
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
	time_t registered;
	time_t lastLogin;
	time_t lastLogout;
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
	unsigned int value;

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
	char* customId;
	char* customValue;

	~_gradeRewardCustom()
	{
		FREESTR(customId)
		FREESTR(customValue)
	}
} gradeRewardCustom;

typedef struct _gradeRewards {
	char* expValue;
	char* pointValue;
	_array<gradeRewardCustom> gradeRewardCustomArray;

	~_gradeRewards()
	{
		FREESTR(expValue)
		FREESTR(pointValue)
	}
} gradeRewards;

typedef struct _grade {
	char* gradeId;
	char* start;
	char* end;
	char* grade;
	char* rank;
	char* rankImage;
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
	time_t dateStart;
	time_t dateExpire;
	bool status;
	_array<grade> gradeArray;
	bool deleted;
	unsigned int totalMaxScore;
	unsigned int totalQuestions;
} quiz;

typedef struct _gradeDoneReward {
	char* eventType;
	char* rewardType;
	char* rewardId;
	char* value;

	~_gradeDoneReward()
	{
		FREESTR(eventType)
		FREESTR(rewardType)
		FREESTR(rewardId)
		FREESTR(value)
	}
} gradeDoneReward;

typedef struct _gradeDone {
	char* gradeId;
	char* start;
	char* end;
	char* grade;
	char* rank;
	char* rankImage;
	_array<gradeDoneReward> rewardArray;
	unsigned int score;
	char* maxScore;
	unsigned int totalScore;
	unsigned int totalMaxScore;

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
	unsigned int value;
	gradeDone gradeDone;
	unsigned int totalCompletedQuestion;
	char* quizId;

	~_quizDone()
	{
		FREESTR(quizId)
	}
} quizDone;

typedef struct _quizPendingGradeReward {
	char* eventType;
	char* rewardType;
	char* rewardId;
	char* value;

	~_quizPendingGradeReward()
	{
		FREESTR(eventType)
		FREESTR(rewardType)
		FREESTR(rewardId)
		FREESTR(value)
	}
} quizPendingGradeReward;

typedef struct _quizPendingGrade {
	unsigned int score;
	_array<quizPendingGradeReward> quizPendingGradeRewardArray;
	char* maxScore;
	unsigned int totalScore;
	unsigned int totalMaxScore;

	~_quizPendingGrade()
	{
		FREESTR(maxScore)
	}
} quizPendingGrade;

typedef struct _quizPending {
	unsigned int value;
	quizPendingGrade grade;
	unsigned int totalCompletedQuestions;
	unsigned int totalPendingQuestions;
	char* quizId;

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
	char* option;
	char* optionImage;
	char* optionId;

	~_questionOption()
	{
		FREESTR(option)
		FREESTR(optionImage)
		FREESTR(optionId)
	}
} questionOption;

typedef struct _question {
	char* question;
	char* questionImage;
	_array<questionOption> optionArray;
	unsigned int index;
	unsigned int total;
	char* questionId;

	~_question()
	{
		FREESTR(question)
		FREESTR(questionImage)
		FREESTR(questionId)
	}
} question;

typedef struct _questionAnsweredGradedone {
	char* gradeId;
	char* start;
	char* end;
	char* grade;
	char* rank;
	char* rankImage;
	unsigned int score;
	char* maxScore;
	unsigned int totalScore;
	unsigned int totalMaxScore;

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
	char* option;
	char* score;
	char* explanation;
	char* optionImage;
	char* optionId;

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
	unsigned int score;
	char* maxScore;
	char* explanation;
	unsigned int totalScore;
	unsigned int totalMaxScore;
	questionAnsweredGradeDone gradeDone;
	_array<gradeDoneReward> gradeDoneRewardArray;

	~_questionAnswered()
	{
		FREESTR(maxScore)
		FREESTR(explanation)
	}
} questionAnswered;

typedef struct _custom {
	char* customId;
	char* customName;
	unsigned int customValue;

	~_custom()
	{
		FREESTR(customId)
		FREESTR(customName)
	}
} custom;

typedef struct _redeemBadge {
	char* badgeId;
	unsigned int badgeValue;

	~_redeemBadge()
	{
		FREESTR(badgeId)
	}
} redeemBadge;

typedef struct _redeem {
	unsigned int pointValue;
	_array<custom> customArray;
	_array<redeemBadge> redeemBadgeArray;
} redeem;

typedef struct _goods {
	char* goodsId;
	unsigned int quantity;
	char* image;
	unsigned int sortOrder;
	char* name;
	char* description_;
	redeem redeem;
	char* code;
	bool sponsor;
	long dateStart;
	long dateExpire;

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
	unsigned int perUser;
	bool isGroup;
} goodsInfo;

typedef struct _badge {
	char* badgeId;
	char* image;
	unsigned int sortOrder;
	char* name;
	char* description_;
	char* hint;
	bool sponsor;
	bool claim;
	bool redeem;

	~_badge()
	{
		FREESTR(badgeId)
		FREESTR(image)
		FREESTR(name)
		FREESTR(description_)
		FREESTR(hint)
	}
} badge;
    
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

#ifdef __cplusplus
}
#endif