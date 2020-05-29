//
//  BYAddCarInfoViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/12.
//  Copyright © 2018年 miwer. All rights reserved.
//
//!<新增车辆
#import <UIKit/UIKit.h>

typedef void(^BYAddCarInfoViewBlock)(NSString *carNum);

@interface BYAddCarInfoViewController : UIViewController

@property (nonatomic,copy) BYAddCarInfoViewBlock addCarInfoViewBlock;

@end
