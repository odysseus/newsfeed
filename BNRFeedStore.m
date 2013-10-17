//
//  BNRFeedStore.m
//  Nerdfeed
//
//  Created by Ryan Case on 10/16/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "BNRFeedStore.h"

@implementation BNRFeedStore

+ (BNRFeedStore *)sharedStore
{
    static BNRFeedStore *feedStore = nil;
    if (!feedStore)
        feedStore = [[BNRFeedStore alloc] init];
    
    return feedStore;
}

@end
