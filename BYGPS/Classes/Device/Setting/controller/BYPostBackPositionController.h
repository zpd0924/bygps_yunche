//
//  BYPostBackPositionController.h
//  BYGPS
//
//  Created by miwer on 16/9/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYPushNaviModel;

@interface BYPostBackPositionController : UITableViewController

@property(nonatomic,strong) BYPushNaviModel * model;

@property(nonatomic,strong) NSString * cmdContent;//指令记录的指令内容

@end
