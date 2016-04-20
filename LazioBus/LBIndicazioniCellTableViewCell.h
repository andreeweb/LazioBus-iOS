//
//  LBIndicazioniCellTableViewCell.h
//  LazioBus
//
//  Created by Andrea Cerra on 14/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBIndicazioniCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *cellText;
@property (weak, nonatomic) IBOutlet UIView *backgroundFrame;
@property (weak, nonatomic) IBOutlet UIView *backgroundShadow;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@end
