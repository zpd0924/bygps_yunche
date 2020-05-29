//
//  BYAutoServiceDeviceRemoveController.h
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYAutoServiceDeviceModel;
@interface BYAutoServiceDeviceRemoveController : UIViewController

@property (nonatomic,strong) BYAutoServiceDeviceModel *deviceModel;

@property (nonatomic,copy) void(^controllerPopBlock)(BYAutoServiceDeviceModel *devModel);

@end
