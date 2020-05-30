//
//  BYAutoRepairDeviceSearchViewController.h
//  BYGPS
//
//  Created by ZPD on 2018/12/14.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYAutoServiceDeviceModel;
@class BYAutoServiceCarModel;
@interface BYAutoRepairDeviceSearchViewController : UIViewController


@property (nonatomic,strong) BYAutoServiceCarModel *carModel;
@property (nonatomic,strong) NSString *carGroupId;


@property (nonatomic,copy) void(^deviceSnSearchBlock)(BYAutoServiceDeviceModel *deviceModel);

@end
