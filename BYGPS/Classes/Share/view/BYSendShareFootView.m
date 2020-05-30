//
//  BYSendShareFootView.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYSendShareFootView.h"
static NSString * const placeholderStr = @"请输入需要备注（200字内)";
@interface BYSendShareFootView()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *wordNumberLabel;

@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;


@end

@implementation BYSendShareFootView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.remarkTextView.delegate = self;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:placeholderStr]) {
        
        textView.text = @"";
        self.remarkTextView.textColor = UIColorHexFromRGB(0x3a3a3a);
        
    }
}



- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:placeholderStr]) {
        
        self.wordNumberLabel.text = @"0/200";
        
    }else{
      
        self.wordNumberLabel.text = [NSString stringWithFormat:@"%zd/200",textView.text.length];
        if (textView.text.length >=200) {
            textView.text = [textView.text substringToIndex:200];
            return;
        }
    }
}

// 控制输入文字的长度和内容，可调用一下方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=200)
    {
        //控制输入文本的长度
        return  NO;
    }else
    {
        return YES;
    }
}



#pragma mark -- 去分享
- (IBAction)goToShareBtnClick:(UIButton *)sender {
    if (self.goToShareBlock) {
        self.goToShareBlock([_remarkTextView.text isEqualToString:placeholderStr]?@"":_remarkTextView.text);
    }
}


@end
