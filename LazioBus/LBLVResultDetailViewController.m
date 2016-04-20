//
//  LBLVResultDetailViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 17/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBLVResultDetailViewController.h"

@interface LBLVResultDetailViewController ()

@end

@implementation LBLVResultDetailViewController
@synthesize percorsoTextView, lastPositionLabel, stateLabel, detail;
@synthesize percorsoLabel, lPositionLabel, sLabel;

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
    
    [self setTitle:NSLocalizedString(@"Dettagli corsa", @"")];
    
    //translations
    [percorsoLabel setText:NSLocalizedString(@"Percorso", @"")];
    [lPositionLabel setText:NSLocalizedString(@"Ultima posizione disponibile", @"")];
    [sLabel setText:NSLocalizedString(@"Stato", @"")];
    
    [percorsoTextView setText:detail.journey];
    [percorsoTextView setFont:[UIFont systemFontOfSize:14]];
    [percorsoTextView setTextColor:[UIColor colorWithRed:62.0/255 green:62.0/255 blue:62.0/255 alpha:1]];
    
    [lastPositionLabel setText:detail.lastPosition];
    [stateLabel setText:detail.state];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
