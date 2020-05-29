//
//  BYKeepWorkOrderLookDetailViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/18.
//  Copyright © 2018年 miwer. All rights reserved.
//
//!<检修工单查看详情
#import <UIKit/UIKit.h>
#import "BYDeviceModel.h"
@interface BYKeepWorkOrderLookDetailViewController : UIViewController
///订单号
@property (nonatomic,strong) NSString *orderNo;

///设备号
@property (nonatomic,strong) NSString *deviceSn;

///安装确认单
@property (nonatomic,strong) NSString *installConfirm;


@property (nonatomic,strong) BYDeviceModel *deviceModel;
@end
