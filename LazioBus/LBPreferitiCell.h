//
//  LBPreferitiCell.h
//  LazioBus
//
//  Created by Andrea Cerra on 14/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBButton.h"

@interface LBPreferitiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellText;
@property (weak, nonatomic) IBOutlet LBButton *cellButton;


@end
