//
//  BYBindPhoneTextFieldCell.m
//  BYGPS
//
//  Created by ZPD on 2017/7/27.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYBindPhoneTextFieldCell.h"
#import "BYSettingArrowItem.h"
#import "BYSettingSwitchItem.h"
#import "BYSettingTextFieldItem.h"
#import "BYSettingAlarmTypeItem.h"
#import "BYSettingNoneItem.h"
#import "BYCodeItem.h"
#import "BYSettingBlueArrowItem.h"
#import "UITextField+BYPlaceholderCenter.h"


@interface BYBindPhoneTextFieldCell ()<UITextFieldDelegate>
@property(nonatomic, strong) UIImageView *arrowImageView;

@property(nonatomic,strong) UISwitch * switchView;

@property(nonatomic, strong) UIImageView *alarmSelectImageView;

@property(nonatomic,strong) UILabel * labelView;

@property (nonatomic,strong) UIView * codeView;//获取验证码bgView



@end

@implementation BYBindPhoneTextFieldCell

+ (instancetype)cellWithTableView:(UITableView *)tableView tableViewCellStyle:(UITableViewCellStyle)tableViewCellStyle
{
    static NSString *ID = @"cell";
    BYBindPhoneTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setItem:(BYBaseSettingItem *)item{
    _item = item;
    
    [self setUpData];
    
    [self setUpAccessory];
    
}
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    [super setFrame:frame];
}
- (void)setUpData
{
    self.textLabel.text = _item.title;
    self.imageView.image = _item.image;
    self.detailTextLabel.text = _item.subTitle;
    self.detailTextLabel.textColor = BYGlobalTextGrayColor;
}

-(void)setUpAccessory{
    if ([_item isKindOfClass:[BYSettingTextFieldItem class]]){
        BYSettingTextFieldItem * textFieldItem = (BYSettingTextFieldItem *)_item;
        self.accessoryView = self.textField;
        self.textField.keyboardType = textFieldItem.keyboardType;
        self.textField.secureTextEntry = textFieldItem.isSecurity;
        
        [self.textField adjustCenterWithPlaceholder:textFieldItem.cellPlaceholder];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else if ([_item isKindOfClass:[BYCodeItem class]]){
        self.accessoryView = self.codeView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
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

#pragma mark - lazy


-(UITextField *)textField{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W * 0.68, BYS_W_H(20))];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _textField.delegate = self;
    }
    return _textField;
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

-(BYVerifyCodeButton *)codeButton{
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
    
//    BYCodeItem *codeItem = (BYCodeItem *)_item;
    
    if (self.codeButtonCallBack) {
        self.codeButtonCallBack();
    }
//    if (codeItem.codeCallBack) {
//        codeItem.codeCallBack();
////        if (codeItem.isAble) {
////            [_codeButton timeFailBegin];
////        }
//    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
