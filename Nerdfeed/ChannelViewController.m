//
//  ChannelViewController.m
//  Nerdfeed
//
//  Created by Ryan Case on 10/14/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "ChannelViewController.h"
#import "RSSChannel.h"

@interface ChannelViewController ()

@end

@implementation ChannelViewController

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                      reuseIdentifier:@"UITableViewCell"];
    
    if ([indexPath row] == 0) {
        // Put the title of the channel in row 0
        [[cell textLabel] setText:@"Title"];
        [[cell detailTextLabel] setText:[channel title]];
    } else {
        // Put the description of the channel in row 1
        [[cell textLabel] setText:@"Info"];
        [[cell detailTextLabel] setText:[channel infoString]];
    }
    
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return YES;
    return io == UIInterfaceOrientationPortrait;
}

// Delegate method for the ListViewController
- (void)listViewController:(ListViewController *)lvc handleObject:(id)object
{
    // Make sure the ListViewController gave us the right object
    if (![object isKindOfClass:[RSSChannel class]])
        return;
    
    channel = object;
    
    [[self tableView] reloadData];
}

// Delegate methods for the UISplitViewController
- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    [barButtonItem setTitle:@"List"];
    
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if (barButtonItem == [[self navigationItem] leftBarButtonItem])
        [[self navigationItem] setLeftBarButtonItem:nil];
}

@end
