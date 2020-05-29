//
//  BYShareCommitParamModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/26.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYShareCommitParamModel.h"

@implementation BYShareCommitParamModel

- (id)copyWithZone:(NSZone *)zone{
    BYShareCommitParamModel *model = [[[self class] allocWithZone:zone] init];
   
    ///车辆Id
//    @property (nonatomic,strong) NSString *carId;
//    ///车架号
//    @property (nonatomic,strong) NSString *carVin;
//    ///车主
//    @property (nonatomic,strong) NSString *carOwnerName;
//    ///车牌号
//    @property (nonatomic,strong) NSString *carNum;
//    ///分享有效期
//    @property (nonatomic,strong) NSString *shareTime;
//    ///是否可以发送指令 Y N
//    @property (nonatomic,strong) NSString *sendCommand;
//    ///是否可以发送警报 Y N
//    @property (nonatomic,strong) NSString *checkAlarm;
//    ///备注
//    @property (nonatomic,strong) NSString *remark;
//    ///内部员工
//    @property (nonatomic,strong) NSMutableArray *shareLine;
//    ///外部员工
//    @property (nonatomic,strong) NSMutableArray *shareMobile;
//
//    ///分享设备
//    @property (nonatomic,strong) NSMutableArray *deviceShare;
//    ///设备类型0 有线 1无线
//    @property (nonatomic,assign) NSInteger deviceType;
//
//    ///车品牌
//    @property (nonatomic,strong) NSString *carBrand;
//    ///车系
//    @property (nonatomic,strong) NSString *carSet;
//    ///车颜色
//    @property (nonatomic,strong) NSString *carColor;
//    ///定位地址
//    @property (nonatomic,strong) NSString *address;
    model.carId = [self.carId copy];
     model.carVin = [self.carVin copy];
     model.carOwnerName = [self.carOwnerName copy];
     model.carNum = [self.carNum copy];
     model.shareTime = [self.shareTime copy];
     model.sendCommand = [self.sendCommand copy];
     model.checkAlarm = [self.checkAlarm copy];
     model.remark = [self.remark copy];
     model.shareLine = [self.shareLine mutableCopy];
     model.shareMobile = [self.shareMobile mutableCopy];
     model.deviceShare = [self.deviceShare copy];
     model.deviceType = self.deviceType;
     model.carBrand = [self.carBrand copy];
     model.carSet = [self.carSet copy];
     model.carColor = [self.carColor copy];
     model.address = [self.address copy];
    return model;
}
@end
