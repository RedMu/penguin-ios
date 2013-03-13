//
//  ConfigViewController.m
//  iPenguin
//
//  Created by Dan Hall on 13/03/2013.
//  Copyright (c) 2013 Dan Hall. All rights reserved.
//

#import "ConfigViewController.h"
#import "AppDelegate.h"

@interface ConfigViewController ()

@end

@implementation ConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSString *url = [textField.text stringByAppendingString:@"/api/queues"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) urlResponse;
    
    if([httpResponse statusCode] == 200)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server found"
                                                        message:@"Server was successfully found, view queues and stories by pressing Queues tab"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate setUrl:textField.text];
        
        return YES;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server not found"
                                                    message:@"Server could not be found, please enter the server with http://<server>:<port>"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
    return NO;

}

- (BOOL)textFieldShouldReturn: (UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
    
}

@end
