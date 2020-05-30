//
//  BYAutoServiceHttpTool.h
//  BYGPS
//
//  Created by ZPD on 2018/12/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYAutoServiceHttpTool : NSObject

#pragma mark --自助拆检修

///自助拆修搜索接口
+(void)POSTQuickCarByCarQParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;


///获取车辆已装设备列表
+(void)POSTQuickOrderGetCarDeviceWithCarId:(NSString *)carId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

///自助拆机信息提交
+(void)POSTQuickRemoveCommitWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;


///自助检修提交
+(void)POSTQuickRepairCommitWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

///自助检修获取设备 模糊查询
+(void)POSTQuickRepairDeviceSearchWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

///设备检测
+(void)POSTQuickDeviceCheckWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

///查看示意图api/appoint/order/installConfirm
+(void)POSTQuickInstallConfirmWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

///查看安装图片 api/quick/order/showInstallImg
+(void)POSTQuickShowInstallImgWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;


///检测是否重装或替换设备 api/common/groupControl
+(void)POSTQuickGroupControlWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

///检测是否在派单 api/quick/order/checkIsSendOrder
+(void)POSTQuickCheckIsSendOrderWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

///检测是否可以拆机 api/quick/order/checkIsRemove
+(void)POSTQuickCheckIsRemoveWithParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

@end
