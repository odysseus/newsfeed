//
//  BNRFeedStore.h
//  Nerdfeed
//
//  Created by Ryan Case on 10/16/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSSChannel;

@interface BNRFeedStore : NSObject

+ (BNRFeedStore*)sharedStore;

- (void)fetchRSSFeedWithCompletion:(void (^)(RSSChannel *obj, NSError *err))block;

- (void)fetchTopSongs:(int)count
       withCompletion:(void (^)(RSSChannel *obj, NSError *err))block;

@end
