//
//  StoryDetailsViewController.m
//  iPenguin
//
//  Created by Dan Hall on 13/03/2013.
//  Copyright (c) 2013 Dan Hall. All rights reserved.
//

#import "StoryDetailsViewController.h"
#import "PenguinServiceImpl.h"

@interface StoryDetailsViewController ()

@end

@implementation StoryDetailsViewController

#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 25.0f

@synthesize storyId, queueId;

NSObject<PenguinService> *service;
NSMutableDictionary *storyDetailsViewModel;

UITextField *storyReferenceField;
UITextField *storyAuthorField;
UITextView *storyTitleField;


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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    if(storyId == nil)
    {
        storyDetailsViewModel = [NSMutableDictionary new];
    }
    else
    {
        storyDetailsViewModel = [NSMutableDictionary dictionaryWithDictionary:[service getStoryDetailsForStory:storyId]]; 
    }
    self.navigationItem.title = [storyDetailsViewModel objectForKey:STORY_REFERENCE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn: (UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - UITextViewDelegate methods

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldReturn: (UITextView *)textView{
	[textView resignFirstResponder];
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
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
            storyReferenceField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 30)];
            [storyReferenceField setEnabled:YES];
            [storyReferenceField setReturnKeyType:UIReturnKeyDone];
            [storyReferenceField setPlaceholder:@"Please enter a reference"];
            [storyReferenceField setText:[storyDetailsViewModel objectForKey:STORY_REFERENCE]];
            [storyReferenceField setFont:[UIFont boldSystemFontOfSize:18]];
            [storyReferenceField setDelegate:self];
            
            [cell.contentView addSubview:storyReferenceField];
            break;
        case 1:
            storyAuthorField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 30)];
            [storyAuthorField setEnabled:YES];
            [storyAuthorField setReturnKeyType:UIReturnKeyDone];
            [storyAuthorField setPlaceholder:@"Please enter an author"];
            [storyAuthorField setText:[storyDetailsViewModel objectForKey:STORY_AUTHOR]];
            [storyAuthorField setFont:[UIFont boldSystemFontOfSize:18]];
            [storyAuthorField setDelegate:self];

            [cell.contentView addSubview:storyAuthorField];
            break;
        case 2:
            if([[storyDetailsViewModel objectForKey:STORY_MERGE] boolValue] == YES)
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
            storyTitleField = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, 280, [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]] - 3)];
            [storyTitleField setReturnKeyType:UIReturnKeyDone];
            [storyTitleField setText:[storyDetailsViewModel objectForKey:STORY_TITLE]];
            [storyTitleField setFont:[UIFont boldSystemFontOfSize:18]];
            [storyTitleField setDelegate:self];
            
            [cell.contentView addSubview:storyTitleField];
            
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
            text = [storyDetailsViewModel objectForKey:STORY_REFERENCE];
            break;
        case 1:
            text = [storyDetailsViewModel objectForKey:STORY_AUTHOR];
            break;
        case 2:
            text = @"1";
            break;
        case 3:
            text = [storyDetailsViewModel objectForKey:STORY_TITLE];
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
        return @"Merged Status";
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
    if (indexPath.section == 2 && storyId != nil)
    {
        BOOL merged = [[storyDetailsViewModel objectForKey:STORY_MERGE] boolValue];
        [storyDetailsViewModel setValue:storyReferenceField.text forKey:STORY_REFERENCE];
        [storyDetailsViewModel setValue:storyAuthorField.text forKey:STORY_AUTHOR];
        [storyDetailsViewModel setValue:storyTitleField.text forKey:STORY_TITLE];
        [storyDetailsViewModel setValue:[NSNumber numberWithBool:!merged] forKey:STORY_MERGE];
        [self.tableView reloadData];
    }

}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section == 3)
    {
        return 200;
    }
    return UITableViewAutomaticDimension;
}

#pragma IBActions

-(void)save:(id)sender
{
    BOOL refPresent = ![storyReferenceField.text isEqualToString:@""];
    BOOL authorPresent = ![storyAuthorField.text isEqualToString:@""];
    BOOL titlePresent = ![storyTitleField.text isEqualToString:@""];
    
    if(refPresent && authorPresent && titlePresent)
    {
        NSArray *keys = [NSArray arrayWithObjects:STORY_REFERENCE, STORY_TITLE, STORY_AUTHOR, nil];
        NSArray *objects = [NSArray arrayWithObjects:storyReferenceField.text, storyTitleField.text, storyAuthorField.text, nil];
        NSDictionary *model = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
        if(storyId == nil)
        {
            BOOL saved = [service createStory:model InQueue:queueId];
            if(!saved)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed"
                                                                message:@"Attempted to create the queue on the server but it failed, you may try again"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            BOOL saved = [service updateStory:storyId WithDetails:model InQueue:queueId WithMergeStatus:[[storyDetailsViewModel objectForKey:STORY_MERGE] boolValue]];
            if(!saved)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed"
                                                                message:@"Attempted to update the queue on the server but it failed, you may try again"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed"
                                                        message:@"Please provide a reference, author and description"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

@end
