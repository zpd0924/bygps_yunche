//
//  BYInstallDemolishHttpTool.m
//  BYGPS
//
//  Created by miwer on 2017/2/8.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYInstallDemolishHttpTool.h"
#import "BYNetworkHelper.h"
#import "BYReceivingModel.h"
#import "BYAppointmentDeviceModel.h"
#import "BYDemolishDeviceModel.h"
#import "BYSubmitAppontmentParams.h"
#import "BYInstallModel.h"
#import "BYPhotoModel.h"

static NSString * const loadUsernameByCarNumUrl = @"weixin/findDevice";//根据车牌获取车辆信息
static NSString * const findDeviceForShareUrl = @"share/findDeviceForShare";//根据车牌id获取车辆信息
static NSString * const loadOrderListUrl = @"weixin/findOrders";//以接列表和未接列表
static NSString * const changeOrderUrl = @"weixin/changeOrder";//取消订单(微信接口)// 确认回收//提醒接单
static NSString * const appointmentLoadDevicesByCarNumUrl = @"weixin/findDevice";//预约通过车牌查询底下的设备
static NSString * const submitAppointmentUrl = @"weixin/submitConvention";//提交预约
static NSString * const demolishLoadDevicesByCarNumUrl = @"device/queryInstall";//拆机根据carId取设备
static NSString * const demolishSureUrl = @"device/demolition";//确认拆机
static NSString * const uploadInstallInfoUrl = @"device/install";

@implementation BYInstallDemolishHttpTool

+(void)POSTUploadInstallInfoWith:(NSInteger)deviceId infoArr:(NSMutableArray *)infoArr images:(NSMutableArray *)images success:(void (^)(id data))success{
    
    NSMutableDictionary * httpParams = [NSMutableDictionary dictionary];
    
    httpParams[@"deviceId"] = @(deviceId);
    //遍历上传信息数组,组成字典模型
    for (BYInstallModel * model in infoArr) {
        httpParams[model.postKey] = model.subTitle;
    }

    BYPhotoModel *model = images.firstObject;
    httpParams[@"deviceCarNumImg"] = model.imageAddress;
    
    BYPhotoModel *model1 = images[1];
    httpParams[@"connectionIntallImg"] = model1.imageAddress;
    //    //上传多张图片
        NSArray * imageNames = @[@"imgA",@"imgB",@"imgC",@"imgD"];
    for (NSInteger i = 2; i < images.count; i++) {
        BYPhotoModel *modelTest = images[i];
        httpParams[imageNames[i - 2]] = modelTest.imageAddress;
    }
    
    [[BYNetworkHelper sharedInstance] POST:uploadInstallInfoUrl params:httpParams success:^(id data) {
        [BYProgressHUD by_dismiss];
        if (success) {
            success(data);
        }
    } failure:nil showError:YES];
}

+(void)POSTLoadUsernameByCarNum:(NSString *)carNum success:(void (^)(id data))success showError:(BOOL)showError{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    params[@"carNum"] = [carNum stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    params[@"carNumOrCarVin"] = carNum;
    [[BYNetworkHelper sharedInstance] POST:loadUsernameByCarNumUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        
    } showError:showError];
}

+(void)POSTLoadUsernameByCarNum1:(NSInteger)carId success:(void (^)(id data))success showError:(BOOL)showError{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //    params[@"carNum"] = [carNum stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    params[@"carId"] = @(carId);
    [[BYNetworkHelper sharedInstance] POST:findDeviceForShareUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        
    } showError:showError];
}
//orderStatuses : 1：待抢单，2：已抢单，3：取消的订单，4已完成的订单’（多个逗号隔开）
+(void)POSTLoadOrderListWithStatus:(NSString *)orderStatuses page:(NSInteger)page success:(void (^)(NSMutableArray * array))success failure:(void(^)(NSError *error))failure{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
//    params[@"weinxinUserId"] = [BYSaveTool valueForKey:weixinUserIdKey] == nil ? @(0) : [BYSaveTool valueForKey:weixinUserIdKey];
    params[@"currentPage"] = @(page);
    params[@"showCount"] = @20;
    params[@"status"] = orderStatuses;
    
    [[BYNetworkHelper sharedInstance] POST:loadOrderListUrl params:params success:^(id data) {
        NSMutableArray * tempArr = [NSMutableArray array];
        for (NSDictionary * dict in data) {
            BYReceivingModel * model = [[BYReceivingModel alloc] initWithDictionary:dict error:nil];
            [tempArr addObject:model];
        }
        
        if (success) {
            success(tempArr);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

+(void)POSTOrderHandleWithType:(BYDemolishOrderHandleType)handleType orderId:(NSInteger)orderId success:(void (^)(id data))success{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    1：取消订单 2:确认回收,3:提醒
    switch (handleType) {
        case BYDemolishOrderSure: params[@"type"] = @(2); break;
        case BYDemolishOrderRemind: params[@"type"] = @(3); break;
        case BYDemolishOrderCancel: params[@"type"] = @(1); break;
        default: break;
    }
    
    
    params[@"orderId"] = @(orderId);
    
    [[BYNetworkHelper sharedInstance] POST:changeOrderUrl params:params success:^(id data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * successMsg = nil;
            switch (handleType) {
                case BYDemolishOrderRemind: successMsg = @"提醒成功"; break;
                case BYDemolishOrderCancel: successMsg = @"取消成功"; break;
                case BYDemolishOrderSure: successMsg = @"回收成功"; break;
            }
            [BYProgressHUD by_showSuccessWithStatus:successMsg];
        });
        
        if (success) {
            success(data);
        }
        
    } failure:nil showError:YES];
}

+(void)POSTAppointmentLoadDevicesByCarNum:(NSString *)carNum success:(void (^)(id data))success{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"carNumOrCarVin"] = carNum;
    
    [[BYNetworkHelper sharedInstance] POST:appointmentLoadDevicesByCarNumUrl params:params success:^(id data) {
        NSMutableArray * tempArr = [NSMutableArray array];
        for (NSDictionary * dict in data) {
            BYAppointmentDeviceModel * model = [[BYAppointmentDeviceModel alloc] init];
            model.sn = dict[@"sn"];
            model.deviceID = dict[@"deviceId"];
            model.wifi = [dict[@"wifi"] boolValue];
            model.model = dict[@"model"];
            model.carVin = dict[@"carVin"];
            model.carNum = dict[@"carNum"];
            model.ownerName = dict[@"ownerName"];
            model.isSelect = YES;
            [tempArr addObject:model];
        }
        
        if (success) {
            success(tempArr);
        }
    } failure:^(NSError *error) {
        
    } showError:YES];
}

+(void)POSTDemolishLoadDevicesByCarNum:(NSInteger)carId success:(void (^)(id data))success{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"carId"] = @(carId);
    
    [[BYNetworkHelper sharedInstance] POST:demolishLoadDevicesByCarNumUrl params:params success:^(id data) {
        BYLog(@"%@",data);
        NSMutableArray * tempArr = [NSMutableArray array];
        for (NSDictionary * dict in data) {
            BYDemolishDeviceModel * model = [[BYDemolishDeviceModel alloc] initWithDictionary:dict error:nil];
            
            model.isSelect = YES;
            [tempArr addObject:model];
        }
        
        if (success) {
            success(tempArr);
        }
    } failure:^(NSError *error) {
        
    } showError:YES];
}

+(void)POSTSubmitAppointmentWith:(BYSubmitAppontmentParams *)params success:(void (^)(id data))success{
    
    NSMutableDictionary * httpParams = [NSMutableDictionary dictionary];
    
    httpParams[@"keyKeeper"] = params.keyKeeper;
    httpParams[@"keeperIphone"] = params.keeperIphone;
    httpParams[@"carPlace"] = params.carPlace;
    httpParams[@"carVin"] = params.carVin;
    httpParams[@"reason"] = @(params.reason);
    httpParams[@"carNum"] = params.carNum;
    httpParams[@"ownerName"] = params.ownerName;
    
    NSInteger i = 0;
    for (BYAppointmentDeviceModel *model in params.deviceModel) {
        
        httpParams[[NSString stringWithFormat:@"orderDetails[%zd].deviceId",i]] = model.deviceID;
        httpParams[[NSString stringWithFormat:@"orderDetails[%zd].wifi",i]] = @(model.wifi);
        httpParams[[NSString stringWithFormat:@"orderDetails[%zd].model",i]] = model.model;
        httpParams[[NSString stringWithFormat:@"orderDetails[%zd].sn",i]] = model.sn;
        i++;
    }
    
    [[BYNetworkHelper sharedInstance] POST:submitAppointmentUrl params:httpParams success:^(id data) {
        
        if (success) {
            success(data);
        }
        
        [BYProgressHUD by_showSuccessWithStatus:@"预约成功"];
        
    } failure:nil showError:YES];
}

+(void)POSTDemolishSureWith:(NSMutableDictionary *)params success:(void (^)(id data))success{
    
    [[BYNetworkHelper sharedInstance] POST:demolishSureUrl params:params success:^(id data) {
        
        if (success) {
            success(data);
        }
        
    } failure:nil showError:NO];
}

@end
