//
//  MainViewController.m
//  ModalUITest
//
//  Created by George Polak on 2/9/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import "MainViewController.h"
#import "GPUberViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)callUber {
    /*
     * I left a test server token here for the convenience of this demo app.
     * Please use your own credentials in your own production app.
     */
    NSString *serverToken = @"P_DXM1dCDDq_f17lvgk57FBPWmc8vCD6Bwid2ULp";
    
//    CLLocationCoordinate2D pickup = CLLocationCoordinate2DMake(42.352311,-71.055304);
//    CLLocationCoordinate2D dropoff = CLLocationCoordinate2DMake(42.346676,-71.097218);
    
//    CLLocationCoordinate2D pickup = CLLocationCoordinate2DMake(26.142234, -81.800060);
//    CLLocationCoordinate2D dropoff = CLLocationCoordinate2DMake(26.527701,-81.755580);
    
    CLLocationCoordinate2D pickup = CLLocationCoordinate2DMake(40.74844,-73.985664);
    CLLocationCoordinate2D dropoff = CLLocationCoordinate2DMake(40.713008,-74.013169);
    
    GPUberViewController *uber = [[GPUberViewController alloc] initWithServerToken:serverToken
                                                                             start:pickup
                                                                               end:dropoff];
    
    uber.startName = @"SStation";
    uber.endName = @"Fenway Stadium";

    [uber showInViewController:self];
}

@end
