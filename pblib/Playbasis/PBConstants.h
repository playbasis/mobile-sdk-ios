//
//  PBConstants.h
//  pblib
//
//  Created by Playbasis on 3/4/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#ifndef pblib_PBConstants_h
#define pblib_PBConstants_h

typedef NS_ENUM (NSInteger, pbErrorCode) {
    /** Invalid token key */
    pbErrorCodeInvalidToken = 900,
    
    /** Request exceeded. Too much request */
    pbErrorCodeRequestExceeded = 901,
    
    /** Token key required */
    pbErrorCodeTokenRequired = 902,
    
    /** Invalid parameter, must not be blank and special character. */
    pbErrorCodeParameterMissing = 903,
    
    /** There is an internal server error */
    pbErrorCodeInternalError = 800,
    
    /** Email error, canot send email */
    pbErrorCodeCannotSentEmail = 801,
    
    /** Email error, all designated recipients are in black list */
    pbErrorCodeAllEmailsInBlacklist = 802,
    
    /** Email is already in black list */
    pbErrorCodeEmailAlreadyInBlacklist = 803,
    
    /** Email is not in black list */
    pbErrorCodeEmailNotInBlacklist = 804,
    
    /** This Amazon SNS message type is not supported */
    pbErrorCodeUnknownSNSMessageType = 805,
    
    /** Unknown notification message */
    pbErrorCodeUnknownNotificationMessage = 806,
    
    /** Cannot verify the authenticity of PayPal IPN message */
    pbErrorCodeCannotVerifyPaypalIPN = 807,
    
    /** Invalid PayPal IPN */
    pbErrorCodeInvalidPaypalIPN = 808,
    
    /** Invalid API-KEY or API-SECRET */
    pbErrorCodeInvalidApiKeyOrSecret = 1,
    
    /** Can't access, permission denied */
    pbErrorCodeAccessDenied = 2,
    
    /** Limit exceeded, contact admin */
    pbErrorCodeLimitExceeded = 3,
    
    /** User doesn't exist */
    pbErrorCodeUserNotExist = 200,
    
    /** User already exist */
    pbErrorCodeUserAlreadyExist = 201,
    
    /** User registration limit exceeded */
    pbErrorCodeTooManyUsers = 202,
    
    /** The user or reward type doesn't exceed */
    pbErrorCodeUserOrRewardNotExist = 203,
    
    /** cl_player_id format should be 0-9a-zA-Z_- */
    pbErrorCodeUserIdInvalid = 204,
    
    /** Phone number format should be +[countrycode][number] example +66861234567 */
    pbErrorCodeUserPhoneInvalid = 205,
    
    /** The user has no such reward */
    pbErrorCodeRewardForUserNotExist = 206,
    
    /** The user has not enough reward */
    pbErrorCodeRewardForUserNotEnough = 207,
    
    /** Action not available */
    pbErrorCodeActionNotFound = 301,
    
    /** Reward not available */
    pbErrorCodeRewardNotFound = 401,
    
    /** Goods not available */
    pbErrorCodeGoodsNotFound = 501,
    
    /** User has exceeded redeem limit */
    pbErrorCodeOverLimitRedeem = 601,
    
    /** User has already joined this quest */
    pbErrorCodeQuestAlreadyJoined = 701,
    
    /** User has finished this quest */
    pbErrorCodeQuestAlreadyFinished = 702,
    
    /** User has no permission to join this quest */
    pbErrorCodeQuestNotEnoughPermissionToJoinQuest = 703,
    
    /** User has not yet joined this quest */
    pbErrorCodeNotYetJoinQuest = 704,
    
    /** Quest not found */
    pbErrorCodeQuestJoinOrCancelNotFound = 705,
    
    /** Quiz not found */
    pbErrorCodeQuizNotFound = 1001,
    
    /** Qustion not found */
    pbErrorCodeQuizQuestionNotFound = 1002,
    
    /** Option not found */
    pbErrorCodeQuizOptionNotFound = 1003,
    
    /** Question has already been completed by player */
    pbErrorCodeQuizQuestionAlreadyCompleted = 1004,
    
    /** Unknown */
    pbErrorCodeUnknown = 9999
};

#endif
