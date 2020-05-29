//
//  BYBindPhoneTextFieldCell.h
//  BYGPS
//
//  Created by ZPD on 2017/7/27.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYBaseSettingItem.h"
#import "BYVerifyCodeButton.h"

@interface BYBindPhoneTextFieldCell : UITableViewCell

@property (nonatomic, strong) BYBaseSettingItem *item;

@property(nonatomic,strong) UITextField * textField;

@property (nonatomic,strong) BYVerifyCodeButton * codeButton;//获取验证码按钮

@property (nonatomic,copy) void(^codeButtonCallBack)();

+ (instancetype)cellWithTableView:(UITableView *)tableView tableViewCellStyle:(UITableViewCellStyle)tableViewCellStyle;

@end
