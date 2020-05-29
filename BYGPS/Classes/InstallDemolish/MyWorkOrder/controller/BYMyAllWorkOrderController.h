//
//  BYMyAllWorkOrderController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//
//!<全部工单
#import <UIKit/UIKit.h>
#import "BYScreenParameterModel.h"

@interface BYMyAllWorkOrderController : UITableViewController
///是否是筛选
@property (nonatomic,assign) BOOL isScreen;
@property (nonatomic,strong) BYScreenParameterModel *model;
@property (nonatomic,strong) NSString *keyWord;//搜索关键字
@property (nonatomic,assign) BOOL isOverTime;//是否是超时工单
@end
