//
//  GPUberViewElement.m
//  GPUberViewDemo
//
//  Created by George Polak on 2/10/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import "GPUberViewElement.h"

@implementation GPUberViewElement

- (id)initWithProduct:(GPUberProduct *)product {
    self = [super init];
    if (self) {
        self.productId = product.productId;
        self.displayName = product.displayName;
        self.image = product.image;
    }
    
    return self;
}

+ (GPUberViewElement *)elementWithProduct:(GPUberProduct *)product {
    return [[GPUberViewElement alloc] initWithProduct:product];
}

- (void)parametrizeWithPrice:(GPUberPrice *)price {
    if (!price || ![price.productId isEqualToString:self.productId])
        return;
    
    self.estimate = price.estimate;
    self.duration = price.duration;
    self.surgeMultiplier = price.surgeMultiplier;
}

- (BOOL)isEqual:(id)object {
    if (object == nil)
        return NO;
    
    if (![object isKindOfClass:[GPUberViewElement class]])
        return NO;
    
    if (object == self)
        return YES;
    
    GPUberViewElement *element = (GPUberViewElement *)object;
    return self.productId == element.productId;
}

- (NSUInteger)hash {
    return self.productId.hash;
}


@end
