//
//  LBNewsDetailViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBNews.h"

@interface LBNewsDetailViewController : UIViewController

@property LBNews *news;

@property (weak, nonatomic) IBOutlet UILabel *dataNews;
@property (weak, nonatomic) IBOutlet UILabel *titleNews;
@property (weak, nonatomic) IBOutlet UITextView *textNews;

@end
