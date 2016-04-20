//
//  ODButton.m
//  Bene Comune
//
//  Created by Andrea Cerra on 26/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "ODButton.h"

@implementation ODButton
@synthesize selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        selected = FALSE;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
