//
//  BYDeviceInfoModel.h
//  BYGPS
//
//  Created by miwer on 16/9/18.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BYDeviceInfoModel : JSONModel

@property(nonatomic,strong) NSString * batteryNotifier;
@property(nonatomic,strong) NSString * intervalTime;//发送间隔时间
@property(nonatomic,strong) NSString * sn;
@property(nonatomic,strong) NSString * groupName;
@property(nonatomic,strong) NSString * ownerName;
@property (nonatomic,strong) NSString * ownerTel;
@property(nonatomic,assign) CGFloat lon;
@property(nonatomic,assign) CGFloat lat;
@property(nonatomic,strong) NSString * model;
@property(nonatomic,strong) NSString * gpsTime;
@property(nonatomic,assign) CGFloat speed;
@property(nonatomic,strong) NSString * updateTime;
@property(nonatomic,strong) NSString * online;
@property(nonatomic,strong) NSString * carStatus;
@property(nonatomic,strong) NSString * carNum;

@property (nonatomic,strong) NSString *carVin;
@property (nonatomic,strong) NSString * gpsModel;
@property(nonatomic,assign) BOOL wifi;
@property(nonatomic,assign) NSInteger carId;//车辆ID
@property(nonatomic,assign) NSInteger deviceId;
@property (nonatomic,strong) NSString *adress;

@property(nonatomic,strong) NSString * brand;

@property(nonatomic,strong) NSString * beginDate;
@property(nonatomic,strong) NSString * endDate;
@property(nonatomic,assign) NSInteger totalSend;
@property(nonatomic,assign) NSInteger receiveCount;
@property (nonatomic,strong) NSString * salesman;
@property (nonatomic,assign) NSInteger showAlarm;
@property (nonatomic,assign) NSInteger isLocation;//在线是否定位:1:在线定位，2：在线不定位（GPS不定位，基站定位，基站不定位）
@property (nonatomic,strong) NSString *installTime;//装机时间 (格式yyyy-MM-dd HH:mm:ss)
@property (nonatomic,assign) BOOL isCcid;

@property (nonatomic,strong) NSString *carModel;
@property (nonatomic,strong) NSString *carGroupId;
@property (nonatomic,strong) NSString *carColor;
@property (nonatomic,strong) NSString *carType;
@property (nonatomic,strong) NSString *shareId;//分享id

///设备别名
@property (nonatomic , strong) NSString *alias;
///合同编号
@property (nonatomic,strong) NSString *contractNo;

@end

/*
 {
 
 "batteryNotifier": "0.00%",
 "sn": "864297600118803",
 "ownerName": "",
 "lon": 113.93817,
 "model": "015",
 "groupName": "015设备",
 "gpsTime": "2016-09-09 21:15:02",
 "speed": 0,
 "updateTime": "2016-09-09 21:15:03",
 "endDate": "2017-09-08 15:58:56",
 "beginDate": "2016-09-08 15:58:56",
 "totalSend": 0,
 "online": "报警,电路通",
 "wifi": 0,
 "carStatus": "熄火,油路通",
 "showAlarm": 1,
 "receiveCount": 52,
 "brand": "",
 "lat": 22.508219,
 "deviceId": 159200
 
 }
 
 "batteryNotifier": "78.5%",   剩余电量
 "sn": "864296200012077",    设备号
 "groupName": "雷佳平",        分组名
 "ownerName": "孟宪忠",        车主姓名
 "lon": 113.9385,              经度
 "model": "013",              设备类型
 "gpsTime": "2016-09-23 10:44:42",         最后定位时间
 "speed": 0,                           熟读
 "updateTime": "2016-09-23 11:17:46",         最好上传时间
 "endDate": "2017-05-16 00:00:00",              设备服务期结束时间
 "beginDate": "2016-05-17 18:08:49",           设备服务器开始时间
 "totalSend": 1200,                        （暂时无用）设备总发送条数
 "online": ‘’’’,                     设备状态String 在线，离线，报警
 "wifi": 1,                             0有线，1无线
 "carID": 125037,                        车辆ID
 "carStatus": "省电模式",                 车辆状态
 "carNum": "黑AB871H",				车牌
 "receiveCount": 258,                  已发送条数
 "brand": "日产",                      车品牌
 "lat": 22.5061,                         纬度
 "deviceId": 142834                          设备id
 " showAlarm    ": 1
 */
