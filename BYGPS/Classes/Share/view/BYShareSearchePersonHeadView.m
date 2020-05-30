//
//  BYShareSearchePersonHeadView.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/28.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYShareSearchePersonHeadView.h"
@interface BYShareSearchePersonHeadView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
@implementation BYShareSearchePersonHeadView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.textField.delegate = self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.selectBlock) {
        self.selectBlock(textField.text);
    }
    return YES;
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
    if (self.backBlock) {
        self.backBlock(nil);
    }
}
- (IBAction)editingDidEndClick:(UITextField *)sender {
    if (self.selectBlock) {
        self.selectBlock(sender.text);
    }
}




@end
