//
//  LBNewsTableViewCell.h
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBNewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
