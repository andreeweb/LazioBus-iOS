//
//  LBTrovaFermataViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 14/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBTrovaFermataViewController.h"

@interface LBTrovaFermataViewController ()

@end

@implementation LBTrovaFermataViewController
@synthesize textHeader, buttonSearch;

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
    
    [self setTitle:NSLocalizedString(@"Trova fermata", @"")];
    
    //translations
    [textHeader setText:NSLocalizedString(@"Inserisci la fermata per sapere quando passerà il prossimo autobus!", @"")];
    [buttonSearch setTitle:NSLocalizedString(@"Cerca", @"") forState:UIControlStateNormal];
    
    //inizializzo l'array finale di risposta
    arrayStop = [[NSMutableArray alloc] init];
    
    //spinner
    spinner = [[LBSpinner alloc] initForViewController:self];
    
    #if defined(IS_LITE)
    //load admob
    [self performSelectorOnMainThread:@selector(loadADMobBanner) withObject:nil waitUntilDone:NO];
    #endif
}

#if defined(IS_LITE)
- (void) loadADMobBanner {
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    //bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Initialize the banner at the bottom of the screen.
    CGPoint origin = CGPointMake(0.0,[UIScreen mainScreen].bounds.size.height - 113 - CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner
                                                 origin:origin];
    
    // Specify the ad unit ID.
    bannerView_.adUnitID = ADSTESTID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    GADRequest *request = [GADRequest request];
    
    if (ADSTESTMODE) {
        // Make the request for a test ad. Put in an identifier for
        // the simulator as well as any devices you want to receive test ads.
        request.testDevices = [NSArray arrayWithObjects:
                               @"Simulator",
                               nil];
    }
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:request];
}
#endif

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchAction:(id)sender {
    
    LBTrovaFermataRicercaViewController *controller = [[LBTrovaFermataRicercaViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
