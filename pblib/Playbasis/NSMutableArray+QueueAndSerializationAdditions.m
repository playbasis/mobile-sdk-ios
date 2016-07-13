//
//  NSMutableArray+QueueAndSerializationAdditions.m
//  pblib
//
//  Modified code from https://github.com/esromneb/ios-queue-object
//
//  Created by Playbasis on 1/22/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "NSMutableArray+QueueAndSerializationAdditions.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "PBMacros.h"

static NSString * const SAVEFILE_NAME = @"requests.pb";
static NSString * const PASSWORD = @"Playbasis2015*_thsisfEiaslkfjslfIIDF";

@implementation NSMutableArray (QueueAndSerializationAdditions) 

// Add to the tail of the queue
-(void) enqueue: (id) anObject
{
    // Push the item in
    [self addObject: anObject];
}

// Grab the next item in the queue, if there is one
-(id) dequeue
{
    // Set aside a reference to the object to pass back
    id queueObject = nil;
    
    // Do we have any items?
    if ([self lastObject]) {
        // Pick out the first one
#if !__has_feature(objc_arc)
        queueObject = [[[self objectAtIndex: 0] retain] autorelease];
#else
        queueObject = [self objectAtIndex: 0];
#endif
        // Remove it from the queue
        [self removeObjectAtIndex: 0];
    }
    
    // Pass back the dequeued object, if any
    return queueObject;
}

-(id) dequeueAndStart
{
    PBRequestUnit *req = [self dequeue];
    
    // start sending request right away if founded a request object there
    if(req != nil)
    {
        // start a request
        [req start];
    }
    
    return req;
}

// Takes a look at an object at a given location
-(id) peek: (int) index
{
    // Set aside a reference to the peeked at object
    id peekObject = nil;
    // Do we have any items at all?
    if ([self lastObject]) {
        // Is this within range?
        if (index < [self count]) {
            // Get the object at this index
            peekObject = [self objectAtIndex: index];
        }
    }
	
    // Pass back the peeked at object, if any
    return peekObject;
}

// Let's take a look at the next item to be dequeued
-(id) peekHead
{
    // Peek at the next item
	return [self peek: 0];
}

// Let's take a look at the last item to have been added to the queue
-(id) peekTail
{
    // Pick out the last item
	return [self lastObject];
}

// Checks if the queue is empty
-(BOOL) empty
{
    return ([self lastObject] == nil);
}

-(BOOL)serializeAndSaveToFile
{
    // if there's no requests in the queue then return immediately
    if([self empty])
    {
        // treat it as success
        return true;
    }
    
    // get the path to write file to
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:SAVEFILE_NAME];
    
    // loop through all the requests from first to last item
    // as we need to preserve order
    NSMutableArray *requests = [NSMutableArray array];
    for (int i=0; i<self.count; i++)
    {
        [requests addObject:[self objectAtIndex:i]];
    }
    
    // save to data
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:requests];
    
    // error for encryption
    NSError *error;
    
    // encrypt data
    NSData *encryptedData = [RNEncryptor encryptData:archiveData withSettings:kRNCryptorAES256Settings password:PASSWORD error:&error];
    
    NSAssert(error == nil, @"There's error regarding encrypting data");
    
    // save to file
    if([encryptedData writeToFile:appFile atomically:YES])
    {
        // remove all objects in a queue
        // this is for consistency
        [self removeAllObjects];
        
        PBLOG(@"Successfully serialized and saved all requests to %@", SAVEFILE_NAME);
        return YES;
    }
    else
    {
        PBLOG(@"Failed serializing and saving all requests to %@", SAVEFILE_NAME);
        return NO;
    }
}

-(BOOL)load
{
    // get the path to write file to
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:SAVEFILE_NAME];
    
    // create a file manager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // check if file exists or not
    if(![fileManager fileExistsAtPath:appFile])
    {
        PBLOG(@"File didn't exist. Start fresh :)");
        return NO;
    }
    
    // error of decrypting data
    NSError *error;
    
    // read encrypted data
    NSData *encryptedData = [NSData dataWithContentsOfFile:appFile];
    // decrypt data
    NSData *decryptedData = [RNDecryptor decryptData:encryptedData withPassword:PASSWORD error:&error];
    
    NSAssert(error == nil, @"Decrypting data has an error");
    
    // unarchive requests into array
    NSMutableArray *requests = [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
    
    /**
     add those loaded items into queue
    
     Note: we *add* and not wipe out all requests residing in the queue
     this gives us some more control ie. client will be able to push auth() request
     at the first item (in ViewController class), then after application loaded requests
     from file successfully, it further continues the work from there with new token.
     
     This guaranteeds that each request will have token available before making a request
     even after the app started again after termination.
     */
    [self addObjectsFromArray:requests];
    
    // reuse error object
    error = nil;
    // now we're done, then we need to remove file
    BOOL success = [fileManager removeItemAtPath:appFile error:&error];
    if(success)
    {
        PBLOG(@"Successfully loaded requests from %@", SAVEFILE_NAME);
        return YES;
    }
    else
    {
        PBLOG(@"Failed loading requests file from %@, error: %@", SAVEFILE_NAME, [error localizedDescription]);
        return NO;
    }
}

@end
