//
//  BYCheckNoPassReasonViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCheckNoPassReasonViewController.h"

static NSString * const placeholderStr = @"请输入审核不通过原因，如图片不清晰";
@interface BYCheckNoPassReasonViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *mengView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation BYCheckNoPassReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.mengView addGestureRecognizer:tap];
    self.textView.delegate = self;
  
    
}
- (void)tap:(UITapGestureRecognizer *)tap{
    NSLog(@"tap = %@",tap);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- uitextView
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
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 100) {
        BYShowError(@"最多不能超过100个字符");
        textView.text = [textView.text substringToIndex:100];
        return;
    }
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sureBtnClick:(UIButton *)sender {

    [self.view endEditing:YES];
    if (self.textView.text.length == 0)
        return BYShowError(@"审核原因不能为空");
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"orderNo"] = _model.orderNo;
    dict[@"status"] = @(0);//状态 1：通过 0：不通过
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:placeholderStr]) {
        return BYShowError(@"请输入审核通过原因");
    }
    dict[@"approveReason"] = self.textView.text;
    [BYSendWorkHttpTool POSSauditingParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            BYShowSuccess(@"操作成功");
            if (weakSelf.checkNoPassReasonBlock) {
                weakSelf.checkNoPassReasonBlock();
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
    } failure:^(NSError *error) {
            
    }];
    
    
}


@end
