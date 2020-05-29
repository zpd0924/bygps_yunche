//
//  BYMonitorHttpTool.m
//  BYGPS
//
//  Created by ZPD on 2017/11/8.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYMonitorHttpTool.h"
#import "BYNetworkHelper.h"

static NSString * const getDeviceStatusUrl = @"monitor/getDeviceStatus";
static NSString * const getShareDeviceStatusUrl = @"monitor/getShareDeviceStatus";//分享列表进入调用
static NSString * const realTrackingUrl = @"monitor/realTimeTracking";

@implementation BYMonitorHttpTool


+(void)POSTMonitorDeviceStatusWithPragrams:(NSMutableDictionary *)params isShare:(int)isShare success:(void (^)(id))success failure:(void (^)(NSError *))failure showError:(BOOL)showError 
{
    [[BYNetworkHelper sharedInstance] POST:isShare?getShareDeviceStatusUrl:getDeviceStatusUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:showError];
}

+(void)POSTMonitorRealTimeTrackingWithParams:(NSMutableDictionary *)params success:(void(^)(id))success failure:(void(^)(NSError *))failure showError:(BOOL)showError{
    [[BYNetworkHelper sharedInstance] POST:realTrackingUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:showError];
}

@end
