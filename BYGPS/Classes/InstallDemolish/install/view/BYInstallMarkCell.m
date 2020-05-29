//
//  BYInstallMarkCell.m
//  父子控制器
//
//  Created by miwer on 2016/12/23.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYInstallMarkCell.h"

static NSString * const placeholderStr = @"技师服务态度是否服务您的要求，安装速度还满足您的预期吗？说说您的想法吧!";

@interface BYInstallMarkCell () <UITextViewDelegate>



@end

@implementation BYInstallMarkCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.textView.delegate = self;
    
    self.textView.text = placeholderStr;
    self.textView.textColor = [UIColor grayColor];

}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:placeholderStr]) {
        
        textView.text = @"";
        self.textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView.text.length<1) {
        
        textView.text = placeholderStr;
        self.textView.textColor = [UIColor grayColor];
    }
    
    if (![textView.text isEqualToString:placeholderStr] && textView.text.length) {
        if (self.didEndInputBlock) {
            self.didEndInputBlock(textView.text);
        }
    }
}


@end
