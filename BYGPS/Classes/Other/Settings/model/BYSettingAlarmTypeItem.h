//
//  BYSettingAlarmTypeItem.h
//  BYGPS
//
//  Created by miwer on 16/7/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBaseSettingItem.h"

@interface BYSettingAlarmTypeItem : BYBaseSettingItem

@property(nonatomic,strong) NSString * typeKey;

@property(nonatomic,assign) NSInteger typeValue;

@property (nonatomic,strong) NSString *alarmStatus;

@property (nonatomic,assign) NSInteger alarmType;

@end
