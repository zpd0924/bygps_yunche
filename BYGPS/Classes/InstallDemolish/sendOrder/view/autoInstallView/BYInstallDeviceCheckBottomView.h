//
//  BYInstallDeviceCheckBottomView.h
//  BYGPS
//
//  Created by 李志军 on 2018/9/7.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYInstallDeviceCheckModel.h"
typedef void(^BYInstallDeviceCheckBottomBlock)(void);

@interface BYInstallDeviceCheckBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *installCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *installCheckLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic,copy) BYInstallDeviceCheckBottomBlock addBlock;
@property (nonatomic,copy) BYInstallDeviceCheckBottomBlock nextBlock;
///设备分组是否一致
@property (nonatomic,assign) BOOL isFit;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end
