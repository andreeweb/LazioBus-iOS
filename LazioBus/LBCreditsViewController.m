//
//  LBCreditsViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 02/06/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBCreditsViewController.h"

@interface LBCreditsViewController ()

@end

@implementation LBCreditsViewController
@synthesize versionLabel, scrollCredits, textDisclaimer;

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
    [self setTitle:NSLocalizedString(@"Crediti", @"")];
    
    [versionLabel setText:[NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [scrollCredits setContentSize:CGSizeMake(0, 475)];
    
    [textDisclaimer setText:NSLocalizedString(@"L'applicazione LazioBus ed il suo team non sono in alcun modo legati alla Cotral S.p.A. I dati forniti sono presi dai siti ufficiali di Cotral S.p.A., pertanto non ci riteniamo responsabili per eventuali errori e/o ritardi nella comunicazione delle informazioni.", @"")];
    [textDisclaimer setFont:[UIFont systemFontOfSize:14.0]];
    [textDisclaimer setTextColor:[UIColor colorWithRed:62.0/255 green:62.0/255 blue:62.0/255 alpha:1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
