//
//  LBListaFermateCell.m
//  LazioBus
//
//  Created by Andrea Cerra on 29/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBListaFermateCell.h"

@implementation LBListaFermateCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    self.cellColor.layer.cornerRadius = 10;
    self.cellColor.layer.masksToBounds = YES;
}

@end
