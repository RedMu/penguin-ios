//
//  PenguinServiceImpl.h
//  iPenguin
//
//  Created by Dan Hall on 15/03/2013.
//  Copyright (c) 2013 Dan Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PenguinService.h"

@interface PenguinServiceImpl : NSObject <PenguinService>

FOUNDATION_EXPORT NSString *const QUEUE_ID;
FOUNDATION_EXPORT NSString *const QUEUE_NAME;
FOUNDATION_EXPORT NSString *const QUEUE_STORIES;

FOUNDATION_EXPORT NSString *const STORY_ID;
FOUNDATION_EXPORT NSString *const STORY_TITLE;
FOUNDATION_EXPORT NSString *const STORY_AUTHOR;
FOUNDATION_EXPORT NSString *const STORY_MERGE;

FOUNDATION_EXPORT NSString *const QUEUE_PENDING_MERGE_COUNT;
@end
