//
//  BYPostBackContinueController.h
//  BYGPS
//
//  Created by miwer on 2017/1/16.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYPushNaviModel;

@interface BYPostBackContinueController : UITableViewController

@property(nonatomic,strong) BYPushNaviModel * model;

@property (nonatomic,assign) BOOL is027;

@property (nonatomic,assign) BOOL is029;

@property (nonatomic,assign) BOOL is036;

@property(nonatomic,strong) NSString * cmdContent;

@end
