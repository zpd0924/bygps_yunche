//
//  BYAlarmConfigModel.h
//  BYGPS
//
//  Created by miwer on 16/9/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BYAlarmConfigModel : JSONModel

@property(nonatomic,strong) NSString * alarmConfigKey;
@property(nonatomic,strong) NSString * alarmConfigTitle;
@property(nonatomic,assign) BOOL alarmConfigValue;

+(BYAlarmConfigModel *)createModelWith:(NSString *)key value:(BOOL)value title:(NSString *)title;

@end
