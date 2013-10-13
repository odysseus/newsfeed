//
//  RSSItem.h
//  Nerdfeed
//
//  Created by Ryan Case on 10/12/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSItem : NSObject <NSXMLParserDelegate>
{
    NSMutableString *currentString;
}
@property (nonatomic, weak) id parentParserDelegate;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;


@end
