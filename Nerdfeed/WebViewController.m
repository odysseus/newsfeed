//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Ryan Case on 10/12/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "WebViewController.h"

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
    // Remove the current toolbar
    [toolbar removeFromSuperview];
    // Set to nil for good measure
    toolbar = nil;
    
    // Change the frame based on orientation
    CGRect toolbarFrame;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[UIApplication sharedApplication] statusBarOrientation] > 2) {
        toolbarFrame = CGRectMake(0, bounds.size.height - 44, bounds.size.width, 44);
    } else {
        toolbarFrame = CGRectMake(0, bounds.size.width - 44, bounds.size.height, 44);
    }

    toolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];

    // Add the toolbar items, saved in instance variables so no need to re init them
    NSArray *barItems = [NSArray arrayWithObjects:back, forward, nil];
    [toolbar setItems:barItems];
    
    // Add the toolbar to the webview
    [webView addSubview:toolbar];
    [self updateButtons];
}

@end
