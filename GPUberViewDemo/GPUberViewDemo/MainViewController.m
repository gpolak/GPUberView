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
    
    [self performSelector: @selector(callUber) withObject:self afterDelay: 0.0];
}

- (IBAction)callUber {
    GPUberViewController *vc = [[GPUberViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nVc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nVc animated:YES completion:nil];
}

@end
