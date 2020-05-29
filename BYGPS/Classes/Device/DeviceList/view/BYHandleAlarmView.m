//
//  BYHandleAlarmView.m
//  BYGPS
//
//  Created by miwer on 16/9/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYHandleAlarmView.h"

static NSString * const placeholderStr = @"请输入处理备注...";

@interface BYHandleAlarmView () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewContraint_H;


@property(nonatomic,strong) UIButton * currentItem;

@end

@implementation BYHandleAlarmView

- (IBAction)itemAction:(UIButton *)sender {
    
    if (![sender isEqual:self.currentItem]) {
        self.currentItem.selected = NO;
    }
    sender.selected = !sender.selected;
    self.currentItem = sender;
    
    if (self.itemBlock) {
        self.itemBlock(sender.tag - 20);
    }
}


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.currentItem = (UIButton *)[self viewWithTag:20];
    self.currentItem.selected = YES;
    
    self.textViewContraint_H.constant = BYS_W_H(100);
    
    self.textView.layer.cornerRadius = 5;
    self.textView.clipsToBounds = YES;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.textView.text = placeholderStr;
    self.textView.font = BYS_T_F(15);
    self.textView.textColor = [UIColor grayColor];
    self.textView.delegate = self;
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
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.textView resignFirstResponder];
}

@end








