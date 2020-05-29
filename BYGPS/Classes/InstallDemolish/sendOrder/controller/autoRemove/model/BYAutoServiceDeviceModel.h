//
//  BYAutoServiceDeviceModel.h
//  BYGPS
//
//  Created by ZPD on 2018/12/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "JSONModel.h"

@interface BYAutoServiceDeviceModel : JSONModel<NSMutableCopying>

///设备ID
@property (nonatomic,strong) NSString *deviceId;
///设备sn
@property (nonatomic,strong) NSString *deviceSn;
///新设备sn
@property (nonatomic,strong) NSString *recentlyDeviceSn;

@property (nonatomic,strong) NSString *deviceSupplier;
@property (nonatomic,strong) NSString *recentlyDeviceSupplier;

///设备型号
@property (nonatomic,strong) NSString *deviceModel;
///新设备型号
@property (nonatomic,strong) NSString *recentlyDeviceModel;


///设备型号别名
@property (nonatomic , strong) NSString *alias;
//
@property (nonatomic , strong) NSString *recentlyAlias;


///设备类型 0:有源 1:无源 3:其他
@property (nonatomic,assign) NSInteger deviceType;
//新设备类型 0:有源 1:无源 3:其他
@property (nonatomic,assign) NSInteger recentlyDeviceType;

///设备当前状态
@property (nonatomic,strong) NSString *deviceStatus;
///设备所属公司
@property (nonatomic,strong) NSString *deviceGroup;
///最后定位时间
@property (nonatomic,strong) NSString *gpsTime;
///最后定位地址
@property (nonatomic,strong) NSString *gpsAddress;
///设备到期时间
@property (nonatomic,strong) NSString *endDate;
///设备安装位置（新数据）
@property (nonatomic,strong) NSString *devicePosition;
///新设备安装位置 有线 1-16 无线17-31
@property (nonatomic,strong) NSString *recentlyDevicePosition;
///安装确认单
@property (nonatomic,strong) NSString *installConfirm;
///设备安装位置（老数据）
@property (nonatomic,strong) NSString *installPosition;

///拆机图片地址
@property (nonatomic,strong) NSString *deviceVinImg;

///是否已检修
@property (nonatomic,assign) BOOL repaired;
/////是否已拆机
//@property (nonatomic,assign) BOOL removed;

///1设备已拆除，解除关联 2设备未拆除，未解除关联 3设备未拆除，强制解除关联
@property (nonatomic,assign) NSInteger isRemoved;


@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,strong) NSMutableArray *photoArr;


///检修模式

///检修类型（ 1:仅维修 2:设备更换 3:重新安装’）
@property (nonatomic,assign) NSInteger repairScheme;

///安装位置图片
@property (nonatomic,strong) NSString *imgUrl;

///检修图片
@property (nonatomic,strong) NSString *vinDeviceImg;

///检修原因 （1 设备不上线、2 设备不定位、3 设备没电、4 其他）
@property (nonatomic,assign) NSInteger serviceReson;

///是否可以修改检修方式 0 是 1否
@property (nonatomic,assign) NSInteger control;

@end
