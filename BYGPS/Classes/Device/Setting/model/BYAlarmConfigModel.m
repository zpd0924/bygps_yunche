//
//  BYAlarmConfigModel.m
//  BYGPS
//
//  Created by miwer on 16/9/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAlarmConfigModel.h"

@implementation BYAlarmConfigModel

+(BYAlarmConfigModel *)createModelWith:(NSString *)key value:(BOOL)value title:(NSString *)title{
    BYAlarmConfigModel * model = [[BYAlarmConfigModel alloc] init];
    model.alarmConfigKey = key;
    model.alarmConfigValue = value;
    model.alarmConfigTitle = title;
    return model;
}

@end
