//
//  PBConstants.h
//  pblib
//
//  Created by Playbasis on 3/4/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#ifndef pblib_PBConstants_h
#define pblib_PBConstants_h

typedef enum : NSInteger {
    /** Invalid token key */
    PBERROR_INVALID_TOKEN = 900,
    
    /** Request exceeded. Too much request */
    PBERROR_REQUEST_EXCEEDED = 901,
    
    /** Token key required */
    PBERROR_TOKEN_REQUIRED = 902,
    
    /** Invalid parameter, must not be blank and special character. */
    PBERROR_PARAMETER_MISSING = 903,
    
    /** There is an internal server error */
    PBERROR_INTERNAL_ERROR = 800,
    
    /** Email error, canot send email */
    PBERROR_CANNOT_SEND_EMAIL = 801,
    
    /** Email error, all designated recipients are in black list */
    PBERROR_ALL_EMAILS_IN_BLACKLIST = 802,
    
    /** Email is already in black list */
    PBERROR_EMAIL_ALREADY_IN_BLACKLIST = 803,
    
    /** Email is not in black list */
    PBERROR_EMAIL_NOT_IN_BLACKLIST = 804,
    
    /** This Amazon SNS message type is not supported */
    PBERROR_UNKNOWN_SNS_MESSAGE_TYPE = 805,
    
    /** Unknown notification message */
    PBERROR_UNKNOWN_NOTIFICATION_MESSAGE = 806,
    
    /** Cannot verify the authenticity of PayPal IPN message */
    PBERROR_CANNOT_VERIFY_PAYPAL_IPN = 807,
    
    /** Invalid PayPal IPN */
    PBERROR_INVALID_PAYPAL_IPN = 808,
    
    /** Invalid API-KEY or API-SECRET */
    PBERROR_INVALID_API_KEY_OR_SECRET = 1,
    
    /** Can't access, permission denied */
    PBERROR_ACCESS_DENIED = 2,
    
    /** Limit exceeded, contact admin */
    PBERROR_LIMIT_EXCEED = 3,
    
    /** User doesn't exist */
    PBERROR_USER_NOT_EXIST = 200,
    
    /** User already exist */
    PBERROR_USER_ALREADY_EXIST = 201,
    
    /** User registration limit exceeded */
    PBERROR_TOO_MANY_USERS = 202,
    
    /** The user or reward type doesn't exceed */
    PBERROR_USER_OR_REWARD_NOT_EXIST = 203,
    
    /** cl_player_id format should be 0-9a-zA-Z_- */
    PBERROR_USER_ID_INVALID = 204,
    
    /** Phone number format should be +[countrycode][number] example +66861234567 */
    PBERROR_USER_PHONE_INVALID = 205,
    
    /** The user has no such reward */
    PBERROR_REWARD_FOR_USER_NOT_EXIST = 206,
    
    /** The user has not enough reward */
    PBERROR_REWARD_FOR_USER_NOT_ENOUGH = 207,
    
    /** Action not available */
    PBERROR_ACTION_NOT_FOUND = 301,
    
    /** Reward not available */
    PBERROR_REWARD_NOT_FOUND = 401,
    
    /** Goods not available */
    PBERROR_GOODS_NOT_FOUND = 501,
    
    /** User has exceeded redeem limit */
    PBERROR_OVER_LIMIT_REDEEM = 601,
    
    /** User has already joined this quest */
    PBERROR_QUEST_JOINED = 701,
    
    /** User has finished this quest */
    PBERROR_QUEST_FINISHED = 702,
    
    /** User has no permission to join this quest */
    PBERROR_QUEST_CONDITION = 703,
    
    /** User has not yet joined this quest */
    PBERROR_QUEST_CANCEL_FAILED = 704,
    
    /** Quest not found */
    PBERROR_QUEST_JOIN_OR_CANCEL_NOTFOUND = 705,
    
    /** Quiz not found */
    PBERROR_QUIZ_NOT_FOUND = 1001,
    
    /** Qustion not found */
    PBERROR_QUIZ_QUESTION_NOT_FOUND = 1002,
    
    /** Option not found */
    PBERROR_QUIZ_OPTION_NOT_FOUND = 1003,
    
    /** Question has already been completed by player */
    PBERROR_QUIZ_QUESTION_ALREADY_COMPLETED = 1004,
    
    /** Unknown */
    PBERROR_DEFAULT = 9999
} kPBErrorCode;

#endif
