//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Ryan Case on 10/12/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "WebViewController.h"
#import "RSSItem.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webView;

- (void)loadView
{
    NSLog(@"Load view");
    // Create an instance of UIWebView as large as the screen
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    
    webView = [[UIWebView alloc] initWithFrame:screenFrame];
    [webView setScalesPageToFit:YES];
    [webView setDelegate:self];
    
    // Create the frame for the back/forward toolbar
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect toolbarFrame;
    // Set the size and position depending on orientation
    if ([[UIApplication sharedApplication] statusBarOrientation] < 3) {
        // Portrait Orientation
        toolbarFrame = CGRectMake(0, bounds.size.height - 44, bounds.size.width, 44);
    } else {
        // Landscape Orientation
        toolbarFrame = CGRectMake(0, bounds.size.width - 44, bounds.size.height, 44);
    }
    toolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
    // init the toolbar buttons into their instance variables, because the toolbar is destroyed and
    // re-drawn when the iPad is turned, we save them to prevent re-initing them each time
    back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                         target:self
                                                         action:@selector(goBack)];
    forward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                            target:self
                                                            action:@selector(goForward)];
    // Set the toolbar items
    NSArray *barItems = [NSArray arrayWithObjects:back, forward, nil];
    [toolbar setItems:barItems];
    
    // Add the toolbar to the webview
    [webView addSubview:toolbar];
    // Set it as the view
    [self setView:webView];
    // Update the back/forward buttons so they don't appear blue on launch
    [self updateButtons];
}

// Both webViewDidStartLoad and webViewDidFinishLoad are needed to get the desired behavior
// out of the buttons
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateButtons];
}

// (semi) overriding the webView's built in back/forward methods to also call updateButtons
- (void)goBack
{
    [webView goBack];
    [self updateButtons];
}

- (void)goForward
{
    [webView goForward];
    [self updateButtons];
}

- (void)updateButtons
{
    [back setEnabled:[webView canGoBack]];
    [forward setEnabled:[webView canGoForward]];
}

- (UIWebView *)webView
{
    return (UIWebView *)[self view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return YES;
    return io == UIInterfaceOrientationPortrait;
}

// This method is called whenever the device rotates, this controls the destruction and re-drawing
// of the toolbar to always be at the bottom of the screen
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    // Change the frame based on orientation
    CGRect toolbarFrame;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if (toInterfaceOrientation == UIDeviceOrientationPortrait ||
        toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        // Changing to portrait orientation
        toolbarFrame = CGRectMake(0, bounds.size.height - 44, bounds.size.width, 44);
    } else {
        // Changing to landscape
        toolbarFrame = CGRectMake(0, bounds.size.width - 44, bounds.size.height, 44);
    }

    // Set the toolbar frame to the new value
    toolbar.frame = toolbarFrame;

    [self updateButtons];
}

// Longest method name on earth from the UISplitViewControllerDelegate
// This method specifies how the split part of a splite view controller will
// display when the iPad is in portrait orientation
- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    // If this bar button item doesn't have a title, it won't appear at all.
    [barButtonItem setTitle:@"List"];
    
    // Take this bar button item and put it on the left side of our nav item.
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
}

// The other delegate method deals with re-presenting the view controller
- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Remove the bar button item from our navigation item
    // We'll double check that its the correct button, even though we know it is
    if (barButtonItem == [[self navigationItem] leftBarButtonItem])
        [[self navigationItem] setLeftBarButtonItem:nil];
}

// Delegate method for ListViewControllerDelegate
- (void)listViewController:(ListViewController *)lvc handleObject:(id)object
{
    // Cast the passed object to RSSItem
    RSSItem *entry = object;
    
    // Make sure that we are really getting a RSSItem
    if (![entry isKindOfClass:[RSSItem class]])
        return;
    
    // Grab the info from the item and push it into the appropriate views
    NSURL *url = [NSURL URLWithString:[entry link]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [[self webView] loadRequest:req];
    
    [[self navigationItem] setTitle:[entry title]];
}

@end
