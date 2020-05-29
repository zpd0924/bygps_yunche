//
//  BYAppointmentDeviceModel.h
//  BYGPS
//
//  Created by miwer on 2017/2/9.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BYAppointmentDeviceModel : JSONModel

@property(nonatomic,assign) BOOL isSelect;

@property(nonatomic,strong) NSString * carId;
@property(nonatomic,strong) NSString * model;
@property(nonatomic,assign) BOOL wifi;
@property(nonatomic,strong) NSString * sn;
@property(nonatomic,strong) NSString * ownerName;
@property(nonatomic,strong) NSString * carNum;
@property(nonatomic,strong) NSString * deviceID;
@property(nonatomic,assign) BOOL subscribe;
@property (nonatomic,strong) NSString * carVin;

@end

/*
 "carId": "100890",
 "model": "008+",
 "wifi": "0",
 "sn": "80201111570",
 "ownerName": "余威",
 "carNum": "鄂ANC115",
 "deviceID": "2",
 "subscribe":false 是否已经提交预约
 */
