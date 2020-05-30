//
//  UIButton+HNVerBut.m
//  VeraShow
//
//  Created by 小兵 on 16/8/15.
//  Copyright © 2016年 Red-bird-OfTMZ. All rights reserved.
//

#import "UIButton+HNVerBut.h"

@implementation UIButton (HNVerBut)

+ (instancetype)verBut:(NSString *)text textFont:(CGFloat)font titleColor:(UIColor *)titleColor bkgColor:(UIColor *)bkgColor {
    UIButton* but = [[UIButton alloc]init];
    [but setTitle:text forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:font];
    [but setTitleColor:titleColor forState:UIControlStateNormal];
    if (bkgColor) {
        [but setBackgroundColor:bkgColor];
    }
    return but;
}
@end
