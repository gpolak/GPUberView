//
//  GPUberTime.h
//  GPUberViewDemo
//
//  Created by George Polak on 2/10/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import "JSONModel.h"

@interface GPUberTime : JSONModel

@property (nonatomic) NSString *productId;
@property (nonatomic) NSString *displayName;
@property (nonatomic) NSInteger estimate;

@end
