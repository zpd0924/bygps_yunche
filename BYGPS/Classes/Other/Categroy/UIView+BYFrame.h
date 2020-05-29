//
//  UIView+BYFrame.h
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BYFrame)

@property (nonatomic, assign) CGSize by_size;
@property (nonatomic, assign) CGFloat by_x;
@property (nonatomic, assign) CGFloat by_y;
@property (nonatomic, assign) CGFloat by_width;
@property (nonatomic, assign) CGFloat by_height;
@property (nonatomic, assign) CGFloat by_centerX;
@property (nonatomic, assign) CGFloat by_centerY;
@property (nonatomic, assign) CGFloat by_top;
@property (nonatomic, assign) CGFloat by_bottom;
//@property (nonatomic, assign) CGFloat by_bottom;

#pragma mark  load xib
+ (instancetype)by_viewFromXib;

#pragma mark - 插入view
- (BOOL)intersectWithView:(UIView *)view;

@end
