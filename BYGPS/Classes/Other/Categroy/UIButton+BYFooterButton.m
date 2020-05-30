//
//  UIButton+BYFooterButton.m
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "UIButton+BYFooterButton.h"

@implementation UIButton (BYFooterButton)

+(UIButton *)buttonWithMargin:(CGFloat)margin backgroundColor:(UIColor *)color title:(NSString *)title target:(id)target action:(SEL)action{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, margin, BYSCREEN_W - 20, BYS_W_H(40));
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
