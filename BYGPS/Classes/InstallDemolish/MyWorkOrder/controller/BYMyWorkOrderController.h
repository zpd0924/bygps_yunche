//
//  BYMyWorkOrderController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "YZDisplayViewController.h"
#import "BYInstallSendOrderCountModel.h"

@interface BYMyWorkOrderController : YZDisplayViewController
///显示第几列
@property (nonatomic,assign) NSInteger row;

@property (nonatomic,assign) BOOL isOverTime;///是否是超时工单点入
@property (nonatomic,strong) BYInstallSendOrderCountModel *model;
@end
