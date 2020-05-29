//
//  BYMyWorkOrderCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYMyAllWorkOrderModel.h"

typedef void(^BYMyWorkOrderCellBlock)(NSString *name);

@interface BYMyWorkOrderCell : UITableViewCell

@property (nonatomic,strong) BYMyAllWorkOrderModel *model;
@property (nonatomic,copy) BYMyWorkOrderCellBlock cellBlock;

@end
