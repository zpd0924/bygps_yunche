//
//  BYUnderlineButton.m
//  下划线Button
//
//  Created by bean on 16/9/8.
//  Copyright © 2016年 bean. All rights reserved.
//

#import "BYUnderlineButton.h"

@implementation BYUnderlineButton


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();//开启上下文
    
    CGFloat x = self.titleLabel.frame.origin.x;
    CGFloat y = self.titleLabel.frame.origin.y;
    CGFloat width = self.titleLabel.frame.size.width;
    CGFloat height = self.titleLabel.frame.size.height;
    
    CGContextMoveToPoint(context, x, y + height + 0.2);//开始点的坐标
    
    CGContextAddLineToPoint(context, x + width, y + height + 0.2);//终点坐标,可设置多个点
    
    CGContextSetLineWidth(context, 0.7);//设置宽度
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);//设置背景颜色
    
    CGContextStrokePath(context);//开始描边
}


@end
