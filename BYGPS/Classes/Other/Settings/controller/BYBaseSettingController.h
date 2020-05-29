//
//  BYBaseSettingController.h
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYBaseSettingController : UIViewController

// 保存当前tableView有多少组,元素应该是一个groupItem
@property (nonatomic, strong) NSMutableArray *groups;

@property(nonatomic,assign) UITableViewCellStyle BYTableViewCellStyle;

@property(nonatomic,strong) UITableView *tableView;

@end
