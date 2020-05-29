//
//  BYDeviceDetailHttpTool.h
//  BYGPS
//
//  Created by miwer on 16/9/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYReplayHttpParams;
@class BYSendPostBackParams;
@class BYSendBreakingOilParams;

@interface BYDeviceDetailHttpTool : NSObject

+(void)POSTDeviceDetailWithDeviceId:(NSInteger)deviceId success:(void (^)(id data))success showHUD:(BOOL)showHUD;//根据DeviceId获取设备详情

+(void)POSTRelativeCarWithCarId:(NSInteger)carId success:(void (^)(id data))success;//关联设备

+(void)POSTDeviceConfigWithDeviceId:(NSInteger)deviceId success:(void (^)(id data))success failure:(void(^)())failure isShowFlower:(BOOL)isShowFlower;//通过deviceId获取设备报警配置信息

+(void)POSTDeviceConfigWithDeviceId:(NSInteger)deviceId cmdTypeArr:(NSArray *)cmdTypeArr success:(void (^)(NSMutableArray *cmdArr))success failure:(void(^)())failure isShowFlower:(BOOL)isShowFlower;//获取指令详情

+(void)POSTDeviceConfigWithDeviceId:(NSInteger)deviceId cmdType:(NSInteger)cmdType success:(void(^)(id data))success failure:(void(^)())failure isShowFlower:(BOOL)isShowFlower;

+(void)POSTSaveAlarmSetWithParams:(NSMutableDictionary *)params success:(void (^)(void))success;//设置报警

+(void)POSTReplayListWith:(BYReplayHttpParams *)params success:(void (^)(NSMutableArray * array))success failure:(void(^)())failure;//获取轨迹回放数据

+(void)POSTSendPostBackWithParams:(BYSendPostBackParams *)params success:(void (^)(void))success;//发送回传间隔

//发送设备重启指令

+(void)POSTSendRestartSetWithParams:(NSMutableDictionary *)params success:(void (^)(void))success;
//开启光感报警
+(void)POSTOpenLightAlarmWithParams:(BYSendPostBackParams *)params success:(void (^)(void))success;

+(void)POSTSendBreakingOilWith:(BYSendBreakingOilParams *)params success:(void(^)(void))success;

+(void)POSTListParkingEventWith:(BYReplayHttpParams *)params success:(void(^)(NSMutableArray * array))success failure:(void(^)())failure;//获取轨迹停车事件信息

//判断021D是否经过测试
+(void)POSTJudgeTest021DWith:(NSInteger)deviceId success:(void (^)(id data))success;


//+(void)POSTListParkingEventWith:(BYReplayHttpParams *)params success:(void(^)(NSMutableArray * array))success failure:(void(^)())failure;//获取轨迹停车事件信息

//开启行驶报警接口
+(void)POSTOpenDeviceAlarmWithDeviceId:(NSInteger)deviceId success:(void(^)(id data))success;


//查询更近设备gps定位
+(void)POSTQueryOtherDevideWithDeviceId:(NSInteger)deviceId success:(void(^)(id data))success;


@end
