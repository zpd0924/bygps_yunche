//
//  UIView+BYFrame.m
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "UIView+BYFrame.h"

@implementation UIView (BYFrame)


#pragma mark setting frame value
- (void)setBy_size:(CGSize)by_size
{
    CGRect frame = self.frame;
    frame.size = by_size;
    self.frame = frame;
}

- (CGSize)by_size
{
    return self.frame.size;
}

- (void)setBy_x:(CGFloat)by_x
{
    CGRect frame = self.frame;
    frame.origin.x = by_x;
    self.frame = frame;
}

- (CGFloat)by_x
{
    return self.frame.origin.x;
}

- (void)setBy_y:(CGFloat)by_y
{
    CGRect frame = self.frame;
    frame.origin.y = by_y;
    self.frame = frame;
}

- (CGFloat)by_y
{
    return self.frame.origin.y;
}

- (void)setBy_width:(CGFloat)by_width
{
    CGRect frame = self.frame;
    frame.size.width = by_width;
    self.frame = frame;
}

- (CGFloat)by_width
{
    return self.bounds.size.width;
}

- (void)setBy_height:(CGFloat)by_height
{
    CGRect frame = self.frame;
    frame.size.height = by_height;
    self.frame = frame;
}

- (CGFloat)by_height
{
    return self.frame.size.height;
}


- (void)setBy_centerX:(CGFloat)by_centerX
{
    CGPoint center = self.center;
    center.x = by_centerX;
    self.center = center;
}

- (CGFloat)by_centerX
{
    return self.center.x;
}

- (void)setBy_centerY:(CGFloat)by_centerY
{
    CGPoint center = self.center;
    center.y = by_centerY;
    self.center = center;
}


- (CGFloat)by_centerY
{
    return self.center.y;
}

- (void)setBy_top:(CGFloat)by_top
{
    CGRect newframe = self.frame;
    newframe.origin.y = by_top;
    self.frame = newframe;
}

- (CGFloat)by_top
{
    return self.frame.origin.y;
}

- (void)setBy_bottom:(CGFloat)by_bottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = by_bottom;
    self.frame = newframe;
}

- (CGFloat)by_bottom
{
    return self.frame.origin.y;
}



#pragma mark  load xib
+ (instancetype)by_viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


#pragma mark - 插入view
- (BOOL)intersectWithView:(UIView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [self convertRect:self.bounds toView:window];
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    return CGRectIntersectsRect(selfRect, viewRect);
}
@end
