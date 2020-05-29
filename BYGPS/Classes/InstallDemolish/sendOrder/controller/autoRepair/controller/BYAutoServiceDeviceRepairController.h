//
//  BYAutoServiceDeviceRepairController.h
//  BYGPS
//
//  Created by ZPD on 2018/12/13.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYAutoServiceCarModel;
@class BYAutoServiceDeviceModel;
@interface BYAutoServiceDeviceRepairController : UIViewController

@property (nonatomic,strong) BYAutoServiceCarModel *carModel;

@property (nonatomic,strong) BYAutoServiceDeviceModel *deviceModel;

@property (nonatomic,copy) void(^controllerPopBlock)(BYAutoServiceDeviceModel *devModel);

@end
