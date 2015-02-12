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
@property (nonatomic, readonly) NSString *clientId;
@property (nonatomic, readonly) CLLocationCoordinate2D startLocation;
@property (nonatomic, readonly) CLLocationCoordinate2D endLocation;

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *countryCode;
@property (nonatomic) NSString *mobileCountryCode;
@property (nonatomic) NSString *mobilePhone;
@property (nonatomic) NSString *zipcode;

- (id)initWithServerToken:(NSString *)serverToken
                 clientId:(NSString *)clientId
                    start:(CLLocationCoordinate2D)start
                      end:(CLLocationCoordinate2D)end;

- (void)showInViewController:(UIViewController *)viewController;

@end
