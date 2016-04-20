//
//  LBDepArrTableViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 12/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBStop.h"
#import "LBTrovaPercorsoViewController.h"
#import "LBSpinner.h"
#import "LBPreferitiCell.h"
#import "LBButton.h"
#import "MBProgressHUD.h"
#import "LBUrl.h"

@class LBTrovaPercorsoViewController;
@interface LBTrovaIndirizzoTableController : UIViewController{
    
    //connessione
    NSURLConnection *searchStop;
    NSMutableData *receivedData;
    
    //tabella
    NSMutableArray *arrayDistrict;
    NSMutableArray *arrayStop;
    NSMutableArray *favorites;
    NSMutableArray *lastResearch;
    
    GADBannerView *bannerView_;
    
    //wait
    LBSpinner *spinner;
}

@property NSString *depOrArr; //identifica se provengo da seleziona partenza o seleziona arrivo
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//parent delegate
@property LBTrovaPercorsoViewController *parent;

@end
