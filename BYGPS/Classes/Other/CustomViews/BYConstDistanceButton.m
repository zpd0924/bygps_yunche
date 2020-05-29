//
//  BYConstDistanceButton.m
//  BYGPS
//
//  Created by miwer on 16/9/9.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYConstDistanceButton.h"

@implementation BYConstDistanceButton

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat labelHeight = self.titleLabel.bounds.size.height;
    CGFloat imageHeight = self.imageView.bounds.size.height;

    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = 10;
    imageFrame.origin.y = self.by_height / 2 - imageHeight / 2;
    self.imageView.frame = imageFrame;
    
    CGRect labelFrame = self.titleLabel.frame;
    labelFrame.origin.x = BYS_W_H(45);
    labelFrame.origin.y = self.by_height / 2 - labelHeight / 2;
    self.titleLabel.frame = labelFrame;
    
}

@end



