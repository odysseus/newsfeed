//
//  ListViewController.m
//  Nerdfeed
//
//  Created by Ryan Case on 10/11/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "ListViewController.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "WebViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

@synthesize webViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self fetchEntries];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [channel.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    RSSItem *item = [[channel items] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item title]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Push the web view controller onto the navigation stack - this implicitly
    // creates the web view controller's view the first time through
    [[self navigationController] pushViewController:webViewController animated:YES];
    
    // Grab the selected item
    RSSItem *entry = [[channel items] objectAtIndex:[indexPath row]];
    
    // Construct a URL with the link string of the item
    NSURL *url = [NSURL URLWithString:[entry link]];
    
    // Construct a request object with that URL
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Load the request into the web view
    [[webViewController webView] loadRequest:req];
    
    // Set the title of the web view controller's navigation item
    [[webViewController navigationItem] setTitle:[entry title]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Apple News";
}

- (void)fetchEntries
{
    // Create a container for the data
    xmlData = [[NSMutableData alloc] init];
    
    // Connect to Apple's Hot News Feed
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com/pr/feeds/pr.rss"];
    
    // Use the URL to create the request
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Create the connection and connect
    connection = [[NSURLConnection alloc] initWithRequest:req
                                                 delegate:self
                                         startImmediately:YES];
}

// Data methods

// Method called every time a chunk of data is received from the NSURLConnection
- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [xmlData appendData:data];
}

// Method called when all data has been retrieved
- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    // Create a parser object with the xmlData
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    // Give it a delegate - ignore the warning here for now
    [parser setDelegate:self];
    
    // Tell it to start parsing - the document will be parsed and
    // the delegate of NSXMLParser will get all of its delegate messages
    // sent to it before this line finishes execution - it is blocking
    [parser parse];
    
    // Remove the xmlData and the connection since they are not needed anymore
    xmlData = nil;
    connection = nil;
    
    NSLog(@"%@\n %@\n %@\n", channel, [channel title], [channel infoString]);
    
    // Reload the table.
    [[self tableView] reloadData];
}

- (void)connection:(NSURLConnection *)conn
  didFailWithError:(NSError *)error
{
    // Release the connection object, we're done with it
    connection = nil;
    
    // Release the xmlData object, we're done with it
    xmlData = nil;
    
    // Grab the description of the error object passed to us
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                             [error localizedDescription]];
    
    // Create and show an alert view with this error displayed
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errorString
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}

// Parser Delegate Methods

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    NSLog(@"%@ found a %@ element", self, elementName);
    if ([elementName isEqual:@"channel"]) {
        
        // If the parser saw a channel, create new instance, store in our ivar
        channel = [[RSSChannel alloc] init];
        
        // Give the channel object a pointer back to ourselves for later
        [channel setParentParserDelegate:self];
        
        // Set the parser's delegate to the channel object
        // There will be a warning here, ignore it for now
        [parser setDelegate:channel];
    }
}


@end































