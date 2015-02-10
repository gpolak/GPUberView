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
    NSString *serverToken = @"your_server_token";
    NSString *clientId = @"your_client_id";
    
    CLLocationCoordinate2D start = CLLocationCoordinate2DMake(40.7471787,-73.997494);
    CLLocationCoordinate2D end = CLLocationCoordinate2DMake(40.712774,-74.006059);
    
    GPUberViewController *uber = [[GPUberViewController alloc] initWithServerKey:serverToken
                                                                        clientId:clientId
                                                                           start:start
                                                                             end:end];
    [uber showInViewController:self];
}

@end
