//
//  GPUberNetworking.h
//  GPUberViewDemo
//
//  Created by George Polak on 2/9/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bolts.h"
#import <CoreLocation/CoreLocation.h>

@interface GPUberNetworking : NSObject

extern NSString *const GP_UBER_VIEW_DOMAIN;

+ (BFTask *)productsForStart:(CLLocationCoordinate2D)start serverToken:(NSString *)serverToken;
+ (BFTask *)timeEstimatesForStart:(CLLocationCoordinate2D)start serverToken:(NSString *)serverToken;
+ (BFTask *)pricesForStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end serverToken:(NSString *)serverToken;

+ (void)imageForUrl:(NSURL *)url completion:(void (^)(UIImage *image, NSError *error))completion;

@end
