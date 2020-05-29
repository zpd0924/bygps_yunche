//
//  BYSwitchButtonView.h
//  dscjs
//
//  Created by ZPD on 2018/4/27.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLUHUnderLineButtonUnderLineTag 4000

@interface BYSwitchButtonView : UIView

- (nullable instancetype)initWithItems:(nullable NSArray *)items;
- (void)addTarget:(nullable id)target action:(nonnull SEL)action;
@property (nonatomic) NSInteger selectedIndex;

@end
