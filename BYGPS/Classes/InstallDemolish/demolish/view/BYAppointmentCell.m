//
//  BYAppointmentCell.m
//  父子控制器
//
//  Created by miwer on 2016/12/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAppointmentCell.h"
#import "BYInstallModel.h"

@interface BYAppointmentCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation BYAppointmentCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.textField.delegate = self;
}

-(void)setIsUserInteraction:(BOOL)isUserInteraction{
    self.textField.userInteractionEnabled = isUserInteraction;
}

-(void)setModel:(BYInstallModel *)model{
    self.titleLabel.text = model.title;
    self.textField.placeholder = model.placeholder;
    
    self.textField.text = model.subTitle;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (self.shouldEndInputBlock) {
        self.shouldEndInputBlock(textField.text);
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location == 6 && string.length != 0) {
        if (self.shouldChangeCharsBlock) {
            self.shouldChangeCharsBlock([textField.text stringByAppendingString:string]);
        }
    }else if (range.location == 7){
        if (self.shouldChangeCharsBlock) {
            self.shouldChangeCharsBlock(string.length == 1 ? [textField.text stringByAppendingString:string] : [textField.text substringToIndex:7]);
        }
    }else if (range.location == 8 && string.length == 0){
        if (self.shouldChangeCharsBlock) {
            self.shouldChangeCharsBlock([textField.text substringToIndex:8]);
        }
    }else if (range.location == 6 && string.length == 0){
        if (self.shouldChangeCharsBlock) {
            self.shouldChangeCharsBlock(@"-1");
        }
    }else if (range.location == 8 && string.length ==1){
        if (self.shouldChangeCharsBlock) {
            self.shouldChangeCharsBlock(@"-1");
        }
    }
    
//    BYLog(@"textFiled.text : %@ - location : %ld - length : %ld - string - %@",textField.text,range.location,range.length,string);
    
    return YES;
}


@end
