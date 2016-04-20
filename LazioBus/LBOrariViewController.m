//
//  LBOrariViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 18/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBOrariViewController.h"

@interface LBOrariViewController ()

@end

@implementation LBOrariViewController
@synthesize textHeader, orariButton, savedTimesButton;

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
    
    [self setTitle:NSLocalizedString(@"Orari", @"")];
    
    //translations
    [textHeader setText:NSLocalizedString(@"Visualizza la lista degli orari attualmente disponibili oppure cerca tra gli orari salvati", @"")];
    [orariButton setTitle:NSLocalizedString(@"Orari", @"") forState:UIControlStateNormal];
    [savedTimesButton setTitle:NSLocalizedString(@"Orari salvati", @"") forState:UIControlStateNormal];
    
    //path di base
    basePath = DEFAULTLINKORARI;
    
    //spinner
    spinner = [[LBSpinner alloc] initForViewController:self];
    
    #if defined(IS_LITE)
    //load AdMob
    [self performSelectorOnMainThread:@selector(loadADMobBanner) withObject:nil waitUntilDone:NO];
    [savedTimesButton setHidden:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)times:(id)sender {

    [self checkTimesAvailable];
}

- (IBAction)pdfSaved:(id)sender {
    
    LBOrariTableViewController *list = [[LBOrariTableViewController alloc] initWithNibName:@"LBOrariTableViewController" bundle:nil];
    [list setAction:@"pdfSaved"];
    [list setPdfArray:[LBPDF getPDFSavedList]];
    
    [self.navigationController pushViewController:list animated:YES];
}

-(void) pushToTimesList {
    
    LBOrariTableViewController *list = [[LBOrariTableViewController alloc] initWithNibName:@"LBOrariTableViewController" bundle:nil];
    [list setAction:@"pdfList"];
    [list setPath:basePath];
    [list setPdfArray:[LBPDF getPDFList]];
    
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark connessione

-(void) checkTimesAvailable {
    
    [spinner startSpinner];
    
    /*NSString *os       = OS;
    NSString *version  = APPVERSION;
    NSString *lang     = [[NSLocale preferredLanguages] objectAtIndex:0];*/
    
    /*NSString *bodyData = [NSString stringWithFormat:@"os=%@&version=%@&lang=%@",os, version, lang];*/
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:LINKORARI]];
    
    // Set the request's content type to application/x-www-form-urlencoded
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Designate the request a POST request and specify its body data
    [postRequest setHTTPMethod:@"POST"];
    /*[postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];*/
    
    // Create the NSMutableData to hold the received data.
    // receivedData is an instance variable declared elsewhere.
    receivedData = [NSMutableData dataWithCapacity: 0];
    
    // create the connection with the request
    // and start loading the data
    checkTimes = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
    if (!checkTimes) {
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
    checkTimes = nil;
    receivedData = nil;
    
    // inform the user
    /*NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);*/
    
    [spinner stopSpinner];
    
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
    
    //NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",responseString);
    
    /*{ "code": "0", "data": { "paths": [ { "path": "www.cotralspa.it/PDF_Orari_Comune/Appo_Nuovi_Orari/dal 05 Maggio al 07 Giugno/", "name": "Orari in vigore dal 05 Maggio al 07 Giugno" } ], "update_link": [] } }*/
    
    [spinner stopSpinner];
    
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
            
            NSDictionary *data = [jsonArray objectForKey:@"data"];
            NSArray *paths = [data objectForKey:@"paths"];
            
            //raccolgo i vari path
            pathsArray = [[NSMutableArray alloc] init];
            
            //aggiungo al popup "orari di sempre"
            NSMutableDictionary *orariGenerali = [[NSMutableDictionary alloc] init];
            [orariGenerali setObject:basePath forKey:@"path"];
            [orariGenerali setObject:NSLocalizedString(@"Orari generali", @"") forKey:@"name"];
            [pathsArray addObject:orariGenerali];
            
            for (int i = 0; i < [paths count]; i++)
                [pathsArray addObject:[paths objectAtIndex:i]];
            
            //show popup
            LBPopupList *controller = [[LBPopupList alloc] initWithNibName:@"LBPopupList" bundle:nil];
            [controller setPathsArray:pathsArray];
            [controller setParent:self];
            
            [[self tabBarController] setModalPresentationStyle:UIModalPresentationCurrentContext];
            [self presentViewController:controller animated:NO completion:nil];
            
            [[controller view] setAlpha:0];
            [UIView animateWithDuration:0.2 animations:^{
                [[controller view] setAlpha:1];
            }];
            
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
    checkTimes = nil;
    receivedData = nil;
}

@end
