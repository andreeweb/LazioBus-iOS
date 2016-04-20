//
//  LBAlternativeTableViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 17/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPercorsoAlternativoCell.h"
#import "LBResults.h"
#import "LBSpinner.h"
#import "LBSession.h"
#import "LBUrl.h"

@class LBTrovaPercorsoDetailView;
@interface LBAlternativeTableViewController : UIViewController {
    
    //connessione
    NSURLConnection *downloadDettaglio;
    NSMutableData *receivedData;
    NSInteger index;
    
    //spinner
    LBSpinner *spinner;
    
    GADBannerView *bannerView_;
}

//parent
@property LBTrovaPercorsoDetailView *parent;
@property LBSession *sessione;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
