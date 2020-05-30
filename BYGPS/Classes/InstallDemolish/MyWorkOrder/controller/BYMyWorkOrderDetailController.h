//
//  BYMyWorkOrderDetailController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//
//!<订单详情
#import <UIKit/UIKit.h>

@interface BYMyWorkOrderDetailController : UIViewController
@property (nonatomic,assign) BYSendOrderType sendOrderType;
///订单状态 0待安装 1已接单 2安装完成 3审核不通过 4审核通过 5撤销
@property (nonatomic,assign) NSInteger orderStatus;
///订单号
@property (nonatomic,strong) NSString *orderNo;

@end
