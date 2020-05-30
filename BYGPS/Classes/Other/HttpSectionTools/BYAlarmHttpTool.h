//
//  BYAlarmHttpTool.h
//  BYGPS
//
//  Created by miwer on 16/9/14.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYAlarmModel;

@class BYAlarmHttpParams;

@interface BYAlarmHttpTool : NSObject

+(void)POSTAlarmListWith:(BYAlarmHttpParams *)params success:(void (^)(NSMutableArray * array))success failure:(void(^)(NSError *error))failure;//获取报警信息列表

+(void)POSTAlarmSetSuccess:(void (^)(id data))success;//获取报警设置

+(void)POSTUpdateAlarmSetWithParams:(NSMutableDictionary *)params success:(void (^)())success;//更新报警设置

+(void)POSTHandleAlarmWithParams:(NSMutableDictionary *)params success:(void (^)())success;//处理报警

+(void)POSTAlarmPositionWith:(NSString *)alarmId success:(void (^)(id data))success;//根据alarmId来获取报警详情

@end
