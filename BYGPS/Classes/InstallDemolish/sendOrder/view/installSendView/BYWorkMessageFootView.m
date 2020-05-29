//
//  BYWorkMessageFootView.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYWorkMessageFootView.h"

static NSString * const placeholderStr = @"请输入备注,技师可见";
@interface BYWorkMessageFootView()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end


@implementation BYWorkMessageFootView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.textView.delegate = self;
    self.textView.text = placeholderStr;
    self.nextBtn.layer.cornerRadius = 6;
    self.nextBtn.layer.masksToBounds = YES;
//    self.textView.textColor =
}
- (void)setWorkMessageModel:(BYWorkMessageModel *)workMessageModel{
    _workMessageModel = workMessageModel;
    if (workMessageModel.comment.length) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.textView.text = workMessageModel.comment;
            self.textView.textColor = UIColorHexFromRGB(0x333333);
        });
    }
}


- (void)textViewDidChange:(UITextView *)textView{
    if (self.editBlock) {
        self.editBlock(textView.text);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView.text.length<1) {
        
        textView.text = placeholderStr;
        self.textView.textColor = UIColorHexFromRGB(0x999999);
    }
    
    if (![textView.text isEqualToString:placeholderStr] && textView.text.length) {
        
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:placeholderStr]) {
        
        textView.text = @"";
        self.textView.textColor = UIColorHexFromRGB(0x333333);
    }
}



- (IBAction)nextClick:(UIButton *)sender {

    [self endEditing:YES];
    if(self.workMessageFootViewNextClickBlock)
        self.workMessageFootViewNextClickBlock();
}

@end
