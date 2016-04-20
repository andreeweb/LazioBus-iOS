//
//  LBCalcolaTariffaViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBCalcolaTariffaViewController.h"

@interface LBCalcolaTariffaViewController ()

@end

@implementation LBCalcolaTariffaViewController
@synthesize daText, aText, textHeader, calculateButton;

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
    
    [self setTitle:NSLocalizedString(@"Calcola tariffa", @"")];
    
    //tranlsations
    [daText setPlaceholder:NSLocalizedString(@"DA", @"Calcola tariffa")];
    [aText setPlaceholder:NSLocalizedString(@"A", @"Calcola tariffa")];
    [textHeader setText:NSLocalizedString(@"Inserire nei campi DA e A il nome della località o parte di esso", @"")];
    [calculateButton setTitle:NSLocalizedString(@"Calcola", @"") forState:UIControlStateNormal];
    
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

//vado a capo quando premi return per textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch ;
    touch = [[event allTouches] anyObject];
    
    if ([touch view].tag == 999){
        [self.view endEditing:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calcolaAction:(id)sender {
    
    if ([self textFieldHasText:daText] && [self textFieldHasText:aText]) {
        
        [self.view endEditing:YES];
        [spinner startSpinner];
        
        NSString *os       = OS;
        NSString *version  = APPVERSION;
        NSString *lang     = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        NSString *bodyData = [NSString stringWithFormat:@"par=%@&arr=%@&os=%@&version=%@&lang=%@",daText.text, aText.text,os,version,lang];
        
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:LINKCALCOLATARIFFA]];
        
        // Set the request's content type to application/x-www-form-urlencoded
        [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        // Designate the request a POST request and specify its body data
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
        
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [NSMutableData dataWithCapacity: 0];
        
        // create the connection with the request
        // and start loading the data
        calcolaConnection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
        if (!calcolaConnection) {
            // Release the receivedData object.
            receivedData = nil;
            
            [spinner stopSpinner];
            
            // Inform the user that the connection failed.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errore", @"")
                                                            message:NSLocalizedString(@"Verifica che il tuo dispositivo sia collegato alla rete.", @"")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errore", @"")
                                                        message:NSLocalizedString(@"Per effettuare la ricerca devi inserire i campi richiesti.", @"")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                              otherButtonTitles:nil, nil];
        [alert show];
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
    calcolaConnection = nil;
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
    //NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[receivedData length]);
    
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
            
            NSMutableArray *fares = [[NSMutableArray alloc] init];
            
            NSArray *arrayData = [jsonArray objectForKey:@"data"];
            
            for (int i = 0; i < [arrayData count]; i++) {
                
                LBFare *fare = [[LBFare alloc] initWithJsonInfo:[arrayData objectAtIndex:i]];
                [fares addObject:fare];
            }
            
            //preparo per la push
            LBCalcolaTariffaDetailController *controller = [[LBCalcolaTariffaDetailController alloc]
                                                              initWithNibName:@"LBCalcolaTariffaDetailController" bundle:nil];
            
            //passo l'array delle tariffe
            [controller setFaresArray:fares];
            [self.navigationController pushViewController:controller animated:YES];
            
            //pulisco le text DA e A
            [daText setText:@""];
            [aText setText:@""];
            
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
    calcolaConnection = nil;
    receivedData = nil;
}

//remove white spaces and check if textfield has text
-(BOOL) textFieldHasText:(UITextField*)textfield {
    
    NSString *t1= [textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([t1 length] > 0)
        return true;
    else
        return false;
}


@end
