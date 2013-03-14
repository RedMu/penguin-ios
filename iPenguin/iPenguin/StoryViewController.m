//
//  StoryViewController.m
//  iPenguin
//
//  Created by Dan Hall on 25/02/2013.
//  Copyright (c) 2013 Dan Hall. All rights reserved.
//

#import "StoryViewController.h"
#import "StoryDetailsViewController.h"
#import "AppDelegate.h"

@interface StoryViewController ()

@end

@implementation StoryViewController

@synthesize queue;

NSArray *stories;

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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *url = [appDelegate.url stringByAppendingString:@"/api/queues"];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *tempStories = [NSMutableArray new];
    
    for (NSDictionary *currentQueue in jsonObjects) {

        NSString *queueName = [currentQueue objectForKey:@"name"];
        
        if([queueName isEqualToString:queue])
        {
            for(NSDictionary *story in [currentQueue objectForKey:@"stories"])
            {
                NSMutableDictionary *storyDetails = [[NSMutableDictionary alloc] init];
                
                [storyDetails setObject:[story objectForKey:@"_id"] forKey:@"_id"];
                [storyDetails setObject:[story objectForKey:@"reference"] forKey:@"reference"];
                [storyDetails setObject:[story objectForKey:@"author"] forKey:@"author"];
                [storyDetails setObject:[story objectForKey:@"title"] forKey:@"title"];
                
                NSNumber *merged = [story objectForKey:@"merged"];
                
                [storyDetails setObject:merged forKey:@"merged"];
                
                [tempStories addObject:storyDetails];
            }
        }
    }
    
    stories = [[NSArray alloc] initWithArray:tempStories];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    
    [segue.destinationViewController setReference:[[stories objectAtIndex:[indexPath row]] objectForKey:@"reference"]];
    [segue.destinationViewController setAuthor:[[stories objectAtIndex:[indexPath row]] objectForKey:@"author"]];
    [segue.destinationViewController setDescription:[[stories objectAtIndex:[indexPath row]] objectForKey:@"title"]];
    [segue.destinationViewController setMerged:[[stories objectAtIndex:[indexPath row]] objectForKey:@"merged"]];
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
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [stories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    cell.textLabel.text = [[stories objectAtIndex:indexPath.row] objectForKey:@"reference"];
    cell.detailTextLabel.text = [[stories objectAtIndex:indexPath.row] objectForKey:@"author"];
    
    
    
    if([[[stories objectAtIndex:indexPath.row] objectForKey:@"merged"] boolValue] == YES)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
                cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
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
