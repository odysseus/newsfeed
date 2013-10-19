//
//  BNRFeedStore.m
//  Nerdfeed
//
//  Created by Ryan Case on 10/16/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "BNRFeedStore.h"
#import "RSSChannel.h"
#import "BNRConnection.h"

@implementation BNRFeedStore

+ (BNRFeedStore *)sharedStore
{
    static BNRFeedStore *feedStore = nil;
    if (!feedStore)
        feedStore = [[BNRFeedStore alloc] init];
    
    return feedStore;
}

- (void)fetchRSSFeedWithCompletion:(void (^)(RSSChannel *, NSError *))block
{
    NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com/"
                  @"smartfeed.php?limit=1_DAY&sort_by=standard"
                  @"&feed_type=RSS2.0&feed_style=COMPACT"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Create an empty channel
    RSSChannel *channel = [[RSSChannel alloc] init];
    
    // Create a connection "actor" object that will transfer data from the server
    BNRConnection *connection = [[BNRConnection alloc] initWithRequest:req];
    
    // When the connection completes, this block from the controller will be called
    [connection setCompletionBlock:block];
    
    // Let the empty channel parse the returning data from the web service
    [connection setXmlRootObject:channel];
    
    // Begin the connection
    [connection start];
}

- (void)fetchTopSongs:(int)count
       withCompletion:(void (^)(RSSChannel *obj, NSError *err))block
{
    // Prepare a request URL, including the argument from the controller
    NSString *requestString = [NSString stringWithFormat:
                               @"http://itunes.apple.com/us/rss/topsongs/limit=%d/json", count];
    
    NSURL *url = [NSURL URLWithString:requestString];
    
    // Set up the connection as normal
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    RSSChannel *channel = [[RSSChannel alloc] init];
    
    BNRConnection *connection = [[BNRConnection alloc] initWithRequest:req];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    [connection start];
}

@end
