//
//  QueueViewController.m
//  iPenguin
//
//  Created by Dan Hall on 25/02/2013.
//  Copyright (c) 2013 Dan Hall. All rights reserved.
//

#import "QueueViewController.h"
#import "StoryViewController.h"
#import "PenguinServiceImpl.h"
#import "LoadingIndicator.h"

@interface QueueViewController ()

@end

@implementation QueueViewController

NSArray *queues;
NSNumber *deleteQueueIndex;
NSObject<PenguinService> *service;

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
    
    service = [[PenguinServiceImpl alloc] init];

}

- (void) viewDidAppear:(BOOL)animated
{
    if([service isAvailable] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Config missing"
                                                        message:@"No server was found, please select Config tab and enter server URL"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        queues = [NSArray new];
    }
    else
    {
        LoadingIndicator *loadingIndicator = [[LoadingIndicator alloc] init];
        [self.view addSubview:loadingIndicator];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            queues = [service getQueues];
            [loadingIndicator removeFromSuperview];
            [self.tableView reloadData];
        });
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([sender isKindOfClass:[UIBarButtonItem class]])
    {
        
    }
    else
    {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    
        [segue.destinationViewController setQueueId:[[queues objectAtIndex:[indexPath row]] objectForKey:QUEUE_ID]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [queues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QueueCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Configure the cell...
    cell.textLabel.text = [[queues objectAtIndex:indexPath.row] objectForKey:QUEUE_NAME];
    if([[[queues objectAtIndex:indexPath.row] objectForKey:QUEUE_PENDING_MERGE_COUNT] intValue] == 1)
    {
        cell.detailTextLabel.text = [[[[queues objectAtIndex:indexPath.row] objectForKey:QUEUE_PENDING_MERGE_COUNT] stringValue] stringByAppendingString:@" story pending merge"];
    }
    else
    {
        cell.detailTextLabel.text = [[[[queues objectAtIndex:indexPath.row] objectForKey:QUEUE_PENDING_MERGE_COUNT] stringValue] stringByAppendingString:@" stories pending merge"];
    }
    
    return cell;
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
                    NSString *queueId = [[queues objectAtIndex:[deleteQueueIndex integerValue]] objectForKey:QUEUE_ID];
                    BOOL deleted = [service deleteQueue:queueId];
                    
                    if(deleted)
                    {
                        queues = [service getQueues];
                        NSIndexPath *path = [NSIndexPath indexPathForRow:[deleteQueueIndex integerValue] inSection:0];
                        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete failed"
                                                                        message:@"Attempted to delete the queue from the server but it failed"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
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
        deleteQueueIndex = [NSNumber numberWithInteger:indexPath.row];
        NSString *queueName = [[queues objectAtIndex:indexPath.row] objectForKey:QUEUE_NAME];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                        message:[NSString stringWithFormat:@"Are you sure you want to delete %@?  Once it's gone, it's gone!", queueName]
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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ROW SELECTED!");
}

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

@end
