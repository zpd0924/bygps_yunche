//
//  DeviceItem.h
//  父子控制器
//
//  Created by miwer on 2016/12/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <JSONModel.h>

@protocol DeviceItem <NSObject>

@end

@interface DeviceItem : JSONModel

//@property(nonatomic,assign) NSInteger deviceId;
//@property(nonatomic,assign) NSInteger deviceIdWeb;
//@property(nonatomic,assign) NSInteger deviceType;
@property(nonatomic,strong) NSString * sn;
@property(nonatomic,strong) NSString * model;
//@property(nonatomic,assign) BOOL wifi;
@property (nonatomic,strong) NSString * wireLess;
//@property(nonatomic,assign) BOOL statu;
//@property(nonatomic,assign) BOOL online;

@end

/*
"deviceId": 424, -------微信设备id
"deviceIdWeb": 46453, --------平台设备id
"deviceType": 23, --------设备类型id
"sn": "80201117167", ---------设备号码
"logs": 0,
"lats": 0,
"lon": 0,
"lat": 0,
"model": "011", -------设备类型
"wifi": 0,
"statu": true, ----
"online": false, -----在线
"speed": 0 ---速度
*/
