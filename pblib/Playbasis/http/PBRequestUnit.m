//
//  PBRequestUnit.m
//  pblib
//
//  Created by Playbasis on 1/22/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "PBRequestUnit.h"
#import "Playbasis.h"
#import <OCMapper/OCMapper.h>
#import "CustomDeviceInfoHttpHeaderFields.h"
#import "PBUtils.h"
#import "PBSettings.h"
#import "PBValidator.h"
#import "PBTypes.h"
#import "PBSuccessStatus.h"
#import "JSONKit.h"

static NSString * const KEY_URLREQUEST = @"urlRequest";
static NSString * const KEY_RECEIVEDDATA = @"receivedData";
static NSString * const KEY_JSONRESPONSE = @"jsonResponse";
static NSString * const KEY_STATE = @"state";
static NSString * const KEY_ISSYNCURLREQUEST = @"isSyncURLRequest";
static NSString * const KEY_RESULTCLASS = @"resultClass";

@interface PBRequestUnit ()
{
    NSURLRequest *_urlRequest;
    NSMutableData *_receivedData;
    NSDictionary *_jsonResponse;
    NSUInteger _retryCount;
    
    Class _resultClass;
    CustomDeviceInfoHttpHeaderFields *_customDeviceInfoHttpHeaderFieldsVar;
    NSString *_jsonResultSubKey;
}
@end

@implementation PBRequestUnit

@synthesize state = _state;
@synthesize isSyncURLRequest = _isSyncURLRequest;

-(instancetype)initWithMethodWithApikey:(NSString *)method withData:(NSString *)data isAsync:(BOOL)async completion:(void (^)(id, NSError *))completion forResultClass:(Class)objClass
{
    if (!(self = [super init]))
        return nil;
    
    // create url request
    NSURLRequest *urlRequest = [self createUrlRequestFromMethodWithApiKey:method withData:data isAsync:async];

    // set state of this request unit
    _urlRequest = urlRequest;
    _receivedData = [NSMutableData data];
    _retryCount = 0;
    _isSyncURLRequest = !async;
    _state = pbRequestUnitStateReadyToStart;
    _completion = completion;
    _resultClass = objClass;
    
    return self;
}

-(instancetype)initWithMethodWithApikey:(NSString *)method withData:(NSString *)data isAsync:(BOOL)async completion:(void (^)(id, NSError *))completion withJsonResultSubKey:(NSString *)jsonSubKey forResultClass:(Class)objClass
{
    if (!(self = [super init]))
        return nil;
    
    self = [self initWithMethodWithApikey:method withData:data isAsync:async completion:completion forResultClass:objClass];
    _jsonResultSubKey = jsonSubKey;
    
    return self;
}

- (NSURLRequest *)createUrlRequestFromMethodWithApiKey:(NSString *)method withData:(NSString *)data isAsync:(BOOL)async
{
    NSMutableURLRequest *request = nil;
    NSURL* url = nil;
    if(async)
    {
        url = [NSURL URLWithString:BASE_ASYNC_URL];
    }
    else
    {
        url = [NSURL URLWithString:[BASE_URL stringByAppendingString:method]];
    }
    
    // form the data
    if(data == nil)
    {
        request = [NSMutableURLRequest requestWithURL:url];
        PBLOG(@"Get request");
    }
    else
    {
        request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        
        // if for async then we send it as json
        NSString *reformedData = data;
        if(async)
        {
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            // form async data
            reformedData = [self createAsyncDataFromMethodWithApiKey:method andData:data];
        }
        // otherwise send it as http post data
        else
        {
            [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        }
        
        // at this point data is proper one
        NSData *postData = [reformedData dataUsingEncoding:NSUTF8StringEncoding];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        PBLOG(@"Post request");
    }
    
    // set custom headers to url request
    CustomDeviceInfoHttpHeaderFields *headers = [[CustomDeviceInfoHttpHeaderFields alloc] initWithDefault];
    [headers setUrlRequestHeaders:request];
    
    return request;
}

-(NSString *)createAsyncDataFromMethodWithApiKey:(NSString*)method andData:(NSString *)data
{
    // create json data object
    // we will set object for each field in the loop
    NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
    
    // split all params from data
    NSArray *linesWithEqualSign = [data componentsSeparatedByString:@"&"];
    for(NSString *lineWithEqualSign in linesWithEqualSign)
    {
        NSArray *fieldAndValue = [lineWithEqualSign componentsSeparatedByString:@"="];
        
        // set into dict
        [dictData setValue:(NSString*)[fieldAndValue objectAtIndex:1] forKey:[fieldAndValue objectAtIndex:0]];
    }
    
    // package into format
    NSMutableDictionary *dictWholeData = [NSMutableDictionary dictionary];
    [dictWholeData setObject:method forKey:@"endpoint"];
    [dictWholeData setObject:dictData forKey:@"data"];
    [dictWholeData setObject:@"nil" forKey:@"channel"];
    
    // get json string
    NSString *dataFinal = [dictWholeData JSONString];
    PBLOG(@"jsonString = %@", dataFinal);
    
    return dataFinal;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];

    _urlRequest = [decoder decodeObjectForKey:KEY_URLREQUEST];
    _receivedData = [decoder decodeObjectForKey:KEY_RECEIVEDDATA];
    _jsonResponse = [decoder decodeObjectForKey:KEY_JSONRESPONSE];
    _state = [decoder decodeIntForKey:KEY_STATE];
    _isSyncURLRequest = [decoder decodeBoolForKey:KEY_ISSYNCURLREQUEST];
    _resultClass = [decoder decodeObjectForKey:KEY_RESULTCLASS];
    
    //*we have no need to de-serialize completion handler, as we just want to execute api call
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_urlRequest forKey:KEY_URLREQUEST];
    [encoder encodeObject:_receivedData forKey:KEY_RECEIVEDDATA];
    [encoder encodeObject:_jsonResponse forKey:KEY_JSONRESPONSE];
    [encoder encodeInt:_state forKey:KEY_STATE];
    [encoder encodeBool:_isSyncURLRequest forKey:KEY_ISSYNCURLREQUEST];
    [encoder encodeObject:_resultClass forKey:KEY_RESULTCLASS];
    
    //*we have no need to serialize completion handler, as we just want to execute api call
}

-(NSDictionary *)getResponse
{
    return _jsonResponse;
}

-(void)responseAsyncURLRequestFromStringResponse:(NSString *)strResponse error:(NSError*)error
{
    //* the code in this section is in secondary thread (not UI thread)
    // for async url request
    // success message contains only "OK", otherwise regards it as failure
    if(strResponse != nil && [strResponse isEqualToString:@"OK"] && error == nil)
    {
        [self responseFromBool:YES error:nil];
    }
    else
    {
        // if there's connection error, then use its object to send to back to response
        if(error)
        {
            // if retry count doesn't reach the limit then retry
            if(_retryCount <= pbRequestRetryCount)
            {
                PBLOG(@"Waiting to make a request to %@ for duration of %.2f", [_urlRequest URL], pbDelayAmountBeforeNextRequestRetry / 1000.0f);
                
                // sleep the current thread that this request is on for set amount of time
                [NSThread sleepForTimeInterval:pbDelayAmountBeforeNextRequestRetry / 1000.0f];
                
                // if network can be reached then retry
                if([Playbasis sharedPB].isNetworkReachable)
                {
                    // after sleep for certain amount of time, then restart the request again
                    PBLOG(@"Retry sending request to %@", [_urlRequest URL]);
                    [self start];
                }
                // otherwise, break out the retry-loop, then save to local storage
                else
                {
                    PBLOG(@"Break out of the loop, and save it into local storage");
                    [[[Playbasis sharedPB] getRequestOperationalQueue] enqueue:self];
                    
                    PBLOG(@"Queue size = %lu", (unsigned long)[[[Playbasis sharedPB] getRequestOperationalQueue] count]);
                }
            }
            else
            {
                // response with fail
                [self responseFromBool:NO error:error];
            }
        }
        else
        {
            PBLOG(@"Give up retrying, sending back error for %@.", [_urlRequest URL]);
            
            // create an error message directly from the response back
            NSString *errorMessage = strResponse != nil && ![strResponse isEqualToString:@""] ? strResponse : [NSString stringWithFormat:@"There's error from async url request %@", [_urlRequest URL]];
            
            // create an userInfo for NSError
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString([NSString stringWithString:errorMessage], nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString([NSString stringWithString:errorMessage], nil)
                                       };
            
            // use default value of error code from Playbasis's domain
            NSInteger nserrorErrorCode = pbErrorCodeUnknown;
            
            // create an NSError
            NSError *userError = [NSError errorWithDomain:@"com.playbasis.ios.playbasissdk" code:nserrorErrorCode userInfo:userInfo];
            
            // response with fail
            [self responseFromBool:NO error:userError];
        }
    }
}

/**
 Validate resulting json response, and call a proper completion handler

 @param jsonResponse resulting json response
 */
-(void)validateAndCall:(NSDictionary *)jsonResponse
{
    // we need to check the error code, and success flag from json-response first before dispatch out either for success or failure
    // check "error_code" and "success"
    BOOL success = [[jsonResponse objectForKey:@"success"] boolValue];
    // get error code from this json message
    NSString *errorCode = [jsonResponse objectForKey:@"error_code"];
    
    PBLOG(@"request success? [%@]", success ? @"YES" : @"NO");
    
    // success
    if(success && [errorCode isEqualToString:@"0000"])
    {
        // if it's type of success response
        if ([NSStringFromClass([_resultClass class]) isEqualToString:NSStringFromClass([PBSuccessStatus class])])
        {
            [self responseFromBool:YES error:nil];
        }
        else
        {
            // response success with actual 'response' data in json level
            NSDictionary *result = [jsonResponse objectForKey:@"response"];
            if ([PBValidator isValidString:_jsonResultSubKey])
                result = [result objectForKey:_jsonResultSubKey];
            [self responseFromJsonResponse:result error:nil];
        }
    }
    else
    {
        PBLOG(@"Give up retrying, sending back error for %@.", [_urlRequest URL]);
        
        // get error message
        NSString *errorMessage = [jsonResponse objectForKey:@"message"];
        
        // create an userInfo for NSError
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString([NSString stringWithString:errorMessage], nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString([NSString stringWithString:errorMessage], nil)
                                   };
        
        // convert errorCode from Playbasis platform
        NSInteger nserrorErrorCode = [errorCode integerValue];
        
        // create an NSError
        NSError *error = [NSError errorWithDomain:@"com.playbasis.ios.playbasissdk" code:nserrorErrorCode userInfo:userInfo];
        
        // response with fail
        // if it's type of success response
        if ([NSStringFromClass([_resultClass class]) isEqualToString:NSStringFromClass([PBSuccessStatus class])])
        {
            [self responseFromBool:NO error:error];
        }
        else
        {
            [self responseFromJsonResponse:nil error:error];
        }
    }
}

-(void)responseFromJsonResponse:(NSDictionary *)jsonResponse error:(NSError *)error
{
    PBLOG(@"check _resultClass == nil? [%@]", _resultClass == nil ? @"YES" : @"NO");
    
    if (_resultClass != nil)
    {
        id result = nil;
        if (error == nil)
        {
            // either object returned is NSArray<>, or model class
            result = [_resultClass objectFromDictionary:jsonResponse];
        }
        
        PBLOG(@"check _completion == nil? [%@]", _completion == nil ? @"YES" : @"NO");
        if (_completion != nil)
        {
            PBLOG(@"execute inside if statement of _completion != nil");
            _completion(result, error);
        }
    }
}

-(void)responseFromBool:(BOOL)success error:(NSError *)error
{
    if (_completion != nil && _resultClass != nil)
    {
        _completion([[PBSuccessStatus alloc] initWithBool:success], error);
    }
}

-(void)start
{
    // set to proper state
    _state = pbRequestUnitStateStarted;
    
    // increase the number of retry-count
    _retryCount++;
    
    // debug only: only print out for the first try
#if DEBUG
    if(_retryCount == 1)
    {
        PBLOG(@"Sending request for %@", [_urlRequest URL]);
    }
#endif
    
    // send async request
    [NSURLConnection sendAsynchronousRequest:_urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // if it's sync url request
        if(_isSyncURLRequest)
        {
            // if there's no error
            if(error == nil)
            {
                // set to a proper state
                _state = pbRequestUnitStateFinished;
                
                // convert data into dictionary
                _jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                
                // validate json response before sending back to user's callback
                [self validateAndCall:_jsonResponse];
            }
            // otherwise, there's an error
            else
            {
                // set to a proper state
                _state = pbRequestUnitStateFinishedWithError;
                
                // response fail
                [self responseFromJsonResponse:nil error:error];
            }
        }
        // it's async url request
        else
        {
            // if there's no error
            if(error == nil)
            {
                // set to a proper state
                _state = pbRequestUnitStateFinished;
                
                // convert data into string
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                // response to async url request
                [self responseAsyncURLRequestFromStringResponse:responseString error:nil];
            }
            // otherwise, there's an error
            else
            {
                // set to a proper state
                _state = pbRequestUnitStateFinishedWithError;
                
                // response fail
                [self responseAsyncURLRequestFromStringResponse:nil error:error];
            }
        }
    }];
}

@end
