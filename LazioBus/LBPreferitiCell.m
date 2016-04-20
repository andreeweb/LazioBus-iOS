//
//  LBPreferitiCell.m
//  LazioBus
//
//  Created by Andrea Cerra on 14/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBPreferitiCell.h"

@implementation LBPreferitiCell
@synthesize cellButton, cellText;

- (void)awakeFromNib
{
    // Initialization code
    #if defined(IS_LITE)
        
        //nascondo la stella
        [cellButton setHidden:YES];
        
        //riposiziono la label del testo
        [cellText setFrame:CGRectMake(10,
                                      cellText.frame.origin.y,
                                      255,
                                      50)];
    #endif
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
