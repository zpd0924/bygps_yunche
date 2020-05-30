//
//  BYDeviceListHttpTool.m
//  BYGPS
//
//  Created by miwer on 16/9/1.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDeviceListHttpTool.h"
#import "BYNetworkHelper.h"
#import "BYDeviceListHttpParams.h"
#import "BYDeviceTypeModel.h"

static NSString * const groupListUrl = @"devices/queryDeviceTree";
static NSString * const deviceListUrl = @"devices/queryGroupDevice";
static NSString * const allDeviceTypeUrl = @"devices/getAllDeviceType";
static NSString * const queryDeviceBySnUrl = @"device/queryDeviceBySn";

@implementation BYDeviceListHttpTool

+(void)POSTGroupListWith:(BYDeviceListHttpParams *)params success:(void (^)(id data,NSInteger typeIndex, NSInteger countInt))success{
    
    NSMutableDictionary * httpParams = [NSMutableDictionary dictionary];
    if (params.groupName) {//北京
        httpParams[@"groupName"] = params.groupName;
    }
    
    if (params.online) {
        httpParams[@"online"] = params.online;
    }
    
    if (params.deviceTypeIds) {
        httpParams[@"deviceTypeIds"] = params.deviceTypeIds.count > 0 ? [params.deviceTypeIds componentsJoinedByString:@","] : @"-1";
    }
    
    if (params.queryStr) {
        httpParams[@"queryStr"] = params.queryStr;
    }
    
    if (params.alarm) {
        httpParams[@"alarm"] = params.alarm;
    }
    [[BYNetworkHelper sharedInstance] POST:groupListUrl params:httpParams success:^(id data) {
        NSArray * dataArr = data;
        if (dataArr.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [BYProgressHUD by_dismiss];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [BYProgressHUD by_showErrorWithStatus:@"未查询到设备信息"];
            });
        }
        
        NSInteger countInt = 0;
        if (success) {
            if (params.queryStr || params.deviceTypeIds || params.groupName) {
                success(data,-1,-1);//当不是全部,在线,离线,报警时不用计算
            }else if (httpParams.allKeys.count == 0 ) {//全部时键值对数量为0
                for (NSDictionary * dict in dataArr) {
                    countInt = [dict[@"number"] integerValue] + countInt;
                }
                success(data,0,countInt);
            }else if ([params.online isEqualToString:@"1"] && params.alarm == nil){//在线
                for (NSDictionary * dict in dataArr) {
                    countInt = [dict[@"number"] integerValue] + countInt;
                }
                success(data,1,countInt);
            }else if ([params.online isEqualToString:@"0"] && params.alarm == nil){//离线
                for (NSDictionary * dict in dataArr) {
                    countInt = [dict[@"number"] integerValue] + countInt;
                }
                success(data,2,countInt);
            }else if (params.online == nil && [params.alarm isEqualToString:@"1"]){//报警
                for (NSDictionary * dict in dataArr) {
                    countInt = [dict[@"number"] integerValue] + countInt;
                }
                success(data,3,countInt);
            }
        }
    } failure:nil showError:YES];
    
}

+(void)POSTDeviceListWithGroupId:(NSInteger)groupId params:(BYDeviceListHttpParams *)params success:(void (^)(id))success{
    
    NSMutableDictionary * httpParams = [NSMutableDictionary dictionary];
    httpParams[@"groupId"] = @(groupId);
    
    if (params.online) {
        httpParams[@"online"] = params.online;
    }
    
    if (params.deviceTypeIds) {
        NSString * typeStr = [params.deviceTypeIds componentsJoinedByString:@","];
        httpParams[@"deviceTypeIds"] = typeStr;
    }
    
    if (params.queryStr) {
        httpParams[@"queryStr"] = params.queryStr;
    }
    
    if (params.alarm) {
        httpParams[@"alarm"] = params.alarm;
    }
    [[BYNetworkHelper sharedInstance] POST:groupListUrl params:httpParams success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        
    } showError:YES];
}

+(void)POSTAllDeviceTypeSuccess:(void (^)(id))success{
    [[BYNetworkHelper sharedInstance] POST:allDeviceTypeUrl params:nil success:^(id data) {
        if (success) {
            
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dict in data) {
                BYDeviceTypeModel * model = [[BYDeviceTypeModel alloc] initWithDictionary:dict error:nil];
                model.isSelect = YES;
                [arr addObject:model];
            }
            
            success(arr);
        }
    } failure:nil showError:YES];
}

+(void)POSTQueryDeviceBySN:(NSString *)sn Success:(void (^)(id data))success
{
    NSMutableDictionary * httpParams = [NSMutableDictionary dictionary];
    httpParams[@"sn"] = sn;
    
    [[BYNetworkHelper sharedInstance] POST:queryDeviceBySnUrl params:httpParams success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:nil showError:YES];
}


@end
