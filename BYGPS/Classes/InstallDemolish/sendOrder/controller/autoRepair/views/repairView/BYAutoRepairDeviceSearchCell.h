//
//  BYAutoRepairDeviceSearchCell.h
//  BYGPS
//
//  Created by ZPD on 2018/12/25.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYAutoServiceDeviceModel;
@interface BYAutoRepairDeviceSearchCell : UITableViewCell

@property (nonatomic,strong) BYAutoServiceDeviceModel *deviceModel;

@property (nonatomic,copy) void(^addDeviceBlock)(void);

@end
