//
//  BYAutoServiceDeviceRepairInfoCell.h
//  BYGPS
//
//  Created by ZPD on 2018/12/13.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BYAutoDeviceRepairDeviceModel;
@interface BYAutoServiceDeviceRepairInfoCell : UITableViewCell

///检修类型（ 1:仅维修 2:设备更换 3:重新安装’）
@property (nonatomic,assign) NSInteger repairScheme;

@property (nonatomic,strong) BYAutoDeviceRepairDeviceModel *model;

@property (nonatomic,copy) void(^installImgViewTapBlock)(void);
@property (nonatomic,copy) void(^installImgViewDeleteBlock)(void);

@property(nonatomic,copy) void (^imageViewTapBlock) (NSInteger tag);
@property(nonatomic,copy) void (^deleteImageBlock) (NSInteger tag);

@property (nonatomic,copy) void(^recentDevicePositionInputBlock)(NSString *recentDevicePosition);

@property (nonatomic,copy) void(^checkInstallConfirmBlock)(void);
@property (weak, nonatomic) IBOutlet UIButton *checkInstallButton;

@end
