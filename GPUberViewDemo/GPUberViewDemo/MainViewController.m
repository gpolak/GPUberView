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
    
//    [self performSelector: @selector(callUber) withObject:self afterDelay: 0.0];
}

- (IBAction)callUber {
    NSString *serverToken = @"P_DXM1dCDDq_f17lvgk57FBPWmc8vCD6Bwid2ULp";
    NSString *clientId = @"your_client_id";
    
    CLLocationCoordinate2D start = CLLocationCoordinate2DMake(42.384373, -71.077672);
    CLLocationCoordinate2D end = CLLocationCoordinate2DMake(42.365613, -71.00956);
    
    GPUberViewController *uber = [[GPUberViewController alloc] initWithServerKey:serverToken clientId:clientId start:start end:end];
    [uber showInViewController:self];
}

@end
