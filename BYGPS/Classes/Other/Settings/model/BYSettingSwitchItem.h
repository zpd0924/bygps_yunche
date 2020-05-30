//
//  BYSettingSwitchItem.h
//  BYGPS
//
//  Created by miwer on 16/7/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBaseSettingItem.h"

@interface BYSettingSwitchItem : BYBaseSettingItem

@property(nonatomic, copy) void (^opration_switch) (BOOL isOn);

/** 默认打开开关 */

@property (nonatomic, assign) BOOL defaultOn;

@property(nonatomic,strong) NSString * saveKey;

/** 根据BYSettingSwitchItem 设置的title获取 UISwitch的开关状态 */
+ (BOOL) isONSwitchByTitle:(NSString *)title;

@end
