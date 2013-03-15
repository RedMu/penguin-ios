//
//  PenguinService.h
//  iPenguin
//
//  Created by Dan Hall on 15/03/2013.
//  Copyright (c) 2013 Dan Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PenguinService <NSObject>

@required

-(BOOL)isAvailable;

-(NSArray *)getQueues;

-(NSArray *)getStoriesForQueue:(NSString *)queueId;
-(NSArray *)getStoriesPendingMergeForQueue:(NSString *)queueId;

-(NSDictionary *)getStoryDetails:(NSString *)storyId;

@end
