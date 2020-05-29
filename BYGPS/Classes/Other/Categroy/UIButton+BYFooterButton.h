//
//  UIButton+BYFooterButton.h
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BYFooterButton)

+(UIButton *)buttonWithMargin:(CGFloat)margin backgroundColor:(UIColor *)color title:(NSString *)title target:(id)target action:(SEL)action;

@end
