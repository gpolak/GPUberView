//
//  GPUberViewCell.m
//  GPUberViewDemo
//
//  Created by George Polak on 2/10/15.
//  Copyright (c) 2015 George Polak. All rights reserved.
//

#import "GPUberViewCell.h"

@implementation GPUberViewCell

- (void)awakeFromNib {
    self.rightLabel.textColor = [UIColor grayColor];
    self.innerLabel.textColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier {
    return [GPUberViewCell reuseIdentifier];
}

+ (NSString *)reuseIdentifier {
    return @"uber_cell";
}

@end
