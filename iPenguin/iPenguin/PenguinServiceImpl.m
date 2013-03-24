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

#pragma mark - Configuration methods

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

#pragma mark - Queue methods

-(BOOL)deleteQueue:(NSString *)queueId
{
    NSString *identifier = [NSString stringWithFormat:@"/api/queue/%@", queueId];
    
    NSString *url = [[self getURL] stringByAppendingString:identifier];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"DELETE"];
    
    NSError *requestError;
    NSHTTPURLResponse *urlResponse = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if([urlResponse statusCode] == 204)
    {
        return YES;
    }
    return NO;
}

-(BOOL)createQueue:(NSString *)queueName
{
    
    NSString *identifier = @"/api/queues";
    
    NSString *url = [[self getURL] stringByAppendingString:identifier];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"POST"];
    
    NSData *body = [[@"name=" stringByAppendingString:queueName] dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:body];
    
    NSError *requestError;
    NSHTTPURLResponse *urlResponse = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if([urlResponse statusCode] == 201)
    {
        return YES;
    }
    return NO;

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

#pragma mark - Story methods

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

-(BOOL)createStory:(NSDictionary *)storyDetails InQueue:(NSString *)queueId
{
    
    NSString *identifierPrefix = @"/api/queue/";
    NSString *identifier = [[identifierPrefix stringByAppendingString:queueId] stringByAppendingString:@"/stories"];
    
    NSString *url = [[self getURL] stringByAppendingString:identifier];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"POST"];
    
    NSError *error;
    NSData *body = [NSJSONSerialization dataWithJSONObject:storyDetails
                                                       options:0
                                                         error:&error];
    
    
    [request setHTTPBody:body];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSError *requestError;
    NSHTTPURLResponse *urlResponse = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if([urlResponse statusCode] == 201)
    {
        return YES;
    }
    return NO;
}

-(BOOL)updateStory:(NSString *)storyId WithDetails:(NSDictionary *)storyDetails InQueue:(NSString *)queueId WithMergeStatus:(BOOL)merged
{
    NSString *identifierPrefix = @"/api/queue/";
    NSString *identifier = [[[identifierPrefix stringByAppendingString:queueId] stringByAppendingString:@"/story/"] stringByAppendingString:storyId];
    
    NSString *url = [[self getURL] stringByAppendingString:identifier];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"PUT"];
    
    NSError *error;
    NSData *body = [NSJSONSerialization dataWithJSONObject:storyDetails
                                                   options:0
                                                     error:&error];
    
    
    [request setHTTPBody:body];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSError *requestError;
    NSHTTPURLResponse *urlResponse = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if([urlResponse statusCode] != 204)
    {
        return NO;
    }
      
    ////////////MERGE STATUS//////////////////
    
    NSString *merge = merged ? @"/merge" : @"/unmerge";
    
    NSString *mergeUrl = [url stringByAppendingString:merge];
    
    NSMutableURLRequest *mergeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:mergeUrl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [mergeRequest setHTTPMethod: @"POST"];
    
    NSHTTPURLResponse *mergeResponse = nil;
    
    [NSURLConnection sendSynchronousRequest:mergeRequest returningResponse:&mergeResponse error:nil];
    
    
    if([mergeResponse statusCode] != 204)
    {
        return NO;
    }
    return YES;
}

-(BOOL)deleteStory:(NSString *)storyId ForQueue:(NSString *)queueId
{
    NSString *identifier = [NSString stringWithFormat:@"/api/queue/%@/story/%@", queueId, storyId];
    
    NSString *url = [[self getURL] stringByAppendingString:identifier];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"DELETE"];
    
    NSError *requestError;
    NSHTTPURLResponse *urlResponse = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if([urlResponse statusCode] == 204)
    {
        return YES;
    }
    return NO;
}



@end
