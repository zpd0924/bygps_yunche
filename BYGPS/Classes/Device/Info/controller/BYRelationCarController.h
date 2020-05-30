//
//  BYRelationCarController.h
//  BYGPS
//
//  Created by miwer on 16/7/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBaseSettingController.h"

@class BYDeviceInfoModel;

@interface BYRelationCarController : BYBaseSettingController

@property(nonatomic,strong) BYDeviceInfoModel * model;
@property(nonatomic,copy) void (^relativeIdBlock)(NSInteger deviceId);

@end
