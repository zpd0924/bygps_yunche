//
//  BYDeviceInfoCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYDeviceModel.h"

typedef void(^BYDeviceInfoBlock)(BYDeviceModel *model);
typedef void(^BYDeviceCountAddOrMinusBlock)();
@interface BYDeviceInfoCell : UITableViewCell
@property (nonatomic,strong) BYDeviceModel *model;
@property (nonatomic,copy) BYDeviceInfoBlock addBlock;
@property (nonatomic,copy) BYDeviceInfoBlock minusBlock;
@property (nonatomic,copy) BYDeviceCountAddOrMinusBlock deviceCountAddOrMinusBlock;
@end
