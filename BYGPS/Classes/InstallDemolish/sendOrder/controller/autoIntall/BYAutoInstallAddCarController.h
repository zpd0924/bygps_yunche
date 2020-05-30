//
//  BYAutoInstallAddCarController.h
//  BYGPS
//
//  Created by 李志军 on 2018/9/7.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BYAddCarInfoViewBlock)(NSString *carNum);
@interface BYAutoInstallAddCarController : UIViewController
@property (nonatomic,copy) BYAddCarInfoViewBlock addCarInfoViewBlock;
@property (nonatomic,assign) BOOL isCheckVin;//是否要输入车架号 yes要 no不要
@property (nonatomic,assign) NSInteger groupId;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSMutableArray *array;//设备信息数组
@end
