//
//  NSMutableArray+QueueAndSerializationAdditions.h
//  pblib
//
//  Modified code from https://github.com/esromneb/ios-queue-object
//
//  Created by haxpor on 1/22/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "PBRequest.h"

@interface NSMutableArray (QueueAndSerializationAdditions)

-(id) dequeue;
-(id) dequeueAndStart;
-(void) enqueue:(id)obj;
-(id) peek:(int)index;
-(id) peekHead;
-(id) peekTail;
-(BOOL) empty;

/**
 Serialize all requests in this queue and save into file on local storage in Document directory.
 
 @return YES if successfully serialized and saved to file, otherwise return FALSE.
 */
-(BOOL)serializeAndSaveToFile;

/**
 Load all saved serialized requests from file.
 */
-(void)load;


@end