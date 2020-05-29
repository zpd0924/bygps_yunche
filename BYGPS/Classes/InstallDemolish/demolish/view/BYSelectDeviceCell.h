//
//  BYSelectDeviceDemolishCell.h
//  父子控制器
//
//  Created by miwer on 2016/12/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYAppointmentDeviceModel;
@class BYDemolishDeviceModel;

@interface BYSelectDeviceCell : UITableViewCell

@property(nonatomic,assign) BOOL isHidenImageBgView;

@property(nonatomic,strong) BYAppointmentDeviceModel * appointmentModel;

@property(nonatomic,strong) BYDemolishDeviceModel * demolishModel;

@property(nonatomic,strong) void (^selectDeviceBlock)(BOOL isSelect);

@property(nonatomic,assign) CGFloat markBgV_H;

@property (nonatomic,strong) NSMutableArray *imgArr;

@end
