//
//  LBNewsDetailViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBNewsDetailViewController.h"

@interface LBNewsDetailViewController ()

@end

@implementation LBNewsDetailViewController
@synthesize news, dataNews, titleNews, textNews;

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
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"Dettaglio news"];
    
    [dataNews setText:news.newsDate ];
    [titleNews setText:news.newsTitle];
    [textNews setText:news.newsText];
    
    [textNews  setFont:[UIFont systemFontOfSize:15.0]];
    [textNews setTextColor:[UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
