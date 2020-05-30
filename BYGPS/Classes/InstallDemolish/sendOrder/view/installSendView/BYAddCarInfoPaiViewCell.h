//
//  BYAddCarInfoPaiViewCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYAddCarInfoModel.h"
typedef void(^BYAddCarInfoBlock)(NSString *str,NSIndexPath *indexPath);
typedef void(^BYAddCarInfoPaiBlock)(void);
typedef void(^BYAddCarInfoCarNumBlock)(NSString *carNumber);
typedef void(^ScanBtnClickBlock)(void);
@interface BYAddCarInfoPaiViewCell : UITableViewCell
@property (nonatomic,copy) BYAddCarInfoPaiBlock carInfoPaiBlock;
@property (nonatomic,copy) BYAddCarInfoCarNumBlock carNumBlock;
@property (nonatomic,copy) ScanBtnClickBlock scanBtnClickBlock;
@property (nonatomic,strong) BYAddCarInfoModel *model;
@property (weak, nonatomic) IBOutlet UITextField *textField;
//@property (weak, nonatomic) IBOutlet UITextField *otherColorTextFiedld;
///是否是自助安装
@property (nonatomic,assign) BOOL isAutoInstall;
///是否是需要输入车架号
@property (nonatomic,assign) BOOL isInputVin;
@end
