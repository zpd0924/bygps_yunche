//
//  BYAlarmHttpTool.m
//  BYGPS
//
//  Created by miwer on 16/9/14.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAlarmHttpTool.h"
#import "BYNetworkHelper.h"
#import "BYAlarmHttpParams.h"
#import "BYAlarmModel.h"

static NSString * const alarmUrl = @"alarm/queryAlarms";
static NSString * const alarmHandleUrl = @"alarm/processAlarm";
static NSString * const alarmSetUrl = @"alarm/queryConfig";
static NSString * const updateAlarmSetUrl = @"alarm/updateConfig";
static NSString * const alarmPositionUrl = @"alarm/queryInfo";

@implementation BYAlarmHttpTool

+(void)POSTAlarmListWith:(BYAlarmHttpParams *)params success:(void (^)(NSMutableArray * array))success failure:(void(^)(NSError *error))failure{
    
    NSMutableDictionary * httpParams = [NSMutableDictionary dictionary];
    
    httpParams[@"currentPage"] = @(params.currentPage);//当前页
    
    httpParams[@"showCount"] = @"20";//单页显示的数量
    
    if (params.status) {
        httpParams[@"status"] = @(params.status);//1已处理，2未处理
    }
    
    if (params.groupId) {
        httpParams[@"groupIds"] = params.groupId;//分组ID
    }
    
    if (params.alarmType) {
        httpParams[@"alarmTypeIds"] = params.alarmType;//报警类型
    }
    
    if (params.startTime) {
        httpParams[@"startTime"] = params.startTime;//报警开始时间:格式”2016-09-09 00:00:00”
    }
    
    if (params.endTime) {
        httpParams[@"endTime"] = params.endTime;
    }
    
    if (params.queryStr) {
        httpParams[@"queryStr"] = params.queryStr;//搜索SN跟车主跟车牌
    }
    
    if (params.deviceId) {
        httpParams[@"deviceId"] = @(params.deviceId);
    }
    
    [[BYNetworkHelper sharedInstance] POST:alarmUrl params:httpParams success:^(id data) {
        
        if (data) {
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dict in data) {
                
                NSInteger index = [data indexOfObject:dict];
                
                BYAlarmModel * model = [[BYAlarmModel alloc] initWithDictionary:dict error:nil];
                if (index == 0 && params.currentPage == 1) {
                    model.isExpand = YES;
                }else{
                    model.isExpand = NO;
                }
                model.isSelect = NO;
                
                [arr addObject:model];
            }
            
            if (arr.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BYProgressHUD by_showErrorWithStatus:@"未查询到报警信息"];
                });
            }
            
            if (success) {
                success(arr);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

+(void)POSTAlarmPositionWith:(NSString *)alarmId success:(void (^)(id data))success{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"alarmId"] = alarmId;
    
    [[BYNetworkHelper sharedInstance] POST:alarmPositionUrl params:params success:^(id data) {
//        BYAlarmModel * model = [[BYAlarmModel alloc] initWithDictionary:data error:nil];
        
        if (success) {
            
            success(data);
        }
    } failure:nil showError:YES];
    
//    [[BYNetworkHelper sharedInstance] GET:alarmPositionUrl params:params success:^(id data) {
//
//        BYAlarmModel * model = [[BYAlarmModel alloc] initWithDictionary:data error:nil];
//
//        if (success) {
//
//            success(model);
//        }
//
//    } failure:nil showHUD:YES showError:NO];
}

+(void)POSTAlarmSetSuccess:(void (^)(id data))success{
    
    [[BYNetworkHelper sharedInstance] POST:alarmSetUrl params:nil success:^(id data) {
        if (success) {
            
            success(data);
        }
    } failure:nil showError:YES];
    
//    [[BYNetworkHelper sharedInstance] GET:alarmSetUrl params:nil success:^(id data) {
//        
//        if (success) {
//            
//            success(data);
//        }
//        
//    } failure:nil showHUD:YES showError:NO];
}

+(void)POSTUpdateAlarmSetWithParams:(NSMutableDictionary *)params success:(void (^)())success{
    //应急报警,脱离报警,震动报警不推送
    params[@"type1"] = @"1";
    params[@"type21"] = @"1";
    params[@"type4"] = @"1";
    [[BYNetworkHelper sharedInstance] POST:updateAlarmSetUrl params:params success:^(id data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYProgressHUD by_showSuccessWithStatus:@"设置成功"];
        });
        
        if (success) {
            success();
        }
        
    } failure:nil showError:YES];
    
}

+(void)POSTHandleAlarmWithParams:(NSMutableDictionary *)params success:(void (^)())success{
    
    [[BYNetworkHelper sharedInstance] POST:alarmHandleUrl params:params success:^(id data) {
        
        if (success) {
            success();
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYProgressHUD by_showSuccessWithStatus:@"处理成功"];
        });
        
    } failure:nil showError:YES];
    
}

@end

/*
 currentPage;
 showCount;
 status;
 groupId;
 alarmType;
 startTime;
 queryStr;
 */
