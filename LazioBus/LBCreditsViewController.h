//
//  LBCreditsViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 02/06/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBCreditsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollCredits;
@property (weak, nonatomic) IBOutlet UITextView *textDisclaimer;

@end
