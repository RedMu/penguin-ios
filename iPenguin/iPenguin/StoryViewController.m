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

@interface StoryViewController ()

@end

@implementation StoryViewController

@synthesize queue;

NSArray *stories;
PenguinServiceImpl *service;

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
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 190, 22)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.text = @"Show/hide merged stories";
    [loadingView addSubview:loadingLabel];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    if([service shouldShowMerged] == YES)
    {
        stories = [service getStoriesForQueue:queue];
    }
    else
    {
        stories = [service getStoriesPendingMergeForQueue:queue];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    
    [segue.destinationViewController setStoryId:[[stories objectAtIndex:[indexPath row]] objectForKey:STORY_ID]];
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
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        [self.view addSubview:loadingView];
    }
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [loadingView removeFromSuperview];
        if(recognizer.scale > 1)
        {
            [service setShouldShowMerged:YES];
        }
        else
        {
            [service setShouldShowMerged:NO];
        }
        [self viewWillAppear:YES];
        [self.tableView reloadData];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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
