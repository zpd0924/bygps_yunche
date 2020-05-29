//
//  BYPostBackDurationController.h
//  BYGPS
//
//  Created by miwer on 16/7/29.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBaseSettingController.h"

@class BYPushNaviModel;

@interface BYPostBackDurationController : UITableViewController

@property(nonatomic,strong) BYPushNaviModel * model;

@property (nonatomic,assign) BOOL is026;

@property (nonatomic,assign) BOOL isWireless;

@property(nonatomic,strong) NSString * cmdContent;//指令记录的指令内容

@end
