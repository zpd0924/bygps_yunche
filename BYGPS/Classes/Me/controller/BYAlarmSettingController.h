//
//  BYAlarmSettingController.h
//  BYGPS
//
//  Created by miwer on 16/7/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBaseSettingController.h"

@interface BYAlarmSettingController : BYBaseSettingController

@property(nonatomic,assign) BOOL isAlarmSetting;

@property(nonatomic,strong) void (^typesResultBlock) (NSString * resultStr);

@end
