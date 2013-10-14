//
//  AppDelegate.m
//  Nerdfeed
//
//  Created by Ryan Case on 10/11/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "AppDelegate.h"
#import "ListViewController.h"
#import "WebViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    ListViewController *lvc = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *masterNav = [[UINavigationController alloc]
                                        initWithRootViewController:lvc];
    
    WebViewController *wvc = [[WebViewController alloc] init];
    [lvc setWebViewController:wvc];
    
    // Check to make sure we're running on the iPad.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        UINavigationController *detailNav =
        [[UINavigationController alloc] initWithRootViewController:wvc];
        
        NSArray *vcs = [NSArray arrayWithObjects:masterNav, detailNav, nil];
        
        UISplitViewController *svc = [[UISplitViewController alloc] init];
        
        // Set the delegate of the split view controller to the detail VC
        [svc setDelegate:wvc];
        
        [svc setViewControllers:vcs];
        
        // Set the root view controller of the window to the split view controller
        [[self window] setRootViewController:svc];
    } else {
        // For non iPad's just use a normal single view approach
        [[self window] setRootViewController:masterNav];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
