//
//  GPUberUtils.m
//  GPUberViewDemo
//
//  Created by George Polak on 2/9/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import "GPUberUtils.h"

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define MAX_DEGREES_ARC 360

@implementation GPUberUtils

+ (UILabel *)titleLabelForController:(UINavigationController *)controller text:(NSString *)text {
    CGRect frame = CGRectMake(0, 0, 150, controller.navigationBar.frame.size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;

    return label;
}

+ (UILabel *)errorLabelWithText:(NSString *)text {
    CGRect frame = CGRectMake(0, 0, 200, 50);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = text;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.minimumScaleFactor = 0.5;
    [label sizeToFit];
    
    return label;
}

+ (void)openURL:(NSURL *)url {
    if (url) {
        // use Chrome browser if installed
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://"]]) {
            NSString *scheme = url.scheme;
            NSString *chromeScheme = nil;
            if ([scheme isEqualToString:@"http"])
                chromeScheme = @"googlechrome";
            else if ([scheme isEqualToString:@"https"])
                chromeScheme = @"googlechromes";
            
            // Proceed only if a valid Google Chrome URI Scheme is available.
            if (chromeScheme)
            {
                NSString *absoluteString = [url absoluteString];
                NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
                NSString *urlNoScheme = [absoluteString substringFromIndex:rangeForScheme.location];
                NSString *chromeURLString = [chromeScheme stringByAppendingString:urlNoScheme];
                url = [NSURL URLWithString:chromeURLString];
            }
        }
        
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (void)zoomMapView:(MKMapView *)mapView toRoute:(MKRoute *)route animated:(BOOL)animated {
    if (!route)
        return;
    
    // add padding
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:route.polyline.points count:route.polyline.pointCount] boundingMapRect];
    UIEdgeInsets insets = UIEdgeInsetsMake(50, 20, 30, 20);
    mapRect = [mapView mapRectThatFits:mapRect edgePadding:insets];
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( route.polyline.pointCount == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

+ (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated {
    NSArray *annotations = mapView.annotations;
    NSInteger count = [mapView.annotations count];
    
    if (count == 0)
        return;
    
    
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }

    // add padding
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    UIEdgeInsets insets = UIEdgeInsetsMake(50, 20, 30, 20);
    mapRect = [mapView mapRectThatFits:mapRect edgePadding:insets];
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

+ (BOOL)isCoordinate:(CLLocationCoordinate2D)c1 equalToCoordinate:(CLLocationCoordinate2D)c2 {
    return c1.latitude == c2.latitude && c1.longitude == c2.longitude;
}

@end
