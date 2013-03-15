//
//  StoryDetailsViewController.m
//  iPenguin
//
//  Created by Dan Hall on 13/03/2013.
//  Copyright (c) 2013 Dan Hall. All rights reserved.
//

#import "StoryDetailsViewController.h"

@interface StoryDetailsViewController ()

@end

@implementation StoryDetailsViewController

#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 15.0f

@synthesize reference ,author, description, merged;

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoryDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 1;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    switch ([indexPath section])
    {
        case 0:
            cell.textLabel.text = reference;
            break;
        case 1:
            cell.textLabel.text = author;
            break;
        case 2:
            if([merged boolValue] == YES)
            {
                cell.textLabel.text = @"Story merged";
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.backgroundColor = [UIColor greenColor];
            }
            else
            {
                cell.textLabel.text = @"Story pending merge";
                cell.backgroundColor = [UIColor redColor];
            }
            
            break;
        case 3:
            cell.textLabel.text = description;
            cell.textLabel.numberOfLines = 0;
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *text;
    
    switch ([indexPath section])
    {
        case 0:
            text = reference;
            break;
        case 1:
            text = author;
            break;
        case 2:
            text = @"1";
            break;
        case 3:
            text = description;
            break;
    }
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGSize lineSize = [@"1" sizeWithFont:[UIFont systemFontOfSize:[UIFont labelFontSize]] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    
    if(size.height / lineSize.height > 1)
    {
        return size.height + (CELL_CONTENT_MARGIN * 2);
    }
    return 44.0f;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Story Reference";
    }
    if (section == 1)
    {
        return @"Author";
    }
    if (section == 2)
    {
        return @"Merged?";
    }
    if (section == 3)
    {
        return @"Story Description";
    }
    return @"";
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
