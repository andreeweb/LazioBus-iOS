//
//  LBCalcolaTariffaViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSpinner.h"
#import "LBUrl.h"
#import "LBFare.h"
#import "LBCalcolaTariffaDetailController.h"

@interface LBCalcolaTariffaViewController : UIViewController {
    
    //connessione
    NSURLConnection *calcolaConnection;
    NSMutableData *receivedData;
    
    GADBannerView *bannerView_;
    
    LBSpinner *spinner;
}

@property (weak, nonatomic) IBOutlet UITextField *daText;
@property (weak, nonatomic) IBOutlet UITextField *aText;
@property (weak, nonatomic) IBOutlet UILabel *textHeader;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;


- (IBAction)calcolaAction:(id)sender;

@end
