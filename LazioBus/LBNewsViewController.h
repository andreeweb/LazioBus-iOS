//
//  LBNewsViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBUrl.h"
#import "LBNewsTableViewCell.h"
#import "LBNews.h"
#import "LBSpinner.h"
#import "LBNewsDetailViewController.h"

@interface LBNewsViewController : UIViewController {
    
    GADBannerView *bannerView_;
    
    //table array
    NSMutableArray *newsArray;
    
    NSURLConnection *downloadNews;
    NSMutableData *receivedData;
    
    //wait
    LBSpinner *spinner;
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewNews;

@end
