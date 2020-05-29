//
//  BYKeepDetailFinshDeviceCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYDeviceModel.h"

typedef void(^BYKeepDetailFinshDeviceCellBlock)(void);

@interface BYKeepDetailFinshDeviceCell : UITableViewCell
@property (nonatomic,copy) BYKeepDetailFinshDeviceCellBlock detailFinshDeviceCellBlock;
@property (nonatomic,strong) BYDeviceModel *deviceModel;
@end
