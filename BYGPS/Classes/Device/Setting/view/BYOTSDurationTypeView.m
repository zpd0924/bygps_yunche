//
//  BYOTSDurationTypeView.m
//  BYGPS
//
//  Created by ZPD on 2017/6/28.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYOTSDurationTypeView.h"

@interface BYOTSDurationTypeView ()

@property(nonatomic,strong) UIButton * currentItem;

@end

@implementation BYOTSDurationTypeView


- (void)drawRect:(CGRect)rect {
    
}

-(void)setSelectType:(NSInteger)selectType{
    
    self.currentItem = (UIButton *)[self viewWithTag:30 + selectType];
    self.currentItem.selected = YES;
}

-(void)initBaseUI
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    for (NSInteger i = 0; i < _buttonNum; i ++ ) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.btnNameArr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_radio_nornal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_radio_checked"] forState:UIControlStateSelected];
        btn.tag = i + 30;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }

}

-(instancetype)initWithFrame:(CGRect)frame btnNameArr:(NSArray *)btnNameArr selectType:(NSInteger)selectType haveTextField:(BOOL)isHaveTextField
{
    if (self = [super initWithFrame:frame]) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(5, 5,frame.size.width - 10,BYS_W_H(18));
        
        for (NSInteger i = 0; i < btnNameArr.count; i ++ ) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(5, 5 + BYS_W_H(18) * i,frame.size.width - 10, BYS_W_H(18));
            [btn setTitle:btnNameArr[i] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"icon_radio_nornal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"icon_radio_checked"] forState:UIControlStateSelected];
            btn.tag = i + 30;
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        if (isHaveTextField) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5 + BYS_W_H(18) * btnNameArr.count, frame.size.width - 30, BYS_W_H(18))];
            textField.placeholder = @"";
            textField.textAlignment = NSTextAlignmentCenter;
            [self addSubview:textField];
        }
        
        if (isHaveTextField) {
            
        }

    }
    return self;
}

-(void)buttonClick:(UIButton *)button
{
    if (![button isEqual:self.currentItem]) {
        self.currentItem.selected = NO;
    }
    
    button.selected = !button.selected;
    self.currentItem = button;
    
    if (self.durationTypeBlock) {
        self.durationTypeBlock(button.tag - 30, button.selected);
    }
}

-(NSMutableArray *)btnNameArr
{
    if (!_btnNameArr) {
        _btnNameArr = [NSMutableArray array];
    }
    return _btnNameArr;
}

@end
