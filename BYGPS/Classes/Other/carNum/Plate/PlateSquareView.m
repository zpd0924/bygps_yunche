//
//  PlateSquareView.m
//  PlateDemo
//
//  Created by ocrgroup on 2018/3/15.
//  Copyright © 2018年 DXY. All rights reserved.
//

#import "PlateSquareView.h"

#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW [UIScreen mainScreen].bounds.size.width

@implementation PlateSquareView {
    
    CGPoint _leftBottom; //竖屏左下角
    CGPoint _rightBottom; //竖屏右下角
    CGPoint _leftTop;  //竖屏左上角
    CGPoint _rightTop;  //竖屏右上角
}

- (instancetype)initWithFrame:(CGRect)frame andIsHorizontal:(BOOL)isHorizontal {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width,height;
        if (!isHorizontal) {
            width = SCREENW;
            height = width * 0.47;
            if (SCREENW > SCREENH) {
                height = SCREENH;
                width = height * 0.47;
            }
        } else {
            //横屏
            height = SCREENW;
            width = height * 0.47;
            if (SCREENW > SCREENH) {
                width = SCREENH;
                height = width * 0.47;
            }
        }
        
        
        CGFloat x,y;
        x = (SCREENW - width) * 0.5;
        y = (SCREENH - height) * 0.5;
        
        
        _leftTop = CGPointMake(x , y);
        _leftBottom = CGPointMake(x, y + height);
        _rightTop = CGPointMake(x + width , y);
        _rightBottom = CGPointMake(x + width , y + height);
        
        self.squareFrame = CGRectMake(x, y, width, height);
        
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [[UIColor greenColor] set];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线宽
    CGContextSetLineWidth(context, 2.0f);
    
    //画角线
    CGContextMoveToPoint(context,_leftBottom.x+1, _leftBottom.y-20);
    CGContextAddLineToPoint(context, _leftBottom.x+1, _leftBottom.y);
    CGContextAddLineToPoint(context, _leftBottom.x+20, _leftBottom.y);
    
    CGContextMoveToPoint(context, _rightBottom.x-2,_rightBottom.y-20);
    CGContextAddLineToPoint(context, _rightBottom.x-2,_rightBottom.y);
    CGContextAddLineToPoint(context, _rightBottom.x-20,_rightBottom.y);
    
    CGContextMoveToPoint(context, _leftTop.x+20,_leftTop.y);
    CGContextAddLineToPoint(context, _leftTop.x+1,_leftTop.y);
    CGContextAddLineToPoint(context, _leftTop.x+1,_leftTop.y+20);
    
    CGContextMoveToPoint(context, _rightTop.x-2, _rightTop.y+20);
    CGContextAddLineToPoint(context, _rightTop.x-2, _rightTop.y);
    CGContextAddLineToPoint(context, _rightTop.x-20, _rightTop.y);
    CGContextStrokePath(context);
    
    [[UIColor whiteColor] set];
    context = UIGraphicsGetCurrentContext();
    //设置线宽
    CGContextSetLineWidth(context, 0.2f);
    //画边线
    CGContextMoveToPoint(context,_leftBottom.x, _leftBottom.y);
    CGContextAddLineToPoint(context, _leftBottom.x, _rightBottom.y);
    CGContextAddLineToPoint(context, _rightTop.x, _rightBottom.y);
    CGContextAddLineToPoint(context, _rightTop.x, _leftTop.y);
    CGContextAddLineToPoint(context, _leftBottom.x, _leftTop.y);
    CGContextStrokePath(context);
}
@end
