//
//  LBTrovaFermateLVResult.m
//  LazioBus
//
//  Created by Andrea Cerra on 14/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBTrovaFermateLVResultViewController.h"

@interface LBTrovaFermateLVResultViewController ()

@end

@implementation LBTrovaFermateLVResultViewController
@synthesize lvArrayResultPerHour, hourSelected, scrollMenuTime, stopSelected, lVtableView, errorMessage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Lista corse", @"")];
    
    //scrollView data load
    [[self scrollMenuTime] loadScrollViewAndInitWithIndex:(hourSelected+1)];
    
    //spinner
    spinner = [[LBSpinner alloc] initForViewController:self];

    //refresh button
    refresh = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                 target:self
                                                                                 action:@selector(refreshAction)];
    
    [[self navigationItem] setRightBarButtonItems:[NSArray arrayWithObjects:refresh, nil]];
    
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
    [lVtableView setFrame:CGRectMake(lVtableView.frame.origin.x,
                                        lVtableView.frame.origin.y,
                                        lVtableView.frame.size.width,
                                        lVtableView.frame.size.height - bannerView_.frame.size.height)];
    
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

- (void) refreshAction {
    
    //+1 perché così deve essere!
    NSInteger refreshHour = hourSelected+1;
    [lvArrayResultPerHour replaceObjectAtIndex:hourSelected withObject:[NSNull null]];
    
    //avvio aggiornamento
    [self scrollTopBarSelectedItem:(refreshHour)];
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

- (NSInteger) buttonInScrollView {
    // Return the number of button in scrollView.
    return 24;
}

// Customize the appearance of button in scrollView.
- (ODButton *) buttonInColumn:(NSInteger)index {
    
    ODButton *button = [[ODButton alloc] init];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"%ld",(long)index] forState:UIControlStateNormal];
    
    return button;
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
    if([lvArrayResultPerHour objectAtIndex:hourSelected] != [NSNull null])
        return [[lvArrayResultPerHour objectAtIndex:hourSelected] count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"lvresult";
    
    LBTrovaFermataTableViewCell *cell = (LBTrovaFermataTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LBTrovaFermataTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (LBTrovaFermataTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    UIColor *greenColor = [UIColor colorWithRed:4.0/255 green:174.0/255 blue:4.0/255 alpha:1];
    UIColor *grayColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1];
    UIColor *redColor = [UIColor redColor];

    LBLVResult *result = [[lvArrayResultPerHour objectAtIndex:hourSelected] objectAtIndex:indexPath.row];
    
    //Preparo lo stile per le scritte
    if ([result.state isEqualToString:@"Corsa terminata"]) {
        
        [cell.state setTextColor:grayColor];
        [cell.detailState setTextColor:grayColor];
        
        [cell.state setFrame:CGRectMake(189, 8, 88, 35)];
        [cell.detailState setFrame:CGRectMake(189, 44, 88, 35)];
        
        [cell.state setHidden:NO];
        [cell.detailState setHidden:NO];
    
    }else if ([result.state isEqualToString:@"Non conosciuto"]){
        
        [cell.state setTextColor:greenColor];
        //[cell.detailState setTextColor:grayColor];
        
        [cell.state setFrame:CGRectMake(189, 8, 88, 70)];
        //[cell.detailState setFrame:CGRectMake(189, 44, 88, 35)];
        
        [cell.state setHidden:NO];
        [cell.detailState setHidden:YES];
    
    }else if ([result.state isEqualToString:@"Corsa soppressa"]){
        
        [cell.state setTextColor:redColor];
        //[cell.detailState setTextColor:grayColor];
        
        [cell.state setFrame:CGRectMake(189, 8, 88, 70)];
        //[cell.detailState setFrame:CGRectMake(189, 44, 88, 35)];
        
        [cell.state setHidden:NO];
        [cell.detailState setHidden:YES];
    
    }else if ([result.state isEqualToString:@"In Viaggio"] || [result.state isEqualToString:@"In viaggio"]){
        
        [cell.state setTextColor:greenColor];
        [cell.detailState setTextColor:redColor];
        
        [cell.state setFrame:CGRectMake(189, 8, 88, 35)];
        [cell.detailState setFrame:CGRectMake(189, 44, 88, 35)];
        
        [cell.state setHidden:NO];
        [cell.detailState setHidden:NO];
    
    }else{
        
        [cell.state setTextColor:greenColor];
        [cell.detailState setTextColor:redColor];
        
        [cell.state setFrame:CGRectMake(189, 8, 88, 35)];
        [cell.detailState setFrame:CGRectMake(189, 44, 88, 35)];
        
        [cell.state setHidden:NO];
        [cell.detailState setHidden:NO];
    
    }
    
    //stile detail state
    if ([result.detailState isEqualToString:@""])
        [cell.state setFrame:CGRectMake(189, 8, 88, 70)];
    else
        [cell.state setFrame:CGRectMake(189, 8, 88, 35)];
    
    cell.directionLabel.text = result.direction;
    cell.timeLabel.text = result.programTime;
    
    cell.state.text = result.state;
    
    //riduco PUNTUALE in Puntuale
    if ([result.detailState isEqualToString:@"PUNTUALE"])
        [cell.detailState setText:[@"PUNTUALE" capitalizedString]];
    else
        cell.detailState.text = result.detailState;
    
    //nel caso non ho ne state ne detailState
    if ([result.state isEqualToString:@""] && [result.detailState isEqualToString:@""]) {
        
        [cell.state setTextColor:grayColor];
        //[cell.detailState setTextColor:redColor];
        
        [cell.state setFrame:CGRectMake(189, 8, 88, 70)];
        //[cell.detailState setFrame:CGRectMake(189, 44, 88, 35)];
        
        [cell.state setHidden:NO];
        [cell.detailState setHidden:YES];
        
        [cell.state setText:@"ND"];
    
    }
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBLVResultDetailViewController *detailController = [[LBLVResultDetailViewController alloc] initWithNibName:@"LBLVResultDetailViewController"
                                                                                                        bundle:nil];
    [detailController setDetail:[[lvArrayResultPerHour objectAtIndex:hourSelected] objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark ODScrollMenu view delegate

- (void)scrollTopBarSelectedItem:(NSInteger)index {
    
    [self setHourSelected:(index-1)];
    [scrollMenuTime scrollToIndex:(index)];
    
    [lVtableView reloadData];
    [lVtableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];

    // Return the tag of button pressed in scrollView
    if([lvArrayResultPerHour objectAtIndex:(index - 1)] != [NSNull null]){
        
        [self setHourSelected:(index - 1)];
        
        if ([[lvArrayResultPerHour objectAtIndex:(index - 1)] count] == 0) {
            [errorMessage setHidden:NO];
            [lVtableView setHidden:YES];
        }else{
            [errorMessage setHidden:YES];
            [lVtableView setHidden:NO];
            [lVtableView reloadData];
        }
        
    }else{
        
        [spinner startSpinner];
        
        //close keyboard
        [self.view endEditing:YES];
        
        // In body data for the 'application/x-www-form-urlencoded' content type,
        // form fields are separated by an ampersand. Note the absence of a
        // leading ampersand.
        
        hourRequest = (index - 1);
        
        NSString *bodyData = [NSString stringWithFormat:@"idPal=%@&hour=%ld&number=%d",stopSelected.idPal,(long)hourRequest,0];
        
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
        searchStop = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
        if (searchStop) {
            
            receivedData = [NSMutableData data];
            
        }else{
            
            // Release the receivedData object.
            receivedData = nil;
            [spinner stopSpinner];
            [[self navigationItem] setRightBarButtonItems:[NSArray arrayWithObjects:refresh, update, nil]];
            
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

#pragma mark - Connection

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
    [[self navigationItem] setRightBarButtonItems:[NSArray arrayWithObjects:refresh, update, nil]];
    
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
    [[self navigationItem] setRightBarButtonItems:[NSArray arrayWithObjects:refresh, update, nil]];
    
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
                
                [lvArrayResultPerHour setObject:app atIndexedSubscript:hourRequest];
            }
            
            //nel caso in cui non mi venga restituito nulla comunque metto un array vuoto
//            if ([arrayData count] == 0) {
//                NSMutableArray *app = [[NSMutableArray alloc] init];
//                [lvArrayResultPerHour setObject:app atIndexedSubscript:hourRequest];
//            }
            
            [self setHourSelected:hourRequest];
            
            if ([lvArrayResultPerHour objectAtIndex:hourRequest] != [NSNull null]) {
                if ([[lvArrayResultPerHour objectAtIndex:hourRequest] count] == 0) {
                    [errorMessage setHidden:NO];
                    [lVtableView setHidden:YES];
                }else{
                    [errorMessage setHidden:YES];
                    [lVtableView setHidden:NO];
                    [lVtableView reloadData];
                }
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

@end
