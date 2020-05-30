//
//  BYAutoServiceHttpTool.m
//  BYGPS
//
//  Created by ZPD on 2018/12/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceHttpTool.h"
#import "BYNetworkHelper.h"

///搜索车辆
static NSString * const BYQuickCarByCarQ = @"api/car/quickCarByCarQ";

///车辆已装设备列表
static NSString * const BYQuickOrderGetCarDevice = @"api/quick/order/getCarDevice";

///自助拆信息提交
static NSString * const BYQuickRemoveCommitUrl = @"api/quick/order/quickRemove";

///自助检修信息提交
static NSString * const BYQuickRepairCommitUrl = @"api/quick/order/quickRepair";

///自助搜索设备查询
static NSString * const BYQuichRepairDeviceSearchUrl = @"api/quick/order/pageDevice";

///设备查询
static NSString * const BYQuickDeviceCheckUrl = @"api/technician/device/quickDeviceCheck";

///查看示意图api/appoint/order/installConfirm
static NSString * const BYQuickInstallConfirmUrl = @"api/appoint/order/installConfirm";

///查看安装图片 api/quick/order/showInstallImg
static NSString * const BYQuickShowInstallImgUrl = @"api/quick/order/showInstallImg";

///检测是否重装或替换设备 api/common/groupControl
static NSString * const BYQuickGroupControlUrl = @"api/common/groupControl";

///检测是否在派单 api/quick/order/checkIsSendOrder
static NSString * const BYQuickCheckIsSendOrderUrl = @"api/quick/order/checkIsSendOrder";

///检测是否可以拆机 api/quick/order/checkIsRemove
static NSString * const BYQuickCheckIsRemoveUrl = @"api/quick/order/checkIsRemove";




@implementation BYAutoServiceHttpTool


+(void)POSTQuickCarByCarQParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [[BYNetworkHelper sharedInstance] POST:BYQuickCarByCarQ params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}

+(void)POSTQuickOrderGetCarDeviceWithCarId:(NSString *)carId success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:carId forKey:@"carId"];
    
    [[BYNetworkHelper sharedInstance] POST:BYQuickOrderGetCarDevice params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}

///自助拆机信息提交
+(void)POSTQuickRemoveCommitWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYQuickRemoveCommitUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

///自助检修提交
+(void)POSTQuickRepairCommitWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [[BYNetworkHelper sharedInstance] POST:BYQuickRepairCommitUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

///自助检修获取设备 模糊查询
+(void)POSTQuickRepairDeviceSearchWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYQuichRepairDeviceSearchUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

///设备检测
+(void)POSTQuickDeviceCheckWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [[BYNetworkHelper sharedInstance] POST:BYQuickDeviceCheckUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];

}


///查看示意图api/appoint/order/installConfirm
+(void)POSTQuickInstallConfirmWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [[BYNetworkHelper sharedInstance] POST:BYQuickInstallConfirmUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

///查看安装图片 api/quick/order/showInstallImg
+(void)POSTQuickShowInstallImgWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [[BYNetworkHelper sharedInstance] POST:BYQuickShowInstallImgUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}


///检测是否重装或替换设备 api/common/groupControl
+(void)POSTQuickGroupControlWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [[BYNetworkHelper sharedInstance] POST:BYQuickGroupControlUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

///检测是否在派单 api/quick/order/checkIsSendOrder
+(void)POSTQuickCheckIsSendOrderWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [[BYNetworkHelper sharedInstance] POST:BYQuickCheckIsSendOrderUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

///检测是否可以拆机 api/quick/order/checkIsRemove
+(void)POSTQuickCheckIsRemoveWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [[BYNetworkHelper sharedInstance] POST:BYQuickCheckIsRemoveUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

@end
