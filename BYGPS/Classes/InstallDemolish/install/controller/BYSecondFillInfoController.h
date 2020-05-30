//
//  BYSecondFillInfoController.h
//  父子控制器
//
//  Created by miwer on 2016/12/23.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYSecondFillInfoController : UITableViewController

@property(nonatomic,strong) NSMutableArray * carInfoData;//从车辆信息传过来的数据

@property(nonatomic,assign) NSInteger deviceId;

@property(nonatomic,assign) BOOL isWirless;

@end
