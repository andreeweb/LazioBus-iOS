//
//  LBSpinner.h
//  LazioBus
//
//  Created by Andrea Cerra on 13/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBSpinner : UIView {
    UIBarButtonItem * barButton;
}

@property UIActivityIndicatorView *spinner;
@property UIViewController *controller;
@property UIColor *spinnerColor;

- (id) initForViewController:(UIViewController*)controller;
- (void) startSpinner;
- (void) stopSpinner;

@end
