//
//  UILabel+BYCaculateHeight.m
//  BYGPS
//
//  Created by miwer on 2017/3/1.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "UILabel+BYCaculateHeight.h"

@implementation UILabel (BYCaculateHeight)

+ (CGFloat)caculateLabel_HWith:(CGFloat)width Title:(NSString *)title font:(NSInteger)font{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = BYS_T_F(font);
    label.numberOfLines = 0;
    [label sizeToFit];
    return label.by_height;
}

@end
