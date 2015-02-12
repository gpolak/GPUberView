//
//  UberViewController.m
//  ModalUITest
//
//  Created by George Polak on 2/9/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import "GPUberViewController.h"
#import <MapKit/MapKit.h>
#import "GPUberViewElement.h"
#import "GPUberPrice.h"
#import "GPUberNetworking.h"
#import "NSDictionary+URLEncoding.h"
#import "GPUberUtils.h"
#import "UIColor+GPUberView.h"
#import <UIImageView+WebCache.h>
#import "GPUberViewCell.h"
#import <PulsingHaloLayer.h>
#import <Masonry.h>

#define DEFAULT_CLIENT_ID @"70zxopERw9Nx2OeQU8yrUYSpW69N-RVh"

@interface GPUberViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableHeight;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *loadingView;

@property (nonatomic) PulsingHaloLayer *pulsingHalo;
@property (nonatomic) MKRoute *route;

@property (nonatomic) NSString *serverToken;
@property (nonatomic) CLLocationCoordinate2D startLocation;
@property (nonatomic) CLLocationCoordinate2D endLocation;

@property (nonatomic) NSArray *elements;

@property (nonatomic) UIColor *previousWindowColor;

@end


@implementation GPUberViewController

- (id)initWithServerToken:(NSString *)serverToken
                    start:(CLLocationCoordinate2D)start
                      end:(CLLocationCoordinate2D)end {
    
    if (serverToken.length == 0)
        [NSException raise:NSInvalidArgumentException format:@"invalid server token:%@", serverToken];
    if (!CLLocationCoordinate2DIsValid(start))
        [NSException raise:NSInvalidArgumentException format:@"invalid start (%f, %f)", start.latitude, start.longitude];
    if (!CLLocationCoordinate2DIsValid(end))
        [NSException raise:NSInvalidArgumentException format:@"invalid end (%f, %f)", end.latitude, end.longitude];
    
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.serverToken = serverToken;
        self.startLocation = start;
        self.endLocation = end;
    }
    
    return self;
}

- (id)initWithServerToken:(NSString *)serverToken
               clientId:(NSString *)clientId
                  start:(CLLocationCoordinate2D)start
                    end:(CLLocationCoordinate2D)end {
    
    GPUberViewController *instance = [self initWithServerToken:serverToken start:start end:end];
    instance.clientId = clientId;
    
    return instance;
}

- (void)showInViewController:(UIViewController *)viewController {
    UINavigationController *nVc = [[UINavigationController alloc] initWithRootViewController:self];
    [viewController presentViewController:nVc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                  target:self
                                                                                  action:@selector(cancelView)];
    cancelButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = cancelButton;
   
    self.navigationItem.titleView = [GPUberUtils titleLabelForController:self.navigationController text:@"finding drivers..."];
    
    self.view.backgroundColor = [UIColor uberLightGray];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GPUberViewCell" bundle:nil] forCellReuseIdentifier:[GPUberViewCell reuseIdentifier]];
    
    self.pulsingHalo = [PulsingHaloLayer layer];
    self.pulsingHalo.animationDuration = 1.5;
    self.pulsingHalo.backgroundColor = [UIColor uberBlue].CGColor;
    self.pulsingHalo.radius = 100;
    self.pulsingHalo.position = self.loadingView.center;
    [self.loadingView.layer addSublayer:self.pulsingHalo];
    self.pulsingHalo.hidden = YES;
    
    [self refreshTable];
    
    [[self initializeUber] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        if (task.error) {
            self.navigationItem.titleView = [GPUberUtils titleLabelForController:self.navigationController text:@"network error"];
            [self.pulsingHalo removeFromSuperlayer];
            
            UILabel *label = [GPUberUtils errorLabelWithText:@"We're sorry, but there was a problem contacting Uber."];
            [self.loadingView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.loadingView.mas_centerX);
                make.centerY.equalTo(self.loadingView.mas_centerY);
                make.width.equalTo(@(label.frame.size.width)).priorityHigh();
                make.height.equalTo(@(label.frame.size.height)).priorityHigh();
            }];
        } else {
            [self refreshTable];
            
            if (self.route)
                [GPUberUtils zoomMapView:self.mapView toRoute:self.route animated:NO];
            else
                [GPUberUtils zoomMapViewToFitAnnotations:self.mapView animated:NO];
            
            [UIView animateWithDuration:0.5 animations:^{
                self.loadingView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.loadingView removeFromSuperview];
            }];
            
            [UIView animateWithDuration:0.2 animations:^{
                self.navigationItem.titleView.alpha = 0;
            } completion:^(BOOL finished) {
                UIImage *logo = [UIImage imageNamed:@"uber_logo_15"];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:logo];
                imageView.contentMode = UIViewContentModeCenter;
                self.navigationItem.titleView = imageView;
                self.navigationItem.titleView.alpha = 0;
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.navigationItem.titleView.alpha = 1.0;
                }];
            }];
        }
        
        return nil;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIApplication *application = [UIApplication sharedApplication];
    self.previousWindowColor = application.keyWindow.backgroundColor;
    application.keyWindow.backgroundColor = [UIColor whiteColor];
    
    // recenter after view has loaded (and shifted)
    self.pulsingHalo.position = self.loadingView.center;
    self.pulsingHalo.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // restore previous UI values
    UIApplication *application = [UIApplication sharedApplication];
    application.keyWindow.backgroundColor = self.previousWindowColor;
}

- (void)setClientId:(NSString *)clientId {
    _clientId = clientId;
}

- (NSString *)clientId {
    if (_clientId)
        return _clientId;
    else
        return DEFAULT_CLIENT_ID;
}

- (IBAction)cancelView {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (GPUberViewElement *)elementWithProductId:(NSString *)productId {
    if (!productId)
        return nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productId == %@", productId];
    NSArray *filteredArray = [self.elements filteredArrayUsingPredicate:predicate];
    return filteredArray.count > 0 ? filteredArray.firstObject : nil;
}

- (BFTask *)initializeUber {
    // wait for both map routing and Uber data to finish before dismissing wait screen
    
    NSMutableArray *tasks = [NSMutableArray new];
    
    [tasks addObject:[self setupMap]];
    [tasks addObject:[self getUberData]];
    
    return [BFTask taskForCompletionOfAllTasks:tasks];
}

- (BFTask *)getUberData {
    BFTaskCompletionSource *taskSource = [BFTaskCompletionSource taskCompletionSource];
    
    [[[[GPUberNetworking productsForStart:self.startLocation
                              serverToken:self.serverToken] continueWithSuccessBlock:^id(BFTask *task) {
        
        NSArray *products = task.result;
        NSMutableArray *elements = [NSMutableArray arrayWithCapacity:products.count];
        for (GPUberProduct *product in products)
            [elements addObject:[GPUberViewElement elementWithProduct:product]];
        
        self.elements = [NSArray arrayWithArray:elements];
        
        return [GPUberNetworking pricesForStart:self.startLocation end:self.endLocation serverToken:self.serverToken];
    }] continueWithSuccessBlock:^id(BFTask *task) {
        NSArray *prices = task.result;
        for (GPUberPrice *price in prices) {
            GPUberViewElement *element = [self elementWithProductId:price.productId];
            [element parametrizeWithPrice:price];
        }
        
        return [GPUberNetworking timeEstimatesForStart:self.startLocation serverToken:self.serverToken];
    }] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"error fetching uber data:%@", task.error);
            
            [taskSource setError:task.error];
        } else {
            NSArray *times = task.result;
            for (GPUberTime *time in times) {
                GPUberViewElement *element = [self elementWithProductId:time.productId];
                [element parametrizeWithTime:time];
            }
            
            [taskSource setResult:nil];
        }
        
        return nil;
    }];
    
    return taskSource.task;
}

- (void)launchUberWithProductId:(NSString *)productId clientId:(NSString *)clientId {
    NSString *urlString = nil;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uber://"]]) {
        // launch Uber app
        NSDictionary *params = @{@"product_id": productId,
                                 @"client_id": clientId,
                                 @"pickup[latitude]": [NSNumber numberWithDouble:self.startLocation.latitude],
                                 @"pickup[longitude]": [NSNumber numberWithDouble:self.startLocation.longitude],
                                 @"dropoff[latitude]": [NSNumber numberWithDouble:self.endLocation.latitude],
                                 @"dropoff[longitude]": [NSNumber numberWithDouble:self.endLocation.longitude],
                                 };

        urlString = [NSString stringWithFormat:@"uber://?action=setPickup&%@", [params urlEncodedString]];
    } else {
        // launch mobile site
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       productId, @"product_id",
                                       clientId, @"client_id",
                                       [NSNumber numberWithDouble:self.startLocation.latitude], @"pickup_latitude",
                                       [NSNumber numberWithDouble:self.startLocation.longitude], @"pickup_longitude",
                                       [NSNumber numberWithDouble:self.endLocation.latitude], @"dropoff_latitude",
                                       [NSNumber numberWithDouble:self.endLocation.longitude], @"dropoff_longitude",
                                       nil];
        
        if (self.firstName) [params setObject:self.firstName forKey:@"first_name"];
        if (self.lastName) [params setObject:self.lastName forKey:@"last_name"];
        if (self.email) [params setObject:self.email forKey:@"email"];
        if (self.countryCode) [params setObject:self.countryCode forKey:@"country_code"];
        if (self.mobileCountryCode) [params setObject:self.mobileCountryCode forKey:@"mobile_country_code"];
        if (self.mobilePhone) [params setObject:self.mobilePhone forKey:@"mobile_phone"];
        if (self.zipcode) [params setObject:self.zipcode forKey:@"zipcode"];
        
        urlString = [NSString stringWithFormat:@"https://m.uber.com/sign-up?%@", [params urlEncodedString]];
    }
    
    NSLog(@"[GPUberView] launching Uber with: %@", urlString);
    [GPUberUtils openURL:[NSURL URLWithString:urlString]];
}


#pragma mark - Map

- (BFTask *)setupMap {
    BFTaskCompletionSource *taskSource = [BFTaskCompletionSource taskCompletionSource];
    
    MKPlacemark *startMark = [[MKPlacemark alloc] initWithCoordinate:self.startLocation addressDictionary:nil];
    MKPlacemark *endMark = [[MKPlacemark alloc] initWithCoordinate:self.endLocation addressDictionary:nil];
    
    [self.mapView addAnnotation:startMark];
    [self.mapView addAnnotation:endMark];
    
    // optimization to pre-load tile
    [GPUberUtils zoomMapViewToFitAnnotations:self.mapView animated:NO];
    
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startMark];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endMark];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = startItem;
    request.destination = endItem;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error || response.routes.count == 0) {
            NSLog(@"error calculating directions:%@", error);
        } else {
            self.route = [response.routes firstObject];
            [self.mapView addOverlay:self.route.polyline level:MKOverlayLevelAboveRoads];
        }
        
        // it's a success either way, we just wait for this to finish
        [taskSource setResult:nil];
    }];
    
    return taskSource.task;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor uberBlue];
    renderer.lineWidth = 5.0;
    return renderer;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    static NSString *startPin = @"startPin";
    static NSString *endPin = @"endPin";
    
    MKPinAnnotationView *annotationView = nil;
    if ([GPUberUtils isCoordinate:annotation.coordinate equalToCoordinate:self.startLocation]) {
        annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:startPin];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:startPin];
            annotationView.pinColor = MKPinAnnotationColorGreen;
        }
    } else {
        annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:endPin];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:endPin];
            annotationView.pinColor = MKPinAnnotationColorRed;
        }
    }
    
    return annotationView;
}

#pragma mark - Table

- (void)refreshTable {
    self.tableView.rowHeight = 44;
    self.tableHeight.constant = self.tableView.rowHeight * self.elements.count;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.elements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GPUberViewCell *cell = (GPUberViewCell *)[tableView dequeueReusableCellWithIdentifier:[GPUberViewCell reuseIdentifier]];
    
    GPUberViewElement *element = [self.elements objectAtIndex:indexPath.row];
    
    [cell.productImageView sd_setImageWithURL:element.image];
    
    cell.productNameLabel.text = element.displayName;
    
    cell.timeEstimateLabel.text = [element timeEstimateString];
    
    cell.costEstimateLabel.text = element.priceEstimate;
    cell.costEstimateLabel.textColor = element.surgeMultiplier > 1 ? [UIColor uberBlue] : [UIColor grayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GPUberViewElement *element = [self.elements objectAtIndex:indexPath.row];
    
    [self launchUberWithProductId:element.productId clientId:self.clientId];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
