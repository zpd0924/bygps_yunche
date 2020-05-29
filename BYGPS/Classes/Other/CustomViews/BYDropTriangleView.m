//
//  BYDropTriangleView.m
//  BYGPS
//
//  Created by miwer on 16/10/8.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDropTriangleView.h"

@implementation BYDropTriangleView

- (void)setTriangleColor:(UIColor *)triangleColor {
    _triangleColor = triangleColor;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    
    //绘制路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //设置颜色
    [[UIColor whiteColor] set];
    
    //-------------绘制三角形------------
    //
    //                 B
    //                /\
    //               /  \
    //              /    \
    //             /______\
    //            A        C
    //
    //
    
    //设置起点 A
    [path moveToPoint:CGPointMake(0, rect.size.height)];
    
    //添加一根线到某个点 B
    [path addLineToPoint:CGPointMake(rect.size.width * 0.5, 0)];
    
    //添加一根线到某个点 C
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    
    //关闭路径
    [path closePath];
    
    //填充（会把颜色填充进去）
    [path fill];
}

@end
