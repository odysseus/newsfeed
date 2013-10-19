//
//  BNRConnection.h
//  Nerdfeed
//
//  Created by Ryan Case on 10/17/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface BNRConnection : NSObject
    <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

- (id)initWithRequest:(NSURLRequest *)req;

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(id obj, NSError *err);

@property (nonatomic, strong) id <NSXMLParserDelegate> xmlRootObject;
@property (nonatomic, strong) id <JSONSerializable> jsonRootObject;

- (void)start;

@end
