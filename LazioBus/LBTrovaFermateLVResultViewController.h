//
//  LBTrovaFermateLVResult.h
//  LazioBus
//
//  Created by Andrea Cerra on 14/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTrovaFermataTableViewCell.h"
#import "LBLVResult.h"
#import "ODButton.h"
#import "LBLVResultDetailViewController.h"
#import "ODScrollMenu.h"
#import "LBSpinner.h"
#import "LBStop.h"
#import "LBUrl.h"

@interface LBTrovaFermateLVResultViewController : UIViewController {
    
    //connessione
    NSURLConnection *searchStop;
    NSMutableData *receivedData;
    NSInteger hourRequest;
    
    //wait
    LBSpinner *spinner;
    
    //button refresh
    UIBarButtonItem *refresh;
    UIBarButtonItem *update;
    
    GADBannerView *bannerView_;
}

@property (weak, nonatomic) IBOutlet ODScrollMenu *scrollMenuTime;

@property (nonatomic, retain) NSMutableArray *lvArrayResultPerHour;

@property NSInteger hourSelected;
@property LBStop *stopSelected;

@property (weak, nonatomic) IBOutlet UITableView *lVtableView;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;

@end
