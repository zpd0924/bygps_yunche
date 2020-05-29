//
//  BYAutoServiceRepairRemarkCell.m
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceRepairRemarkCell.h"

static NSString * const placeholderStr = @"请输入检修备注...";
@interface BYAutoServiceRepairRemarkCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *remarkNumLabel;


@end

@implementation BYAutoServiceRepairRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.remarkTextView.layer.cornerRadius = 5;
    self.remarkTextView.clipsToBounds = YES;
    self.remarkTextView.layer.borderWidth = 1;
    self.remarkTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.remarkTextView.text = placeholderStr;
    self.remarkTextView.font = BYS_T_F(13);
    self.remarkTextView.textColor = UIColorHexFromRGB(0x9b9b9b);
    self.remarkTextView.delegate = self;
}

-(void)setRemarkStr:(NSString *)remarkStr{
    _remarkStr = remarkStr;
    self.remarkTextView.text = remarkStr.length > 0 ? remarkStr : placeholderStr;
    self.remarkTextView.font = BYS_T_F(13);
    self.remarkTextView.textColor = remarkStr.length > 0 ?  UIColorHexFromRGB(0x3a3a3a) : UIColorHexFromRGB(0x9b9b9b);
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:placeholderStr]) {
        
        textView.text = @"";
        self.remarkTextView.textColor = UIColorHexFromRGB(0x3a3a3a);
        
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (textView.text.length > 200) {
//        BYShowError(@"最多输入200个字符");
//        return NO;
//    }
//    return YES;
//}

- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:placeholderStr]) {
        
        self.remarkNumLabel.text = @"0/200";
        
    }else{
        self.remarkNumLabel.text = [NSString stringWithFormat:@"%zd/200",textView.text.length];
    }
    
    if (textView.text.length > 200) {
        BYShowError(@"最多输入200个字符");
        UITextRange *markedRange = [textView markedTextRange];
        if (markedRange) {
            return;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [textView.text rangeOfComposedCharacterSequenceAtIndex:199];
        textView.text = [textView.text substringToIndex:range.location];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView.text.length<1) {
        
        textView.text = placeholderStr;
        self.remarkTextView.textColor = UIColorHexFromRGB(0x9b9b9b);
        if (self.remarkInputBlock) {
            self.remarkInputBlock(@"");
        }
    }else{
        if (self.remarkInputBlock) {
            self.remarkInputBlock(textView.text);
        }
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.remarkTextView resignFirstResponder];
}

@end
