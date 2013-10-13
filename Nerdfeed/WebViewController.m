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
    // Create an instance of UIWebView as large as the screen
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    
    webView = [[UIWebView alloc] initWithFrame:screenFrame];
    [webView setScalesPageToFit:YES];
    [webView setDelegate:self];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect toolbarFrame = CGRectMake(0, bounds.size.height - 44, bounds.size.width, 44);
    toolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
    
    back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                                          target:self
                                                                          action:@selector(goBack)];
    forward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                             target:self
                                                                             action:@selector(goForward)];
    NSArray *barItems = [NSArray arrayWithObjects:back, forward, nil];
    [toolbar setItems:barItems];
    
    // Add the toolbar to the webview
    [webView addSubview:toolbar];
    
    [self setView:webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateButtons];
}

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

@end
