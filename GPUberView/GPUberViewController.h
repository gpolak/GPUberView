//
//  UberViewController.h
//  ModalUITest
//
//  Created by George Polak on 2/9/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GPUberViewController : UIViewController {
    NSString *_clientId;
}

@property (nonatomic, readonly) NSString *serverToken;
@property (nonatomic) NSString *clientId;

@property (nonatomic) CLLocationCoordinate2D startLocation;
@property (nonatomic) CLLocationCoordinate2D endLocation;
@property (nonatomic) NSString *startName;
@property (nonatomic) NSString *endName;

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *countryCode;
@property (nonatomic) NSString *mobileCountryCode;
@property (nonatomic) NSString *mobilePhone;
@property (nonatomic) NSString *zipcode;

- (id)initWithServerToken:(NSString *)serverToken;

// deprecated in 1.0
- (id)initWithServerToken:(NSString *)serverToken
                    start:(CLLocationCoordinate2D)start
                      end:(CLLocationCoordinate2D)end __attribute__((deprecated("use initWithServerToken: instead")));

// deprecated in 0.4
- (id)initWithServerToken:(NSString *)serverToken
                 clientId:(NSString *)clientId
                    start:(CLLocationCoordinate2D)start
                      end:(CLLocationCoordinate2D)end __attribute__((deprecated("use initWithServerToken: instead")));

- (void)showInViewController:(UIViewController *)viewController;

@end
