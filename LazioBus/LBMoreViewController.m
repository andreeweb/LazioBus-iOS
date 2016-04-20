//
//  LBMoreViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBMoreViewController.h"

@interface LBMoreViewController ()

@end

@implementation LBMoreViewController
@synthesize newsButton, contactsButton, creditsButton, goToProButton;

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
    
    [self setTitle:NSLocalizedString(@"Altro", @"")];
    
    [newsButton setTitle:NSLocalizedString(@"News", @"") forState:UIControlStateNormal];
    [contactsButton setTitle:NSLocalizedString(@"Contatti", @"") forState:UIControlStateNormal];
    [creditsButton setTitle:NSLocalizedString(@"Crediti", @"") forState:UIControlStateNormal];
    
    #if defined(IS_PRO)
    [goToProButton setHidden:YES];
    #endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newsButtonAction:(id)sender {
    
    LBNewsViewController *controller = [[LBNewsViewController alloc] initWithNibName:@"LBNewsViewController" bundle:nil];
    [[self navigationController] pushViewController:controller animated:YES];
}

- (IBAction)contactsButtonAction:(id)sender {
    
    LBContattiViewController *controller = [[LBContattiViewController alloc] initWithNibName:@"LBContattiViewController" bundle:nil];
    [[self navigationController] pushViewController:controller animated:YES];
}

- (IBAction)creditsButtonAction:(id)sender {
    
    LBCreditsViewController *controller = [[LBCreditsViewController alloc] initWithNibName:@"LBCreditsViewController" bundle:nil];
    [[self navigationController] pushViewController:controller animated:YES];
}

- (IBAction)goToPro:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/laziobus/id885570718?l=it&ls=1&mt=8"]];
}

@end
