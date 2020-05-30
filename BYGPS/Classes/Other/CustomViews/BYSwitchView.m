//
//  BYSwitchView.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/18.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYSwitchView.h"
#import "UIButton+HNVerBut.h"

@interface BYSwitchView()


@property (nonatomic ,strong) NSArray *items;


@end

@implementation BYSwitchView

- (instancetype)initWithItems:(NSArray *)items;
{
    self = [super init];
    if (self) {
        _items = items;
        [self initBase];
       
    }
    return self;
}

- (void)selectIndex:(NSInteger)index{
    if (!index) {
        self.leftBtn.selected = YES;
        [self.leftBtn setBackgroundColor:BYGlobalBlueColor];
        self.rightBtn.selected = NO;
        [self.rightBtn setBackgroundColor:WHITE];
    }else{
        self.leftBtn.selected = NO;
        [self.leftBtn setBackgroundColor:WHITE];
        
        self.rightBtn.selected = YES;
        [self.rightBtn setBackgroundColor:BYGlobalBlueColor];
    }
}

- (void)initBase{
    
    UIButton *leftBtn = [UIButton verBut:_items[0] textFont:15 titleColor:UIColorHexFromRGB(0x333333) bkgColor:WHITE];
    _leftBtn = leftBtn;
    leftBtn.frame = CGRectMake(0, 0, 70, 30);
    leftBtn.selected = YES;
    [leftBtn setBackgroundColor:BYGlobalBlueColor];
    [leftBtn setTitleColor:WHITE forState:UIControlStateSelected];
    leftBtn.layer.cornerRadius = 15;
    leftBtn.layer.masksToBounds = YES;
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightBtn = [UIButton verBut:_items[1] textFont:15 titleColor:UIColorHexFromRGB(0x333333) bkgColor:WHITE];
    _rightBtn = rightBtn;
    rightBtn.frame = CGRectMake(70, 0, 70, 30);
    rightBtn.layer.cornerRadius = 15;
    rightBtn.layer.masksToBounds = YES;
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:WHITE forState:UIControlStateSelected];
    [self addSubview:leftBtn];
    [self addSubview:rightBtn];
    
    
}
- (void)leftBtnClick:(UIButton *)btn{
    
    
    if (self.enableClick) {
        btn.selected = YES;
        [btn setBackgroundColor:BYGlobalBlueColor];
        [_rightBtn setBackgroundColor:WHITE];
        _rightBtn.selected = NO;
        if (self.switchViewBlock) {
            self.switchViewBlock(0);
        }
    }
    
    
    
}
- (void)rightBtnClick:(UIButton *)btn{
    
    if (self.enableClick) {
        btn.selected = YES;
        [btn setBackgroundColor:BYGlobalBlueColor];
        [_leftBtn setBackgroundColor:WHITE];
        _leftBtn.selected = NO;
        if (self.switchViewBlock) {
            self.switchViewBlock(1);
        }
    }
}

@end
