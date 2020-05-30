//
//  BYUnderCircleButtonView.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/18.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#define circleWH 20
#define kLUHUnderLineButtonUnderLineHeight 3
@interface BYUnderCircleButtonView : UIView
- (nullable instancetype)initWithItems:(nullable NSArray *)items;
- (void)addTarget:(nullable id)target action:(nonnull SEL)action;
@property (nonatomic) NSInteger selectedIndex;
@end
