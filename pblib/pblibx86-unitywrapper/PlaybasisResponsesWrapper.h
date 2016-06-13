#import <string>
#import <cstdlib>

using std::string;

template <typename T>
struct _array {
	T* data=NULL;
	int count;

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
		if (image)
			free(image);
		if (userName)
			free(userName);
		if (firstName)
			free(firstName);
		if (lastName)
			free(lastName);
		if (clPlayerId)
			free(clPlayerId);
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
		if (email)
			free(email);
		if (phoneNumber)
			free(phoneNumber);
	}
} player;

typedef struct _point {
	char* rewardId=NULL;
	char* rewardName=NULL;
	unsigned int value;

	~_point()
	{
		if (rewardId)
            free(rewardId);
		if (rewardName)
			free(rewardName);
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
		if (customId)
			free(customId);
		if (customValue)
			free(customValue);
	}
} gradeRewardCustom;

typedef struct _gradeRewards {
	char* expValue;
	char* pointValue;
	_array<gradeRewardCustom> gradeRewardCustomArray;

	~_gradeRewards()
	{
		if (expValue)
			free(expValue);
		if (pointValue)
			free(pointValue);
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
		if (gradeId)
			free(gradeId);
		if (start)
			free(start);
		if (end)
			free(end);
		if (grade)
			free(grade);
		if (rank)
			free(rank);
		if (rankImage)
			free(rankImage);
	}
} grade;

typedef struct _quizBasic {
	char* name;
	char* image;
	int weight;
	char* description_;
	char* descriptionImage;
	char* quizId;

	~_quizBasic()
	{
		if (name)
			free(name);
		if (image)
			free(image);
		if (description_)
			free(description_);
		if (descriptionImage)
			free(descriptionImage);
		if (quizId)
			free(quizId);
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
		if (eventType)
			free(eventType);
		if (rewardType)
			free(rewardType);
		if (rewardId)
			free(rewardId);
		if (value)
			free(value);
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
		if (gradeId)
			free(gradeId);
		if (start)
			free(start);
		if (end)
			free(end);
		if (grade)
			free(grade);
		if (rank)
			free(rank);
		if (rankImage)
			free(rankImage);
		if (maxScore)
			free(maxScore);
	}
} gradeDone;

typedef struct _quizDone {
	unsigned int value;
	gradeDone gradeDone;
	unsigned int totalCompletedQuestion;
	char* quizId;

	~_quizDone()
	{
		if (quizId)
			free(quizId);
	}
} quizDone;

typedef struct _quizPendingGradeReward {
	char* eventType;
	char* rewardType;
	char* rewardId;
	char* value;
} quizPendingGradeReward;

typedef struct _quizPendingGrade {
	unsigned int score;
	_array<quizPendingGradeReward> quizPendingGradeRewardArray;
	char* maxScore;
	unsigned int totalScore;
	unsigned int totalMaxScore;
} quizPendingGrade;

typedef struct _quizPending {
	unsigned int value;
	quizPendingGrade grade;
	unsigned int totalCompletedQuestions;
	unsigned int totalPendingQuestions;
	char* quizId;
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
} questionOption;

typedef struct _question {
	char* question;
	char* questionImage;
	_array<questionOption> optionArray;
	unsigned int index;
	unsigned int total;
	char* questionId;
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
} questionAnsweredGradeDone;

typedef struct _questionAnsweredOption {
	char* option;
	char* score;
	char* explanation;
	char* optionImage;
	char* optionId;
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
} questionAnswered;

typedef struct _custom {
	char* customId;
	char* customName;
	unsigned int customValue;
} custom;

typedef struct _redeemBadge {
	char* badgeId;
	unsigned int badgeValue;
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
} badge;
    
typedef struct _ruleEventBadgeRewardData
{
    char* badgeId;
    char* image;
    char* name;
    char* description_;
    char* hint;
} ruleEventBadgeRewardData;

typedef struct _ruleEventGoodsRewardData
{
    char* goodsId;
    char* image;
    char* name;
    char* description_;
    char* perUser;
    char* code;
} ruleEventGoodsRewardData;

typedef struct _ruleEvent {
	char* eventType;
	char* rewardType;
	char* value;
	ruleEventBadgeRewardData badgeData;
	ruleEventGoodsRewardData goodsData;
} ruleEvent;

typedef struct _ruleEventMission {
	_array<ruleEvent> eventArray;
	char* missionId;
	char* missionNumber;
	char* missionName;
	char* description_;
	char* hint;
	char* image;
	char* questId;
} ruleEventMission;

typedef struct _ruleEventQuest {
	_array<ruleEvent> eventArray;
	char* questId;
	char* questName;
	char* description_;
	char* hint;
	char* image;
} ruleEventQuest;

typedef struct _rule {
	_array<ruleEvent> ruleEventArray;
	_array<ruleEventMission> ruleEventMissionArray;
	_array<ruleEventQuest> ruleEventQuestArray;  
} rule;

#ifdef __cplusplus
}
#endif