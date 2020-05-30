//
//  BYSendWorkHttpTool.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/19.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BYSendWorkHttpTool : NSObject
///常用联系人接口
+(void)POSTHotContactPersonParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
///技师查询
+(void)POSTTechnicianParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
///查询工单数量
+(void)POSTAppointOrderCountParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
///工单列表
+(void)POSTOrderListParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
///评价接口
+(void)POSTevaluateParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
///评价列表接口
+(void)POSTevaluateListParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///工单推送接口
+(void)POSPushSetParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///工单推送查询接口
+(void)POSLookPushParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///装机 拆机 检修 详情
+(void)POSSendOrderDetailParams:(NSMutableDictionary *)params sendOrderType:(NSInteger)sendOrderType success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///审核接口
+(void)POSSauditingParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///撤回工单接口
+(void)POSTCannelOrderParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///安装确认单接口
+(void)POSTInstallConfirmOrderParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///检修设备详情查询
+(void)POSTRepairSnDetailParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///新增车辆
+(void)POSTAddCarParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///编辑车辆
+(void)POSTEditCarParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///车架/车牌号查询接口
+(void)POSTSearchCarByNumOrVinParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///车辆查询列表接口
+(void)POSTqueryCarListParams:(NSMutableDictionary *)params sendOrderType:(NSInteger)sendOrderType success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///省份获取接口
+(void)POSTGetProvinceParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///城市获取接口
+(void)POSTGetCityParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///区获取接口
+(void)POSTGetAreaParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///新增安装 检修 拆机 派单接口
+(void)POSTAddInstallWorkParams:(NSMutableDictionary *)params sendOrderType:(NSInteger)sendOrderType success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;


///安装 拆机 检修 派单编辑接口
+(void)POSTEditInstallWorkParams:(NSMutableDictionary *)params sendOrderType:(NSInteger)sendOrderType success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

///车辆设备查询接口
+(void)POSTDeviceByCarParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///请求品牌
+(void)POSTCarBrandParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
/// 请求车系
+(void)POSTCarSetParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///请求车详细信息
+(void)POSTCarInfoParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///识别车牌号和车架号
+(void)POSCarNumberOrVinParams:(NSMutableDictionary *)params withImage:(NSData *)data success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///是否在派单接口
+(void)POSTIsSendWorkParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///所属分组列表
+(void)POSTGroupTreesParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///查看装机图片
+(void)POSTCheckInstallImgParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///审核工单SN定位查询
+(void)POSTQueryListLocationParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///车辆设备查询接口
///车辆设备查询
+(void)POSTGetDeviceByCarParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///OSS签名
+(void)POSTOssSignParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

#pragma mark *********************快速安装******************************
///设备检测
+(void)POSTDeviceCheckParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///查询公司是否需要输入VIN接口
+(void)POSTCheckCarUniquePropertyParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///快速安装校验是否在派单
+(void)POSTAutoCheckIsSendOrderParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///快速查询车辆信息
+(void)POSTAutoQuickGetCarParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///快速安装记录
+(void)POSTAutoQuickOrderListParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///校验车牌号
+(void)POSTAutoCheckCarNumParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

///快速安装
+(void)POSTAutoInstallParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///获取三址信息
+(void)POSTGetSzSameParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

@end
