//
//  NewQueueViewController.h
//  iPenguin
//
//  Created by Dan Hall on 18/03/2013.
//  Copyright (c) 2013 Dan Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewQueueViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;

-(IBAction)cancel:(id)sender;
-(IBAction)save:(id)sender;

@end
