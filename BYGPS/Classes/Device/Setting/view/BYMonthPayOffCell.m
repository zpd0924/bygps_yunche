//
//  BYMonthPayOffCell.m
//  BYGPS
//
//  Created by ZPD on 2018/6/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMonthPayOffCell.h"
#import "BYMonthPayoffModel.h"

@interface BYMonthPayOffCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *dayTextField;

@property (weak, nonatomic) IBOutlet UITextField *beforDayTextField;
@property (weak, nonatomic) IBOutlet UITextField *afterDayTextField;

@property (weak, nonatomic) IBOutlet UIView *timeView;


@end

@implementation BYMonthPayOffCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTime)];
    
    self.timeView.userInteractionEnabled = YES;
    [self.timeView addGestureRecognizer:tap];
    
    self.dayTextField.delegate = self;
    self.beforDayTextField.delegate = self;
    self.afterDayTextField.delegate = self;
    
    
}

-(void)setPayOffModel:(BYMonthPayoffModel *)payOffModel
{
    _payOffModel = payOffModel;
    if ([payOffModel.day integerValue] > 0 ) {
        self.dayTextField.text = payOffModel.day;
    }
    
    if ([payOffModel.beforDay integerValue] <= 0) {
        self.beforDayTextField.placeholder = 0;
    }else{
        self.beforDayTextField.text = payOffModel.beforDay;
    }
    
    if ([payOffModel.afterDay integerValue] <= 0) {
        self.afterDayTextField.placeholder = 0;
    }else{
        self.beforDayTextField.text = payOffModel.beforDay;
    }
    
    self.timeLabel.text = payOffModel.time;
}



-(void)chooseTime{
    [self endEditing:YES];
    if (self.chooseTimeBlock) {
        self.chooseTimeBlock();
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //tag   day 3000    beforDay 3001    afterDay 3002
    if (textField.tag == 3000) {
        if ([textField.text integerValue] > 31 ) {
            BYShowError(@"还款日为1～31日");
            return NO;
        }
        
        if (self.dayTextFieldEndEditBlock) {
            self.dayTextFieldEndEditBlock(textField.text);
        }
    }
    
    if (textField.tag == 3001) {
        if ([textField.text integerValue] > 10) {
            BYShowError(@"还款前天数为0～10日");
            return NO;
        }
        if (self.beforDayTextFieldEndEditBlock) {
            self.beforDayTextFieldEndEditBlock(textField.text);
        }
    }
    if (textField.tag == 3002) {
        if ([textField.text integerValue] > 10) {
            BYShowError(@"还款后天数为0～10日");
            return NO;
        }
        if (self.afterDayTextFieldEndEditBlock) {
            self.afterDayTextFieldEndEditBlock(textField.text);
        }
    }
    
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
