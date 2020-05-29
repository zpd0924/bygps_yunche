//
//  BYSwitchView.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/18.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BYSwitchViewBlock)(NSInteger index);

@interface BYSwitchView : UIView

- (instancetype)initWithItems:(NSArray *)items;
@property (nonatomic,copy) BYSwitchViewBlock switchViewBlock;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIButton *leftBtn;

@property (nonatomic , assign) BOOL enableClick;

- (void)selectIndex:(NSInteger)index;
@end
