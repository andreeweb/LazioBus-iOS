//
//  LBPopupList.h
//  LazioBus
//
//  Created by Andrea Cerra on 14/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBOrariTableViewController.h"

@interface LBPopupList : UIViewController {
    
}

@property NSMutableArray *pathsArray;
@property UIViewController *parent;

- (IBAction)closeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *selectTimesLabel;

@end
