//
//  BYCheckWorkOrderFootView.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/16.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCheckWorkOrderFootView.h"

@implementation BYCheckWorkOrderFootView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)noPassBtnClick:(UIButton *)sender {
    if (self.noPassBlock) {
        self.noPassBlock();
    }
}
- (IBAction)passBtnClick:(UIButton *)sender {
    if (self.passBlock) {
        self.passBlock();
    }
}

@end
