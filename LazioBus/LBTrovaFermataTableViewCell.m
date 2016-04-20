//
//  LBTrovaFermataTableViewCell.m
//  LazioBus
//
//  Created by Andrea Cerra on 14/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBTrovaFermataTableViewCell.h"

@implementation LBTrovaFermataTableViewCell
@synthesize direzioneLabel, orarioProgrammatoLabel;

- (void)awakeFromNib
{
    // Initialization code
    [direzioneLabel setText:NSLocalizedString(@"Direzione", @"")];
    [orarioProgrammatoLabel setText:NSLocalizedString(@"Orario programmato", @"")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted)
        [self.shadowVie setBackgroundColor:[UIColor colorWithRed:0.0/255 green:150.0/255 blue:210.0/255 alpha:1]];
    else
        [self.shadowVie setBackgroundColor:[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1]];
}

@end
