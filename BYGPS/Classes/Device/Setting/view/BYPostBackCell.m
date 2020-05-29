//
//  BYPostBackCell.m
//  BYGPS
//
//  Created by bean on 16/7/30.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYPostBackCell.h"

@interface BYPostBackCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;


@end

@implementation BYPostBackCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.textField.delegate = self;

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (self.shouldEndInputBlock) {
        self.shouldEndInputBlock(textField.text);
    }
    return YES;
}

- (IBAction)saveLightClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.saveLightBlock) {
        self.saveLightBlock();
    }
    
}

-(void)setModel:(BYPostBackModel *)model{
    
    self.titleLabel.text = model.title;

    self.textField.placeholder = model.palceholder;
    
    self.unitLabel.text = model.unit;
    
    self.saveLightButton.selected = model.saveLightSelected;
    
//    [self.textField becomeFirstResponder];
    
}

@end
