//
//  BYDeviceModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/19.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYDeviceModel : NSObject
///设备id
@property (nonatomic,assign) NSInteger deviceId;
///设备名称
@property (nonatomic,strong) NSString *deviceProvider;
///0.有线设备 1.无线设备 3.其它设备
@property (nonatomic,assign) NSInteger deviceType;
///设备数量
@property (nonatomic,assign) NSInteger deviceCount;
///yes增加   no删除
@property (nonatomic,assign) BOOL isAdd;
///设备编号
@property (nonatomic,strong) NSString *deviceSn;

///检修新sn
@property (nonatomic,strong) NSString *newestSn;

///是否选中yes  no
@property (nonatomic,assign) BOOL isSelect;
/// 1设备不上线、2 设备不定位、3 设备没电、4 其他
@property (nonatomic,assign) NSInteger serviceReson;
///故障描述
@property (nonatomic,strong) NSString *resonDetail;

///检修方案： 1:仅维修 2:设备更换 3:重新安装
@property (nonatomic,assign) NSInteger repairScheme;
///安装位置
@property (nonatomic,strong) NSString *devicePosition;
///1=离线,2=在线不定位,3=在线行驶,4=在线熄火,5=报警

@property (nonatomic,assign) NSInteger status;
///安装图片
@property (nonatomic,strong) NSString *deviceImg;
///vin图片 老版
@property (nonatomic,strong) NSString *deviceVinImg;
///vin图片 新版
@property (nonatomic,strong) NSString *NewDeviceVinImg;
///安装确认单图片
@property (nonatomic,strong) NSString *installConfirm;
/// 0=有线、1=无线

///离线多少天
@property (nonatomic,assign) NSInteger days;

///1,拆除成功2，拆除失败
@property (nonatomic,assign) NSInteger removed;

///0 是不显示三址一致  1 显示一致   2 不一致
@property (nonatomic , assign) NSInteger sameAdd;



@end
