//
//  BYWorkMessageController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/9.
//  Copyright © 2018年 miwer. All rights reserved.
//
//!<工单信息
#import <UIKit/UIKit.h>


@interface BYWorkMessageController : UIViewController

@property (nonatomic,assign) BYSendOrderType sendOrderType;
@property (nonatomic,strong) NSString *titleLabelStr;
///是否是编辑模式
@property (nonatomic,assign) BOOL isEdit;
///工单号
@property (nonatomic,strong) NSString *orderNo;
@end
