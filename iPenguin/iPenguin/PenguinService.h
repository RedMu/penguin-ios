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
-(BOOL)shouldShowMerged;
-(void)setShouldShowMerged:(BOOL)showMerged;


-(NSArray *)getQueues;

-(NSArray *)getStoriesForQueue:(NSString *)queueId;
-(NSArray *)getStoriesPendingMergeForQueue:(NSString *)queueId;

-(NSDictionary *)getStoryDetailsForStory:(NSString *)storyId;

-(BOOL)deleteQueue:(NSString *)queueId;
-(BOOL)createQueue:(NSString *)queueName;

-(BOOL)createStory:(NSDictionary *)storyDetails InQueue:(NSString *)queueId;
-(BOOL)updateStory:(NSString *)storyId WithDetails:(NSDictionary *)storyDetails InQueue:(NSString *)queueId WithMergeStatus:(BOOL)merged;
-(BOOL)deleteStory:(NSString *)storyId ForQueue:(NSString *)queueId;

@end
