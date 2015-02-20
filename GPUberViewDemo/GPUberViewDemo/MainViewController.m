//
//  MainViewController.m
//  ModalUITest
//
//  Created by George Polak on 2/9/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import "MainViewController.h"
#import <GPUberViewController.h>

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
    
    // Boston: South Station
    CLLocationCoordinate2D pickup = CLLocationCoordinate2DMake(42.352311,-71.055304);
    // Boston: Fenway Park
    CLLocationCoordinate2D dropoff = CLLocationCoordinate2DMake(42.346676,-71.097218);
    
    GPUberViewController *uber = [[GPUberViewController alloc] initWithServerToken:serverToken];
    uber.startLocation = pickup;
    uber.endLocation = dropoff;

    [uber showInViewController:self];
}

@end
