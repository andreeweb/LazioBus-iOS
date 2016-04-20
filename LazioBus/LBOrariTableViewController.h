//
//  LBOrariSavedTableViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 30/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPDF.h"
#import "LBOrariDetailViewController.h"
#import "MBProgressHUD.h"
#import "LBUrl.h"

@interface LBOrariTableViewController : UIViewController {
    
    NSMutableArray *searchResults;
    
    GADBannerView *bannerView_;
}

@property NSString *action;
@property NSString *path;
@property NSMutableArray *pdfArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
