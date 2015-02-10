//
//  GPUberViewElement.h
//  GPUberViewDemo
//
//  Created by George Polak on 2/10/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUberProduct.h"
#import "GPUberPrice.h"

@interface GPUberViewElement : NSObject

@property (nonatomic) NSString *productId;
@property (nonatomic) NSString *displayName;
@property (nonatomic) NSURL *image;
@property (nonatomic) NSString *estimate;
@property (nonatomic) NSInteger duration;
@property (nonatomic) CGFloat surgeMultiplier;

- (id)initWithProduct:(GPUberProduct *)product;
+ (GPUberViewElement *)elementWithProduct:(GPUberProduct *)product;

- (void)parametrizeWithPrice:(GPUberPrice *)price;

@end
