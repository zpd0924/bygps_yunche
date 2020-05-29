//
//  BYDetailSearchHeadView.m
//  BYIntelligentAssistant
//
//  Created by 主沛东 on 2019/4/10.
//  Copyright © 2019 BYKJ. All rights reserved.
//

#import "BYDetailSearchHeadView.h"

@interface BYDetailSearchHeadView ()<UITextFieldDelegate>

@end

@implementation BYDetailSearchHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    self.searchBackView.layer.cornerRadius = 5.0;
    self.searchBackView.layer.masksToBounds = YES;
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (self.searchBlock) {
        self.searchBlock(textField.text);
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.searchBlock) {
        self.searchBlock(textField.text);
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if (self.searchBlock) {
        self.searchBlock(textField.text);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.inputIngSearchBlock) {
        self.inputIngSearchBlock(textField.text);
    }
    
    return YES;
}

@end
