//
//  LBTrovaPercorsoDetailView.m
//  LazioBus
//
//  Created by Andrea Cerra on 04/12/13.
//  Copyright (c) 2013 Andrea Cerra. All rights reserved.
//

#import "LBTrovaPercorsoDetailView.h"

@interface LBTrovaPercorsoDetailView ()

@end

@implementation LBTrovaPercorsoDetailView

@synthesize departureLabel, departureTimeLabel;
@synthesize arrivalLabel, arrivalTimeLabel;
@synthesize rideDurationLabel;
@synthesize scrollSegment, tableVewIndications;
@synthesize departureSessioLabel, arrivalSessionLabel, showAlternatives;
@synthesize segmentCtl, tempoPercorrenza, tempoProgrammatoLabel, tempoProgrammatoLabel2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        indicazioni = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //translations
    [segmentCtl setTitle:NSLocalizedString(@"Dettaglio", @"") forSegmentAtIndex:0];
    [segmentCtl setTitle:NSLocalizedString(@"Indicazioni", @"") forSegmentAtIndex:1];

    [tempoProgrammatoLabel setText:NSLocalizedString(@"Tempo programmato", @"")];
    [tempoProgrammatoLabel2 setText:NSLocalizedString(@"Tempo programmato", @"")];
    [tempoPercorrenza setText:NSLocalizedString(@"Tempo percorrenza", @"")];
    [showAlternatives setTitle:NSLocalizedString(@"Visualizza alternative", @"") forState:UIControlStateNormal];
    
    self.title = NSLocalizedString(@"Dettaglio percorso", @"");
    
    sessione = [LBSession sharedSession];
    
    departureSessioLabel.text = sessione.departure;
    arrivalSessionLabel.text = sessione.arrival;
    
    //NSLog(@"session id %@",sessione.idSession);
    
    //mostro il best
    NSArray *breakMinHour = [[[sessione jsonTrovaPercorso] time] componentsSeparatedByString:@"-"];
    NSString *timeDeparture = breakMinHour[0];
    NSString *timeArrival = breakMinHour[1];
    
    departureLabel.text = [[sessione jsonTrovaPercorso] departureStop];
    departureTimeLabel.text = timeDeparture;
    arrivalLabel.text = [[sessione jsonTrovaPercorso] arrivalStop];
    arrivalTimeLabel.text = timeArrival;
    rideDurationLabel.text = [[sessione jsonTrovaPercorso] timeTravel];
    indicazioni = [[sessione jsonTrovaPercorso] travelDescription];
    
    [scrollSegment setContentSize:CGSizeMake(640, 410)];
    
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
    [scrollSegment setFrame:CGRectMake(scrollSegment.frame.origin.x,
                                        scrollSegment.frame.origin.y,
                                        scrollSegment.frame.size.width,
                                        scrollSegment.frame.size.height - 54)];
    
    [tableVewIndications setFrame:CGRectMake(tableVewIndications.frame.origin.x,
                                             tableVewIndications.frame.origin.y,
                                             tableVewIndications.frame.size.width,
                                             scrollSegment.frame.size.height)];
    
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
-(BOOL) hidesBottomBarWhenPushed{
    return YES;
}

- (void) viewWillAppear:(BOOL)animated {
    
    NSIndexPath *tableSelection = [tableVewIndications indexPathForSelectedRow];
    [tableVewIndications deselectRowAtIndexPath:tableSelection animated:NO];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        
        [spinner stopSpinner];
        
        [getStopList cancel];
        getStopList = nil;
    }
    [super viewWillDisappear:animated];
}

- (void) updateDetailViewWithAlternative:(LBResults*)alternativa {

    NSArray *breakMinHour = [[alternativa time] componentsSeparatedByString:@"-"];
    NSString *timeDeparture = breakMinHour[0];
    NSString *timeArrival = breakMinHour[1];
    
    departureLabel.text = [alternativa departureStop];
    departureTimeLabel.text = timeDeparture;
    arrivalLabel.text = [alternativa arrivalStop];
    arrivalTimeLabel.text = timeArrival;
    rideDurationLabel.text = [alternativa timeTravel];
    
    indicazioni = [alternativa travelDescription];
    [[self tableVewIndications] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentAction:(id)sender {
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    if ([segmentedControl selectedSegmentIndex] == 0) {
        [scrollSegment setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if([segmentedControl selectedSegmentIndex] == 1){
        [scrollSegment setContentOffset:CGPointMake(320, 0) animated:YES];
    }
}

- (IBAction)showAlternative:(id)sender {
    
    LBAlternativeTableViewController *controller = [[LBAlternativeTableViewController alloc] init];
    [controller setParent:self];
    [controller setSessione:sessione];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [indicazioni count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *CellIdentifier = @"celIndication";
    LBIndicazioniCellTableViewCell *cell = (LBIndicazioniCellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LBIndicazioniCellTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (LBIndicazioniCellTableViewCell *)currentObject;
                break;
            }
        }
        
        //configure cell
        LBIndication *indication = [indicazioni objectAtIndex:indexPath.row];
        
        CGRect requiredHeight = [self getDynamicHeightForCell:indication.text];

        CGRect newFrame = cell.cellText.frame;
        newFrame.size.height = requiredHeight.size.height;
        cell.cellText.frame = newFrame;
        cell.cellText.text = indication.text;
        
        while ([cell.cellText.text rangeOfString:@"$"].location != NSNotFound)
            [cell.cellText boldSubstringInRange:@"$"];
        
        if (requiredHeight.size.height > 57){
            
            CGRect newFrameView = cell.backgroundFrame.frame;
            newFrameView.size.height = cell.frame.size.height + (requiredHeight.size.height - 57);
            cell.backgroundFrame.frame = newFrameView;
            
            CGRect newFrameShadow = cell.backgroundShadow.frame;
            newFrameShadow.size.height = cell.frame.size.height + (requiredHeight.size.height - 57);
            cell.backgroundShadow.frame = newFrameShadow;
        }
        
        if ([indication.type isEqualToString:@"feet"]) {
            cell.cellTypeImage.image = [UIImage imageNamed:@"walk_round_icon.png"];
            [cell.arrow setHidden:YES];
        }else if ([indication.type isEqualToString:@"bus"]){
            cell.cellTypeImage.image = [UIImage imageNamed:@"bus_round_icon.png"];
        }else if ([indication.type isEqualToString:@"metro"]){
            cell.cellTypeImage.image = [UIImage imageNamed:@"tram_round_icon.png"];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBIndication *indication = [indicazioni objectAtIndex:indexPath.row];
    
    CGRect requiredHeight = [self getDynamicHeightForCell:indication.text];
    
    if (requiredHeight.size.height > 57)
        return requiredHeight.size.height += 35;
    else
        return 80;
}

- (CGRect) getDynamicHeightForCell:(NSString*)text {
    
    //210 larghezza della label in xib
    
    CGSize constrainedSize = CGSizeMake(210, 9999);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13.0], NSFontAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return requiredHeight;
}

#pragma mark -
#pragma mark Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBIndication *indication = [indicazioni objectAtIndex:indexPath.row];
    
    if ([indication.type isEqualToString:@"bus"] || [indication.type isEqualToString:@"metro"]){
        
        [spinner startSpinner];
        
        // In body data for the 'application/x-www-form-urlencoded' content type,
        // form fields are separated by an ampersand. Note the absence of a
        // leading ampersand.
        
        NSString *raceNumber = indication.raceNumber;
        NSString *palinaDep = indication.palinaDeparture;
        NSString *palinaArr = indication.palinaArrival;
        NSString *date = [[sessione jsonTrovaPercorso] dataTravel];
        
        NSString *os       = OS;
        NSString *version  = APPVERSION;
        NSString *lang     = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        //NSLog(@"race: %@ - paliD: %@ - paliA: %@ - date: %@",raceNumber,palinaDep,palinaArr,date);
        
        NSString *bodyData = [NSString stringWithFormat:@"raceNumber=%@&palinaDep=%@&palinaArr=%@&date=%@&os=%@&version=%@&lang=%@",raceNumber,palinaDep,palinaArr,date,os,version,lang];
        
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:
                                            [NSURL URLWithString:LINKLISTAFERMATE]];
        
        // Set the request's content type to application/x-www-form-urlencoded
        [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        // Designate the request a POST request and specify its body data
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
        
        // Initialize the NSURLConnection and proceed as described in
        // Retrieving the Contents of a URL
        
        // create the connection with the request
        // and start loading the data
        getStopList = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
        if (getStopList) {
            
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
    
    }else{
        
        //deseleziono subito nel caso di altre celle
        [self.tableVewIndications deselectRowAtIndexPath:[self.tableVewIndications indexPathForSelectedRow] animated:YES];
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
    getStopList = nil;
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
        
        //preparo per la push
        LBListaFermateTableController *controller = [[LBListaFermateTableController alloc] init];
        
        if ([[jsonArray objectForKey:@"code"] isEqualToString:@"0"]) {
            
            //esplodo json
            NSMutableArray *data = [jsonArray objectForKey:@"data"];
            NSMutableArray *arrayStopList = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [data count]; i++) {
                
                LBRouteStop *stop = [[LBRouteStop alloc] initWithJsonInfo:[data objectAtIndex:i]];
                [arrayStopList addObject:stop];
            }
            
            [controller setTableStopArray:arrayStopList];
            [self.navigationController pushViewController:controller animated:YES];
            
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
    getStopList = nil;
    receivedData = nil;
}


@end
