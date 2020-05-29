//
//  BYDeviceDetailHttpTool.m
//  BYGPS
//
//  Created by miwer on 16/9/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDeviceDetailHttpTool.h"
#import "BYNetworkHelper.h"
#import "BYAlarmConfigModel.h"
#import "BYCmdRecordModel.h"
#import "BYReplayHttpParams.h"
#import "BYReplayModel.h"
#import "BYParkEventModel.h"
#import "BYSendPostBackParams.h"
#import "BYSendBreakingOilParams.h"

static NSString * const deviceInfoUrl = @"device/detail";
static NSString * const relativeCarUrl = @"device/queryInstall";
static NSString * const getDeviceConfigUrl = @"deviceConfig/getDeviceConfig";
static NSString * const getLastCommandUrl = @"deviceCmd/getLastCommand";
static NSString * const openLightAlarmUrl = @"deviceCmd/openLightAlarm";
static NSString * const saveAlarmSetUrl = @"alarm/confAlarm";//报警配置
static NSString * const setRestartUrl = @"deviceCmd/restart";
//static NSString * const replayUrl = @"trackService/trackPush";
static NSString * const replayNewUrl = @"track/query";
static NSString * const sendCommandUrl = @"deviceCmd/sendCommand";//在线监控指令下发接口
static NSString * const listParkingEventUrl = @"track/stayPoint";
static NSString * const breakingOilUrl =  @"deviceCmd/breakingOilElectricity";

static NSString * const judgeTest021DUrl = @"deviceCmd/judgeTest021D";//判断021d是否经过测试

static NSString * const openDeviceAlarmUrl = @"device/openDriveAlarm";//开启行驶报警接口
static NSString * const queryOtherDeviceUrl = @"device/queryOtherDevice";//查询更近设备gps定位


@implementation BYDeviceDetailHttpTool

+(void)POSTDeviceDetailWithDeviceId:(NSInteger)deviceId success:(void (^)(id data))success showHUD:(BOOL)showHUD{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"deviceId"] = @(deviceId);
    [[BYNetworkHelper sharedInstance] POST:deviceInfoUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:nil showError:showHUD];
}

+(void)POSTRelativeCarWithCarId:(NSInteger)carId success:(void (^)(id data))success{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"carId"] = @(carId);
    [[BYNetworkHelper sharedInstance] POST:relativeCarUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:nil showError:YES];
}

+(void)POSTDeviceConfigWithDeviceId:(NSInteger)deviceId success:(void (^)(id data))success failure:(void (^)())failure isShowFlower:(BOOL)isShowFlower{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"deviceId"] = @(deviceId);

    [[BYNetworkHelper sharedInstance] POST:getDeviceConfigUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    } showError:isShowFlower];
}
//#warning ZpdGet

+(void)POSTDeviceConfigWithDeviceId:(NSInteger)deviceId cmdTypeArr:(NSArray *)cmdTypeArr success:(void (^)(NSMutableArray *cmdArr))success failure:(void (^)())failure isShowFlower:(BOOL)isShowFlower{
    [BYProgressHUD show];
    NSMutableArray *cmdArr = [NSMutableArray array];
    //    /创建信号量/
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //    /创建全局并行/
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (NSString * cmdType in cmdTypeArr) {
        
        dispatch_group_async(group, queue, ^{
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"deviceId"] = @(deviceId);
            
            params[@"type"] = [cmdType integerValue] > 0 ? cmdType : nil;
            
            [[BYNetworkHelper sharedInstance] POST:getLastCommandUrl params:params success:^(id data) {
                BYLog(@"configAlarmData : %@",data);
                
//                NSArray * tempCmdArr = data[@"commandData"];
                //如果请求过来的指令内容为空, 并且cmdType为1或者3、4, 自己创建一条数据
                if (![data isKindOfClass:[NSNull class]]) {
//                    for (NSDictionary * dict in tempCmdArr) {
                    BYCmdRecordModel * model = [[BYCmdRecordModel alloc] initWithDictionary:data error:nil];
                    model.type = [cmdType integerValue];
                    if ([cmdType integerValue] == 1) {
                        [cmdArr insertObject:model atIndex:0];
                    }else{
                        [cmdArr addObject:model];
                    }
//                    }
                }else{
                    if ([cmdType integerValue] == 1 || [cmdType integerValue] == 3 || [cmdType integerValue] == 4 || [cmdType integerValue] == 5 || [cmdType integerValue] == 12){
                        
                        BYCmdRecordModel * model = [[BYCmdRecordModel alloc] init];
                        model.status = @"无记录";
                        model.content = @"无记录";
                        model.sendTime = @"无记录";
                        model.updateTime = @"无记录";
                        model.nickName = @"无记录";
                        model.type = [cmdType integerValue];
                        model.mode = @"无记录";
//                        if ([cmdType integerValue] == 1) {
//                            [cmdArr insertObject:model atIndex:0];
//                        }else if([cmdType integerValue] == 3 || [cmdType integerValue] == 4){
//                            if ([cmdType integerValue] == 3) {
//                                if(cmdArr.count > 0){
//                                    [cmdArr insertObject:model atIndex:1];
//                                }else{
//                                    [cmdArr addObject:model];
//                                }
//                            }else{
//                                [cmdArr addObject:model];
//                            }
//                        }else{
                            [cmdArr addObject:model];
//                        }
                    }
                }
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSError *error) {
                if ([cmdType integerValue] == 1 || [cmdType integerValue] == 3 || [cmdType integerValue] == 4 || [cmdType integerValue] == 5 || [cmdType integerValue] == 12) {
                    
                    BYCmdRecordModel * model = [[BYCmdRecordModel alloc] init];
                    model.status = @"无记录";
                    model.content = @"无记录";
                    model.sendTime = @"无记录";
                    model.updateTime = @"无记录";
                    model.nickName = @"无记录";
                    model.type = [cmdType integerValue];
                    if ([cmdType integerValue] == 1) {
                        [cmdArr insertObject:model atIndex:0];
                    }else if([cmdType integerValue] == 3){
                        if(cmdArr.count > 0){
                            [cmdArr insertObject:model atIndex:1];
                        }else{
                            [cmdArr addObject:model];
                        }
                    }else{
                        [cmdArr addObject:model];
                    }
                    
                }
                dispatch_semaphore_signal(semaphore);
            } showError:isShowFlower];
        });
    }

    dispatch_group_notify(group, queue, ^{
        switch (cmdTypeArr.count) {
            case 1:
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                break;
            case 2:
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                break;
            case 3:
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                break;
                
            default:
                break;
        }

        dispatch_queue_t mainQueue= dispatch_get_main_queue();
        dispatch_sync(mainQueue, ^{
//            [BYProgressHUD dismiss];
            if (success) {
                
                NSArray *array2 = [cmdArr sortedArrayUsingComparator:^NSComparisonResult(BYCmdRecordModel * obj1, BYCmdRecordModel * obj2) {
                    NSString *typeStr1 = [NSString stringWithFormat:@"%zd",obj1.type];
                    NSString *typeStr2 = [NSString stringWithFormat:@"%zd",obj2.type];
                    NSComparisonResult result = [typeStr1 compare:typeStr2];
                    return result;
                }];
                NSMutableArray *cmdDatasource = [NSMutableArray arrayWithArray:array2];
                success(cmdDatasource);
            }
            if (failure) {
                failure();
            }
        });
    });
    
}

+(void)POSTDeviceConfigWithDeviceId:(NSInteger)deviceId cmdType:(NSInteger)cmdType success:(void(^)(id data))success failure:(void(^)())failure isShowFlower:(BOOL)isShowFlower{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"deviceId"] = @(deviceId);
    
    params[@"type"] = @(cmdType);
    
    [[BYNetworkHelper sharedInstance] POST:getLastCommandUrl params:params success:^(id data) {
        BYLog(@"configAlarmData : %@",data);

        if (success) {
            success(data);
        }
        //                NSArray * tempCmdArr = data[@"commandData"];
        
        
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    } showError:isShowFlower];
}

+(void)POSTSaveAlarmSetWithParams:(NSMutableDictionary *)params success:(void (^)())success{
    
    [[BYNetworkHelper sharedInstance] POST:saveAlarmSetUrl params:params success:^(id data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYProgressHUD by_showSuccessWithStatus:@"设置成功"];
        });
        
        if (success) {
            success();
        }

    } failure:nil showError:YES];
    
}

+(void)POSTReplayListWith:(BYReplayHttpParams *)params success:(void (^)(NSMutableArray * array))success failure:(void (^)())failure{
    
    NSMutableDictionary * httpParams = [NSMutableDictionary dictionary];
    
    httpParams[@"deviceId"] = @(params.deviceid);
    httpParams[@"beginTime"] = params.startTime;
    
    if (params.endTime) {
        httpParams[@"endTime"] = params.endTime;
    }
    
    httpParams[@"gps"] = @(params.gps);
    httpParams[@"speed"] = @(params.speed);
    httpParams[@"stopKM"] = @(params.stopKM);
    httpParams[@"flameOut"] = @(params.flameOut);
    
    
    [[BYNetworkHelper sharedInstance] POST:replayNewUrl params:httpParams success:^(id data) {
        NSMutableArray * arr = [NSMutableArray array];
        for (NSDictionary * dict in data) {
            BYReplayModel * model = [[BYReplayModel alloc] initWithDictionary:dict error:nil];
            [arr addObject:model];
        }
        
        if (success) {
            success(arr);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

+(NSString *)getAlarmTitleWithKey:(NSString *)key{
    
    if ([key rangeOfString:@"online"].location != NSNotFound) return @"上线报警";
    
    if ([key rangeOfString:@"start"].location != NSNotFound) return @"行驶报警";
    
    if ([key rangeOfString:@"stop"].location != NSNotFound) return @"停车报警";
    
    return nil;
}

+(void)POSTSendPostBackWithParams:(BYSendPostBackParams *)params success:(void (^)())success{
    
    NSMutableDictionary * httpParams = [NSMutableDictionary dictionary];
    httpParams[@"deviceId"] = @(params.deviceId);
    httpParams[@"type"] = @(params.type);
    httpParams[@"mold"] = @(params.mold);
    httpParams[@"model"] = params.model;
    httpParams[@"content"] = params.content;

    
    [[BYNetworkHelper sharedInstance] POST:sendCommandUrl params:httpParams success:^(id data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYProgressHUD by_showSuccessWithStatus:@"指令发送成功"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (success) {
                success();
            }
        });
        
        
    } failure:nil showError:YES];
}

#pragma mark 设备重启指令发送
+(void)POSTSendRestartSetWithParams:(NSMutableDictionary *)params success:(void (^)())success
{
    [[BYNetworkHelper sharedInstance] POST:setRestartUrl params:params success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYProgressHUD by_showSuccessWithStatus:@"指令发送成功"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (success) {
                success();
            }
        });
    } failure:nil showError:YES];
}

+(void)POSTOpenLightAlarmWithParams:(BYSendPostBackParams *)params success:(void (^)(void))success{
    
    NSMutableDictionary * httpParams = [NSMutableDictionary dictionary];
    httpParams[@"deviceId"] = @(params.deviceId);
    httpParams[@"type"] = @(params.type);
    httpParams[@"mold"] = @(params.mold);
    httpParams[@"model"] = params.model;
    httpParams[@"content"] = params.content;
    
    [[BYNetworkHelper sharedInstance] POST:openLightAlarmUrl params:httpParams success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYProgressHUD by_showSuccessWithStatus:@"指令发送成功"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (success) {
                success();
            }
        });
    } failure:nil showError:YES];
}


+(void)POSTSendBreakingOilWith:(BYSendBreakingOilParams *)params success:(void (^)())success
{
    NSMutableDictionary *httpParams = [NSMutableDictionary dictionary];
    httpParams[@"deviceId"] = @(params.deviceId);
    httpParams[@"type"] = @(params.type);
    httpParams[@"content"] = params.content;
    httpParams[@"model"] = params.model;
//    httpParams[@"levelPassWord"] = params.levelPassWord;
    
    [[BYNetworkHelper sharedInstance] POST:breakingOilUrl params:httpParams success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYProgressHUD by_showSuccessWithStatus:@"指令发送成功"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (success) {
                success();
            }
        });
    } failure:nil showError:YES];
    
}

#pragma mark 判断021d是否通过测试

+(void)POSTJudgeTest021DWith:(NSInteger)deviceId success:(void (^)(id data))success
{
    NSMutableDictionary *httpParams = [NSMutableDictionary dictionary];
    httpParams[@"deviceId"] = @(deviceId);
    [[BYNetworkHelper sharedInstance] POST:judgeTest021DUrl params:httpParams success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:nil showError:YES];
}


#pragma mark 获取停车事件信息
+(void)POSTListParkingEventWith:(BYReplayHttpParams *)params success:(void (^)(NSMutableArray *))success failure:(void (^)())failure
{
    NSMutableDictionary * httpParams = [NSMutableDictionary dictionary];
    
//    httpParams[@"sn"] = @"864297600033663";
//    httpParams[@"beginTime"] = @"2017-05-18 00:00:00";
//    
//    if (params.endTime) {
//        httpParams[@"endTime"] = @"2017-06-15 00:00:00";
//    }
    
    httpParams[@"sn"] = params.sn;
    httpParams[@"deviceId"] =  @(params.deviceid);
    httpParams[@"beginTime"] = params.startTime;
    
    if (params.endTime) {
        httpParams[@"endTime"] = params.endTime;
    }
    
    [[BYNetworkHelper sharedInstance] POST:listParkingEventUrl params:httpParams success:^(id data) {
        NSMutableArray * arr = [NSMutableArray array];
        for (NSDictionary * dict in data) {
            BYParkEventModel * model = [[BYParkEventModel alloc] initWithDictionary:dict error:nil];
            [arr addObject:model];
        }
        
        if (success) {
            success(arr);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];

}


+(void)POSTOpenDeviceAlarmWithDeviceId:(NSInteger)deviceId success:(void (^)(id))success{
    
    NSMutableDictionary *httpParams = [NSMutableDictionary dictionary];
    httpParams[@"deviceId"] = @(deviceId);
    
    [[BYNetworkHelper sharedInstance] POST:openDeviceAlarmUrl params:httpParams success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:nil showError:NO];
}

+(void)POSTQueryOtherDevideWithDeviceId:(NSInteger)deviceId success:(void (^)(id))success
{
    NSMutableDictionary *httpParams = [NSMutableDictionary dictionary];
    httpParams[@"deviceId"] = @(deviceId);
    
    [[BYNetworkHelper sharedInstance] POST:queryOtherDeviceUrl params:httpParams success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:nil showError:YES];
    
}

@end
