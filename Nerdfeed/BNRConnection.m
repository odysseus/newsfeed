//
//  BNRConnection.m
//  Nerdfeed
//
//  Created by Ryan Case on 10/17/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "BNRConnection.h"

@implementation BNRConnection

@synthesize request, completionBlock, xmlRootObject, jsonRootObject;

static NSMutableArray *sharedConnectionList = nil;

- (id)initWithRequest:(NSURLRequest *)req
{
    self = [super init];
    if (self) {
        [self setRequest:req];
    }
    return self;
}

- (void)start
{
    // Initialize container for data collected from NSURLConnection
    container = [[NSMutableData alloc] init];
    
    // Spawn connection
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request]
                                                         delegate:self
                                                 startImmediately:YES];
    
    // If this is the first connection started, create the array
    if (!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    
    // Add the connection to the array so it doesn't get destroyed
    [sharedConnectionList addObject:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set a root object that will work for both JSON and XML
    id rootObject = nil;
    // Now check for an xmlRootObject
    if ([self xmlRootObject]) {
        // Create a parser
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:container];
        [parser setDelegate:[self xmlRootObject]];
        // Parse the data
        [parser parse];
        // Set the root object
        rootObject = [self xmlRootObject];
    // Otherwise check for a jsonRootObject
    } else if ([self jsonRootObject]) {
        // Turn JSON data into basic model objects
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:container
                                                          options:0
                                                            error:nil];
        
        // Construct the root object from the JSON data
        [[self jsonRootObject] readFromJSONDictionary:d];
        
        rootObject = [self jsonRootObject];
    }
    
    // Finally pass the root object to the provided completion block
    if ([self completionBlock])
        [self completionBlock](rootObject, nil);
    
    // Now, destroy this connection
    [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Pass the error from the connection to the completionBlock
    if ([self completionBlock])
        [self completionBlock](nil, error);
    
    // Destroy this connection
    [sharedConnectionList removeObject:self];
}

@end
