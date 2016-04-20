//
//  LBTrovaFermataRicercaViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 30/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBStop.h"
#import "LBSpinner.h"
#import "LBTrovaFermateLVResultViewController.h"
#import "LBLVResult.h"
#import "LBButton.h"
#import "LBLVStopsTableViewCell.h"
#import "MBProgressHUD.h"
#import "LBUrl.h"

@interface LBTrovaFermataRicercaViewController : UIViewController{
    
    //connessione
    NSURLConnection *searchStop;
    NSURLConnection *downloadDetail;

    NSMutableData *receivedData;
    
    //tabella
    NSMutableArray *favorites;
    NSMutableArray *arrayStop;
    NSMutableArray *lastResearch;
    
    NSInteger hourRequest;
    
    //wait
    LBSpinner *spinner;
    
    GADBannerView *bannerView_;
}

@property LBStop *stopSelected; //mi salvo globalmente la fermata selezionata dalla tabella
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
