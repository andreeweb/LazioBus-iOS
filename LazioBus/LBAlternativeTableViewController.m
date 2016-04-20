//
//  LBAlternativeTableViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 17/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBAlternativeTableViewController.h"
#import "LBTrovaPercorsoDetailView.h"

@interface LBAlternativeTableViewController ()

@end

@implementation LBAlternativeTableViewController

@synthesize parent, sessione;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //title
    [self setTitle:NSLocalizedString(@"Alternative", @"")];
    
    //spinner
    spinner = [[LBSpinner alloc] initForViewController:self];
    
    //NSLog(@"index %d",index);
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        
        [spinner stopSpinner];
        
        [downloadDettaglio cancel];
        downloadDettaglio = nil;
    }
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [[[sessione jsonTrovaPercorso] alternatives] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"alternativeCell";
    LBPercorsoAlternativoCell *cell = (LBPercorsoAlternativoCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PercorsoAlternativoCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (LBPercorsoAlternativoCell *)currentObject;
                break;
            }
        }
    }
    
    LBResults *lbride = [[[sessione jsonTrovaPercorso] alternatives] objectAtIndex:indexPath.row];
    cell.timeTravelLabel.text = lbride.time;
    cell.travelLengthLabel.text = lbride.timeTravel;
    cell.numberBusLabel.text = lbride.travelBus;
    cell.numberTramLabel.text = lbride.travelMetro;
    cell.walkLabel.text = lbride.travelFeet;
    
    //[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

//-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
//    
//    LBPercorsoAlternativoCell *ccell = (LBPercorsoAlternativoCell *)cell;
//    
//    if ([sessione rideDetailIndex] == indexPath.row){
//        [ccell.shadowView setBackgroundColor:[UIColor redColor]];
//    }else{
//        [ccell.shadowView setBackgroundColor:[UIColor blueColor]];
//    }
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //se ho la descrizione del viaggio è una alternativa già scaricata, e quindi mostro direttamente
    if ([[[[[sessione jsonTrovaPercorso] alternatives] objectAtIndex:indexPath.row] travelDescription] count] > 0) {
        
        LBResults *alternativa = [[[sessione jsonTrovaPercorso] alternatives] objectAtIndex:indexPath.row];
        
        //imposto l'indice della corsa in dettaglio
        [sessione setRideDetailIndex:indexPath.row];
        
        //mostro nel parent il nuovo dettaglio
        [parent updateDetailViewWithAlternative:alternativa];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        //eseguo il download dei dati
        [spinner startSpinner];
        
        // In body data for the 'application/x-www-form-urlencoded' content type,
        // form fields are separated by an ampersand. Note the absence of a
        // leading ampersand.
        
        index = [indexPath row];
        
        NSString *session = [sessione idSession];
        NSString *os       = OS;
        NSString *version  = APPVERSION;
        NSString *lang     = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        NSString *bodyData = [NSString stringWithFormat:@"index=%ld&session=%@&os=%@&version=%@&lang=%@",(long)index,session,os,version,lang];
        
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:
                                            [NSURL URLWithString:LINKALTERNATIVE]];
        
        // Set the request's content type to application/x-www-form-urlencoded
        [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        // Designate the request a POST request and specify its body data
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
        
        // Initialize the NSURLConnection and proceed as described in
        // Retrieving the Contents of a URL
        
        // create the connection with the request
        // and start loading the data
        downloadDettaglio = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
        if (downloadDettaglio) {
            
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
    downloadDettaglio = nil;
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
            
            NSMutableDictionary *data = [jsonArray objectForKey:@"data"];
            NSMutableDictionary *result = [data objectForKey:@"result"];
            
            //mi popolo l'alternativa con tutti i nuovi dati
            LBResults *alternativa = [[LBResults alloc] initWithJsonInfo:result];
            
            //e la sostituisco nell'array delle alternative, in modo da non dover ripetere la connessione in altri casi
            [[[sessione jsonTrovaPercorso] alternatives] replaceObjectAtIndex:index withObject:alternativa];
            
            //imposto l'indice della corsa in dettaglio
            [sessione setRideDetailIndex:index];
            
            //mostro nel parent il nuovo dettaglio
            [parent updateDetailViewWithAlternative:alternativa];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            
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
    downloadDettaglio = nil;
    receivedData = nil;
}

@end
