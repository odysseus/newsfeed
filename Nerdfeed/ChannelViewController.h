//
//  ChannelViewController.h
//  Nerdfeed
//
//  Created by Ryan Case on 10/14/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@class RSSChannel;

@interface ChannelViewController : UITableViewController <ListViewControllerDelegate>
{
    RSSChannel *channel;
}

@end
