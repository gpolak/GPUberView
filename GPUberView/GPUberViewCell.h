//
//  GPUberViewCell.h
//  GPUberViewDemo
//
//  Created by George Polak on 2/10/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPUberViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *productImageView;
@property (nonatomic, weak) IBOutlet UILabel *productNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *innerLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightLabel;

+ (NSString *)reuseIdentifier;

@end
