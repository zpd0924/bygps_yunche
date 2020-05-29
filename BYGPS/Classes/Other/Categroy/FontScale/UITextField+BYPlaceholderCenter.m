//
//  UITextField+BYPlaceholderCenter.m
//  BYGPS
//
//  Created by miwer on 2017/4/25.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "UITextField+BYPlaceholderCenter.h"

@implementation UITextField (BYPlaceholderCenter)

-(void)adjustCenterWithPlaceholder:(NSString *)placeholder{
    
    NSMutableParagraphStyle *style = [self.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    
    style.minimumLineHeight = self.font.lineHeight - (self.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) / 2.0;
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName : BYS_T_F(14),                             NSParagraphStyleAttributeName : style}];
}

@end
