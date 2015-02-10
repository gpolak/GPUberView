//
//  GPUberNetworking.h
//  GPUberViewDemo
//
//  Created by George Polak on 2/9/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts.h>
#import <CoreLocation/CoreLocation.h>

@interface GPUberNetworking : NSObject

+ (BFTask *)productsForStart:(CLLocationCoordinate2D)start serverToken:(NSString *)serverToken;
+ (BFTask *)pricesForStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end serverToken:(NSString *)serverToken;

@end
