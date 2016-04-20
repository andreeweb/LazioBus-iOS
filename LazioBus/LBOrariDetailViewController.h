//
//  LBOrariDetailViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 30/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSpinner.h"
#import "LBPDF.h"
#import "MBProgressHUD.h"

@interface LBOrariDetailViewController : UIViewController {
    
    //wait
    LBSpinner *spinner;
    
    UIBarButtonItem *saveButton;
}

@property NSString *link;
@property NSString *localita;
@property NSString *pdfName;
@property NSString *action;

@property (weak, nonatomic) IBOutlet UIWebView *webViewCotral;

@end
