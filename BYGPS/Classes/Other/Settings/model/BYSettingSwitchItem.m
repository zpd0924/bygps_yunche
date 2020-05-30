//
//  BYSettingSwitchItem.m
//  BYGPS
//
//  Created by miwer on 16/7/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSettingSwitchItem.h"

@implementation BYSettingSwitchItem

/** 根据BYSettingSwitchItem 设置的title获取 UISwitch的开关状态 */
+(BOOL)isONSwitchByTitle:(NSString *)title{
    return [BYSaveTool isTurnOnSwitchByTitle:title];
}

@end
