//
//  BYHomeHttpTool.m
//  BYGPS
//
//  Created by miwer on 16/8/30.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYHomeHttpTool.h"
#import "BYNetworkHelper.h"
#import "BYUploadCurrentVersion.h"

static NSString * const statusCountUrl = @"devices/countNumber";
static NSString * const alarmCountUrl = @"alarm/statisticsAlarm";
static NSString * const unreadCountUrl = @"monAlarm/setCornerMark";
static NSString * const statisticsHomeUrl = @"homePage/statisticsHomePage";



@implementation BYHomeHttpTool

+(void)GETUnreadCountWith:(NSInteger)count success:(void (^)(id data))success{
    
    NSMutableDictionary * httpParams = [NSMutableDictionary dictionary];
    httpParams[@"count"] = @(count);
    
    [[BYNetworkHelper sharedInstance] GET:unreadCountUrl params:httpParams success:^(id data) {
        
        if (success) {
            success(data);
        }
        
    } failure:nil showHUD:NO showError:NO];
}

+(void)POSTHomeStatusCountSuccess:(void (^)(id data))success isShowFlower:(BOOL)isShowFlower{
    [[BYNetworkHelper sharedInstance] POST:statusCountUrl params:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:nil showError:NO];
//    [[BYNetworkHelper sharedInstance] GET:statusCountUrl params:nil success:^(id data) {
//
//        if (success) {
//            success(data);
//        }
//
//    } failure:nil showHUD:isShowFlower showError:NO];
}

+(void)POSTHomeRingChartCountSuccess:(void (^)(id))success isShowFlower:(BOOL)showFlower
{
    [[BYNetworkHelper sharedInstance] POST:statisticsHomeUrl params:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:nil showError:NO];
}

+(void)POSTHomeAlarmCountSuccess:(void (^)(id data))success{

//    NSMutableDictionary * httpParams = [NSMutableDictionary dictionary];
    
//    httpParams[@"version"] = BYLocalVersion;
    [[BYNetworkHelper sharedInstance] POST:alarmCountUrl params:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        
    } showError:NO];
//    [[BYNetworkHelper sharedInstance] GET:alarmCountUrl params:nil success:^(id data) {
//
//        if (success) {
//            success(data);
//        }
//
//    } failure:nil showHUD:NO showError:NO];
}

+(void)cancelOperation{
    BYNetworkHelper * helper = [BYNetworkHelper sharedInstance];
//    BYLog(@"taskArr : %@",helper.taskArr);
    for (NSURLSessionTask * task in helper.taskArr) {

        [task cancel];
    }
}


//    [helper.manager invalidateSessionCancelingTasks:YES];//manager 再也不可用发请求了
//    [helper.manager.tasks makeObjectsPerformSelector:@selector(cancel)];//// 取消之前的所有请求
//    [helper.task cancel];
@end
