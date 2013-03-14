//
//  StoryDetailsViewController.h
//  iPenguin
//
//  Created by Dan Hall on 13/03/2013.
//  Copyright (c) 2013 Dan Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryDetailsViewController : UITableViewController

@property (strong, nonatomic) NSString *reference;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *merged;

@end
