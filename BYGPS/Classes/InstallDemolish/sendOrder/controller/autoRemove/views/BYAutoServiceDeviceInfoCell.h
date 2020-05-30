//
//  BYAutoServiceDeviceInfoCell.h
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYAutoServiceConstant.h"

@class BYAutoServiceDeviceModel;
@interface BYAutoServiceDeviceInfoCell : UITableViewCell

@property (nonatomic,assign) BYFunctionType functionType;
@property (nonatomic,strong) BYAutoServiceDeviceModel *model;

@property (nonatomic,copy) void(^removeOrRepairBlock)(void);


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deviceTypeImgView;
@property (weak, nonatomic) IBOutlet UILabel *deviceSnLabel;
@property (weak, nonatomic) IBOutlet UILabel *repairStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpsTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpsAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *handleButton;


@end
