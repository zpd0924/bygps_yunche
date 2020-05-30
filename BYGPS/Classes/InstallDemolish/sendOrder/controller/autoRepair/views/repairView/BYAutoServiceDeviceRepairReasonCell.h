//
//  BYAutoServiceDeviceRepairReasonCell.h
//  BYGPS
//
//  Created by ZPD on 2018/12/21.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYAutoDeviceRepairDeviceModel;
@interface BYAutoServiceDeviceRepairReasonCell : UITableViewCell

@property (nonatomic,strong) BYAutoDeviceRepairDeviceModel *model;

@property (nonatomic,copy) void(^repairReasonTypeBlock)(void);
@property (weak, nonatomic) IBOutlet UIButton *reasonButton;


@end
