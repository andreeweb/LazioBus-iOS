//
//  LBTrovaPercorsoDetailView.h
//  LazioBus
//
//  Created by Andrea Cerra on 04/12/13.
//  Copyright (c) 2013 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPercorsoAlternativoCell.h"
#import "LBResults.h"
#import "LBIndicazioniCellTableViewCell.h"
#import "LBSession.h"
#import "UILabel+Boldify.h"
#import "LBAlternativeTableViewController.h"
#import "LBRouteStop.h"
#import "LBSpinner.h"
#import "LBListaFermateTableController.h"
#import "LBUrl.h"

@interface LBTrovaPercorsoDetailView : UIViewController <UITableViewDelegate,UITableViewDataSource>{
    
    LBSession *sessione;
    
    //array table indicazioni
    NSMutableArray *indicazioni;
    
    LBSpinner *spinner;
    
    //connessione
    NSURLConnection *getStopList;
    NSMutableData *receivedData;
    
    GADBannerView *bannerView_;
}

//info
@property (weak, nonatomic) IBOutlet UILabel *departureSessioLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalSessionLabel;

@property (weak, nonatomic) IBOutlet UILabel *departureLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rideDurationLabel;

//scroll segment
@property (weak, nonatomic) IBOutlet UIScrollView *scrollSegment;
@property (weak, nonatomic) IBOutlet UITableView *tableVewIndications;

- (IBAction)segmentAction:(id)sender;
- (IBAction)showAlternative:(id)sender;
- (void) updateDetailViewWithAlternative:(LBResults*)alternativa;

//other outlets
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentCtl;
@property (weak, nonatomic) IBOutlet UILabel *tempoProgrammatoLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempoProgrammatoLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tempoPercorrenza;
@property (weak, nonatomic) IBOutlet UIButton *showAlternatives;


@end
