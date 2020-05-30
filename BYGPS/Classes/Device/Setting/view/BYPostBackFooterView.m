//
//  BYPostBackFooterView.m
//  BYGPS
//
//  Created by miwer on 16/9/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYPostBackFooterView.h"

@interface BYPostBackFooterView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureButtonContraint_H;


@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation BYPostBackFooterView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.sureButtonContraint_H.constant = BYS_W_H(35);
}

- (IBAction)sureAction:(id)sender {
    
    if (self.sureActionBlock) {
        self.sureActionBlock();
    }
}

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
    if (title.length > 0) {
        NSRange range1 = NSMakeRange(0, 1);
        [self setTextColor:self.titleLabel FontNumber:BYS_T_F(13) AndRange:range1 AndColor:[UIColor redColor]];
    }
}

-(void)setSubTitle:(NSString *)subTitle
{
    
    self.subTitleLabel.text = subTitle;
    if (subTitle.length > 0) {
        NSRange range1 = NSMakeRange(0, 1);
        [self setTextColor:self.subTitleLabel FontNumber:BYS_T_F(13) AndRange:range1 AndColor:[UIColor redColor]];
    }
}

-(void)setTextColor:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    label.attributedText = str;
}


@end
