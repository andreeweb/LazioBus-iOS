//
//  LBOrariViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 18/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBOrariTableViewController.h"
#import "LBPDF.h"
#import "LBUrl.h"
#import "LBSpinner.h"
#import "LBPopupList.h"

@interface LBOrariViewController : UIViewController {
    
    NSString *basePath;
    
    NSURLConnection *checkTimes;
    NSMutableData *receivedData;
    
    //wait
    LBSpinner *spinner;
    
    //array dei path disponibili
    NSMutableArray *pathsArray;
    
    GADBannerView *bannerView_;
}

- (IBAction)times:(id)sender;
- (IBAction)pdfSaved:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *textHeader;
@property (weak, nonatomic) IBOutlet UIButton *orariButton;
@property (weak, nonatomic) IBOutlet UIButton *savedTimesButton;

@end
