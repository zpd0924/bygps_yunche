//
//  BYSettingTextFieldItem.h
//  BYGPS
//
//  Created by miwer on 16/7/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBaseSettingItem.h"

@interface BYSettingTextFieldItem : BYBaseSettingItem

@property(nonatomic,strong) NSString * cellPlaceholder;
@property (nonatomic,assign) UIKeyboardType keyboardType;//键盘类型
@property (nonatomic,assign) BOOL isSecurity;//是否密文

@property (nonatomic,strong) void (^endEditCallBack) (NSString *str);

@end
