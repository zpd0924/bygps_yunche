//
//  BYPostBackHeartbeatController.h
//  BYGPS
//
//  Created by miwer on 2017/1/16.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYPushNaviModel;

@interface BYPostBackHeartbeatController : UITableViewController

@property(nonatomic,strong) BYPushNaviModel * model;

@property(nonatomic,strong) NSString * cmdContent;//指令记录的指令内容

@end
