//
//  StoryDetailsViewController.h
//  iPenguin
//
//  Created by Dan Hall on 13/03/2013.
//  Copyright (c) 2013 Dan Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryDetailsViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) NSString *storyId;
@property (strong, nonatomic) NSString *queueId;

-(IBAction)save:(id)sender;

@end
