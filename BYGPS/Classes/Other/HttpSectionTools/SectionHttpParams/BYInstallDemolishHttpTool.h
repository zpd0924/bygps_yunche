//
//  BYInstallDemolishHttpTool.h
//  BYGPS
//
//  Created by miwer on 2017/2/8.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYSubmitAppontmentParams;

@interface BYInstallDemolishHttpTool : NSObject

typedef enum {
    
    BYDemolishOrderCancel,
    BYDemolishOrderSure,
    BYDemolishOrderRemind
    
}BYDemolishOrderHandleType;

+(void)POSTLoadUsernameByCarNum:(NSString *)carNum success:(void (^)(id data))success showError:(BOOL)showError;
+(void)POSTLoadUsernameByCarNum1:(NSInteger)carId success:(void (^)(id data))success showError:(BOOL)showError;
+(void)POSTLoadOrderListWithStatus:(NSString *)orderStatuses page:(NSInteger)page success:(void (^)(NSMutableArray * array))success failure:(void(^)(NSError *error))failure;

+(void)POSTOrderHandleWithType:(BYDemolishOrderHandleType)handleType orderId:(NSInteger)orderId success:(void (^)(id data))success;

+(void)POSTAppointmentLoadDevicesByCarNum:(NSString *)carNum success:(void (^)(id data))success;//拆机预约中通过车牌来请求设备

+(void)POSTDemolishLoadDevicesByCarNum:(NSInteger)carId success:(void (^)(id data))success;//拆机中通过carId来请求设备

+(void)POSTSubmitAppointmentWith:(BYSubmitAppontmentParams *)params success:(void (^)(id data))success;

+(void)POSTDemolishSureWith:(NSMutableDictionary *)params success:(void (^)(id data))success;

+(void)POSTUploadInstallInfoWith:(NSInteger)deviceId infoArr:(NSMutableArray *)infoArr images:(NSMutableArray *)images success:(void (^)(id data))success;

@end
