//
//  NSMutableArray+QueueAndSerializationAdditions.m
//  pblib
//
//  Modified code from https://github.com/esromneb/ios-queue-object
//
//  Created by haxpor on 1/22/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "NSMutableArray+QueueAndSerializationAdditions.h"

static NSString * const SAVEFILE_NAME = @"requests.pb";

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
    PBRequest *req = [self dequeue];
    
    // start sending request right away if founded a request object there
    if(req != nil)
    {
        // update state of request
        req.state = Started;
        
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
    
    // save to file
    if([NSKeyedArchiver archiveRootObject:requests toFile:appFile])
    {
        // remove all objects in a queue
        // this is for consistency
        [self removeAllObjects];
        
        NSLog(@"Successfully serialized and saved all requests to %@", SAVEFILE_NAME);
        return YES;
    }
    else
    {
        NSLog(@"Failed serializing and saving all requests to %@", SAVEFILE_NAME);
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
        NSLog(@"File didn't exist. Start fresh :)");
        return NO;
    }
    
    // unarchive requests into array
    NSMutableArray *requests = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
    
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
    
    // now we're done, then we need to remove file
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:appFile error:&error];
    if(success)
    {
        NSLog(@"Successfully loaded requests from %@", SAVEFILE_NAME);
        return YES;
    }
    else
    {
        NSLog(@"Failed loading requests file from %@, error: %@", SAVEFILE_NAME, [error localizedDescription]);
        return NO;
    }
}

@end
