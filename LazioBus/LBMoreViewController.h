//
//  LBMoreViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBNewsViewController.h"
#import "LBContattiViewController.h"
#import "LBCreditsViewController.h"

@interface LBMoreViewController : UIViewController {
    
}

@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (weak, nonatomic) IBOutlet UIButton *contactsButton;
@property (weak, nonatomic) IBOutlet UIButton *creditsButton;
@property (weak, nonatomic) IBOutlet UIButton *goToProButton;

- (IBAction)newsButtonAction:(id)sender;
- (IBAction)contactsButtonAction:(id)sender;
- (IBAction)creditsButtonAction:(id)sender;
- (IBAction)goToPro:(id)sender;

@end
