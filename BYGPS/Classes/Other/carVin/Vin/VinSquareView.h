//
//  VinSquareView.h
//  VinDemo
//
//  Created by ocrgroup on 2018/3/14.
//  Copyright © 2018年 ocrgroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VinSquareView : UIView

@property (assign ,nonatomic) CGRect squareFrame;  //方框的frame

- (instancetype)initWithIsHorizontal:(BOOL)isHorizontal;

@end
