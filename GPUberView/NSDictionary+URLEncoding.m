//
//  NSDictionary+URLEncoding.m
//  GPUberViewDemo
//
//  Created by George Polak on 2/9/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import "NSDictionary+URLEncoding.h"

@implementation NSDictionary (URLEncoding)

- (NSString *)encodedStringFromObject:(id)object {
    return [[object description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodedString {
    NSMutableArray *parts = [NSMutableArray array];
    
    for (id key in self) {
        id value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat:@"%@=%@",
                          [self encodedStringFromObject:key],
                          [self encodedStringFromObject:value]];
        [parts addObject: part];
    }
    
    return [parts componentsJoinedByString: @"&"];
}

@end
