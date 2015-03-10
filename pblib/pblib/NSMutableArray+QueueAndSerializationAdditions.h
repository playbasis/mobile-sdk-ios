//
//  NSMutableArray+QueueAndSerializationAdditions.h
//  pblib
//
//  Modified code from https://github.com/esromneb/ios-queue-object
//
//  Created by Playbasis on 1/22/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "PBRequestUnit.h"

@interface NSMutableArray (QueueAndSerializationAdditions)

-(id) dequeue;
-(id) dequeueAndStart;
-(void) enqueue:(id)obj;
-(id) peek:(int)index;
-(id) peekHead;
-(id) peekTail;
-(BOOL) empty;

/**
 @abstract Serialize all requests in this queue and save into file on local storage in Document directory.
 
 @returns YES if successfully serialized and saved to file, otherwise return NO.
 */
-(BOOL)serializeAndSaveToFile;

/**
 Load all saved serialized requests from file.
 
 @returns YES if successfully loaded, and deleted the file we load as to preserve consistency, otherwise return NO.
 */
-(BOOL)load;


@end