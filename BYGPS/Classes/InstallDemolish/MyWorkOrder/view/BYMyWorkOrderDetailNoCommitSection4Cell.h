//
//  BYMyWorkOrderDetailNoCommitSection4Cell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYDeviceModel.h"

typedef void(^BYMyWorkOrderDetailNoCommitSection4CellBlock)(BYDeviceModel *model);

@interface BYMyWorkOrderDetailNoCommitSection4Cell : UITableViewCell
@property (nonatomic,strong) BYDeviceModel *deviceModel;
///是否显示拆机按钮
@property (nonatomic,assign) BOOL isShowUnpairBtn;
@property (nonatomic,copy) BYMyWorkOrderDetailNoCommitSection4CellBlock lookImageBlock;
@end
