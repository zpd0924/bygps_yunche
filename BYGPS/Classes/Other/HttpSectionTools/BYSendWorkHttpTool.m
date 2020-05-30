//
//  BYSendWorkHttpTool.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/19.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYSendWorkHttpTool.h"
#import "BYNetworkHelper.h"

static NSString * const BYHotContactPerson = @"api/appoint/hotContactPerson/list";//常用联系人接口
static NSString * const BYTechnician = @"api/technician/queryList";//技师查询接口
static NSString * const BYAppointOrderCount = @"api/appoint/order/myOrder";//查询工单数量
static NSString * const BYListOrder = @"api/appoint/order/listOrder";//工单列表、我的工单接口

static NSString * const BYOrderEvaluate = @"api/technician/comment/evaluate";//工单评价
static NSString * const BYOrderEvaluateList = @"api/technician/comment/evaluate/list";//评价列表接口
static NSString * const BYOrderPushSet = @"api/technician/updatePushConfig";//更新工单推送接口
static NSString * const BYLookPush = @"api/technician/findPushConfig";//查询工单推送接口
static NSString * const BYInstallDetail = @"api/appoint/order/installDetail";//装机单详情接口
static NSString * const BYRemoveDetail = @"api/appoint/order/removeDetail";//拆机单详情接口
static NSString * const BYRepairDetail = @"api/appoint/order/repairDetail";//检修单详情接口
static NSString * const BYOrderAuditing = @"api/appoint/order/auditing";//审核接口
static NSString * const BYOrderCannel = @"api/appoint/order/cancel";//撤回接口
static NSString * const BYOrderInstallConfirm = @"api/appoint/order/installConfirm";//安装确认单接口
static NSString * const BYRepairSnDetail = @"api/appoint/order/repairSnDetail";//检修设备详情查询接口
static NSString * const BYAddCar = @"api/car/addCar";//新增车辆接口
static NSString * const BYEditCar = @"api/car/editCar";//新增车辆接口
static NSString * const BYSearchCarByNumOrVin = @"api/car/getCarByCarQ";//车架/车牌号查询接口
static NSString * const BYSearchInstallByNumOrVin = @"api/car/getInstallCarByCarQ";//车架/车牌号查询接口 安装派单

static NSString * const BYQueryCarList = @"api/car/queryCarList";//车辆查询列表接口
static NSString * const BYGetProvince = @"api/common/getProvince";//省份获取接口
static NSString * const BYGetCity = @"api/common/getCity";//城市获取接口
static NSString * const BYGetArea = @"api/common/getArea";//区获取接口
static NSString * const BYAddInstallWork = @"api/appoint/order/install";//新增安装派单接口
static NSString * const BYAddRepairWork = @"api/appoint/order/repair";//新增检修单接口
static NSString * const BYAddRemoveWork = @"api/appoint/order/remove";//新增拆机单接口

static NSString * const BYEditInstallWork = @"api/appoint/order/installEdit";//编辑安装派单接口
static NSString * const BYEditRepairWork = @"api/appoint/order/repairEdit";//编辑检修单接口
static NSString * const BYEditRemoveWork = @"api/appoint/order/removeEdit";//编辑拆机单接口
static NSString * const BYDeviceByCar = @"api/appoint/order/getDeviceByCar";//车辆设备查询接口
static NSString * const BYGetStatus = @"api/appoint/order/getStatus";//是否在派单接口
static NSString * const BYGroupTrees = @"api/common/groupTrees";//所属分组列表接口

static NSString * const BYCarBrand = @"api/common/carBrand";//汽车品牌
static NSString * const BYCarSet = @"api/common/carType";//汽车系列
static NSString * const BYCarInfo = @"api/common/carModel";//汽车详细信息
static NSString * const BYCheckInstallImg = @"api/appoint/order/checkInstallImg";//查看装机照片接口
static NSString * const BYRecognitionImg = @"api/technician/recognitionImgs";//车牌号/车架号识别
static NSString * const BYQueryListLocation = @"api/appoint/order/queryListLocation";//审核工单SN定位查询
static NSString * const BYGetDeviceByCar = @"api/appoint/order/getDeviceByCar";//车辆设备查询接口
static NSString * const BYOssSign = @"api/service/osssign";//oss签名

static NSString * const BYDeviceCheck = @"api/technician/device/quickDeviceCheck";//设备检测
static NSString * const BYGetCheckCarUniqueProperty = @"api/quick/order/getCheckCarUniqueProperty";//查询公司是否输入VIN接口
static NSString * const BYAutoCheckIsSendOrder = @"api/quick/order/checkIsSendOrder";//校验是否在派单
static NSString * const BYAutoQuickGetCar = @"api/car/quickGetCar";//检查快速车辆查询
static NSString * const BYAutoQuickOrderList = @"api/quick/order/quickOrderList";//安装记录接口
static NSString * const BYAutoCheckCarNum = @"api/car/checkCarNum";//校验车牌号
static NSString * const BYAutoQuickInstallUrl = @"api/quick/order/quickInstall";//快速安装记录接口
static NSString * const BYGetSzSamelUrl = @"api/appoint/order/getSzSame";//快速安装记录接口


@implementation BYSendWorkHttpTool

+(void)POSTHotContactPersonParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
  
    [[BYNetworkHelper sharedInstance] POST:BYHotContactPerson params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];

}
///技师查询
+(void)POSTTechnicianParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[BYNetworkHelper sharedInstance] POST:BYTechnician params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///查询工单数量
+(void)POSTAppointOrderCountParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[BYNetworkHelper sharedInstance] POST:BYAppointOrderCount params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///工单列表
+(void)POSTOrderListParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[BYNetworkHelper sharedInstance] POST:BYListOrder params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///评价接口
+(void)POSTevaluateParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[BYNetworkHelper sharedInstance] POST:BYOrderEvaluate params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///评价列表接口
+(void)POSTevaluateListParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYOrderEvaluateList params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///工单推送接口
+(void)POSPushSetParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYOrderPushSet params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///工单推送查询接口
+(void)POSLookPushParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYLookPush params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///装机 拆机 检修 详情
+(void)POSSendOrderDetailParams:(NSMutableDictionary *)params sendOrderType:(NSInteger)sendOrderType success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    NSString *url = nil;
    switch (sendOrderType) {
        case 0://装机
            url = BYInstallDetail;
            break;
        case 1://拆机
            url = BYRemoveDetail;
            break;
        default://检修
            url = BYRepairDetail;
            break;
    }
    [[BYNetworkHelper sharedInstance] POST:url params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///审核接口
+(void)POSSauditingParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYOrderAuditing params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///撤回工单接口
+(void)POSTCannelOrderParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYOrderCannel params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///安装确认单接口
+(void)POSTInstallConfirmOrderParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYOrderInstallConfirm params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///检修设备详情查询
+(void)POSTRepairSnDetailParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYRepairSnDetail params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///新增车辆
+(void)POSTAddCarParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYAddCar params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///编辑车辆
+(void)POSTEditCarParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYEditCar params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///车架/车牌号查询接口
+(void)POSTSearchCarByNumOrVinParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYSearchCarByNumOrVin params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///车辆查询列表接口
+(void)POSTqueryCarListParams:(NSMutableDictionary *)params sendOrderType:(NSInteger)sendOrderType success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    NSString *url = nil;
    switch (sendOrderType) {
        case 0://装机
            url = BYSearchInstallByNumOrVin;
            break;
        case 1://拆机
            url = BYSearchCarByNumOrVin;
            break;
        default://检修
            url = BYSearchCarByNumOrVin;
            break;
    }
    [[BYNetworkHelper sharedInstance] POST:url params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///省份获取接口
+(void)POSTGetProvinceParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYGetProvince params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///城市获取接口
+(void)POSTGetCityParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYGetCity params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///区获取接口
+(void)POSTGetAreaParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYGetArea params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

///新增安装 检修 拆机 派单接口
+(void)POSTAddInstallWorkParams:(NSMutableDictionary *)params sendOrderType:(NSInteger)sendOrderType success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    NSString *url = nil;
    switch (sendOrderType) {
        case 0://装机
            url = BYAddInstallWork;
            break;
        case 1://拆机
            url = BYAddRemoveWork;
            break;
        default://检修
            url = BYAddRepairWork;
            break;
    }
    [[BYNetworkHelper sharedInstance] POST:url params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}



///安装派单 检修 拆机 编辑接口
+(void)POSTEditInstallWorkParams:(NSMutableDictionary *)params sendOrderType:(NSInteger)sendOrderType success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    NSString *url = nil;
    switch (sendOrderType) {
        case 0://装机
            url = BYEditInstallWork;
            break;
        case 1://拆机
            url = BYEditRemoveWork;
            break;
        default://检修
            url = BYEditRepairWork;
            break;
    }
    [[BYNetworkHelper sharedInstance] POST:url params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}


///车辆设备查询接口
+(void)POSTDeviceByCarParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYDeviceByCar params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///请求品牌
+(void)POSTCarBrandParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{

    [[BYNetworkHelper sharedInstance] POST:BYCarBrand params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
/// 请求车系
+(void)POSTCarSetParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYCarSet params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///请求车详细信息
+(void)POSTCarInfoParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYCarInfo params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///识别车牌号和车架号
+(void)POSCarNumberOrVinParams:(NSMutableDictionary *)params withImage:(NSData *)data success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{

    params[@"token"] = [BYSaveTool objectForKey:BYToken];
    [[BYNetworkHelper sharedInstance] POSTCarNumerOrVin:data params:params success:^(id data) {
        if (success) {
            success(data); 
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showHUD:YES showError:YES];
    
}

///是否在派单接口
+(void)POSTIsSendWorkParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYGetStatus params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

///所属分组列表
+(void)POSTGroupTreesParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYGroupTrees params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

///查看装机图片
+(void)POSTCheckInstallImgParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYCheckInstallImg params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

///审核工单SN定位查询
+(void)POSTQueryListLocationParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYQueryListLocation params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///车辆设备查询
+(void)POSTGetDeviceByCarParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYQueryListLocation params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

///OSS签名
+(void)POSTOssSignParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [[BYNetworkHelper sharedInstance] POST:BYOssSign params:params success:^(id data) {
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
+(void)POSTDeviceCheckParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYDeviceCheck params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///查询公司是否需要输入VIN接口
+(void)POSTCheckCarUniquePropertyParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYGetCheckCarUniqueProperty params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///快速安装校验是否在派单
+(void)POSTAutoCheckIsSendOrderParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYAutoCheckIsSendOrder params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///快速查询车辆信息
+(void)POSTAutoQuickGetCarParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYAutoQuickGetCar params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///快速安装记录
+(void)POSTAutoQuickOrderListParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYAutoQuickOrderList params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}
///校验车牌号
+(void)POSTAutoCheckCarNumParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYAutoCheckCarNum params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

///快速安装
+(void)POSTAutoInstallParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    [[BYNetworkHelper sharedInstance] POST:BYAutoQuickInstallUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

///获取三址信息
+(void)POSTGetSzSameParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    
    [[BYNetworkHelper sharedInstance] POST:BYGetSzSamelUrl params:params success:^(id data) {
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
