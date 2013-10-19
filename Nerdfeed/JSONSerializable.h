//
//  JSONSerializable.h
//  Nerdfeed
//
//  Created by Ryan Case on 10/18/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONSerializable <NSObject>

- (void)readFromJSONDictionary:(NSDictionary *)d;

@end
