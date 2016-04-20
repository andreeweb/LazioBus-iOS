//
//  LBAppDelegate.m
//  LazioBus
//
//  Created by Andrea Cerra on 04/12/13.
//  Copyright (c) 2013 Andrea Cerra. All rights reserved.
//

#import "LBAppDelegate.h"

@implementation LBAppDelegate
@synthesize rootController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //database
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //Save DB to document's directory
    databaseName = @"laziobus.sqlite";
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    databasePath = [documentDir stringByAppendingPathComponent:databaseName];
    
    [defaults setObject:databasePath forKey:@"databasePath"];
    [defaults synchronize];
    
    [self createAndCheckDatabase];
    
    //Inizializzo il rootController
    [[NSBundle mainBundle] loadNibNamed:@"LBMainController" owner:self options:nil];
    [self.window setRootViewController:rootController];
    
    //iOS personalizzazione
    float currentVersion = 7.0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < currentVersion){
        
        //iOS colore icone
        [[rootController tabBar] setTintColor:[UIColor colorWithRed:0.0/255
                                                          green:150.0/255
                                                           blue:210.0/255
                                                          alpha:1]];
        //trova percorso
        UITabBarItem *tp = [rootController.tabBar.items objectAtIndex:0];
        tp.image = [UIImage imageNamed:@"tp"];
        tp.selectedImage = [UIImage imageNamed:@"tp_over"];
        tp.title = NSLocalizedString(@"Trova percorso", @"");
        
        //trova fermata
        UITabBarItem *tf    = [rootController.tabBar.items objectAtIndex:1];
        tf.image            = [UIImage imageNamed:@"tf"];
        tf.selectedImage    = [UIImage imageNamed:@"tf_over"];
        tf.title = NSLocalizedString(@"Trova fermata", @"");
        
        //orari
        UITabBarItem *or    = [rootController.tabBar.items objectAtIndex:2];
        or.image            = [UIImage imageNamed:@"orari"];
        or.selectedImage    = [UIImage imageNamed:@"orari_over"];
        or.title = NSLocalizedString(@"Orari", @"");
        
        //calcola tariffa
        UITabBarItem *ct    = [rootController.tabBar.items objectAtIndex:3];
        ct.image            = [UIImage imageNamed:@"ct"];
        ct.selectedImage    = [UIImage imageNamed:@"ct_over"];
        ct.title = NSLocalizedString(@"Calcola tariffa", @"");
        
        //altro
        UITabBarItem *mr    = [rootController.tabBar.items objectAtIndex:4];
        mr.image            = [UIImage imageNamed:@"more"];
        mr.selectedImage    = [UIImage imageNamed:@"more_over"];
        mr.title = NSLocalizedString(@"Altro", @"");
        
    }else {
        
        //nav bar button color
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
        //iOS7 colore icone quando selezionate
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:40.0/255 green:91.0/255 blue:128.0/255 alpha:1.0],
                                                           UITextAttributeTextColor, nil]
                                                 forState:UIControlStateNormal];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor],
                                                           UITextAttributeTextColor, nil]
                                                 forState:UIControlStateSelected];
        
        [[rootController tabBar] setTintColor:[UIColor whiteColor]];
        
        //setto a mano le img per la tabbar, sembra che non ci sia un modo veloce di poter cambiare colore alle immagini
        
        //trova percorso
        // set selected and unselected icons
        UITabBarItem *tp = [rootController.tabBar.items objectAtIndex:0];
        // this way, the icon gets rendered as it is (thus, it needs to be green in this example)
        tp.image = [[UIImage imageNamed:@"tp"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // this icon is used for selected tab and it will get tinted as defined in self.tabBar.tintColor
        tp.selectedImage = [UIImage imageNamed:@"tp_over"];
        tp.title = NSLocalizedString(@"Trova percorso", @"");
        
        //ora lo faccio per tutte le altre icone
        
        //trova fermata
        UITabBarItem *tf    = [rootController.tabBar.items objectAtIndex:1];
        tf.image            = [[UIImage imageNamed:@"tf"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tf.selectedImage    = [UIImage imageNamed:@"tf_over"];
        tf.title = NSLocalizedString(@"Trova fermata", @"");
        
        //orari
        UITabBarItem *or    = [rootController.tabBar.items objectAtIndex:2];
        or.image            = [[UIImage imageNamed:@"orari"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        or.selectedImage    = [UIImage imageNamed:@"orari_over"];
        or.title = NSLocalizedString(@"Orari", @"");
        
        //calcola tariffa
        UITabBarItem *ct    = [rootController.tabBar.items objectAtIndex:3];
        ct.image            = [[UIImage imageNamed:@"ct"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ct.selectedImage    = [UIImage imageNamed:@"ct_over"];
        ct.title = NSLocalizedString(@"Calcola tariffa", @"");
        
        //altro
        UITabBarItem *mr    = [rootController.tabBar.items objectAtIndex:4];
        mr.image            = [[UIImage imageNamed:@"more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        mr.selectedImage    = [UIImage imageNamed:@"more_over"];
        mr.title = NSLocalizedString(@"Altro", @"");
    }

    //status bar color white
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) createAndCheckDatabase{
    
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    
    if(success){
        NSLog(@"exist");
        return;
    }else
        NSLog(@"not exist");
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    
    NSLog(@"created");
}

@end
