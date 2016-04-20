//
//  LBTrovaFermataViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 14/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSpinner.h"
#import "LBStop.h"
#import "LBTrovaFermataRicercaViewController.h"
#import "LBUrl.h"

@interface LBTrovaFermataViewController : UIViewController{
    
    //connessione
    NSURLConnection *searchStop;
    NSMutableData *receivedData;
    
    //tabella
    NSMutableArray *arrayStop;
    
    //wait
    LBSpinner *spinner;
    
    GADBannerView *bannerView_;
}


@property (weak, nonatomic) IBOutlet UILabel *textHeader;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
- (IBAction)searchAction:(id)sender;

@end
