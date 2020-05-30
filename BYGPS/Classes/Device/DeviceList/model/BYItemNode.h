//
//  BYItemNode.h
//  BYGPS
//
//  Created by miwer on 16/9/2.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBaseNode.h"

@interface BYItemNode : BYBaseNode

@property(nonatomic,strong) NSString * ownerName;//车主姓名
@property(nonatomic,assign) BOOL wifi;//是否无线 : 0 -> 有线,1 -> 无线
@property(nonatomic,strong) NSString * model;//设备类型

@property (nonatomic , strong) NSString *alias;

@property(nonatomic,strong) NSString * carNum;//车牌
@property (nonatomic,strong) NSString * carVin;
@property(nonatomic,strong) NSString * deviceId;
@property(nonatomic,strong) NSString * brand;//车牌
@property(nonatomic,strong) NSString * sn;
@property(nonatomic,assign) NSInteger property;// 1 -> 已装车  其他 -> 未装车
@property(nonatomic,strong) NSString * installTime;
@property(nonatomic,assign) CGFloat lon;
@property(nonatomic,assign) CGFloat lat;
@property(nonatomic,strong) NSString * online;
@property(nonatomic,strong) NSString * carStatus;
@property (nonatomic,assign) NSInteger carId;
@property(nonatomic,assign) NSInteger iconId;//(1离线,2报警,3启动怠速,4启动行驶,5熄火在线)
@property (nonatomic,strong) NSString *endDate;
@property (nonatomic,assign) BOOL expired;
@property (nonatomic,strong) NSString * batteryNotifier;//电量
//(1离线灰色 2在线不定位橙色 3在线行驶蓝色 4在线静止绿色 5报警红色)
@end
/*
 {
 "model": "013i",
 "lon": 0,
 "sn": "80206114609",
 "ownerName": "",
 "speed": 0,
 "property": 99,
 "online": "离线,",
 "parentId": 9001693,
 "wifi": "1",
 "alarm": 0,
 "carStatus": "",
 "carNum": "",
 "selfGroupId": 693,
 "showAlarm": 0,
 "brand": "",
 "alarmOrOff": 1,
 "deviceId": 108412,
 "lat": 0
 }
 */

