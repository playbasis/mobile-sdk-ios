//
//  OCMapperModelConfigurator.m
//  pblib
//
//  Created by Wasin Thonkaew on 7/17/16.
//
//

#import "OCMapperModelConfigurator.h"
#import "OCMapperConfigurable.h"
#import <OCMapper/OCMapper.h>
#import "Playbasis.h"

static NSString* const KEY = @"models";

@implementation OCMapperModelConfigurator

+(void)configure:(NSString *)plistFileName
{
    // read array of class name in .plist file
    NSBundle *bundle = [NSBundle bundleForClass:[Playbasis class]];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[bundle pathForResource:plistFileName ofType:@"plist"]];
    NSArray<NSString*> *classes = [dict objectForKey:KEY];
    
    InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
    [[ObjectMapper sharedInstance] setMappingProvider:mappingProvider];
    
    for(NSString *className in classes)
    {
        Class cls = NSClassFromString(className);
        if ([cls conformsToProtocol:@protocol(OCMapperConfigurable)])
        {
            [cls configure:mappingProvider];
        }
    }
}

@end
