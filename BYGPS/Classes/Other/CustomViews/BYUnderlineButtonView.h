//
//  BYUnderlineButtonView.h
//  BYGPS
//
//  Created by ZPD on 2017/12/13.
//  Copyright © 2017年 miwer. All rights reserved.
//
#define kLUHUnderLineButtonUnderLineTag 2000
#define kLUHUnderLineButtonUnderLinePadding 0
#define kLUHUnderLineButtonUnderLineHeight 3

#import <UIKit/UIKit.h>

@interface BYUnderlineButtonView : UIView

- (nullable instancetype)initWithItems:(nullable NSArray *)items;
- (void)addTarget:(nullable id)target action:(nonnull SEL)action;
@property (nonatomic) NSInteger selectedIndex;
///查看大图样式
@property (nonatomic,assign) BOOL isBigLookImages;

@end
