//
//  BYRepairDeviceInfoCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/25.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYDeviceModel.h"

typedef void(^BYRepairDeviceInfoBlock)(BYDeviceModel *model);
@interface BYRepairDeviceInfoCell : UITableViewCell
@property (nonatomic,strong) BYDeviceModel *model;
@property (nonatomic,copy) BYRepairDeviceInfoBlock repairDeviceInfoBlock;
@end
