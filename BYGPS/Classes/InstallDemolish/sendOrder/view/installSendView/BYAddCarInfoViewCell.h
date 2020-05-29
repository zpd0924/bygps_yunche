//
//  BYAddCarInfoViewCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYAddCarInfoModel.h"
typedef void(^BYAddCarInfoBlock)(NSString *str,NSIndexPath *indexPath);
typedef void(^ScanBtnClickBlock)(void);

@interface BYAddCarInfoViewCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,copy) BYAddCarInfoBlock addCarInfoBlock;
@property (nonatomic,copy) ScanBtnClickBlock scanBtnClickBlock;
@property (nonatomic,strong) BYAddCarInfoModel *model;
@property (nonatomic,assign) BOOL selectOtherColor;

///是否是自助安装
@property (nonatomic,assign) BOOL isAutoInstall;
///是否是需要输入车架号
@property (nonatomic,assign) BOOL isInputVin;
@end
