//
//  BYMyCertifyFootView.m
//  xsxc
//
//  Created by ZPD on 2018/5/28.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "BYMyCertifyFootView.h"

@interface BYMyCertifyFootView ()
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation BYMyCertifyFootView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setIsNoPass:(bool)isNoPass{
    _isNoPass = isNoPass;
    if (isNoPass) {
        [_nextBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    }
}

-(void)setBtnTitle:(NSString *)btnTitle
{
    _btnTitle = btnTitle;
    [self.nextBtn setTitle:btnTitle forState:UIControlStateNormal];

}

- (IBAction)nextStepClick:(UIButton *)sender {
    
    if (self.nextStepBlock) {
        self.nextStepBlock();
    }
    
}

@end
