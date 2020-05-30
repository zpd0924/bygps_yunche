//
//  BYAutoServiceDeviceRepairSwitchCell.h
//  BYGPS
//
//  Created by ZPD on 2018/12/13.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYAutoDeviceRepairDeviceModel;
@interface BYAutoServiceDeviceRepairSwitchCell : UITableViewCell

@property (nonatomic,strong) BYAutoDeviceRepairDeviceModel *model;

///维修方式回调
@property (nonatomic,copy) void(^repairDeviceClickBlock)(NSInteger tag);

@end
