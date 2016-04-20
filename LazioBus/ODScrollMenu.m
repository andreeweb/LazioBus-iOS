//
//  ODScrollMenu.m
//  Bene Comune
//
//  Created by Andrea Cerra on 26/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "ODScrollMenu.h"

@implementation ODScrollMenu
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)buttonAction:(id)sender
{
    ODButton *button = (ODButton*)sender;
    
    if(delegate && [delegate respondsToSelector:@selector(scrollTopBarSelectedItem:)]) {
            
        [self resetStateButton];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:0.0/255 green:150.0/255 blue:211.0/255 alpha:1]];
        [delegate scrollTopBarSelectedItem:button.tag];
        
    }else
        NSAssert(delegate && [delegate respondsToSelector:@selector(scrollTopBarSelectedItem:)], @"Need implement scrollTopBarSelectedItem");
}

- (void) loadScrollView
{
    
    if(delegate && [delegate respondsToSelector:@selector(buttonInScrollView)]) {
        
        //set buttons
        int spazio = 2;
        for (NSInteger i = 0; i < [delegate buttonInScrollView]; i++) {
            
            ODButton *button = [delegate buttonInColumn:i];
            [button setFrame:CGRectMake(spazio, 0, 75, 44)];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundColor:[UIColor whiteColor]];
            //[button setBackgroundColor:[UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1]];
            [self addSubview:button];
            [button setTag:i+1];
            
            spazio += 80;
        }
        
        //set sroll content size
        [self setContentSize:CGSizeMake(spazio, 0)];
        
        //set arrow image on left
        if ([delegate buttonInScrollView] > 4) {
            scrollLeftArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 44)];
            [scrollLeftArrow setImage:[UIImage imageNamed:@"scroll_left_arrow"]];
            [scrollLeftArrow setHidden:YES];
            [self addSubview:scrollLeftArrow];
        }
        
        //set arrow image on right
        if ([delegate buttonInScrollView] > 4) {
            scrollRightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 14, 0, 14, 44)];
            [scrollRightArrow setImage:[UIImage imageNamed:@"scroll_right_arrow"]];
            [self addSubview:scrollRightArrow];
        }
        
    }else
        NSAssert(delegate && [delegate respondsToSelector:@selector(buttonInScrollView)], @"Need implement buttonInScrollView");
}

- (void) loadScrollViewAndInitWithIndex:(NSInteger)index {
    
    //inizializzo
    [self loadScrollView];
    
    //setto la index di default
    for(UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[ODButton class]]) {
            ODButton *button = (ODButton*)subview;
            if ([button tag] == index) {
                [self buttonAction:button]; //set button and scroll to his position, -60 for center in view
                [self setContentOffset:CGPointMake(button.frame.origin.x-120, 0) animated:YES];
                break;
            }
        }
    }
}

- (void) scrollToIndex:(NSInteger)index {
    
    //setto la index di default
    for(UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[ODButton class]]) {
            ODButton *button = (ODButton*)subview;
            if ([button tag] == index) {
                [self setContentOffset:CGPointMake(button.frame.origin.x-120, 0) animated:YES];
                break;
            }
        }
    }
}

- (void) resetStateButton
{
    for(UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[ODButton class]]) {
            ODButton *button = (ODButton*)subview;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            //[button setBackgroundColor:[UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1]];
        }
    }
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    
    if (contentOffset.x > 0.0f) {
        [scrollLeftArrow setHidden:NO];
        [scrollLeftArrow setFrame:CGRectMake(contentOffset.x, 0, 14, 44)];
    }else
        [scrollLeftArrow setHidden:YES];
    
    if (contentOffset.x + self.frame.size.width < self.contentSize.width) {
        [scrollRightArrow setHidden:NO];
        [scrollRightArrow setFrame:CGRectMake(contentOffset.x + self.frame.size.width - scrollRightArrow.frame.size.width, 0, 14, 44)];
    }else
        [scrollRightArrow setHidden:YES];
    
    //NSLog(@"ViewDidScroll: %f, %f", contentOffset.x, contentOffset.y);
}

@end
