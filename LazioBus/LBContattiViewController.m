//
//  LBContattiViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBContattiViewController.h"

@interface LBContattiViewController ()

@end

@implementation LBContattiViewController
@synthesize followLabel, cotactUsLabel, websiteLabel;

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
    
    [self setTitle:NSLocalizedString(@"Contatti", @"")];
    
    [followLabel setText:NSLocalizedString(@"Seguici su Twitter", @"")];
    [cotactUsLabel setText:NSLocalizedString(@"Contattaci", @"")];
    [websiteLabel setText:NSLocalizedString(@"Visita il nostro sito", @"")];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
