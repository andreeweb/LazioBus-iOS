//
//  LBLVResultDetailViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 17/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBLVResult.h"

@interface LBLVResultDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *percorsoTextView;
@property (weak, nonatomic) IBOutlet UILabel *lastPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property LBLVResult *detail;

//for translations
@property (weak, nonatomic) IBOutlet UILabel *percorsoLabel;
@property (weak, nonatomic) IBOutlet UILabel *lPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sLabel;


@end
