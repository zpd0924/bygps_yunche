//
//  BYCheckWorkOrderViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/16.
//  Copyright © 2018年 miwer. All rights reserved.
//
//!<审核工单
#import <UIKit/UIKit.h>
#import "BYMyAllWorkOrderModel.h"

typedef void(^BYCheckWorkOrderBlock)(BYMyAllWorkOrderModel *model);

@interface BYCheckWorkOrderViewController : UIViewController
@property (nonatomic,strong) BYMyAllWorkOrderModel *model;
@property (nonatomic,copy) BYCheckWorkOrderBlock checkWorkOrderBlock;
@end
