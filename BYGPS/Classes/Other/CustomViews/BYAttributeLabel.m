//
//  BYAttributeLabel.m
//  xib中字体适配
//
//  Created by miwer on 2016/11/2.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAttributeLabel.h"

@implementation BYAttributeLabel

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attrStr addAttribute:NSFontAttributeName value:BYS_T_F(10) range:NSMakeRange(attrStr.length - 1, 1)];
    self.attributedText = attrStr;
    
}

@end
