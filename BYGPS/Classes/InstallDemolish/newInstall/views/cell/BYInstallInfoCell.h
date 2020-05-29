//
//  BYInstallInfoCell.h
//  BYIntelligentAssistant
//
//  Created by ZPD on 2018/7/17.
//  Copyright © 2018年 BYKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYSelfServiceInstallDeviceModel.h"

@interface BYInstallInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *positionPlaceholdImgBgView;
@property (weak, nonatomic) IBOutlet UIView *positionImgBgView;
@property (weak, nonatomic) IBOutlet UIImageView *positionImgView;
@property (weak, nonatomic) IBOutlet UIImageView *positionPlaceholdImgView;
@property (weak, nonatomic) IBOutlet UILabel *vinDownLabel;

@property (nonatomic,strong) BYSelfServiceInstallDeviceModel *deviceModel;


@property (nonatomic,copy) void(^inputDeviceIdCallBack)(void);
@property (nonatomic,copy) void(^scanDeviceIdCallBack)(void);

@property (nonatomic,copy) void(^inputInstallNumBlock)(NSString *num);  //安装序列号回调


@property (nonatomic,copy) void(^tapInstallPositionImgBgViewCallBack)(void);
@property (nonatomic,copy) void(^installInfoDeleteImgCallBack)(NSInteger tag);
@end
