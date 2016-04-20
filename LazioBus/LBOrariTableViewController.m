//
//  LBOrariSavedTableViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 30/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBOrariTableViewController.h"

@interface LBOrariTableViewController ()

@end

@implementation LBOrariTableViewController
@synthesize action, pdfArray, path;

- (void)viewDidLoad
{
    [super viewDidLoad];
    searchResults = [[NSMutableArray alloc] init];
    
    [self setTitle:NSLocalizedString(@"Orari", @"")];
    
    if ([action isEqualToString:@"pdfSaved"]){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Modifica", @"")
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(deletePdf)];
    }
    
    if (IS_OS_7_OR_LATER) {
        //iOS7 style bug-fix for searchbar
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    #if defined(IS_LITE)
    //load AdMob
    [self performSelectorOnMainThread:@selector(loadADMobBanner) withObject:nil waitUntilDone:NO];
    #endif
}

#if defined(IS_LITE)
- (void) loadADMobBanner {
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    //bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
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

- (void) deletePdf {
    
    if (self.tableView.editing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Modifica", @"")
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(deletePdf)];
        [self.tableView setEditing:NO animated:YES];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Fine", @"")
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(deletePdf)];
        [self.tableView setEditing:YES animated:YES];
    }
}

//hide tabbar
-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return [pdfArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    LBPDF *pdfFile = [[LBPDF alloc] init];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        pdfFile = [searchResults objectAtIndex:indexPath.row];
    } else {
        pdfFile = [pdfArray objectAtIndex:indexPath.row];
    }
    
    // Configure the cell...
    cell.textLabel.text = [pdfFile localita];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if ([action isEqualToString:@"pdfSaved"])
        return YES;
    else
        return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (self.tableView.editing){
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        LBPDF *pdfFile = [[LBPDF alloc] init];
        if (tableView == self.searchDisplayController.searchResultsTableView)
            pdfFile = [searchResults objectAtIndex:indexPath.row];
        else
            pdfFile = [pdfArray objectAtIndex:indexPath.row];
        
        // For error information
        NSError *error;
        
        // Create file manager
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        // Point to Document directory
        NSString *documentsDirectory = [NSHomeDirectory()
                                        stringByAppendingPathComponent:@"Documents"];
        
        NSString *filePath = [documentsDirectory
                              stringByAppendingPathComponent:[pdfFile pdf]];
        
        // Attempt to delete the file at filePath
        if ([fileMgr removeItemAtPath:filePath error:&error] != YES)
            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        
        //rimuovo dal db
        [pdfFile removePDFSaved];
        
        //rimuovo dall'array della tabella e aggiorno
        [pdfArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        
        // Show contents of Documents directory
        //NSLog(@"Documents directory: %@",[fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    }
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBPDF *pdfFile = [[LBPDF alloc] init];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
        pdfFile = [searchResults objectAtIndex:indexPath.row];
    else
        pdfFile = [pdfArray objectAtIndex:indexPath.row];
        
    // Navigation logic may go here, for example:
    // Create the next view controller.
    LBOrariDetailViewController *detailViewController = [[LBOrariDetailViewController alloc] initWithNibName:@"LBOrariDetailViewController" bundle:nil];
    
    // Pass the selected object to the new view controller.
    if ([action isEqualToString:@"pdfList"])
        [detailViewController setLink:[path stringByAppendingString:[pdfFile pdf]]];
    else
        [detailViewController setLink:[pdfFile pdf]];

    [detailViewController setPdfName:[pdfFile pdf]];
    [detailViewController setLocalita:[pdfFile localita]];
    
    [detailViewController setAction:action];
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - search

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [searchResults removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localita contains[c] %@",searchText];
    searchResults = [NSMutableArray arrayWithArray:[pdfArray filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
