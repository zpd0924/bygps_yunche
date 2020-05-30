//
//  BYHotCityCell.m
//  carLoanManagerment
//
//  Created by miwer on 2017/3/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BYHotCityCell.h"

@interface BYHotCityCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation BYHotCityCell

-(void)setCityArr:(NSArray *)cityArr{
    
    CGFloat margin_W = BYS_W_H(20);
    CGFloat margin_H = BYS_W_H(15);
    CGFloat width = (BYSCREEN_W - margin_W * 4 - BYS_W_H(40)) / 3;
    CGFloat height = BYS_W_H(35);
    
    for (NSInteger i = 0; i < cityArr.count; i ++) {
        
        NSString * city = cityArr[i];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.by_x = i % 3 * (width + margin_W);
        button.by_y = i / 3 * (height + margin_H);
        button.by_width = width;
        button.by_height = height;
        
        button.layer.borderColor = BYGrayColor(243).CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = BYS_W_H(5);
        button.clipsToBounds = YES;
        
        [button setTitle:city forState:UIControlStateNormal];
        [button setTitleColor:BYGrayColor(42) forState:UIControlStateNormal];
        button.titleLabel.font = BYS_T_F(15);
        
        [button addTarget:self action:@selector(citySelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:button];
    }
}

-(void)citySelect:(UIButton *)button{
    if (self.cityCallBack) {
        self.cityCallBack(button.titleLabel.text);
    }
}

@end
