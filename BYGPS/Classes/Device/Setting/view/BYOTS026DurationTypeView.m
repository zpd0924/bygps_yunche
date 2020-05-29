//
//  BYOTS026DurationTypeView.m
//  BYGPS
//
//  Created by ZPD on 2017/6/29.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYOTS026DurationTypeView.h"

@interface BYOTS026DurationTypeView ()

@property(nonatomic,strong) UIButton * currentItem;

@end

@implementation BYOTS026DurationTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setSelectType:(NSInteger)selectType{
    
    self.currentItem = (UIButton *)[self viewWithTag:30 + selectType];
    self.currentItem.selected = YES;
}
- (IBAction)durationType:(UIButton *)sender {
    
    if (![sender isEqual:self.currentItem]) {
        self.currentItem.selected = NO;
    }
    
    sender.selected = !sender.selected;
    self.currentItem = sender;
    
    if (self.durationTypeBlock) {
        self.durationTypeBlock(sender.tag - 30, sender.selected);
    }

}

@end
