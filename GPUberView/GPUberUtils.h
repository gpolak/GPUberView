//
//  GPUberUtils.h
//  GPUberViewDemo
//
//  Created by George Polak on 2/9/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GPUberUtils : NSObject

+ (UILabel *)titleLabelForController:(UINavigationController *)controller text:(NSString *)text;
+ (UILabel *)errorLabelWithText:(NSString *)text;
+ (void)openURL:(NSURL *)url;
+ (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated;
+ (void)zoomMapView:(MKMapView *)mapView toRoute:(MKRoute *)route animated:(BOOL)animated;
+ (BOOL)isCoordinate:(CLLocationCoordinate2D)c1 equalToCoordinate:(CLLocationCoordinate2D)c2;

@end
