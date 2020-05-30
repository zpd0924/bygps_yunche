//
//  BYAutoDeviceRepairDeviceModel.h
//  BYGPS
//
//  Created by ZPD on 2018/12/13.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYAutoServiceConstant.h"
#import "BYPhotoModel.h"

@interface BYAutoDeviceRepairDeviceModel : NSObject

///cell类型
@property (nonatomic,assign) BYRepairCellType repairCellType;

///维修类型
@property (nonatomic,assign) NSInteger repairType;

///旧安装位置 图片地址逗号隔开
@property (nonatomic,strong) NSString *oldInstallPosition;

//新设备sn
@property (nonatomic,strong) NSString *deviceSn;
///设备型号
@property (nonatomic,strong) NSString *deviceModel;
///设备型号别名

@property (nonatomic , strong) NSString *alias;

///设备类型 0:有源 1:无源 3:其他
@property (nonatomic,assign) NSInteger deviceType;


///新安装位置序列号
@property (nonatomic,strong) NSString *installPosition;

///安装位置图片
@property (nonatomic,strong) NSString *installImgUrl;

///检修图片,多张逗号隔开
@property (nonatomic,strong) NSString *repairOtherImgUrl;

@property (nonatomic,assign) NSInteger serviceReson;

@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,strong) NSMutableArray *photoArr;

@property (nonatomic,strong) BYPhotoModel *installImgModel;

@property (nonatomic,assign) NSInteger control;


+(instancetype)modelWithRepairType:(BYRepairCellType)repairCellType reparType:(NSInteger)repairType oldInstallPosition:(NSString *)oldInstallPosition deviceSn:(NSString *)deviceSn installPosition:(NSString *)installPosition installImgUrl:(NSString *)installImgUrl repairOtherImgUrl:(NSString *)repairOtherImgUrl serviceReson:(NSInteger)serviceReson;


@end
