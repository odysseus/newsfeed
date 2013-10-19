//
//  RSSChannel.m
//  Nerdfeed
//
//  Created by Ryan Case on 10/12/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSItem.h"

@implementation RSSChannel

@synthesize parentParserDelegate, infoString, items, title;

- (id)init
{
    self = [super init];
    
    if (self) {
        // Create the container for the RSSItems this channel has;
        // we'll create the RSSItem class shortly.
        items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{    
    if ([elementName isEqual:@"title"]) {
        currentString = [[NSMutableString alloc] init];
        [self setTitle:currentString];
    }
    else if ([elementName isEqual:@"description"]) {
        currentString = [[NSMutableString alloc] init];
        [self setInfoString:currentString];
    } else if ([elementName isEqual:@"item"] || [elementName isEqual:@"entry"]) {
        // When we find an item, create an instance of RSSItem
        RSSItem *entry = [[RSSItem alloc] init];
        
        // Set up its parent as ourselves so we can regain control of the parser
        [entry setParentParserDelegate:self];
        
        // Turn the parser to the RSSItem
        [parser setDelegate:entry];
        
        // Add the item to our array and release our hold on it
        [items addObject:entry];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    // If we were in an element that we were collecting the string for,
    // this appropriately releases our hold on it and the permanent ivar keeps
    // ownership of it. If we weren't parsing such an element, currentString
    // is nil already.
    currentString = nil;
    
    // If the element that ended was the channel, give up control to
    // who gave us control in the first place
    if ([elementName isEqual:@"channel"]) {
        [parser setDelegate:parentParserDelegate];
        [self trimItemTitles];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)str
{
    [currentString appendString:str];
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    // The top-level object contains a "feed" object, which is the channel.
    NSDictionary *feed = [d objectForKey:@"feed"];
    
    // The feed has a title property, make this the title of our channel.
    [self setTitle:[[feed objectForKey:@"title"] objectForKey:@"label"]];
    
    // The feed also has an array of entries, for each one, make a new RSSItem.
    NSArray *entries = [feed objectForKey:@"entry"];
    for (NSDictionary *entry in entries) {
        RSSItem *i = [[RSSItem alloc] init];
        
        // Pass the entry dictionary to the item so it can grab its ivars
        [i readFromJSONDictionary:entry];
        
        [items addObject:i];
    }
}

- (void)trimItemTitles
{
    // Create a regular expression to parse the feed items
    NSRegularExpression *reg =
    [[NSRegularExpression alloc] initWithPattern:@"(.*) :: (.*) :: .*"
                                         options:0
                                           error:nil];
    
    // Loop through every item
    for (RSSItem *i in items) {
        NSString *itemTitle = [i title];
        
        // Find matches in the title string. The range
        // argument specifies how much of the title to search;
        // in this case, all of it.
        NSArray *matches = [reg matchesInString:itemTitle
                                        options:0
                                          range:NSMakeRange(0, [itemTitle length])];
        
        // If there was a match...
        if ([matches count] > 0) {
            // Print the location of the match in the string and the string
            NSTextCheckingResult *result = [matches objectAtIndex:0];
            // One capture group, so two ranges, let's verify
            if ([result numberOfRanges] == 3) {
                
                // Pull out the 2nd range, which will be the capture group
                NSRange titleRange = [result rangeAtIndex:2];
                NSRange subforumRange = [result rangeAtIndex:1];
                
                // Set the title of the item to the string within the capture group
                [i setTitle:[itemTitle substringWithRange:titleRange]];
                NSLog(@"%@", [itemTitle substringWithRange:subforumRange]);
                [i setSubforum:[itemTitle substringWithRange:subforumRange]];
            }
        }
    }
}

@end




















