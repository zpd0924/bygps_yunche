//
//  PlateSquareView.h
//  PlateDemo
//
//  Created by ocrgroup on 2018/3/15.
//  Copyright © 2018年 DXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlateSquareView : UIView

@property (assign ,nonatomic) CGRect squareFrame;  //检测区域

- (instancetype)initWithFrame:(CGRect)frame andIsHorizontal:(BOOL)isHorizontal;

@end
