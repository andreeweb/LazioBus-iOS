//
//  LBOrariDetailViewController.m
//  LazioBus
//
//  Created by Andrea Cerra on 30/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBOrariDetailViewController.h"

@interface LBOrariDetailViewController ()

@end

@implementation LBOrariDetailViewController
@synthesize link, webViewCotral, localita, action, pdfName;

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
    
    [self setTitle:localita];
    
    //spinner
    spinner = [[LBSpinner alloc] initForViewController:self];
    
    NSURL *url = [[NSURL alloc] init];
    
    if ([action isEqualToString:@"pdfList"]){
        url = [NSURL URLWithString:link];
        //NSLog(@"%@",url);
    }else{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:pdfName];
        
        if ( [[NSFileManager defaultManager] fileExistsAtPath:localFilePath] ) {
            url = [NSURL fileURLWithPath:localFilePath];
        }
    }
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webViewCotral loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [spinner startSpinner];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [spinner stopSpinner];
    
    if ([action isEqualToString:@"pdfList"]){
        
        #if defined(IS_PRO)
            saveButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                        target:self
                                                                        action:@selector(savePDF)];
            [[self navigationItem] setRightBarButtonItem:saveButton];
        #endif
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [spinner stopSpinner];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errore", @"")
                                                    message:NSLocalizedString(@"Si è verificato un errore interno, riprova oppure contatta il supporto.", @"")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex != [alertView cancelButtonIndex]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) savePDF {
    
    [[self navigationItem] setRightBarButtonItem:nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       
        // Do something...
        // Get the PDF Data from the url in a NSData Object
        NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:webViewCotral.request.URL.absoluteString]];
        
        // For error information
        //NSError *error;
        
        // Create file manager
        //NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        // Point to Document directory
        NSString *documentsDirectory = [NSHomeDirectory()
                                        stringByAppendingPathComponent:@"Documents"];
        
        // File we want to create in the documents directory
        // Result is: /Documents/file1.txt
        NSString *filePath = [documentsDirectory
                              stringByAppendingPathComponent:pdfName];
        
        // Write the file
        [pdfData writeToFile:filePath atomically:YES];
        
        // Show contents of Documents directory
        //NSLog(@"Documents directory: %@",[fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
        
        //salvo su db
        LBPDF *pdf = [[LBPDF alloc] init];
        [pdf setLocalita:localita];
        [pdf setPdf:pdfName];
        [pdf savePDF];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            //riposiziono il pulsante salva
            saveButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                        target:self
                                                                        action:@selector(savePDF)];
            [[self navigationItem] setRightBarButtonItem:saveButton];
            
        });
    });
}

@end
