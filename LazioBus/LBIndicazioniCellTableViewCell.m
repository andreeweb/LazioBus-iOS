//
//  LBIndicazioniCellTableViewCell.m
//  LazioBus
//
//  Created by Andrea Cerra on 14/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBIndicazioniCellTableViewCell.h"

@implementation LBIndicazioniCellTableViewCell
@synthesize cellText;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected)
        [self.backgroundShadow setBackgroundColor:[UIColor colorWithRed:0.0/255 green:150.0/255 blue:210.0/255 alpha:1]];
    else
        [self.backgroundShadow setBackgroundColor:[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1]];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted)
        [self.backgroundShadow setBackgroundColor:[UIColor colorWithRed:0.0/255 green:150.0/255 blue:210.0/255 alpha:1]];
    else
        [self.backgroundShadow setBackgroundColor:[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1]];
}


@end
