//
//  BYKeepDeviceInfoCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYDeviceModel.h"

typedef void(^BYKeepDeviceInfoBlock)(BYDeviceModel *model);

@interface BYKeepDeviceInfoCell : UITableViewCell
@property (nonatomic,strong) BYDeviceModel *model;
@property (nonatomic,strong) BYKeepDeviceInfoBlock keepDeviceInfoBlock;
@end
