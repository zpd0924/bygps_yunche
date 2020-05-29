//
//  BYKeepDeviceInfoViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//
//!<检修派单 设备
#import <UIKit/UIKit.h>
#import "BYOrderDetailModel.h"
#import "BYSendWorkParameterModel.h"

@interface BYKeepDeviceInfoViewController : UIViewController
@property (nonatomic,assign) BYSendOrderType sendOrderType;
@property (nonatomic,strong) BYOrderDetailModel *detailModel;
///是否是编辑模式
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,strong) BYSendWorkParameterModel *parameterModel;//派单所需参数
@end
