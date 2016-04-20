//
//  LBAppDelegate.h
//  LazioBus
//
//  Created by Andrea Cerra on 04/12/13.
//  Copyright (c) 2013 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBAppDelegate : UIResponder <UIApplicationDelegate> {
    
    //database
    NSString *databasePath;
    NSString *databaseName;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *rootController;

@end
