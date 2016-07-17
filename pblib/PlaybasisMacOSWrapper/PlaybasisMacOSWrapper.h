//
//  PlaybasisMacOSWrapper.h
//  PlaybasisMacOSWrapper
//
//  Created by Wasin Thonkaew on 7/14/16.
//
//


#if TARGET_OS_IOS
#import <UIKit/UIKit.h>

//! Project version number for PlaybasisWrapper.
FOUNDATION_EXPORT double PlaybasisWrapperVersionNumber;

//! Project version string for PlaybasisWrapper.
FOUNDATION_EXPORT const unsigned char PlaybasisWrapperVersionString[];
#endif

#import <PlaybasisMacOSWrapper/PlaybasisResponsesWrapper.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    /*
     Callback via result status
     */
    typedef void (* OnResult)(bool);
    
    /*
     Callback via data.
     If data is null, then there's error thus you should check error integer.
     Otherwise, ignore error integer.
     
     User should manually cast returned opaque data to appropriate type.
     */
    typedef void (* OnDataResult)(void*, int);
    
    /*
     List of fields and exposed methods from Playbasis class.
     */
    const char* _version();
    const char* _token();
    
    void _setServerUrl(const char* url);
    const char* _getServerUrl();
    void _setServerAsyncUrl(const char* url);
    const char* _getServerAsyncUrl();
    
    void _auth(const char* apikey, const char* apisecret, const char* bundleId, OnResult callback);
    void _renew(const char* apikey, const char* apisecret, OnResult callback);
    void _login(const char* playerId, OnResult callback);
    void _logout(const char* playerId, OnResult callack);
    void _register(const char* playerId, const char* userName, const char* email, const char* imageUrl, OnResult callback);
    void _playerPublic(const char* playerId, OnDataResult callback);
    void _player(const char* playerId, OnDataResult callback);
    void _pointOfPlayer(const char* playerId, const char* pointName, OnDataResult callback);
    void _quizList(OnDataResult callback);
    void _quizListOfPlayer(const char* playerId, OnDataResult callback);
    void _quizDetail(const char* quizId, const char* playerId, OnDataResult callback);
    void _quizRandom(const char* playerId, OnDataResult callback);
    void _quizDoneList(const char* playerId, int limit, OnDataResult callback);
    void _quizPendingList(const char* playerId, int limit, OnDataResult callback);
    void _quizQuestion(const char* quizId, const char* playerId, OnDataResult callback);
    void _quizAnswer(const char* quizId, const char* optionId, const char* playerId, const char* questionId, OnDataResult callback);
    void _rule(const char* playerId, const char* action, OnDataResult callback);
    void _ruleWithUrl(const char* playerId, const char* action, const char* url, OnDataResult callback);
    void _badges(OnDataResult callback);
    void _badge(const char* badgeId, OnDataResult callback);
    void _goodsInfo(const char* goodsId, OnDataResult callback);
    void _goodsInfoList(const char* playerId, OnDataResult callback);
    void _questInfo(const char* questId, OnDataResult callback);
    void _questInfoList(OnDataResult callback);
    void _missionInfo(const char* questId, const char* missionId, OnDataResult callback);
    void _questInfoListForPlayer(const char* playerId, OnDataResult callback);
    void _questAvailableForPlayer(const char* questId, const char* playerId, OnDataResult callback);
    void _joinQuest(const char* questId, const char* playerId, OnDataResult callback);
    void _joinAllQuests(const char* playerId, OnResult callback);
    void _cancelQuest(const char* questId, const char* playerId, OnDataResult callback);
    
#ifdef __cplusplus
}
#endif

