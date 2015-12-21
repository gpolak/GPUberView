//
//  GPUberProduct.h
//  GPUberViewDemo
//
//  Created by George Polak on 2/9/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GPUberProduct : JSONModel

@property (nonatomic) NSString *productId;
@property (nonatomic) NSString *displayName;
@property (nonatomic) NSInteger capacity;
@property (nonatomic) NSURL *image;
// "description" is inherited from NSObject


@end
