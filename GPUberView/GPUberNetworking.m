//
//  GPUberNetworking.m
//  GPUberViewDemo
//
//  Created by George Polak on 2/9/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import "GPUberNetworking.h"
#import <JSONModel.h>
#import "GPUberPrice.h"
#import "GPUberProduct.h"
#import "GPUberTime.h"

@implementation GPUberNetworking

NSString *const GP_UBER_VIEW_DOMAIN = @"GP_UBER_VIEW_DOMAIN";

+ (NSURL *)urlWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params {
    NSMutableString *paramString = [NSMutableString new];
    for (NSString *key in params.allKeys) {
        [paramString appendFormat:@"%@=%@&", key, [params objectForKey:key]];
    }
    if (paramString.length > 0) {
        // trim last ampersand
        endpoint = [endpoint stringByAppendingFormat:@"?%@", [paramString substringToIndex:paramString.length - 1]];
    }
    
    NSString *base = @"https://api.uber.com";
    NSURL *baseURL = [NSURL URLWithString:base];
    return [NSURL URLWithString:endpoint relativeToURL:baseURL];
}

+ (BFTask *)GETWithEndpoint:(NSString *)endpoint serverToken:(NSString *)serverToken params:(NSDictionary *)params {
    BFTaskCompletionSource *taskSource = [BFTaskCompletionSource taskCompletionSource];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{@"Authorization": [NSString stringWithFormat:@"Token %@", serverToken]};
    
    NSURL *url = [self urlWithEndpoint:endpoint params:params];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [taskSource setError:error];
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSInteger statusCode = httpResponse.statusCode;
            if (statusCode < 200 || statusCode >= 300) {
                NSError *error = [NSError errorWithDomain:@"GPUberView"
                                                     code:statusCode
                                                 userInfo:nil];
                [taskSource setError:error];
            } else {
                id responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]) {
                    [taskSource setResult:responseObject];
                } else {
                    NSError *error = [NSError errorWithDomain:@"GPUberView"
                                                         code:0
                                                     userInfo:[NSDictionary dictionaryWithObject:@"unable to parse response" forKey:NSLocalizedDescriptionKey]];
                    [taskSource setError:error];
                }
            }
        }
        
    }] resume];
    
    return taskSource.task;
}

+ (BFTask *)productsForStart:(CLLocationCoordinate2D)start serverToken:(NSString *)serverToken {
    NSString *endpoint = @"v1/products";
    
    BFTaskCompletionSource *taskSource = [BFTaskCompletionSource taskCompletionSource];
    
    NSDictionary *params = @{@"latitude": [NSNumber numberWithDouble:start.latitude],
                             @"longitude": [NSNumber numberWithDouble:start.longitude]
                             };
    
    [[self GETWithEndpoint:endpoint serverToken:serverToken params:params] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"%@", task.error);
            [taskSource setError:task.error];
        } else {
            NSMutableArray *products = [NSMutableArray new];
            NSArray *rawProducts = [task.result objectForKey:@"products"];
            for (NSDictionary *rawProduct in rawProducts) {
                NSError *error;
                GPUberProduct *product = [[GPUberProduct alloc] initWithDictionary:rawProduct error:&error];
                if (error)
                    NSLog(@"unable to parse product element:%@", error);
                else
                    [products addObject:product];
            }
            
            [taskSource setResult:products];
        }
        
        return nil;
    }];
    
    return taskSource.task;
}

+ (BFTask *)pricesForStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end serverToken:(NSString *)serverToken {
    NSString *endpoint = @"v1/estimates/price";
    
    BFTaskCompletionSource *taskSource = [BFTaskCompletionSource taskCompletionSource];
    
    NSDictionary *params = @{@"start_latitude": [NSNumber numberWithDouble:start.latitude],
                             @"start_longitude": [NSNumber numberWithDouble:start.longitude],
                             @"end_latitude": [NSNumber numberWithDouble:end.latitude],
                             @"end_longitude": [NSNumber numberWithDouble:end.longitude]};
    
    [[self GETWithEndpoint:endpoint serverToken:serverToken params:params] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"%@", task.error);
            [taskSource setError:task.error];
        } else {
            NSMutableArray *prices = [NSMutableArray new];
            NSArray *rawPrices = [task.result objectForKey:@"prices"];
            for (NSDictionary *rawPrice in rawPrices) {
                NSError *error;
                GPUberPrice *price = [[GPUberPrice alloc] initWithDictionary:rawPrice error:&error];
                if (error)
                    NSLog(@"unable to parse price element:%@", error);
                else
                    [prices addObject:price];
            }
            
            [taskSource setResult:prices];
        }
        
        return nil;
    }];
    
    return taskSource.task;
}

+ (BFTask *)timeEstimatesForStart:(CLLocationCoordinate2D)start serverToken:(NSString *)serverToken {
    NSString *endpoint = @"v1/estimates/time";
    
    BFTaskCompletionSource *taskSource = [BFTaskCompletionSource taskCompletionSource];
    
    NSDictionary *params = @{@"start_latitude": [NSNumber numberWithDouble:start.latitude],
                             @"start_longitude": [NSNumber numberWithDouble:start.longitude]
                             };
    
    [[self GETWithEndpoint:endpoint serverToken:serverToken params:params] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"%@", task.error);
            [taskSource setError:task.error];
        } else {
            NSMutableArray *times = [NSMutableArray new];
            NSArray *rawTimes = [task.result objectForKey:@"times"];
            for (NSDictionary *rawTime in rawTimes) {
                NSError *error;
                GPUberTime *time = [[GPUberTime alloc] initWithDictionary:rawTime error:&error];
                if (error)
                    NSLog(@"unable to parse time element:%@", error);
                else
                    [times addObject:time];
            }
            
            [taskSource setResult:times];
        }
        
        return nil;
    }];
    
    return taskSource.task;
}

@end
