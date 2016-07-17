//
//  PBPlayerApi.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/16/16.
//
//

#import "PBPlayerApi.h"
#import "Playbasis.h"
#import "../helper/PBValidator.h"

@implementation PBPlayerApi

+(void)playerPublic:(Playbasis *)playbasis playerId:(NSString *)playerId andCompletion:(void (^)(PBPlayer *, NSError *))completion
{
    if (![PBValidator isValid:playbasis])
        [NSException raise:@"playbasis instance is neeed" format:@"playabsis instance cannot be nil"];
    
    NSString *method = [[PBUtils sharedInstance] createMethodWithApiKeyUrlFromMethod:[NSString stringWithFormat:@"Player/%@", playerId] andApiKey:playbasis.apiKey];
    
    PBRequestUnit<PBPlayer*> *request = [[PBRequestUnit<PBPlayer*> alloc] initWithMethodWithApikey:method withData:nil isAsync:NO completion:completion withJsonResultSubKey:@"player" forResultClass:[PBPlayer class]];
    
    [playbasis fireRequestIfNecessary:request];
}

@end
