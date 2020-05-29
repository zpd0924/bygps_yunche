//
//  BYAlarmModel.h
//  BYGPS
//
//  Created by miwer on 16/9/13.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BYAlarmModel : JSONModel

@property(nonatomic,assign)BOOL isExpand;
@property(nonatomic,assign)BOOL isSelect;

@property(nonatomic,strong) NSString * alarmRemark;
@property(nonatomic,strong) NSString * deviceId;
@property(nonatomic,assign) NSInteger speed;
@property(nonatomic,assign) NSInteger alarmType;
@property(nonatomic,strong) NSString * nickName;//有名字 -> 已处理; 没名字 -> 未处理
@property(nonatomic,strong) NSString * alarmName;
//@property (nonatomic,strong) NSString *alarmTypeValue;
@property(nonatomic,strong) NSString * updateTime;
@property(nonatomic,assign) CGFloat lat;
@property(nonatomic,assign) CGFloat lon;
@property(nonatomic,assign) BOOL property;
@property(nonatomic,strong) NSString * carNum;
@property (nonatomic,strong) NSString *brand;
@property (nonatomic,strong) NSString *carType;
@property (nonatomic,strong) NSString *carVin;//车架号
@property(nonatomic,strong) NSString * alarmId;
@property(nonatomic,strong) NSString * gpsTime;
@property(nonatomic,assign) NSInteger zoneId;
@property(nonatomic,assign) NSInteger carId;
@property(nonatomic,assign) NSInteger flag;
@property(nonatomic,assign) NSInteger drection;
@property(nonatomic,assign) NSInteger processingResult;
@property(nonatomic,strong) NSString * createTime;
@property(nonatomic,strong) NSString * ownerName;
@property(nonatomic,strong) NSString * sn;
@property(nonatomic,strong) NSString * processingTime;
@property(nonatomic,strong) NSString * reviceTime;
@property(nonatomic,strong) NSString * groupName;
@property(nonatomic,strong) NSString * model;
@property (nonatomic,strong) NSString * alarmStatus;
@property(nonatomic,assign) BOOL wifi;
@property(nonatomic,strong) NSString * processingUserId;
@property (nonatomic,assign) BOOL expired;
@property (nonatomic,strong) NSString * batteryNotifier;//电量

@property (nonatomic,assign) CGFloat pop_H;


@property (nonatomic,strong) NSString *name;//围栏名
@property (nonatomic,strong) NSString *parameter;//中心点或多边形的点
@property (nonatomic,assign) NSInteger type;//围栏类别 1:圆,2:矩形，3:多边形，4:省
@property (nonatomic,assign) NSInteger inorout;//1出围栏 2 入围栏 3出省
@property (nonatomic,assign) double radius;//圆形围栏半径
@property (nonatomic,strong) NSString *centerLat;//多边形中心点经度
@property (nonatomic,strong) NSString *centerLon;//多边形中心点纬度
@property (nonatomic,assign) BOOL isGps;//是否为GPS

@property (nonatomic,assign) NSString *distance;//距离
@end

/*
 {
 "AlarmRemark": "",
 "DeviceID": "159152",
 "speed": 0,
 "AlarmType": 7,
 "NickName": "",
 "AlarmName": "电子围栏报警",
 "UpdateTime": "2016-09-13 18:18:08.0",
 "Lat": 22.5095,
 "Property": 1,
 "CarNum": "粤AA1234",
 "AlarmID": "40464813",
 "GpsTime": "2016-09-13 18:17:11.0",
 "zoneId": 422,
 "Lng": 113.939,
 "CarId": "140654",
 "flag": 2,
 "Drection": 0,
 "processingResult": "",
 "CreateTime": "2016-09-13 18:18:08",
 "ProcessingTime": "",
 "OwnerName": "安装test"
 }
 */
