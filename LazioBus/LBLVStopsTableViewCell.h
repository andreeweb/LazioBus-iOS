//
//  LBLVStopsTableViewCell.h
//  LazioBus
//
//  Created by Andrea Cerra on 29/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBButton.h"

@interface LBLVStopsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellText;
@property (weak, nonatomic) IBOutlet LBButton *cellButton;
@property (weak, nonatomic) IBOutlet UILabel *cellDirections;

@end
