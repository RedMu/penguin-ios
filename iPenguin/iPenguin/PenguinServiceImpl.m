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
NSString *const STORY_TITLE = @"title";
NSString *const STORY_REFERENCE = @"reference";
NSString *const STORY_AUTHOR = @"author";
NSString *const STORY_MERGE = @"merged";

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

-(BOOL)shouldShowMerged
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.showMerged boolValue];
}

-(void)setShouldShowMerged:(BOOL)showMerged
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setShowMerged:[NSNumber numberWithBool:showMerged]];
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

-(NSArray *)getStoriesForQueue:(NSString *)queueId
{
    NSString *url = [[self getURL] stringByAppendingString:@"/api/queues"];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *tempStories = [NSMutableArray new];
    
    for (NSDictionary *queue in jsonObjects)
    {
        if([[queue objectForKey:QUEUE_ID] isEqualToString: queueId])
        {
            for (NSDictionary *story in [queue objectForKey:QUEUE_STORIES])
            {
                NSArray *keys = [NSArray arrayWithObjects:STORY_ID, STORY_REFERENCE, STORY_AUTHOR, STORY_MERGE, nil];
                
                NSArray *values = [NSArray arrayWithObjects:[story objectForKey:STORY_ID], [story objectForKey:STORY_REFERENCE], [story objectForKey:STORY_AUTHOR], [story objectForKey:STORY_MERGE], nil];
                
                NSDictionary *storyDetails = [NSDictionary dictionaryWithObjects: values forKeys: keys];
                
                [tempStories addObject:storyDetails];
            }
        }
    }
    return [[NSArray alloc] initWithArray:tempStories];
}

-(NSArray *)getStoriesPendingMergeForQueue:(NSString *)queueId
{
    NSString *url = [[self getURL] stringByAppendingString:@"/api/queues"];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *tempStories = [NSMutableArray new];
    
    for (NSDictionary *queue in jsonObjects)
    {
        if([[queue objectForKey:QUEUE_ID] isEqualToString: queueId])
        {
            for (NSDictionary *story in [queue objectForKey:QUEUE_STORIES])
            {
                if([[story objectForKey:STORY_MERGE] boolValue] == NO)
                {
                    NSArray *keys = [NSArray arrayWithObjects:STORY_ID, STORY_REFERENCE, STORY_AUTHOR, STORY_MERGE, nil];
                
                    NSArray *values = [NSArray arrayWithObjects:[story objectForKey:STORY_ID], [story objectForKey:STORY_REFERENCE], [story objectForKey:STORY_AUTHOR], [story objectForKey:STORY_MERGE], nil];
                
                    NSDictionary *storyDetails = [NSDictionary dictionaryWithObjects: values forKeys: keys];
                
                    [tempStories addObject:storyDetails];
                }
            }
        }
    }
    return [[NSArray alloc] initWithArray:tempStories];
}

-(NSDictionary *)getStoryDetailsForStory:(NSString *)storyId
{
    NSString *url = [[self getURL] stringByAppendingString:@"/api/queues"];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *queue in jsonObjects)
    {
        for (NSDictionary *story in [queue objectForKey:QUEUE_STORIES])
        {
            if([[story objectForKey:STORY_ID] isEqualToString:storyId])
            {
                
                NSArray *keys = [NSArray arrayWithObjects:STORY_ID, STORY_REFERENCE, STORY_AUTHOR, STORY_TITLE, STORY_MERGE, nil];
                
                NSArray *values = [NSArray arrayWithObjects:[story objectForKey:STORY_ID], [story objectForKey:STORY_REFERENCE], [story objectForKey:STORY_AUTHOR], [story objectForKey:STORY_TITLE], [story objectForKey:STORY_MERGE], nil];
                
                NSDictionary *storyDetails = [NSDictionary dictionaryWithObjects: values forKeys: keys];
                
                return storyDetails;
            }
        }
    }
    [NSException raise:@"Story not found" format:@"Story with id %@ could not be found", storyId];
    return nil;
}

@end
