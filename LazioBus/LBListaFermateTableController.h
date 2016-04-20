//
//  LBListaFermateTableViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 29/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBRouteStop.h"
#import "LBListaFermateCell.h"
#import "LBUrl.h"

@interface LBListaFermateTableController : UIViewController {
    
    GADBannerView *bannerView_;
    BOOL tableLoaded; //lo uso la prima volta per fare lo scroll in automatico della tabella
}

@property NSMutableArray *tableStopArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
