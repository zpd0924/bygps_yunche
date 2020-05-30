//
//  BYCheckWorkOrderCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/16.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYDeviceModel.h"
typedef void(^CheckWorkOrderCellBlock)(void);

@interface BYCheckWorkOrderCell : UITableViewCell
@property (nonatomic,copy) CheckWorkOrderCellBlock lookImagesBlock;
@property (nonatomic,copy) CheckWorkOrderCellBlock lookLocationBlock;
@property (nonatomic,strong) BYDeviceModel *model;
@end
