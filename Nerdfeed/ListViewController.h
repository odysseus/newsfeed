//
//  ListViewController.h
//  Nerdfeed
//
//  Created by Ryan Case on 10/11/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSChannel;
@class WebViewController;

@interface ListViewController : UITableViewController
{    
    RSSChannel *channel;
}

@property (nonatomic, strong) WebViewController *webViewController;

- (void)fetchEntries;

@end

@protocol ListViewControllerDelegate

// Classes conforming to this protocol must implment this method
- (void)listViewController:(ListViewController *)lvc handleObject:(id)object;

@end