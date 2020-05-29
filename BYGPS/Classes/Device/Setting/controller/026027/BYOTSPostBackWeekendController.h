//
//  BYOTSPostBackWeekendController.h
//  BYGPS
//
//  Created by ZPD on 2017/6/29.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYPushNaviModel;
@interface BYOTSPostBackWeekendController : UITableViewController

@property(nonatomic,strong) BYPushNaviModel * model;

@property (nonatomic,assign) BOOL isWireless;

@property(nonatomic,strong) NSString * cmdContent;

@end
