//
//  BYAutoServiceCarModel.h
//  BYGPS
//
//  Created by ZPD on 2018/12/18.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "JSONModel.h"

@interface BYAutoServiceCarModel : JSONModel

@property (nonatomic,strong) NSString *carId;
@property (nonatomic,strong) NSString *carType;
@property (nonatomic,strong) NSString *carBrand;
@property (nonatomic,strong) NSString *carModel;
@property (nonatomic,strong) NSString *carColor;
@property (nonatomic,strong) NSString *carOwnerId;
@property (nonatomic,strong) NSString *carOwner;
@property (nonatomic,strong) NSString *carOwnerTel;
@property (nonatomic,strong) NSString *carNum;
@property (nonatomic,strong) NSString *carVin;
@property (nonatomic,strong) NSString *carGroupId;

@property (nonatomic,strong) NSString *deviceModel;
///设备型号别名

@property (nonatomic , strong) NSString *alias;

@property (nonatomic,strong) NSString *deviceSn;
@property (nonatomic,strong) NSString *deviceType;
@property (nonatomic,strong) NSString *groupIds;


@end
