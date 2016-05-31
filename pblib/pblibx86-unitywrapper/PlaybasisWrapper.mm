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
	[[Playbasis sharedPB] loginPlayerAsync:CreateNSString(playerId) withBlock:^(PBResultStatus_Response* result, NSURL* url, NSError *error) {
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
	[[Playbasis sharedPB] logoutPlayer:CreateNSString(playerId) withBlock:^(PBResultStatus_Response* result, NSURL* url, NSError *error) {
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
	[[Playbasis sharedPB] quizListOfPlayerAsync:CreateNSString(playerId) withBlock:^(PBActiveQuizList_Response * activeQuizList, NSURL *url, NSError *error) {
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
	[[Playbasis sharedPB] quizQuestionAsync:CreateNSString(playerId) forPlayer:CreateNSString(playerId) withBlock:^(PBQuestion_Response * q, NSURL *url, NSError *error) {
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