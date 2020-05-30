//
//  BYInstallDeviceCheckModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/9/7.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYInstallDeviceCheckModel : NSObject
///设备号
@property (nonatomic,strong) NSString *deviceSn;
///设备所在组
@property (nonatomic,strong) NSString *group;
///设备所在组id
@property (nonatomic,assign) NSInteger groupId;
///设备类型 0有线 1无线 3其他设备
@property (nonatomic,assign) NSInteger deviceType;
///设备状态 1=可以安装,2=不可安装
@property (nonatomic,assign) NSInteger deviceStatus;
///1=在线,0=离线
@property (nonatomic,assign) NSInteger online;
///设备状态描述
@property (nonatomic,strong) NSString *deviceStatusLabel;
///设备型号
@property (nonatomic,strong) NSString *deviceModel;
///设备型号别名
@property (nonatomic , strong) NSString *alias;

///最后定位时间
@property (nonatomic,strong) NSString *lastLocationTime;
///最后定位地址
@property (nonatomic,strong) NSString *deviceLocation;
///是否一致
@property (nonatomic,assign) BOOL isFit;
///设备异常说明
@property (nonatomic,strong) NSString *exceptionMsg;
@end
