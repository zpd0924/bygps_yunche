//
//  BYDuratrionTypeView.m
//  BYGPS
//
//  Created by miwer on 16/9/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDuratrionTypeView.h"

@interface BYDuratrionTypeView ()

@property(nonatomic,strong) UIButton * currentItem;

@end

@implementation BYDuratrionTypeView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.textFieldBgViewContraint_H.constant = 0;
}

-(void)setSelectType:(NSInteger)selectType{
    
    self.currentItem = (UIButton *)[self viewWithTag:30 + selectType];
    self.currentItem.selected = YES;
}

- (IBAction)durationTypeAction:(UIButton *)sender {
    
    if (![sender isEqual:self.currentItem]) {
        self.currentItem.selected = NO;
    }
    
    sender.selected = !sender.selected;
    self.currentItem = sender;

    if (self.durationTypeBlock) {
        self.durationTypeBlock(sender.tag - 30, sender.selected);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}


@end
