//
//  LBCalcolaTariffaDetailController.h
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBFare.h"
#import "LBTariffaDetailTableViewCell.h"
#import "LBUrl.h"

@interface LBCalcolaTariffaDetailController : UIViewController {
    
    GADBannerView *bannerView_;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *faresArray;

@end
