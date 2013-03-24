//
//  StoryViewController.m
//  iPenguin
//
//  Created by Dan Hall on 25/02/2013.
//  Copyright (c) 2013 Dan Hall. All rights reserved.
//

#import "StoryViewController.h"
#import "StoryDetailsViewController.h"
#import "PenguinServiceImpl.h"
#import <QuartzCore/QuartzCore.h>
#import "LoadingIndicator.h"

@interface StoryViewController ()

@end

@implementation StoryViewController

@synthesize queueId;

NSArray *stories;
NSNumber *deleteStoryIndex;
NSObject<PenguinService> *service;

UIView *loadingView;
UILabel *loadingLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    service = [PenguinServiceImpl new];
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 210, 75)];
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    loadingView.clipsToBounds = YES;
    loadingView.layer.cornerRadius = 10.0;
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 190, 50)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.numberOfLines = 2;
    loadingLabel.lineBreakMode = UILineBreakModeWordWrap;
    [loadingView addSubview:loadingLabel];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    LoadingIndicator *loadingIndicator = [[LoadingIndicator alloc] init];
    [self.view addSubview:loadingIndicator];
    
    if([service shouldShowMerged] == YES)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            stories = [service getStoriesForQueue:queueId];
            [self.tableView reloadData];
            [loadingIndicator removeFromSuperview];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            stories = [service getStoriesPendingMergeForQueue:queueId];
            [self.tableView reloadData];
            [loadingIndicator removeFromSuperview];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"existing"])
    {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    
        [segue.destinationViewController setStoryId:[[stories objectAtIndex:[indexPath row]] objectForKey:STORY_ID]];
    }
    if ([segue.identifier isEqualToString:@"new"])
    {
        [segue.destinationViewController setStoryId:nil];
    }

    [segue.destinationViewController setQueueId:queueId];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [stories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    cell.textLabel.text = [[stories objectAtIndex:indexPath.row] objectForKey:STORY_REFERENCE];
    cell.detailTextLabel.text = [[stories objectAtIndex:indexPath.row] objectForKey:STORY_AUTHOR];
    
    
    
    if([[[stories objectAtIndex:indexPath.row] objectForKey:STORY_MERGE] boolValue] == YES)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            [self.view addSubview:loadingView];
            break;

        case UIGestureRecognizerStateChanged:
            if(recognizer.scale > 1)
            {
                [loadingLabel setText:@"Show pending and merged stories"];
            }
            else
            {
                [loadingLabel setText:@"Show only stories pending merge"];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            [loadingView removeFromSuperview];
            if(recognizer.scale > 1)
            {
                [service setShouldShowMerged:YES];
            }
            else
            {
                [service setShouldShowMerged:NO];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self viewDidAppear:YES];
            });
            break;
    }

        
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {

    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 0:
            switch (buttonIndex) {
                case 0:
                {
                    LoadingIndicator *loadingIndicator = [[LoadingIndicator alloc] init];
                    [self.view addSubview:loadingIndicator];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSString *storyId = [[stories objectAtIndex:[deleteStoryIndex integerValue]] objectForKey:STORY_ID];
                        BOOL deleted = [service deleteStory:storyId ForQueue:queueId];
                        
                        if(deleted)
                        {
                            stories = [service getStoriesForQueue:queueId];
                            NSIndexPath *path = [NSIndexPath indexPathForRow:[deleteStoryIndex integerValue] inSection:0];
                            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
                        }
                        else
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete failed"
                                                                            message:@"Attempted to delete the story from the server but it failed"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }
                        
                        [loadingIndicator removeFromSuperview];
                        
                    });
                    
                }
                break;
            }
            break;
            
        default:
            break;
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        deleteStoryIndex = [NSNumber numberWithInteger:indexPath.row];
        NSString *storyRef = [[stories objectAtIndex:indexPath.row] objectForKey:STORY_REFERENCE];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                        message:[NSString stringWithFormat:@"Are you sure you want to delete %@?  Once it's gone, it's gone!", storyRef]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"Cancel", nil];
        
        [alert setTag:0];
        [alert show];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
