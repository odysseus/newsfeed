//
//  WebViewController.h
//  Nerdfeed
//
//  Created by Ryan Case on 10/12/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface WebViewController : UIViewController <UIWebViewDelegate, ListViewControllerDelegate>
{
    UIToolbar *toolbar;
    UIBarButtonItem *back;
    UIBarButtonItem *forward;
}

@property (nonatomic, readonly) UIWebView *webView;

- (void)goBack;
- (void)goForward;
- (void)updateButtons;

@end
