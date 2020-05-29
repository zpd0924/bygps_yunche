//
//  BYTitleImageExchangeZeroButton.m
//  BYGPS
//
//  Created by miwer on 2017/2/7.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYTitleImageExchangeZeroButton.h"

@implementation BYTitleImageExchangeZeroButton

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat labelWidth = self.titleLabel.bounds.size.width;
    CGFloat imageWidth = self.imageView.bounds.size.width;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + 5, 0, -labelWidth);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
}

@end
