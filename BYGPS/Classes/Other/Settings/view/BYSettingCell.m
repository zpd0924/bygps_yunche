//
//  BYSettingCell.m
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSettingCell.h"
#import "BYSettingArrowItem.h"
#import "BYSettingSwitchItem.h"
#import "BYSettingTextFieldItem.h"
#import "BYSettingAlarmTypeItem.h"
#import "BYSettingNoneItem.h"
#import "BYCodeItem.h"
#import "BYSettingBlueArrowItem.h"
#import "UITextField+BYPlaceholderCenter.h"
#import "BYVerifyCodeButton.h"

@interface BYSettingCell () <UITextFieldDelegate>

@property(nonatomic, strong) UIImageView *arrowImageView;

@property(nonatomic,strong) UISwitch * switchView;

@property(nonatomic, strong) UIImageView *alarmSelectImageView;

@property(nonatomic,strong) UILabel * labelView;

@property (nonatomic,strong) UIView * codeView;//获取验证码bgView

@property (nonatomic,strong) BYVerifyCodeButton * codeButton;//获取验证码按钮

@end

@implementation BYSettingCell

+ (instancetype) cellWithTableView:(UITableView *)tableView tableViewCellStyle:(UITableViewCellStyle)tableViewCellStyle
{
    static NSString *ID = @"cell";
    BYSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:tableViewCellStyle reuseIdentifier:ID];
        cell.textLabel.textColor = BYGlobalTextGrayColor;
        cell.textLabel.font = BYS_T_F(16);
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.textColor = BYGlobalTextGrayColor;
        cell.detailTextLabel.font = BYS_T_F(16);
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(void)setItem:(BYBaseSettingItem *)item{
    _item = item;
    
    [self setUpData];
    
    [self setUpAccessory];

}

-(void)setUpAccessory{
    if ([_item isKindOfClass:[BYSettingArrowItem class]]) {
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.accessoryView = self.arrowImageView;
    }else if ([_item isKindOfClass:[BYSettingBlueArrowItem class]]){
        self.accessoryView = self.arrowImageView;
        self.textLabel.textColor = [UIColor colorWithHex:@"#0380f4"];
    }else if ([_item isKindOfClass:[BYSettingSwitchItem class]]) { // Cell右边Switch
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = self.switchView;
        BYSettingSwitchItem *switchItem = (BYSettingSwitchItem *)_item;
        if([BYSaveTool isContainsKey:switchItem.saveKey]){
            self.switchView.on = [BYSaveTool isTurnOnSwitchByTitle:switchItem.saveKey];
        }else{
            [BYSaveTool setBool:switchItem.defaultOn forKey:switchItem.saveKey];
            self.switchView.on = switchItem.defaultOn;
        }
        [self.switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }else if ([_item isKindOfClass:[BYSettingTextFieldItem class]]){
        BYSettingTextFieldItem * textFieldItem = (BYSettingTextFieldItem *)_item;
        self.accessoryView = self.textField;
        self.textField.keyboardType = textFieldItem.keyboardType;
        self.textField.secureTextEntry = textFieldItem.isSecurity;
        
        [self.textField adjustCenterWithPlaceholder:textFieldItem.cellPlaceholder];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else if ([_item isKindOfClass:[BYCodeItem class]]){
        self.accessoryView = self.codeView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else if ([_item isKindOfClass:[BYSettingAlarmTypeItem class]]){
        BYSettingAlarmTypeItem * alarmTypeItem = (BYSettingAlarmTypeItem *)_item;
        self.accessoryView = self.alarmSelectImageView;
        self.alarmSelectImageView.hidden = alarmTypeItem.typeValue == 1 ? YES : NO;//为1则隐藏
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([_item isKindOfClass:[BYSettingNoneItem class]]){
        self.accessoryView = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        BYSettingNoneItem * item = (BYSettingNoneItem *)_item;
        self.textLabel.font = [UIFont systemFontOfSize:item.textFont];
        self.textLabel.textColor = BYGlobalTextGrayColor;
    }else {
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }

}
- (void)setUpData
{
    self.textLabel.text = _item.title;
    self.imageView.image = _item.image;
    self.detailTextLabel.text = _item.subTitle;
    self.detailTextLabel.textColor = BYGlobalTextGrayColor;
}
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    [super setFrame:frame];
}


-(void)switchValueChanged:(UISwitch *)switchControl{
    BYLog(@"switchValueChanged %d",switchControl.isOn);
    BYSettingSwitchItem *switchItem = (BYSettingSwitchItem *)_item;
    [BYSaveTool setBool:switchControl.isOn forKey:switchItem.saveKey];
    if ([_item isKindOfClass:[BYSettingSwitchItem class]]) {
        if(switchItem.opration_switch){
            switchItem.opration_switch(switchControl.isOn);
        }
    }
}

#pragma mark - delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if ([_item isKindOfClass:[BYCodeItem class]]) {
        
        BYCodeItem * item = (BYCodeItem *)_item;
        if (item.endEditCallBack) {
            item.endEditCallBack(textField.text);
        }
    }else{
        BYSettingTextFieldItem * item = (BYSettingTextFieldItem *)_item;
        if (item.endEditCallBack) {
            item.endEditCallBack(textField.text);
        }
    }
    
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (range.length + range.location > textField.text.length) {
//        return NO;
//    }
//    NSUInteger length = textField.text.length + string.length - range.length;
//    return length <= 11;
//}

#pragma mark - lazy
- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_icon_right"]];
    }
    return _arrowImageView;
}

- (UISwitch *)switchView {
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}

-(UITextField *)textField{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W * 0.68, BYS_W_H(20))];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _textField.delegate = self;
    }
    return _textField;
}

-(UIImageView *)alarmSelectImageView{
    if (_alarmSelectImageView == nil) {
        _alarmSelectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tick_green"]];
    }
    return _alarmSelectImageView;
}

-(UIView *)codeView{
    if (_codeView == nil) {
        _codeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W * 0.68, self.by_height)];
        
        self.textField.by_width = BYSCREEN_W * 0.4;
        self.textField.by_centerY = self.by_height / 2;
        
        [self.textField adjustCenterWithPlaceholder:@"请输入验证码"];
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        [_codeView addSubview:self.textField];
        
        self.codeButton.by_x = _codeView.by_width - BYS_W_H(85);
        [_codeView addSubview:self.codeButton];
        
    }
    
    return _codeView;
}

-(UIButton *)codeButton{
    if (_codeButton == nil) {
        _codeButton = [BYVerifyCodeButton buttonWithType:UIButtonTypeCustom];
        _codeButton.by_width = BYS_W_H(85);
        _codeButton.by_height = self.by_height * 0.7;
        _codeButton.by_centerY = self.by_height / 2;
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeButton.titleLabel.font = BYS_T_F(13);
        [_codeButton setTitleColor:BYGrayColor(70) forState:UIControlStateNormal];
        _codeButton.layer.cornerRadius = 5;
        _codeButton.clipsToBounds = YES;
        
        _codeButton.layer.borderColor = BYGrayColor(228).CGColor;
        _codeButton.layer.borderWidth = 1;
        
        [_codeButton addTarget:self action:@selector(receiveCode) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _codeButton;
}

-(void)receiveCode{
    
//    _codeButton.isAble = _item.isAble;
    
//    [_codeButton timeFailBegin];

    BYCodeItem *codeItem = (BYCodeItem *)_item;
    if (codeItem.codeCallBack) {
        codeItem.codeCallBack();
        if (codeItem.isAble) {
            [_codeButton timeFailBegin];
        }
    }
}

@end














