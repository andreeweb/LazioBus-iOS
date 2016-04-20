//
//  LBTrovaFermataRicercaViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 30/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBTrovaFermataRicercaViewController.h"

@interface LBTrovaFermataRicercaViewController ()

@end

@implementation LBTrovaFermataRicercaViewController
@synthesize stopSelected;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrayStop = [[NSMutableArray alloc] init];

    lastResearch = [[NSMutableArray alloc] init];
    favorites = [[NSMutableArray alloc] init];
    
    //close keyboard when touches
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    //mostro le ultime ricerche
    lastResearch = [LBStop getLVLastSearches];
    
    //mostro le ultime ricerche
    favorites = [LBStop getLVFavorites];
    
    //spinner
    spinner = [[LBSpinner alloc] initForViewController:self];
    
    [self setTitle:@"Fermata"];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    // Animate the deselection
    [self.tableView deselectRowAtIndexPath:
     [self.tableView indexPathForSelectedRow] animated:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        
        [spinner stopSpinner];
        
        [searchStop cancel];
        searchStop = nil;
        
        [downloadDetail cancel];
        downloadDetail = nil;
    }
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    #if defined(IS_LITE)
    return 1;
    #else
    if ([arrayStop count] > 0)
        return 1;
    else
        return 2;
    #endif
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows = 0;
    
    if ([arrayStop count] > 0){
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
    
    if ([arrayStop count] > 0){
        
        LBLVStopsTableViewCell *cell = (LBLVStopsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellStop];
        
        if (cell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LBLVStopsTableViewCell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = (LBLVStopsTableViewCell *)currentObject;
                    break;
                }
            }
        }
        
        LBStop *stop = [arrayStop objectAtIndex:indexPath.row];
        stop.isFavorites = [self isLBStopFavorites:stop];
        
        [cell.cellText setText:[stop name]];
        [cell.cellDirections setText:[stop directions]];
        
        UIImage *fv = ([stop isFavorites]) ? [UIImage imageNamed:@"star_over"] : [UIImage imageNamed:@"star"];
        [cell.cellButton setImage:fv forState:UIControlStateNormal];
        [cell.cellButton setIndex:indexPath.row];
        [cell.cellButton setSection:indexPath.section];
        [cell.cellButton addTarget:self action:@selector(setFavorites:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    
    }else{
        
        if(indexPath.section == 0){
            
            //mostro ultime ricerche
            LBLVStopsTableViewCell *cell = (LBLVStopsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellDistrict];
            
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LBLVStopsTableViewCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (LBLVStopsTableViewCell *)currentObject;
                        break;
                    }
                }
            }
            
            LBStop *search = [lastResearch objectAtIndex:indexPath.row];
            //search.isFavorites = [LBStop isTPFavorites:search.name];
            
            [cell.cellText setText:[search name]];
            [cell.cellDirections setText:[search directions]];
            
            UIImage *fv = ([search isFavorites]) ? [UIImage imageNamed:@"star_over"] : [UIImage imageNamed:@"star"];
            [cell.cellButton setImage:fv forState:UIControlStateNormal];
            [cell.cellButton setIndex:indexPath.row];
            [cell.cellButton setSection:indexPath.section];
            [cell.cellButton addTarget:self action:@selector(setFavorites:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        
        if(indexPath.section == 1){
            
            LBLVStopsTableViewCell *cell = (LBLVStopsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellDistrict];
            
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LBLVStopsTableViewCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (LBLVStopsTableViewCell *)currentObject;
                        break;
                    }
                }
            }
            
            LBStop *favorite = [favorites objectAtIndex:indexPath.row];
            favorite.isFavorites = YES;
            
            [cell.cellText setText:[favorite name]];
            [cell.cellDirections setText:[favorite directions]];
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
    LBStop *stop = [[LBStop alloc] init];
    
    if ([arrayStop count] > 0) {
        
        stop = [arrayStop objectAtIndex:indexPath.row];
        
        if (![stop isFavorites])
            [stop lvSaveStopToDatabase];

    }else{
        
        if (indexPath.section == 0){
            stop = [lastResearch objectAtIndex:indexPath.row];
        }else{
            stop = [favorites objectAtIndex:indexPath.row];
        }
    }
    
    [self downloadLvStopDetail:stop];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//table view header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = @"";
    
    if ([arrayStop count] > 0) {
        switch (section)
        {
            case 0:
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

- (void) downloadLvStopDetail:(LBStop*) stopS {
    
    //close keyboard
    [self.view endEditing:YES];
    
    [self setStopSelected:stopS];
    
    [spinner startSpinner];
    
    // In body data for the 'application/x-www-form-urlencoded' content type,
    // form fields are separated by an ampersand. Note the absence of a
    // leading ampersand.
    
    //recupero l'ora attuale
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString *hour = [formatter stringFromDate:[NSDate date]];
    
    //mi salvo in variabile globale l'orario scelto
    hourRequest = [hour integerValue];
    
    NSString *os       = OS;
    NSString *version  = APPVERSION;
    NSString *lang     = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    NSString *bodyData = [NSString stringWithFormat:@"idPal=%@&hour=%ld&number=%d&os=%@&version=%@&lang=%@",stopS.idPal,(long)hourRequest,2,os,version,lang];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:LINKLUCEVERDE]];
    
    // Set the request's content type to application/x-www-form-urlencoded
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Designate the request a POST request and specify its body data
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    // Initialize the NSURLConnection and proceed as described in
    // Retrieving the Contents of a URL
    
    // create the connection with the request
    // and start loading the data
    downloadDetail = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
    if (downloadDetail) {
        
        receivedData = [NSMutableData data];
        
    }else{
        
        // Release the receivedData object.
        receivedData = nil;
        [spinner stopSpinner];
        
        // Inform the user that the connection failed.
        //NSLog(@"Connession stop fallita!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errore", @"")
                                                    	message:NSLocalizedString(@"Verifica che il tuo dispositivo sia collegato alla rete.", @"")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

//reset search when press return button
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if([self searchBarTextLength:searchBar] >= 3){
        
        //close keyboard
        [self.view endEditing:YES];
        
        [spinner startSpinner];
        
        // In body data for the 'application/x-www-form-urlencoded' content type,
        // form fields are separated by an ampersand. Note the absence of a
        // leading ampersand.
        
        NSString *os       = OS;
        NSString *version  = APPVERSION;
        NSString *lang     = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        NSString *bodyData = [NSString stringWithFormat:@"stopName=%@&os=%@&version=%@&lang=%@",searchBar.text,os,version,lang];
        
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:
                                            [NSURL URLWithString:LINKSCELTAFERMATE]];
        
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
            
            // Inform the user that the connection failed.
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
        
        //NSLog(@"Error parsing JSON: %@", e);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errore", @"")
                                                        message:NSLocalizedString(@"Si è verificato un errore interno, riprova oppure contatta il supporto.", @"")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        if ([[jsonArray objectForKey:@"code"] isEqualToString:@"0"]) {
            
            if (connection == searchStop) {
                
                //clear array
                [arrayStop removeAllObjects];
                
                NSArray *append = [jsonArray objectForKey:@"data"];
                
                //parso le fermate
                for (int i = 0; i < [append count]; i++) {
                    
                    LBStop *stopStop = [[LBStop alloc] initWithLVJsonInfo:[append objectAtIndex:i]];
                    [arrayStop addObject:stopStop];
                }
                
                [self.tableView reloadData];
                
            }else if (connection == downloadDetail){
             
                //inizializzo l'array di lv result per un totale di 24h
                NSMutableArray *hours = [[NSMutableArray alloc] initWithCapacity:23];
                for (int i = 0; i < 24; i++)
                    [hours addObject:[NSNull null]];
                
                //array di array
                NSArray *arrayData = [jsonArray objectForKey:@"data"];
                for (int i = 0; i < [arrayData count]; i++) {
                    
                    //array di appoggio per salvarmi le fermate
                    NSMutableArray *app = [[NSMutableArray alloc] init];
                    
                    //singola lista
                    for (int j = 0; j < [[arrayData objectAtIndex:i] count]; j++) {
                        
                        LBLVResult *result = [[LBLVResult alloc] initWithJsonInfo:[[arrayData objectAtIndex:i] objectAtIndex:j]];
                        
                        //riuso l'array di questa vista
                        [app addObject:result];
                    }
                    
                    //analizzo i casi critici
                    if (hourRequest == 0 || hourRequest == 1)
                        [hours setObject:app atIndexedSubscript:(hourRequest - hourRequest)+i];
                    else
                        [hours setObject:app atIndexedSubscript:(hourRequest - 2)+i];
                    
                }
                
                //preparo per la push
                LBTrovaFermateLVResultViewController *controller = [[LBTrovaFermateLVResultViewController alloc] initWithNibName:@"LBTrovaFermateLVResultViewController" bundle:nil];
                
                //passo l'array delle 24h con le 4 ore già scaricate
                [controller setLvArrayResultPerHour:hours];
                
                //mi porto dietro la fermata selezionata
                [controller setStopSelected:stopSelected];
                
                //passo l'ora selezionata
                [controller setHourSelected:hourRequest];
                [self.navigationController pushViewController:controller animated:YES];
            }
            
        }else{
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errore", @"")
                                                            message:[jsonArray objectForKey:@"errorMessage"]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", @"")
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
    
    //NSLog(@"Make! %%ld%d",button.index(long), button.section);
    
    if ([arrayStop count] > 0){
        
        st = [arrayStop objectAtIndex:button.index];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            if ([st isFavorites]){
                [st removeLVFavorites];
                [favorites removeObject:st];
                [st setIsFavorites:NO];
            }
            else{
                [st saveLVFavorites];
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
            
            //ultime ricerche
            st = [lastResearch objectAtIndex:button.index];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                [st removeLVSearch];
                
                //salvo in preferiti
                [st saveLVFavorites];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    //sistemo i dati locali
                    [lastResearch removeObjectAtIndex:button.index];
                    [favorites addObject:st];
                    
                    [self.tableView reloadData];
                });
            });
        }
        
        if(button.section == 1){
            
            // preferiti
            st = [favorites objectAtIndex:button.index];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                
                //rimuovo dal db
                [st removeLVFavorites];
                
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
        if([stop.name isEqualToString:st.name] && [stop.directions isEqualToString:st.directions])
            return YES;
    }
    return NO;
}

@end
