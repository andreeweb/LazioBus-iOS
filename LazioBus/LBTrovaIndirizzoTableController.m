//
//  LBDepArrTableViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 12/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBTrovaIndirizzoTableController.h"

@interface LBTrovaIndirizzoTableController ()

@end

@implementation LBTrovaIndirizzoTableController

@synthesize depOrArr;
@synthesize parent;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrayDistrict = [[NSMutableArray alloc] init];
    arrayStop = [[NSMutableArray alloc] init];
    lastResearch = [[NSMutableArray alloc] init];
    
    if ([depOrArr isEqualToString:@"departure"])
        self.title = NSLocalizedString(@"Partenza", @"");
    else
        self.title = NSLocalizedString(@"Arrivo", @"");
    
    //close keyboard when touches
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    //mostro le ultime ricerche e preferiti
    lastResearch = [LBStop getTPLastSearches];
    favorites = [LBStop getTPfavorites];
    
    //spinner
    spinner = [[LBSpinner alloc] initForViewController:self];
    
    #if defined(IS_LITE)
    //load AdMob
    [self performSelectorOnMainThread:@selector(loadADMobBanner) withObject:nil waitUntilDone:NO];
    #endif
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

//hide tabbar
-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void) hideKeyboard {
    [_searchBar resignFirstResponder];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        
        [spinner stopSpinner];
        
        [searchStop cancel];
        searchStop = nil;
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    #if defined(IS_LITE)
    if([arrayDistrict count] > 0 || [arrayStop count] > 0)
        return 2;
    else
        return 1;
    #else
    return 2;
    #endif
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows = 0;

    if ([arrayDistrict count] > 0 || [arrayStop count] > 0){
        if (section == 0)
            rows = [arrayDistrict count];
        else
            rows = [arrayStop count];
    }else{
        if (section == 0)
            rows = [lastResearch count];
        else
            rows = [favorites count];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellDistrict = @"district";
    NSString *cellStop     = @"stop";
    
    if ([arrayDistrict count] > 0 || [arrayStop count] > 0) {
        
        if (indexPath.section == 0) {
            
            //mostro località
            LBPreferitiCell *cell = (LBPreferitiCell *) [tableView dequeueReusableCellWithIdentifier:cellDistrict];
            
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LBPreferitiCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (LBPreferitiCell *)currentObject;
                        break;
                    }
                }
            }
            
            LBStop *district = [arrayDistrict objectAtIndex:indexPath.row];
            district.isFavorites = [self isLBStopFavorites:district];
            
            [cell.cellText setText:[self addCarriageReturn:[district name]]];
            
            UIImage *fv = ([district isFavorites]) ? [UIImage imageNamed:@"star_over"] : [UIImage imageNamed:@"star"];
            [cell.cellButton setImage:fv forState:UIControlStateNormal];
            [cell.cellButton setIndex:indexPath.row];
            [cell.cellButton setSection:indexPath.section];
            [cell.cellButton addTarget:self action:@selector(setFavorites:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            
        }else{
            
            //mostro fermate
            LBPreferitiCell *cell = (LBPreferitiCell *) [tableView dequeueReusableCellWithIdentifier:cellStop];
            
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LBPreferitiCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (LBPreferitiCell *)currentObject;
                        break;
                    }
                }
            }
            
            LBStop *stop = [arrayStop objectAtIndex:indexPath.row];
            stop.isFavorites = [self isLBStopFavorites:stop];
            
            [cell.cellText setText:[self addCarriageReturn:[stop name]]];
            
            UIImage *fv = ([stop isFavorites]) ? [UIImage imageNamed:@"star_over"] : [UIImage imageNamed:@"star"];
            [cell.cellButton setImage:fv forState:UIControlStateNormal];
            [cell.cellButton setIndex:indexPath.row];
            [cell.cellButton setSection:indexPath.section];
            [cell.cellButton addTarget:self action:@selector(setFavorites:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        
    }else{
        
        if(indexPath.section == 0){
            
            //mostro ultime ricerche
            LBPreferitiCell *cell = (LBPreferitiCell *) [tableView dequeueReusableCellWithIdentifier:cellDistrict];
            
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LBPreferitiCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (LBPreferitiCell *)currentObject;
                        break;
                    }
                }
            }
            
            LBStop *search = [lastResearch objectAtIndex:indexPath.row];
            //search.isFavorites = [LBStop isTPFavorites:search.name];
            
            [cell.cellText setText:[self addCarriageReturn:[search name]]];
            
            UIImage *fv = ([search isFavorites]) ? [UIImage imageNamed:@"star_over"] : [UIImage imageNamed:@"star"];
            [cell.cellButton setImage:fv forState:UIControlStateNormal];
            [cell.cellButton setIndex:indexPath.row];
            [cell.cellButton setSection:indexPath.section];
            [cell.cellButton addTarget:self action:@selector(setFavorites:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            
        }else{
            
            //mostro i preferiti
            LBPreferitiCell *cell = (LBPreferitiCell *) [tableView dequeueReusableCellWithIdentifier:cellDistrict];
            
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LBPreferitiCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (LBPreferitiCell *)currentObject;
                        break;
                    }
                }
            }
            
            LBStop *favorite = [favorites objectAtIndex:indexPath.row];
            favorite.isFavorites = YES;
            
            [cell.cellText setText:[self addCarriageReturn:[favorite name]]];
            [cell.cellButton setIndex:indexPath.row];
            
            UIImage *fv = ([favorite isFavorites]) ? [UIImage imageNamed:@"star_over"] : [UIImage imageNamed:@"star"];
            [cell.cellButton setImage:fv forState:UIControlStateNormal];
            [cell.cellButton setSection:indexPath.section];
            [cell.cellButton addTarget:self action:@selector(setFavorites:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    }
        
    return nil;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Pass the selected object to the parent view controller.
    if ([depOrArr isEqualToString:@"departure"]){
        
        if ([arrayDistrict count] > 0 || [arrayStop count] > 0) {
            
            if (indexPath.section == 0){
                parent.departureStop = [arrayDistrict objectAtIndex:indexPath.row];
            }else{
                parent.departureStop = [arrayStop objectAtIndex:indexPath.row];
            }
            
            if (![parent.departureStop isFavorites])
                [parent.departureStop tpSaveStopToDatabase];
            
        }else{
          
            //seleziono una tra le ultime ricerche o preferiti
            if (indexPath.section == 0){
                parent.departureStop = [lastResearch objectAtIndex:indexPath.row];
            }else{
                parent.departureStop = [favorites objectAtIndex:indexPath.row];
            }
        }
        
        [[parent selectDepartureButton] setTitle:parent.departureStop.name forState:UIControlStateNormal];
        
    }else if([depOrArr isEqualToString:@"arrival"]){
        
        if ([arrayDistrict count] > 0 || [arrayStop count] > 0) {
            
            if (indexPath.section == 0){
                parent.arrivalStop = [arrayDistrict objectAtIndex:indexPath.row];
            }else{
                parent.arrivalStop = [arrayStop objectAtIndex:indexPath.row];
            }
            
            if (![parent.arrivalStop isFavorites])
                [parent.arrivalStop tpSaveStopToDatabase];
            
        }else{
            
            //seleziono una tra le ultime ricerche o preferiti
            if (indexPath.section == 0){
                parent.arrivalStop = [lastResearch objectAtIndex:indexPath.row];
            }else{
                parent.arrivalStop = [favorites objectAtIndex:indexPath.row];
            }
        }
        
        [[parent selectArrivalButton] setTitle:parent.arrivalStop.name forState:UIControlStateNormal];
    }
    
    // Push the view controller.
    [self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    /*if ([arrayDistrict count] == 0 || [arrayDistrict count] == 0)
        if (indexPath.section == 1)
            return YES;*/
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        LBStop *st = [favorites objectAtIndex:indexPath.row];
        
        //rimuovo dal db
        [st removeTPFavorites];
        
        //sistemo i dati in locale
        [favorites removeObjectAtIndex:indexPath.row];
    }
    
    [self.tableView reloadData];
}

//table view header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = @"";
    
    if ([arrayDistrict count] > 0 || [arrayStop count] > 0) {
        switch (section)
        {
            case 0:
                sectionName = NSLocalizedString(@"Località", @"");
                break;
            case 1:
                sectionName = NSLocalizedString(@"Fermate", @"");
                break;
        }
    
    }else{
        
        switch (section)
        {
            case 0:
                sectionName = NSLocalizedString(@"Recenti", @"");
                break;
            case 1:
                sectionName = NSLocalizedString(@"Preferiti", @"");
                break;
        }
    }
    
    return sectionName;
}

#pragma mark - Connection

//reset search when press return button
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if([self searchBarTextLength:searchBar] >= 3){
        
        //close keyboard
        [self.view endEditing:YES];
        
        [spinner startSpinner];
        
        // In body data for the 'application/x-www-form-urlencoded' content type,
        // form fields are separated by an ampersand. Note the absence of a
        // leading ampersand.
        
        NSInteger type = 0;
        if ([depOrArr isEqualToString:@"arrival"])
            type = 1;
        
        NSString *os       = OS;
        NSString *version  = APPVERSION;
        NSString *lang     = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        NSString *bodyData = [NSString stringWithFormat:@"comune=%@&type=%ld&os=%@&version=%@&lang=%@",searchBar.text,(long)type,os,version,lang];
        
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:
                                            [NSURL URLWithString:LINKTROVAINDIRIZZO]];
        
        // Set the request's content type to application/x-www-form-urlencoded
        [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        // Designate the request a POST request and specify its body data
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
        
        // Initialize the NSURLConnection and proceed as described in
        // Retrieving the Contents of a URL
        
        // create the connection with the request
        // and start loading the data
        searchStop = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
        if (searchStop) {
            
            receivedData = [NSMutableData data];
            
        }else{
            
            // Release the receivedData object.
            receivedData = nil;
            [spinner stopSpinner];
            
            //Inform the user that the connection failed.
            //NSLog(@"Connession stop fallita!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errore", @"")
                                                            message:NSLocalizedString(@"Verifica che il tuo dispositivo sia collegato alla rete.", @"")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    searchStop = nil;
    receivedData = nil;

    [spinner stopSpinner];

    // inform the user
    /*NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);*/
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errore", @"")
                                                    message:NSLocalizedString(@"Verifica che il tuo dispositivo sia collegato alla rete.", @"")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a property elsewhere
    //NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    [spinner stopSpinner];
    
    //NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",responseString);
    
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:receivedData
                                                         options: NSJSONReadingMutableContainers
                                                           error: &e];
    if (!jsonArray) {
        
        NSLog(@"Error parsing JSON: %@", e);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errore", @"")
                                                        message:NSLocalizedString(@"Si è verificato un errore interno, riprova oppure contatta il supporto.", @"")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        if ([[jsonArray objectForKey:@"code"] isEqualToString:@"0"]) {
            
            //clear array
            [arrayDistrict removeAllObjects];
            [arrayStop removeAllObjects];
            
            NSArray *append = [jsonArray objectForKey:@"data"];
            
            //parso i comuni
            for (int i = 0; i < [[append objectAtIndex:0] count]; i++) {
             
                LBStop *stopDistrict = [[LBStop alloc] initWithJsonInfo:[[append objectAtIndex:0] objectAtIndex:i]];
                [arrayDistrict addObject:stopDistrict];
            }
            
            //parso le fermate
            for (int i = 0; i < [[append objectAtIndex:1] count]; i++) {
                
                LBStop *stopStop = [[LBStop alloc] initWithJsonInfo:[[append objectAtIndex:1] objectAtIndex:i]];
                [arrayStop addObject:stopStop];
            }

            //[self.tableView setSeparatorColor:[UIColor colorWithRed:0.0/255 green:150.0/255 blue:210.0/255 alpha:1]];
            [self.tableView setSeparatorColor:[UIColor grayColor]];
            [self.tableView reloadData];
        
        }else{
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errore", @"")
                                                            message:[jsonArray objectForKey:@"errorMessage"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    searchStop = nil;
    receivedData = nil;
}

//scroll to top
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

//andiamo a capo alla prima parentesi
- (NSString*) addCarriageReturn:(NSString*) text {
    
    NSString *original = @"(";
    NSString *replacement = @"\n(";
    
    NSRange rOriginal = [text rangeOfString: original];
    if (NSNotFound != rOriginal.location) {
        text = [text
                    stringByReplacingCharactersInRange: rOriginal
                    withString:                         replacement];
    }
    return text;
}

- (IBAction)setFavorites:(id)sender{
    
    LBButton *button = (LBButton*)sender;
    LBStop *st = [[LBStop alloc] init];
    
    //NSLog(@"Make! %d %d",button.index, button.section);
    
    if ([arrayDistrict count] > 0 || [arrayStop count] > 0) {
        
        if (button.section == 0) {
            st = [arrayDistrict objectAtIndex:button.index];
        }else{
            st = [arrayStop objectAtIndex:button.index];
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            
            if ([st isFavorites]){
                [st removeTPFavorites];
                [favorites removeObject:st];
                [st setIsFavorites:NO];
            }
            else{
                [st saveTPFavorites];
                [favorites addObject:st];
                [st setIsFavorites:YES];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:button.index inSection:button.section];
                NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
            });
        });
        
    }else{
        
        if(button.section == 0){
            
            st = [lastResearch objectAtIndex:button.index];

            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                // Do something...
                //seleziono da ultime ricerche, rimuovo da array,db e metto in preferiti
                [st removeTPSearch];
                
                //salvo in preferiti
                [st saveTPFavorites];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    //sistemo i dati locali
                    [lastResearch removeObjectAtIndex:button.index];
                    [favorites addObject:st];
                    
                    [self.tableView reloadData];
                });
            });
            
        }else{
            
            //seleziono da ultime preferiti, rimuovo da array,db
            st = [favorites objectAtIndex:button.index];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                
                //rimuovo dal db
                [st removeTPFavorites];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    //sistemo i dati in locale
                    [favorites removeObjectAtIndex:button.index];
                    
                    [self.tableView reloadData];
                });
            });
        }
    }
}

//remove white spaces and check if textfield has text
-(int) searchBarTextLength:(UISearchBar*)searchBar {
    
    NSString *t1 = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [t1 length];
}

//uso per contollare se un LBStop sta nell'array dei favorites
- (BOOL) isLBStopFavorites:(LBStop*) stop {
    for(int i = 0; i < [favorites count]; i++){
        LBStop *st = [favorites objectAtIndex:i];
        if([stop.name isEqualToString:st.name])
            return YES;
    }
    return NO;
}

@end
