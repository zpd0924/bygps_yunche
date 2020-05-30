//
//  BYTitleImageExchangeButton.m
//  BYGPS
//
//  Created by miwer on 16/9/1.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYTitleImageExchangeButton.h"

@implementation BYTitleImageExchangeButton

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat labelWidth = self.titleLabel.bounds.size.width;
    CGFloat imageWidth = self.imageView.bounds.size.width;

    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + 20, 0, -labelWidth);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
}

@end
