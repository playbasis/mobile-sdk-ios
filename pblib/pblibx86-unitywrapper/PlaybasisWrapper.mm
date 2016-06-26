#import "PlaybasisWrapper.h"
#import "Playbasis.h" // your actual iOS library header
#import "Util.h"
#import "Populator.h"

// Populate struct data based on input response type
void PopulateData(pbResponseType type, PBBase_Response *response, void* outData)
{
	if (type == responseType_playerPublic)
	{
		PBPlayerPublic_Response* cr = (PBPlayerPublic_Response*)response;

		playerPublic* data = (playerPublic*)outData;
		[Populator populatePlayerPublic:data from:cr];
	}
	else if (type == responseType_player)
	{
		PBPlayer_Response* cr = (PBPlayer_Response*)response;

		player* data = (player*)outData;
		[Populator populatePlayer:data from:cr];
	}
	else if (type == responseType_point)
	{
		PBPoint_Response* cr = (PBPoint_Response*)response;

		pointR* data = (pointR*)outData;
		[Populator populatePointArray:&data->pointArray from:cr.point];
	}
	else if (type == responseType_activeQuizList)
	{
		PBActiveQuizList_Response* cr = (PBActiveQuizList_Response*)response;

		quizList* data = (quizList*)outData;
		[Populator populateQuizArray:&data->quizBasicArray from:cr.list.quizBasics];
	}
	else if (type == responseType_quizDetail)
	{
		PBQuizDetail_Response* cr = (PBQuizDetail_Response*)response;

		quiz* data = (quiz*)outData;
		[Populator populateQuiz:data from:cr.quiz];
	}
	else if (type == responseType_quizRandom)
	{
		PBQuizRandom_Response* cr = (PBQuizRandom_Response*)response;

		quizBasic* data = (quizBasic*)outData;
		[Populator populateQuizBasic:data from:cr.randomQuiz];
	}
	else if (type == responseType_quizDoneListByPlayer)
	{
		PBQuizDoneList_Response* cr = (PBQuizDoneList_Response*)response;

		quizDoneList* data = (quizDoneList*)outData;
		[Populator populateQuizDoneArray:&data->quizDoneArray from:cr.list.quizDones];
	}
	else if (type == responseType_quizPendingsByPlayer)
	{
		PBQuizPendings_Response* cr = (PBQuizPendings_Response*)response;

		quizPendingList* data = (quizPendingList*)outData;
		[Populator populateQuizPendingArray:&data->quizPendingArray from:cr.quizPendings.list];
	}
	else if (type == responseType_questionFromQuiz)
	{
		PBQuestion_Response* cr = (PBQuestion_Response*)response;

		question* data = (question*)outData;
		[Populator populateQuestion:data from:cr.question];
	}
	else if (type == responseType_questionAnswered)
	{
		PBQuestionAnswered_Response* cr = (PBQuestionAnswered_Response*)response;

		questionAnswered* data = (questionAnswered*)outData;
		[Populator populateQuestionAnswered:data from:cr.result];
	}
	else if (type == responseType_rule)
	{
		PBRule_Response* cr = (PBRule_Response*)response;

		rule* data = (rule*)outData;
		[Populator populateRule:data from:cr];
	}
	else if (type == responseType_badges)
	{
		PBBadges_Response* cr = (PBBadges_Response*)response;

		badges* data = (badges*)outData;
		[Populator populateBadgeArray:&data->badgeArray from:cr.badges];
	}
	else if (type == responseType_badge)
	{
		PBBadge_Response* cr = (PBBadge_Response*)response;

		badge* data = (badge*)outData;
		[Populator populateBadge:data from:cr];
	}
	else if (type == responseType_goodsInfo)
	{
		PBGoodsInfo_Response* cr = (PBGoodsInfo_Response*)response;

		goodsInfo* data = (goodsInfo*)outData;
		[Populator populateGoodsInfo:data from:cr];
	}
	else if (type == responseType_goodsListInfo)
	{
		PBGoodsListInfo_Response* cr = (PBGoodsListInfo_Response*)response;

		goodsInfoList* data = (goodsInfoList*)outData;
		[Populator populateGoodsInfoArray:&data->goodsInfoArray from:cr.goodsList];
	}
	else if (type == responseType_questInfo) {
		PBQuestInfo_Response* cr = (PBQuestInfo_Response*)response;
		
		questInfo* data = (questInfo*)outData;
		[Populator populateQuestInfo:data from:cr];
	}
	else if (type == responseType_questList) {
		PBQuestList_Response* cr = (PBQuestList_Response*)response;
		
		questInfoList* data = (questInfoList*)outData;
		[Populator populateQuestBasicArray:&data->questBasicArray from:cr.list.questBasics];
	}
	else if (type == responseType_missionInfo) {
		PBMissionInfo_Response* cr = (PBMissionInfo_Response*)response;
		
		missionInfo* data = (missionInfo*)outData;
		[Populator populateMissionInfo:data from:cr];
	}
	else if (type == responseType_questListAvailableForPlayer) {
		PBQuestListAvailableForPlayer_Response* cr = (PBQuestListAvailableForPlayer_Response*)response;
		
		questInfoList* data = (questInfoList*)outData;
		[Populator populateQuestBasicArray:&data->questBasicArray from:cr.list.questBasics];
	}
	else if (type == responseType_questAvailableForPlayer) {
		PBQuestAvailableForPlayer_Response* cr = (PBQuestAvailableForPlayer_Response*)response;
		
		questAvailableForPlayer* data = (questAvailableForPlayer*)outData;
		[Populator populateQuestAvailableForPlayer:data from:cr];
	}
	else if (type == responseType_joinQuest) {
		PBJoinQuest_Response* cr = (PBJoinQuest_Response*)response;
		
		joinQuest* data = (joinQuest*)outData;
		[Populator populateJoinQuest:data from:cr.response];
	}
	else if (type == responseType_cancelQuest) {
		PBCancelQuest_Response* cr = (PBCancelQuest_Response*)response;
		
		cancelQuest* data = (cancelQuest*)outData;
		[Populator populateCancelQuest:data from:cr.response];
	}
}

/*
	Fields and methods exposed by Playbasis class.
*/
const char* _version() {
	return MakeStringCopy([[Playbasis version] UTF8String]);
}

const char* _token() {
	return MakeStringCopy([[Playbasis sharedPB].token UTF8String]);
}

void _auth(const char* apikey, const char* apisecret, const char* bundleId, OnResult callback) {
	[[Playbasis sharedPB] authWithApiKeyAsync:CreateNSString(apikey) apiSecret:CreateNSString(apisecret) bundleId:CreateNSString(bundleId) andBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
       	if (error == nil)
       	{
       		NSLog(@"%@", auth);

       		if (callback)
       		{
       			NSLog(@"Call callback(true) on auth()");
       			callback(true);
       		}
       	}
       	else
       	{
       		NSLog(@"Failed in calling auth()");

       		// callback with failure
       		if (callback)
       		{
       			NSLog(@"Call callback(false) on auth()");
       			callback(false);
       		}
       	}
    }];
}

void _renew(const char* apikey, const char* apisecret, OnResult callback) {
	[[Playbasis sharedPB] renewWithApiKeyAsync:CreateNSString(apikey) apiSecret:CreateNSString(apisecret) andBlock:^(PBAuth_Response* auth, NSURL* url, NSError *error) {
		if (error == nil)
		{
			NSLog(@"%@", auth);

			if (callback)
			{
				callback(true);
			}
		}
		else
		{
			if (callback)
			{
				callback(false);
			}
		}
	}];
}

void _login(const char* playerId, OnResult callback)
{
	[[Playbasis sharedPB] loginPlayerAsync:CreateNSString(playerId) options:nil withBlock:^(PBResultStatus_Response *result, NSURL *url, NSError *error) {
        if (error == nil)
        {
            NSLog(@"%@", result);
            
            if (callback)
            {
                callback(true);
            }
        }
        else
        {
            if (callback)
            {
                callback(false);
            }
        }
    }];
}

void _logout(const char* playerId, OnResult callback)
{
    [[Playbasis sharedPB] logoutPlayer:CreateNSString(playerId) sessionId:nil withBlock:^(PBResultStatus_Response* result, NSURL* url, NSError *error) {
		if (error == nil)
		{
			NSLog(@"%@", result);

			if (callback)
			{
				callback(true);
			}
		}
		else
		{
			if (callback)
			{
				callback(false);
			}
		}
	}];
}

void _register(const char* playerId, const char* userName, const char* email, const char* imageUrl, OnResult callback)
{
	[[Playbasis sharedPB] registerUserWithPlayerIdAsync:CreateNSString(playerId) username:CreateNSString(userName) email:CreateNSString(email) imageUrl:CreateNSString(imageUrl) andBlock:^(PBResultStatus_Response* result, NSURL* url, NSError *error) {
		if (error == nil)
		{
			NSLog(@"Registered a new user successfully.");

			callback(true);
		}
		else
		{
			if (callback)
			{
				callback(false);
			}
		}
	}];
}

void _playerPublic(const char* playerId, OnDataResult callback) {
	[[Playbasis sharedPB] playerPublicAsync:CreateNSString(playerId) withBlock:^(PBPlayerPublic_Response *playerResponse, NSURL *url, NSError *error) {
		if (error == nil)
		{
			playerPublic data;
			PopulateData(responseType_playerPublic, playerResponse, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _player(const char* playerId, OnDataResult callback)
{
	[[Playbasis sharedPB] playerAsync:CreateNSString(playerId) withBlock:^(PBPlayer_Response * p, NSURL *url, NSError *error) {
		if (error == nil)
		{
			player data;
			PopulateData(responseType_player, p, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _pointOfPlayer(const char* playerId, const char* pointName, OnDataResult callback)
{
	[[Playbasis sharedPB] pointOfPlayerAsync:CreateNSString(playerId) forPoint:CreateNSString(pointName) withBlock:^(PBPoint_Response * points, NSURL *url, NSError *error) {
		if (error == nil)
		{
            pointR data;
			PopulateData(responseType_point, points, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizList(OnDataResult callback)
{
	[[Playbasis sharedPB] quizListWithBlockAsync:^(PBActiveQuizList_Response * activeQuizList, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quizList data;
			PopulateData(responseType_activeQuizList, activeQuizList, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizListOfPlayer(const char* playerId, OnDataResult callback)
{
    [[Playbasis sharedPB] quizListOfPlayerAsync:CreateNSString(playerId) type:nil tags:nil withBlock:^(PBActiveQuizList_Response * activeQuizList, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quizList data;
			PopulateData(responseType_activeQuizList, activeQuizList, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizDetail(const char* quizId, const char* playerId, OnDataResult callback)
{
	[[Playbasis sharedPB] quizDetailAsync:CreateNSString(quizId) forPlayer:CreateNSString(playerId) withBlock:^(PBQuizDetail_Response * quizDetail, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quiz data;
			PopulateData(responseType_quizDetail, quizDetail, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizRandom(const char* playerId, OnDataResult callback)
{
	[[Playbasis sharedPB] quizRandomForPlayerAsync:CreateNSString(playerId) withBlock:^(PBQuizRandom_Response * quizRandom, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quizBasic data;
			PopulateData(responseType_quizRandom, quizRandom, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizDoneList(const char* playerId, int limit, OnDataResult callback)
{
	[[Playbasis sharedPB] quizDoneForPlayerAsync:CreateNSString(playerId) limit:limit withBlock:^(PBQuizDoneList_Response * qlist, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quizDoneList data;
			PopulateData(responseType_quizDoneListByPlayer, qlist, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizPendingList(const char* playerId, int limit, OnDataResult callback)
{
	[[Playbasis sharedPB] quizPendingOfPlayerAsync:CreateNSString(playerId) limit:limit withBlock:^(PBQuizPendings_Response * response, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quizPendingList data;
			PopulateData(responseType_quizPendingsByPlayer, response, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizQuestion(const char* quizId, const char* playerId, OnDataResult callback)
{
	[[Playbasis sharedPB] quizQuestionAsync:CreateNSString(quizId) forPlayer:CreateNSString(playerId) withBlock:^(PBQuestion_Response * q, NSURL *url, NSError *error) {
		if (error == nil)
		{
			question data;
			PopulateData(responseType_questionFromQuiz, q, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizAnswer(const char* quizId, const char* optionId, const char* playerId, const char* questionId, OnDataResult callback)
{
	[[Playbasis sharedPB] quizAnswerAsync:CreateNSString(quizId) optionId:CreateNSString(optionId) forPlayer:CreateNSString(playerId) ofQuestionId:CreateNSString(questionId) withBlock:^(PBQuestionAnswered_Response * q, NSURL *url, NSError *error) {
		if (error == nil)
		{
			questionAnswered data;
			PopulateData(responseType_questionAnswered, q, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _rule(const char* playerId, const char* action, OnDataResult callback)
{
	[[Playbasis sharedPB] ruleForPlayerAsync:CreateNSString(playerId) action:CreateNSString(action) withBlock:^(PBRule_Response * response, NSURL *url, NSError *error) {
		if (error == nil)
		{
			rule data;
			PopulateData(responseType_rule, response, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}, nil];
}

void _ruleWithUrl(const char* playerId, const char* action, const char* url, OnDataResult callback) {
	[[Playbasis sharedPB] ruleForPlayerAsync:CreateNSString(playerId) action:CreateNSString(action) withBlock:^(PBRule_Response * response, NSURL *url, NSError *error) {
		if (error == nil)
		{
			rule data;
			PopulateData(responseType_rule, response, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}, [NSString stringWithFormat:@"url=%@", url], nil];
}

void _setServerUrl(const char* url)
{
    [Playbasis setServerUrl:CreateNSString(url)];
}

const char* _getServerUrl()
{
    return MakeStringCopy([[Playbasis getServerUrl] UTF8String]);
}

void _setServerAsyncUrl(const char* url)
{
    [Playbasis setServerAsyncUrl:CreateNSString(url)];
}

const char* _getServerAsyncUrl()
{
    return MakeStringCopy([[Playbasis getServerAsyncUrl] UTF8String]);
}

void _badges(OnDataResult callback)
{
    [[Playbasis sharedPB] badgesAsyncWithBlock:^(PBBadges_Response *response, NSURL *url, NSError *error) {
       if (error == nil)
       {
            badges data;
            PopulateData(responseType_badges, response, &data);

            if (callback)
            {
            	callback((void*)&data, -1);
            }
       }
       else
       {
            if (callback)
        	{
        		callback(nil, (int)error.code);
        	}
       }
    }];
}

void _badge(const char* badgeId, OnDataResult callback)
{
    [[Playbasis sharedPB] badgeAsync:CreateNSString(badgeId) withBlock:^(PBBadge_Response * response, NSURL *url, NSError *error) {
    	if (error == nil)
    	{
    		badge data;
    		PopulateData(responseType_badge, response, &data);
            
            if (callback)
            {
                callback((void*)&data, -1);
            }
    	}
    	else
    	{
    		if (callback)
    		{
    			callback(nil, (int)error.code);
    		}
    	}
    }];
}

void _goodsInfo(const char* goodsId, OnDataResult callback)
{
	[[Playbasis sharedPB] goodsAsync:CreateNSString(goodsId) withBlock:^(PBGoodsInfo_Response * response, NSURL *url, NSError *error) {
		if (error == nil)
		{
			goodsInfo data;
			PopulateData(responseType_goodsInfo, response, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _goodsInfoList(const char* playerId, OnDataResult callback)
{
	[[Playbasis sharedPB] goodsListAsync:CreateNSString(playerId) tags:nil withBlock:^(PBGoodsListInfo_Response * response, NSURL *url, NSError *error) {
		if (error == nil)
		{
			goodsInfoList data;
			PopulateData(responseType_goodsListInfo, response, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _questInfo(const char* questId, OnDataResult callback) {
	[[Playbasis sharedPB] questAsync:CreateNSString(questId) withBlock:^(PBQuestInfo_Response * response, NSURL *url, NSError *error) {
		if (error == nil) {
			questInfo data;
			PopulateData(responseType_questInfo, response, &data);
			
			if (callback) {
				callback((void*)&data, -1);
			}
		}
		else {
			if (callback) {
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _questInfoList(OnDataResult callback)
{
    [[Playbasis sharedPB] questListWithBlockAsync:^(PBQuestList_Response *response, NSURL *url, NSError *error) {
        if (error == nil) {
            questInfoList data;
			PopulateData(responseType_questList, response, &data);
			
			if (callback) {
				callback((void*)&data, -1);
			}
        }
		else {
			if (callback) {
				callback(nil, (int)error.code);
			}
		}
    }];
}

void _missionInfo(const char* questId, const char* missionId, OnDataResult callback) {
	[[Playbasis sharedPB] missionAsync:CreateNSString(missionId) ofQuest:CreateNSString(questId) withBlock:^(PBMissionInfo_Response * response, NSURL *url, NSError *error) {
		if (error == nil) {
			missionInfo data;
			PopulateData(responseType_missionInfo, response, &data);
			
			if (callback) {
				callback((void*)&data, -1);
			}
		}
		else {
			if (callback) {
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _questInfoListForPlayer(const char* playerId, OnDataResult callback) {
	[[Playbasis sharedPB] questListAvailableForPlayerAsync:CreateNSString(playerId) withBlock:^(PBQuestListAvailableForPlayer_Response * response, NSURL *url, NSError *error) {
		if (error == nil) {
			questInfoList data;
			PopulateData(responseType_questListAvailableForPlayer, response, &data);
			
			if (callback) {
				callback((void*)&data, -1);
			}
		}
		else {
			if (callback) {
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _questAvailableForPlayer(const char* questId, const char* playerId, OnDataResult callback) {
	[[Playbasis sharedPB] questAvailableAsync:CreateNSString(questId) forPlayer:CreateNSString(playerId) withBlock:^(PBQuestAvailableForPlayer_Response * response, NSURL *url, NSError *error) {
		if (error == nil) {
			questAvailableForPlayer data;
			PopulateData(responseType_questAvailableForPlayer, response, &data);
			
			if (callback) {
				callback((void*)&data, -1);
			}
		}
		else {
			if (callback) {
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _joinQuest(const char* questId, const char* playerId, OnDataResult callback) {
	[[Playbasis sharedPB] joinQuestAsync:CreateNSString(questId) forPlayer:CreateNSString(playerId) withBlock:^(PBJoinQuest_Response * response, NSURL *url, NSError *error) {
		if (error == nil) {
			joinQuest data;
			PopulateData(responseType_joinQuest, response, &data);

			if (callback) {				
				callback((void*)&data, -1);
			}
		}
        else {
            if (callback) {
                callback(nil, (int)error.code);
            }
        }
	}];
}

void _joinAllQuests(const char* playerId, OnResult callback) {
	[[Playbasis sharedPB] joinAllQuestsForPlayerAsync:CreateNSString(playerId) withBlock:^(PBJoinAllQuests_Response * response, NSURL *url, NSError *error) {
		if (error == nil) {
			if (callback) {
				callback(true);
			}
		}
		else {
			if (callback) {
				callback(false);
			}
		}
	}];
}

void _cancelQuest(const char* questId, const char* playerId, OnDataResult callback) {
	[[Playbasis sharedPB] cancelQuestAsync:CreateNSString(questId) forPlayer:CreateNSString(playerId) withBlock:^(PBCancelQuest_Response * response, NSURL *url, NSError *error) {
		if (error == nil) {
			cancelQuest data;
			PopulateData(responseType_cancelQuest, response, &data);
			
			if (callback) {
				callback((void*)&data, -1);
			}
		}
		else {
			if (callback) {
				callback(nil, (int)error.code);
			}
		}
	}];
}