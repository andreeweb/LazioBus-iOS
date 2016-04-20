//
//  LBListaFermateTableViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 29/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBListaFermateTableController.h"

@interface LBListaFermateTableController ()

@end

@implementation LBListaFermateTableController
@synthesize tableStopArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Lista fermate", @"")];
    
    //vedi .h
    tableLoaded = FALSE;
        
    #if defined(IS_LITE)
    //load AdMob
    [self performSelectorOnMainThread:@selector(loadADMobBanner) withObject:nil waitUntilDone:NO];
    #endif
    
    //[[self tableView] reloadData];
}

#if defined(IS_LITE)
- (void) loadADMobBanner {
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    
    // Initialize the banner at the bottom of the screen.
    CGPoint origin = CGPointMake(0.0,self.view.bounds.size.height - CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner
                                                 origin:origin];
    
    // Specify the ad unit ID.
    bannerView_.adUnitID = ADSTESTID;
    
    //Sitemo il layout di questa vista per posizionare il banner in fondo
    [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x,
                                        self.tableView.frame.origin.y,
                                        self.tableView.frame.size.width,
                                        self.tableView.frame.size.height - bannerView_.frame.size.height)];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tableStopArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"listCell";
    
    LBListaFermateCell *cell = (LBListaFermateCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LBListaFermateCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (LBListaFermateCell *)currentObject;
                break;
            }
        }
    }
    
    // Configure the cell...
    
    UIColor *colorABordo = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    UIColor *colorNonABordo = [UIColor colorWithRed:0.0/255 green:110.0/255 blue:164.0/255 alpha:1];
    
    LBRouteStop *stop = [tableStopArray objectAtIndex:indexPath.row];
    cell.cellColor.backgroundColor = [stop.stopColor isEqualToString:@"0"] ? colorABordo : colorNonABordo;
    cell.cellStop.text = stop.stopName;
    cell.cellTime.text = stop.hitHour;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        
        //end of loading table view
        if(!tableLoaded){
            int scrollToIndex = 0;
            for (int i = 0; i < [tableStopArray count]; i++) {
                
                LBRouteStop *stop = [tableStopArray objectAtIndex:i];
                if (![stop.stopColor isEqualToString:@"1"]){
                    scrollToIndex = i;
                }else{
                    break;
                }
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scrollToIndex inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:NO];
            
            //setto il flag a true così faccio lo scroll automatico solo la prima volta
            tableLoaded = TRUE;
        }
    }*/
}

@end
