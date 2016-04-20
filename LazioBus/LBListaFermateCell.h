//
//  LBListaFermateCell.h
//  LazioBus
//
//  Created by Andrea Cerra on 29/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBListaFermateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellColor;
@property (weak, nonatomic) IBOutlet UILabel *cellStop;
@property (weak, nonatomic) IBOutlet UILabel *cellTime;
@end
