//
//  LBSpinner.m
//  LazioBus
//
//  Created by Andrea Cerra on 13/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBSpinner.h"

#define DEFAULT_COLOR [UIColor colorWithRed:0.0/255 green:150.0/255 blue:210.0/255 alpha:1]

@implementation LBSpinner
@synthesize spinner;

- (id) initForViewController:(UIViewController*)controller {
    
    self = [super init];
    if (self){
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        //[spinner setFrame:CGRectMake(0, 0, 20, 20)];
        
        [self setController:controller];

        //set the initial property
        [spinner stopAnimating];
        [spinner hidesWhenStopped];
        
        //Create an instance of Bar button item with custome view which is of activity indicator
        barButton = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    }
    
    return self;
}


- (void) startSpinner {
    
    [[[self controller] view] setUserInteractionEnabled:NO];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[[self controller] navigationItem] setRightBarButtonItem:barButton];
    [(UIActivityIndicatorView *)[[[[self controller] navigationItem] rightBarButtonItem] customView] startAnimating];
}

- (void) stopSpinner {
    
    [[[self controller] view] setUserInteractionEnabled:YES];
    [[[[self controller] navigationController] navigationBar] setUserInteractionEnabled:YES];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [(UIActivityIndicatorView *)[[[[self controller] navigationItem] rightBarButtonItem] customView] stopAnimating];
}

@end
