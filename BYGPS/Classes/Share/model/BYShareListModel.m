//
//  BYShareListModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/28.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYShareListModel.h"
#import "BYShareCommitDeviceModel.h"
#import "BYShareUserModel.h"
@implementation BYShareListModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    
    return @{
             @"deviceShare":[BYShareCommitDeviceModel class],
             @"shareLine":[BYShareUserModel class],
              @"shareMobile":[BYShareUserModel class]
             };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"shareId" :@"id"};
}


- (id)copyWithZone:(NSZone *)zone{
    BYShareListModel *model = [[[self class] allocWithZone:zone] init];
    model.createTime = [self.createTime copy];
    model.carBrand = [self.carBrand copy];
    model.carType = [self.carType copy];
    model.carColor = [self.carColor copy];
    model.shareId = [self.shareId copy];
    model.carId = [self.carId copy];
    model.carVin = [self.carVin copy];
    model.carOwnerName = [self.carOwnerName copy];
    model.carNum = [self.carNum copy];
    model.shareTime = [self.shareTime copy];
    model.sendCommand = [self.sendCommand copy];
    model.checkAlarm = [self.checkAlarm copy];
    model.remark = [self.remark copy];
    model.address = [self.address copy];
    model.isEnd = [self.isEnd copy];
    model.deviceShare = [self.deviceShare copy];
    model.shareLine = [self.shareLine mutableCopy];
    model.shareMobile = [self.shareMobile mutableCopy];
  
    return model;
}

@end
