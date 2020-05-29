//
//  UILabel+HNVerLab.m
//  VeraShow
//
//  Created by 小兵 on 16/8/15.
//  Copyright © 2016年 Red-bird-OfTMZ. All rights reserved.
//

#import "UILabel+HNVerLab.h"

@implementation UILabel (HNVerLab)

+ (instancetype)verLab:(CGFloat)font textRgbColor:(UIColor *)color textAlighment:(NSTextAlignment) alighMent{
    UILabel* lab = [[UILabel alloc]init];
    lab.font =  [UIFont systemFontOfSize:font];
    lab.textColor = color;
    lab.textAlignment = alighMent;
    return lab;


}
@end
