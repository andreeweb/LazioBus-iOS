//
//  LBLVStopsTableViewCell.m
//  LazioBus
//
//  Created by Andrea Cerra on 29/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBLVStopsTableViewCell.h"

@implementation LBLVStopsTableViewCell
@synthesize cellButton, cellText, cellDirections;

- (void)awakeFromNib
{
    // Initialization code
    #if defined(IS_LITE)
        
        //nascondo la stella
        [cellButton setHidden:YES];
        
        //riposiziono la label del testo
        [cellText setFrame:CGRectMake(10,
                                      cellText.frame.origin.y,
                                      275,
                                      25)];
        [cellDirections setFrame:CGRectMake(10,
                                      cellDirections.frame.origin.y,
                                      275,
                                      25)];
    #endif
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
