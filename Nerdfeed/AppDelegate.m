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
    
    [self.window setRootViewController:masterNav];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
