//
//  ODScrollMenu.h
//  Bene Comune
//
//  Created by Andrea Cerra on 26/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODButton.h"

//definisco protocollo per aggiungere un metodo al delegate
@protocol ODScrollMenuDelegate <UIScrollViewDelegate>
@optional


- (void)scrollTopBarSelectedItem:(NSInteger)index;
- (void)scrollTopBarDeselectedItem:(NSInteger)index;
- (NSInteger) buttonInScrollView;
- (ODButton *) buttonInColumn:(NSInteger)index;

@end

//interface classica
@interface ODScrollMenu : UIScrollView
{
    UIImageView *scrollLeftArrow;
    UIImageView *scrollRightArrow;
}

//definisco il delegate
@property(nonatomic, assign) id<ODScrollMenuDelegate> delegate;

- (void) loadScrollView;
- (void) loadScrollViewAndInitWithIndex:(NSInteger)index;
- (void) resetStateButton;
- (void) scrollToIndex:(NSInteger)index;

@end
