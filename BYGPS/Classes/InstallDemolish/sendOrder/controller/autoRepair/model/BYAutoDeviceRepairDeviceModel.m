//
//  BYAutoDeviceRepairDeviceModel.m
//  BYGPS
//
//  Created by ZPD on 2018/12/13.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoDeviceRepairDeviceModel.h"

@implementation BYAutoDeviceRepairDeviceModel


+(instancetype)modelWithRepairType:(BYRepairCellType)repairCellType reparType:(NSInteger)repairType oldInstallPosition:(NSString *)oldInstallPosition deviceSn:(NSString *)deviceSn installPosition:(NSString *)installPosition installImgUrl:(NSString *)installImgUrl repairOtherImgUrl:(NSString *)repairOtherImgUrl serviceReson:(NSInteger)serviceReson{
    
    BYAutoDeviceRepairDeviceModel *model = [[self alloc] init];
    model.repairCellType = repairCellType;
    model.repairType = repairType;
    model.oldInstallPosition = oldInstallPosition;
    model.deviceSn = deviceSn;
    model.installPosition = installPosition;
    model.installImgUrl = installImgUrl;
    model.repairOtherImgUrl = repairOtherImgUrl;
    model.serviceReson = serviceReson;
    return model;
}

-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

-(NSMutableArray *)photoArr{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}

@end
