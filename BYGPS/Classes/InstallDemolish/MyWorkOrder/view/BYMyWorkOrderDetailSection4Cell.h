//
//  BYMyWorkOrderDetailSection4Cell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

//!<派单安装详情 已提交资料的 设备cell
#import <UIKit/UIKit.h>
#import "BYDeviceModel.h"
typedef void(^BYMyWorkOrderDetailSection4CellBlock)(void);

@interface BYMyWorkOrderDetailSection4Cell : UITableViewCell
@property (nonatomic,copy) BYMyWorkOrderDetailSection4CellBlock leftBtnBlock;
@property (nonatomic,copy) BYMyWorkOrderDetailSection4CellBlock rightBtnBlock;
@property (nonatomic,strong) BYDeviceModel *deviceModel;
@end
