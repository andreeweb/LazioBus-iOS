//
//  LBTrovaPercorsoViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 04/12/13.
//  Copyright (c) 2013 Andrea Cerra. All rights reserved.
//

#import "LBTrovaPercorsoViewController.h"

@interface LBTrovaPercorsoViewController ()

@end

@implementation LBTrovaPercorsoViewController
@synthesize selectArrivalButton, selectDepartureButton;
@synthesize departureStop, arrivalStop;
@synthesize pickerDataView, dataText, datePicker;
@synthesize pickerCambiView, cambiText, cambiPicker;
@synthesize pickerTimeView, timeText, timePicker;
@synthesize searchButton, resetButton;

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
    
    [self setTitle:NSLocalizedString(@"Trova percorso", @"")];
    
    //translations
    [selectArrivalButton setTitle:NSLocalizedString(@"Seleziona arrivo",@"") forState:UIControlStateNormal];
    [selectDepartureButton setTitle:NSLocalizedString(@"Seleziona partenza",@"") forState:UIControlStateNormal];
    [timeText setPlaceholder:NSLocalizedString(@"Ora", @"")];
    [dataText setPlaceholder:NSLocalizedString(@"Max cambi", @"")];
    [cambiText setPlaceholder:NSLocalizedString(@"Data", @"")];
    [searchButton setTitle:NSLocalizedString(@"Cerca", @"") forState:UIControlStateNormal];
    [resetButton setTitle:NSLocalizedString(@"Reset", @"") forState:UIControlStateNormal];
    
    departureStop = NULL;
    arrivalStop = NULL;
    
    //picker cambi datasource
    cambiArray = [NSArray arrayWithObjects:@"max 0 cambi",@"max 1 cambi",@"max 2 cambi",@"max 3 cambi",@"max 4 cambi",@"max 5 cambi", nil];
    
    //set some property for arrival/departure button
    selectDepartureButton.titleLabel.numberOfLines = 2;
    selectDepartureButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    selectDepartureButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    selectArrivalButton.titleLabel.numberOfLines = 2;
    selectDepartureButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    selectArrivalButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //spinner
    spinner = [[LBSpinner alloc] initForViewController:self];
    
    //default value
    [self resetButton:nil];
    
    //in questa schermata metto il banner solo se è iPhone 5
    if( IS_IPHONE_5 ){
        #if defined(IS_LITE)
        //load admob
        [self performSelectorOnMainThread:@selector(loadADMobBanner) withObject:nil waitUntilDone:NO];
        #endif
    }
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

-(void) viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        
        [spinner stopSpinner];
        
        [search cancel];
        search = nil;
    }
    [super viewWillDisappear:animated];
}

#pragma mark - Departure/Arrival
- (IBAction)selectDeparture:(id)sender {
    
    LBTrovaIndirizzoTableController *controller = [[LBTrovaIndirizzoTableController alloc] init];
    controller.depOrArr = @"departure";
    controller.parent = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)selectArrival:(id)sender {
    
    LBTrovaIndirizzoTableController *controller = [[LBTrovaIndirizzoTableController alloc] init];
    controller.depOrArr = @"arrival";
    controller.parent = self;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - Main action
- (IBAction)resetButton:(id)sender {
    
    //reset value to default
    departureStop = NULL;
    arrivalStop = NULL;
    
    [selectArrivalButton setTitle:NSLocalizedString(@"Seleziona arrivo",@"") forState:UIControlStateNormal];
    [selectDepartureButton setTitle:NSLocalizedString(@"Seleziona partenza",@"") forState:UIControlStateNormal];
    
    //date
    NSDate *today = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"d MMMM yyyy"];
    dataText.text = [outputFormatter stringFromDate:today];
    
    //time
    [outputFormatter setDateFormat:@"H:mm"];
    timeText.text = [outputFormatter stringFromDate:today];
    
    //changes
    cambiText.text = @"max 2 cambi";
}

- (IBAction)searchButton:(id)sender {
    
    if(departureStop != NULL && arrivalStop != NULL){
        
        [spinner startSpinner];
        
        // In body data for the 'application/x-www-form-urlencoded' content type,
        // form fields are separated by an ampersand. Note the absence of a
        // leading ampersand.
        
        NSString *departureType = departureStop.type;
        NSString *arrivalType = arrivalStop.type;
        NSString *idRowDeparture = departureStop.idRow;
        NSString *idRowArrival = arrivalStop.idRow;
        NSString *idTeleatlasDeparture = departureStop.idTeleatlas;
        NSString *idTeleatlasArrival = arrivalStop.idTeleatlas;
        NSString *coordXd = departureStop.coordX;
        NSString *coordYd = departureStop.coordY;
        NSString *coordXa = arrivalStop.coordX;
        NSString *coordYa = arrivalStop.coordY;
        NSString *departure = departureStop.name;
        NSString *arrival = arrivalStop.name;
        NSString *idItaGcDep = departureStop.idItaGc;
        NSString *idItaGcArr = arrivalStop.idItaGc;
        
        //pulisco cambi, per passare solo il numero
        NSString * maxChanges   = [cambiText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        maxChanges              = [maxChanges stringByReplacingOccurrencesOfString:@"max" withString:@""];
        maxChanges              = [maxChanges stringByReplacingOccurrencesOfString:@"cambi" withString:@""];
        
        //date
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"d MMMM yyyy"];
        NSDate *myDate = [df dateFromString: dataText.text];
        [df setDateFormat:@"dd/MM/yyyy"];
        NSString *dateSearch = [df stringFromDate:myDate];
        
        //hour/minutes
        NSArray *breakMinHour = [timeText.text componentsSeparatedByString:@":"];
        int min = [breakMinHour[1] intValue];
        NSString *hou = breakMinHour[0];
        NSString *hour = hou;
        NSString *minutes = [NSString stringWithFormat:@"%d",[self roundedTime:min]];
        
        NSString *os       = OS;
        NSString *version  = APPVERSION;
        NSString *lang     = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        NSString *bodyData = [NSString stringWithFormat:@"departureType=%@&arrivalType=%@&idRowDeparture=%@&idRowArrival=%@&idTeleatlasDeparture=%@&idTeleatlasArrival=%@&coordXd=%@&coordYd=%@&coordXa=%@&coordYa=%@&departure=%@&arrival=%@&dateSearch=%@&hour=%@&minutes=%@&maxChanges=%@&idItaGcDep=%@&idItaGcArr=%@&os=%@&version=%@&lang=%@",departureType,arrivalType,idRowDeparture,idRowArrival,idTeleatlasDeparture,idTeleatlasArrival,coordXd,coordYd,coordXa,coordYa,departure,arrival,dateSearch,hour,minutes,maxChanges,idItaGcDep,idItaGcArr,os,version,lang];
        
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:
                                            [NSURL URLWithString:LINKTROVAPERCORSO]];
        
        // Set the request's content type to application/x-www-form-urlencoded
        [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        // Designate the request a POST request and specify its body data
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
        
        // Initialize the NSURLConnection and proceed as described in
        // Retrieving the Contents of a URL
        
        // create the connection with the request
        // and start loading the data
        search = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
        if (search) {
            
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errore", @"")
                                                        message:NSLocalizedString(@"Per effettuare la ricerca devi inserire partenza e arrivo.", @"")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                              otherButtonTitles:nil, nil];
        [alert show];
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
    search = nil;
    receivedData = nil;
    
    [spinner stopSpinner];
    
    // inform the user
    //NSLog(@"Connection failed! Error - %@ %@",
          //[error localizedDescription],
          //[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
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
        LBTrovaPercorsoDetailView *controller = [[LBTrovaPercorsoDetailView alloc] init];
        
        if ([[jsonArray objectForKey:@"code"] isEqualToString:@"0"]) {
            
            //esplodo json
            NSMutableDictionary *data = [jsonArray objectForKey:@"data"];
            NSMutableDictionary *session = [data objectForKey:@"session"];
            NSMutableDictionary *result = [data objectForKey:@"result"];
            NSMutableDictionary *best = [result objectForKey:@"best"];
            
            //inizializzo la sessione
            LBSession *sessione = [[LBSession sharedSession] init];
            [sessione setDeparture:[session objectForKey:@"departure"]];
            [sessione setArrival:[session objectForKey:@"arrival"]];
            [sessione setIdSession:[session objectForKey:@"idSession"]];
            
            [sessione setJsonTrovaPercorso:[[LBResults alloc] initWithJsonInfo:best]];
            
            //salvo la data di ricerca
            //date
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"d MMMM yyyy"];
            NSDate *myDate = [df dateFromString: dataText.text];
            [df setDateFormat:@"dd/MM/yyyy"];
            NSString *dateSearch = [df stringFromDate:myDate];
            [[sessione jsonTrovaPercorso] setDataTravel:dateSearch];
            
            //flag best
            BOOL bestTrovato = FALSE;
            
            //salvo le alternative del best
            NSMutableArray *alternatives = [result objectForKey:@"alternatives"];
            for (int i = 0; i < [alternatives count]; i++) {
                
                LBResults *alternativa = [[LBResults alloc] initWithJsonInfo:[alternatives objectAtIndex:i]];
                [[[sessione jsonTrovaPercorso] alternatives] addObject:alternativa];
                
                //tra le alternative individuo la best
                if ([[alternativa time] isEqualToString:[[sessione jsonTrovaPercorso] time]])
                    if ([[alternativa travelRange] isEqualToString:[[sessione jsonTrovaPercorso] travelRange]] && !bestTrovato){
                        
                        [sessione setRideDetailIndex:i];
                        //e la inserisco nelle alternative visto che anche li è presente il best
                        [[[sessione jsonTrovaPercorso] alternatives] replaceObjectAtIndex:i withObject:[sessione jsonTrovaPercorso]];
                        bestTrovato = TRUE;
                        
                        //NSLog(@"best index %d",i);
                    }
            }
            
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
    search = nil;
    receivedData = nil;
}


#pragma mark - Data picker
- (IBAction)setDataPicker:(id)sender {
    
    [UIView animateWithDuration:0.15 animations:^{
        
        //Picker view
        CGRect framePickerView = CGRectMake(0, self.view.frame.size.height, 325, 344);
        pickerDataView = [[UIView alloc] initWithFrame:framePickerView];
        pickerDataView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:pickerDataView];
        
        //toolbar
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        toolbar.frame = CGRectMake(0, 0, 325, 44);
        
        UIBarButtonItem *fatto = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Fatto", @"")
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(setDate)];
        
        [toolbar setItems:[[NSArray alloc] initWithObjects:fatto, nil] animated:NO];
        [pickerDataView addSubview:toolbar];
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 325, 300)];
        [datePicker setBackgroundColor:[UIColor whiteColor]];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.hidden = NO;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"d MMMM yyyy";
        NSDate *date = [dateFormatter dateFromString:[dateFormatter stringFromDate:datePicker.date]];
        [timePicker setDate:date];
        
        [pickerDataView addSubview:datePicker];
        
        CGRect newFrame = framePickerView;
        newFrame.origin.y = 135;
        [pickerDataView setFrame:newFrame];
    
    } completion:^(BOOL finished) {
        //NSLog(@"picker displayed");
        //isPickerDisplay = YES;
    }];
}

- (void) setDate {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"d MMMM yyyy"];
    
    dataText.text = [outputFormatter stringFromDate:datePicker.date];
    
    [UIView animateWithDuration:0.15 animations:^{
        
        //Picker view
        CGRect framePickerView = CGRectMake(0, self.view.frame.size.height, 325, 344);
        [pickerDataView setFrame:framePickerView];
        
    } completion:^(BOOL finished) {
        //NSLog(@"picker displayed");
        [pickerDataView removeFromSuperview];
    }];
}

#pragma mark - Cambi picker
- (IBAction)setCambPicker:(id)sender {
    
    [UIView animateWithDuration:0.15 animations:^{
        
        //Picker view
        CGRect framePickerView = CGRectMake(0, self.view.frame.size.height, 325, 344);
        pickerCambiView = [[UIView alloc] initWithFrame:framePickerView];
        pickerCambiView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:pickerCambiView];
        
        //toolbar
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        toolbar.frame = CGRectMake(0, 0, 325, 44);
        
        UIBarButtonItem *fatto = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Fatto", @"")
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(setCambi)];
        
        [toolbar setItems:[[NSArray alloc] initWithObjects:fatto, nil] animated:NO];
        [pickerCambiView addSubview:toolbar];
        
        cambiPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 325, 300)];
        cambiPicker.showsSelectionIndicator = YES;
        cambiPicker.delegate = self;
        
        //pulisco cambi, per passare solo il numero
        NSString * maxChanges   = [cambiText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        maxChanges              = [maxChanges stringByReplacingOccurrencesOfString:@"max" withString:@""];
        maxChanges              = [maxChanges stringByReplacingOccurrencesOfString:@"cambi" withString:@""];
        //imposto in base alla precedente scelta
        [cambiPicker selectRow:[maxChanges integerValue] inComponent:0 animated:NO];
        
        [pickerCambiView addSubview:cambiPicker];
        
        CGRect newFrame = framePickerView;
        newFrame.origin.y = 135;
        [pickerCambiView setFrame:newFrame];
        
    } completion:^(BOOL finished) {
        //NSLog(@"picker displayed");
        //isPickerDisplay = YES;
    }];
}

- (void) setCambi {
    
    NSInteger row = [cambiPicker selectedRowInComponent:0];
    cambiText.text = [cambiArray objectAtIndex:row];
    
    [UIView animateWithDuration:0.15 animations:^{
        
        //Picker view
        CGRect framePickerView = CGRectMake(0, self.view.frame.size.height, 325, 344);
        [pickerCambiView setFrame:framePickerView];
        
    } completion:^(BOOL finished) {
        //NSLog(@"picker displayed");
        [pickerCambiView removeFromSuperview];
    }];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSUInteger numRows = 6;
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title;
    title = [cambiArray objectAtIndex:row];
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    int sectionWidth = 300;
    return sectionWidth;
}

#pragma mark - Time picker
- (IBAction)setTimPicker:(id)sender {
    
    [UIView animateWithDuration:0.15 animations:^{
        
        //Picker view
        CGRect framePickerView = CGRectMake(0, self.view.frame.size.height, 325, 344);
        pickerTimeView = [[UIView alloc] initWithFrame:framePickerView];
        pickerTimeView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:pickerTimeView];
        
        //toolbar
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        toolbar.frame = CGRectMake(0, 0, 325, 44);
        
        UIBarButtonItem *fatto = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Fatto", @"")
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(setTime)];
        
        [toolbar setItems:[[NSArray alloc] initWithObjects:fatto, nil] animated:NO];
        [pickerTimeView addSubview:toolbar];
        
        timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 325, 300)];
        [timePicker setBackgroundColor:[UIColor whiteColor]];
        timePicker.datePickerMode = UIDatePickerModeDate;
        timePicker.hidden = NO;
        timePicker.datePickerMode = UIDatePickerModeTime;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        NSDate *date = [dateFormatter dateFromString:timeText.text];
        [timePicker setDate:date];
        
        [pickerTimeView addSubview:timePicker];
        
        CGRect newFrame = framePickerView;
        newFrame.origin.y = 135;
        [pickerTimeView setFrame:newFrame];
        
    } completion:^(BOOL finished) {
        //NSLog(@"picker displayed");
        //isPickerDisplay = YES;
    }];
}

- (void) setTime {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"mm"];
    
    //int time = [[outputFormatter stringFromDate:timePicker.date] intValue];
    //NSLog(@"%d",[self roundedTime:time]);
    
    [outputFormatter setDateFormat:@"HH:mm"];
    timeText.text = [outputFormatter stringFromDate:timePicker.date];
    
    [UIView animateWithDuration:0.15 animations:^{
        
        //Picker view
        CGRect framePickerView = CGRectMake(0, self.view.frame.size.height, 325, 344);
        [pickerTimeView setFrame:framePickerView];
        
    } completion:^(BOOL finished) {
        //NSLog(@"picker displayed");
        [pickerTimeView removeFromSuperview];
    }];
}

//arrotonda per difetto ad un multiplo di 5
- (int) roundedTime:(int)time {

    if (time % 5 == 0)
        return time;
    else
        time = [self roundedTime:time-1];
    return time;
}

@end
