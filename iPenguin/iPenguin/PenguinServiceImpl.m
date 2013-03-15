//
//  PenguinServiceImpl.m
//  iPenguin
//
//  Created by Dan Hall on 15/03/2013.
//  Copyright (c) 2013 Dan Hall. All rights reserved.
//

#import "PenguinServiceImpl.h"
#import "AppDelegate.h"

@implementation PenguinServiceImpl

NSString *const QUEUE_ID = @"_id";
NSString *const QUEUE_NAME = @"name";
NSString *const QUEUE_STORIES = @"stories";

NSString *const STORY_ID = @"_id";
NSString *const STORY_TITLE;
NSString *const STORY_AUTHOR;
NSString *const STORY_MERGE;

NSString *const QUEUE_PENDING_MERGE_COUNT = @"pendingMerge";

-(BOOL)isAvailable
{
    if([self getURL] == nil)
    {
        return NO;
    }
    return YES;
}

-(NSString *)getURL
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.url;
}

-(NSArray *)getQueues
{
    NSString *url = [[self getURL] stringByAppendingString:@"/api/queues"];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *tempQueues = [NSMutableArray new];
    
    for (NSDictionary *queue in jsonObjects) {
        
        int pendingMerge = 0;
        for (NSDictionary *story in [queue objectForKey:QUEUE_STORIES])
        {
            if([[story objectForKey:STORY_MERGE] boolValue] == NO)
            {
                pendingMerge++;
            }
        }
        
        NSArray *keys = [NSArray arrayWithObjects:QUEUE_ID, QUEUE_NAME, QUEUE_PENDING_MERGE_COUNT, nil];
        
        NSArray *values = [NSArray arrayWithObjects:[queue objectForKey:QUEUE_ID], [queue objectForKey:QUEUE_NAME], [NSNumber numberWithInt:pendingMerge], nil];
        
        NSDictionary *queueDetails = [NSDictionary dictionaryWithObjects: values forKeys: keys];
        [tempQueues addObject:queueDetails];
    }
    
    return [[NSArray alloc] initWithArray:tempQueues];
}



@end
