//
//  LoadingIndicator.m
//  iPenguin
//
//  Created by Dan Hall on 24/03/2013.
//  Copyright (c) 2013 Dan Hall. All rights reserved.
//

#import "LoadingIndicator.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingIndicator

static const int LOADING_INDICATOR_WIDTH = 150;
static const int LOADING_INDICATOR_HEIGHT = 150;

static const int SPINNER_HEIGHT = 25;
static const int SPINNER_WIDTH = 25;

static const NSString *LOADING = @"Contacting server";

UIActivityIndicatorView  *av;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self.layer setCornerRadius:10];
        [self setBackgroundColor:[UIColor grayColor]];
        
        av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        av.frame=CGRectMake(LOADING_INDICATOR_WIDTH/2 - (SPINNER_WIDTH/2), LOADING_INDICATOR_HEIGHT/2 - (SPINNER_HEIGHT/2) - 10, SPINNER_WIDTH, SPINNER_HEIGHT);
        av.tag  = 1;

        UIColor *color = [UIColor colorWithWhite:0.3 alpha:0.5];
        [self setBackgroundColor: color];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, LOADING_INDICATOR_HEIGHT - 50, LOADING_INDICATOR_WIDTH, 50)];
        
        [label setText:LOADING];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [self addSubview:label];
        
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:av];
        [av startAnimating];
        
    }
    return self;
}

- (id)init
{
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    return [self initWithFrame:CGRectMake(width/4, height/4, LOADING_INDICATOR_WIDTH, LOADING_INDICATOR_HEIGHT)];
}

@end
