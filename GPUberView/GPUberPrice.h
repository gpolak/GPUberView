//
//  GPUberPrice.h
//  GPUberViewDemo
//
//  Created by George Polak on 2/9/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import "JSONModel.h"
#import <CoreGraphics/CoreGraphics.h>

@interface GPUberPrice : JSONModel

@property (nonatomic) NSString *productId;
@property (nonatomic) NSString<Optional> *currencyCode;
@property (nonatomic) NSString *displayName;
@property (nonatomic) NSString *estimate;
@property (nonatomic) NSString<Optional> *lowEstimate;
@property (nonatomic) NSString<Optional> *highEstimate;
@property (nonatomic) CGFloat surgeMultiplier;
@property (nonatomic) NSInteger duration;
@property (nonatomic) CGFloat distance;

@end
